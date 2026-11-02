import 'dart:convert';
import 'dart:math' as math;

import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/sync/sync_result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Yerel DB ile sunucu arasındaki senkron (teknik.md §3). Supabase
/// istemcisine dokunan tek senkron sınıfı; ekranlar ve repository'ler ağa
/// gitmez.
///
/// Aynı anda tek tur çalışır. Tur sürerken gelen çağrı yeni tur başlatmaz,
/// süren turun sonucunu bekler. Kilit nesneye bağlıdır; uygulamada tek
/// örnek `syncServiceProvider`'dan gelir.
class SyncService {
  new(
    this._db,
    this._client, {
    this.clock = DateTime.now,
    this.delay = Future<void>.delayed,
  });

  final AppDatabase _db;
  final SupabaseClient _client;

  /// `client_time` kaynağı; testler sabit saat verir.
  final DateTime Function() clock;

  /// Yeniden denemeden önce bekler; testler beklemeden kaydeder.
  final Future<void> Function(Duration duration) delay;

  /// Bir pakette en fazla bu kadar kayıt gider.
  static const batchSize = 100;

  /// Çekmede bir sayfada istenen satır sayısı. İmleç sunucunun geriye bakma
  /// payındaysa sunucu bunu aşıp en çok 1000 satır döner.
  static const pullPageSize = 500;

  /// Geçici hatadan sonraki ilk bekleme; her denemede iki katına çıkar.
  static const initialBackoff = Duration(seconds: 1);

  /// Aynı paket ya da sayfa geçici hatadan sonra en fazla bu kadar yeniden
  /// denenir (1 + 2 + 4 + 8 + 16 = 31 sn bekleme), sonra tur
  /// [SyncStatus.retryLater] ile biter.
  static const maxRetries = 5;

  /// Tek isteğin süre sınırı; askıda kalan bağlantı kilidi tutmasın.
  static const requestTimeout = Duration(seconds: 30);

  /// Son gönderimde kabul edilen kayıtların en uzun bekleyeni: yerelde
  /// yazılmasından sunucunun kabul etmesine kadar geçen süre (senkron
  /// gecikmesi, analitik). Kayıt kabul edilmediyse null.
  Duration? lastPushDelay;

  Future<SyncResult>? _syncing;
  Future<SyncResult>? _pushing;
  Future<SyncResult>? _pulling;

  /// Sunucudan çekilen tablolar, çekme sırasıyla. Sunucuda `server_seq`
  /// kolonu olan her tablonun yerel aynası burada olmalı.
  List<TableInfo<Table, Object?>> get pullTables => [
    _db.organizations,
    _db.memberships,
    _db.apiaries,
    _db.queens,
    _db.hives,
    _db.hiveLocationHistory,
    _db.inspections,
    _db.media,
    _db.miteCounts,
    _db.refDrugs,
    _db.drugs,
    _db.treatments,
    _db.feedings,
    _db.tasks,
    _db.harvests,
    _db.harvestHives,
    _db.documents,
    _db.migrations,
    _db.migrationStops,
    _db.transports,
    _db.transportItems,
    _db.inventoryItems,
    _db.inventoryMoves,
    _db.queenRearingBatches,
    _db.matingNucs,
    _db.lots,
    _db.lotHarvests,
    _db.lotTreatments,
    _db.labResults,
    _db.lotSales,
    _db.customers,
    _db.transactions,
    _db.customerPayments,
    _db.refSupportPeriods,
  ];

  /// Tam tur: önce outbox gönderilir, gönderme bitince her tablo çekilir.
  /// Gönderme bitmezse (ağ yok, oturum yok, güncelleme gerekli) çekme
  /// yapılmaz ve gönderme sonucu döner. [onProgress] çekmenin ilerleyişini
  /// bildirir.
  Future<SyncResult> sync({void Function(SyncProgress progress)? onProgress}) =>
      _syncing ??= _sync(onProgress).whenComplete(() => _syncing = null);

  Future<SyncResult> _sync(
    void Function(SyncProgress progress)? onProgress,
  ) async {
    final pushed = await push();
    if (pushed.status != SyncStatus.done) return pushed;
    final pulled = await pull(onProgress: onProgress);
    return pulled.copyWith(pushed: pushed.pushed, rejected: pushed.rejected);
  }

  /// Outbox'ı oluşturulma sırasıyla [batchSize]'lık paketler halinde
  /// `sync_push`'a gönderir.
  ///
  /// Sunucunun kabul ettiği kayıtlar silinir. Reddedilen kayıt (RLS, geçersiz
  /// veri) `last_error`'a `<reason>: <message>` olarak işaretlenir, outbox'ta
  /// kalır ve sonraki paketlere alınmaz; kuyruk onun yüzünden durmaz.
  /// Geçici hatada (ağ, zaman aşımı, sunucunun geri aldığı paket) aynı paket
  /// üstel bekleyerek yeniden gönderilir. Başarısız her gönderimde paketteki
  /// kayıtların `attempts` sayısı artar.
  Future<SyncResult> push() =>
      _pushing ??= _push().whenComplete(() => _pushing = null);

  Future<SyncResult> _push() async {
    var pushed = 0;
    var rejected = 0;
    lastPushDelay = null;
    SyncResult result(SyncStatus status) =>
        SyncResult(status: status, pushed: pushed, rejected: rejected);

    try {
      while (true) {
        final batch = await _nextBatch();
        if (batch.isEmpty) return result(SyncStatus.done);

        final response = await _withRetry(
          () => _send(batch),
          onFailure: () => _countAttempt(batch.map((entry) => entry.id)),
        );
        final applied = await _apply(batch, response);
        pushed += applied.pushed;
        rejected += applied.rejected;
        if (applied.maxDelay case final delay?
            when lastPushDelay == null || delay > lastPushDelay!) {
          lastPushDelay = delay;
        }
        // Sonucu gelmeyen kayıt yeniden gönderilirse tur dönüp durur.
        if (!applied.complete) return result(SyncStatus.failed);
      }
    } on _TurnEnded catch (ended) {
      return result(ended.status);
    }
  }

  /// [request]'i gönderir; geçici hatada üstel bekleyerek en fazla
  /// [maxRetries] kez yeniden dener. Başarısız her denemeden sonra önce
  /// [onFailure] çalışır. Hata geçici değilse ya da denemeler biterse turu
  /// hatanın durumuyla bitirir ([_TurnEnded]).
  Future<Map<String, dynamic>> _withRetry(
    Future<Map<String, dynamic>> Function() request, {
    Future<void> Function()? onFailure,
  }) async {
    for (var retries = 0; ; retries++) {
      try {
        return await request();
      } on Exception catch (error) {
        await onFailure?.call();
        final status = _statusFor(error);
        if (status != SyncStatus.retryLater || retries == maxRetries) {
          throw _TurnEnded(status);
        }
      }
      await delay(initialBackoff * (1 << retries));
    }
  }

  /// Reddedilmemiş ilk [batchSize] kayıt, oluşturulma sırasıyla.
  Future<List<OutboxEntry>> _nextBatch() =>
      (_db.select(_db.outbox)
            ..where((t) => t.lastError.isNull())
            ..orderBy([(t) => OrderingTerm.asc(t.id)])
            ..limit(batchSize))
          .get();

  Future<Map<String, dynamic>> _send(List<OutboxEntry> batch) => _client
      .rpc<Map<String, dynamic>>(
        'sync_push',
        params: {
          'changes': [
            for (final entry in batch)
              {
                'id': entry.id,
                'table': entry.recordTable,
                'operation': entry.operation.name,
                'payload': entry.payload,
              },
          ],
          'client_time': clock().toUtc().toIso8601String(),
          'schema_version': _db.schemaVersion,
        },
      )
      // POST zaten kendiliğinden yeniden denenmez; burada yalnız süre sınırı
      // konur, yeniden denemeyi [_push] yapar.
      .retry(enabled: false, requestTimeout: requestTimeout);

  /// Yanıttaki sonuçları tek transaction'da işler: `ok` kayıtlar silinir,
  /// `rejected` kayıtlar işaretlenir. Yanıtta sonucu olmayan ya da tanınmayan
  /// kayıt yerinde kalır ve `complete` false döner.
  Future<({int pushed, int rejected, bool complete, Duration? maxDelay})>
  _apply(List<OutboxEntry> batch, Map<String, dynamic> response) async {
    final results = <int, Map<String, dynamic>>{
      if (response['results'] case final List<dynamic> list)
        for (final result in list)
          if (result case {'id': final int id} && final Map<String, dynamic> r)
            id: r,
    };
    final accepted = <int>[];
    final rejections = <int, String>{};
    for (final entry in batch) {
      switch (results[entry.id]) {
        case {'status': 'ok'}:
          accepted.add(entry.id);
        case {
          'status': 'rejected',
          'reason': final String reason,
          'message': final String message,
        }:
          rejections[entry.id] = '$reason: $message';
      }
    }

    await _db.transaction(() async {
      await (_db.delete(_db.outbox)..where((t) => t.id.isIn(accepted))).go();
      for (final MapEntry(key: id, value: error) in rejections.entries) {
        await _countAttempt([id], error: error);
      }
    });
    final now = clock().toUtc();
    Duration? maxDelay;
    for (final entry in batch) {
      if (!accepted.contains(entry.id)) continue;
      final delay = now.difference(entry.createdAt.toUtc());
      if (maxDelay == null || delay > maxDelay) maxDelay = delay;
    }
    return (
      pushed: accepted.length,
      rejected: rejections.length,
      complete: accepted.length + rejections.length == batch.length,
      maxDelay: maxDelay,
    );
  }

  /// Kayıtların deneme sayısını artırır; [error] verilirse kalıcı ret
  /// olarak işaretler.
  Future<void> _countAttempt(Iterable<int> ids, {String? error}) =>
      (_db.update(_db.outbox)..where((t) => t.id.isIn(ids))).write(
        OutboxCompanion.custom(
          attempts: _db.outbox.attempts + const Constant(1),
          lastError: error == null ? null : Variable(error),
        ),
      );

  /// [pullTables]'ı sırayla, imleçten itibaren `sync_pull` ile sayfa sayfa
  /// çeker ve yerel DB'ye upsert eder.
  ///
  /// Her sayfa tek transaction'da yazılır; imleç yalnız sayfa yazılınca
  /// ilerler, kesilen çekme kaldığı yerden sürer. Outbox'ta bekleyen
  /// değişikliği olan satır ezilmez (reddedilmiş kayıtlar bekleyen sayılmaz).
  /// O satır bu turda atlanır ve imleç onu geçmez; değişiklik gönderilince
  /// satır sonraki turda sunucudaki hâliyle yeniden iner. Geçici hatada aynı
  /// sayfa üstel bekleyerek yeniden istenir. Tablolar bitince ilk tam çekme
  /// işaretlenir ([fullPullMarker]).
  Future<SyncResult> pull({void Function(SyncProgress progress)? onProgress}) =>
      _pulling ??= _pull(onProgress).whenComplete(() => _pulling = null);

  Future<SyncResult> _pull(
    void Function(SyncProgress progress)? onProgress,
  ) async {
    final tables = pullTables;
    var pulled = 0;
    SyncResult result(SyncStatus status) =>
        SyncResult(status: status, pulled: pulled);
    void report(int tablesDone) => onProgress?.call(
      SyncProgress(
        tablesDone: tablesDone,
        tableCount: tables.length,
        rowsPulled: pulled,
      ),
    );

    try {
      for (final (index, table) in tables.indexed) {
        report(index);
        var since = await _cursor(table);
        // Atlanan ilk satırın bir öncesi; imleç bu turda bunu geçmez.
        int? hold;
        while (true) {
          final response = await _withRetry(() => _fetch(table, since));
          final _Page page;
          try {
            page = _Page.parse(table, response);
          } on FormatException {
            return result(SyncStatus.failed);
          }
          // Sunucu ilerlemeden "devamı var" derse aynı sayfa sonsuza dek
          // istenirdi.
          if (page.hasMore && page.nextSeq <= since) {
            return result(SyncStatus.failed);
          }

          final written = await _writePage(table, page, hold);
          hold = written.hold;
          pulled += written.rows;
          report(index);

          if (!page.hasMore) break;
          since = page.nextSeq;
        }
      }
    } on _TurnEnded catch (ended) {
      return result(ended.status);
    }

    await _db
        .into(_db.syncState)
        .insert(
          SyncStateCompanion.insert(recordTable: fullPullMarker),
          mode: InsertMode.insertOrIgnore,
        );
    report(tables.length);
    return result(SyncStatus.done);
  }

  /// Sayfayı tek transaction'da yazar: outbox'ta bekleyen değişikliği
  /// olmayan satırları upsert eder, imleci kaydeder. Satırlar `server_seq`
  /// sırasında geldiği için turda atlanan ilk satır en küçük numaralıdır;
  /// [hold] o satırın bir öncesidir ve imleç onu geçmez. Yazılan satır
  /// sayısını ve güncel [hold]'u döner.
  Future<({int rows, int? hold})> _writePage(
    TableInfo<Table, Object?> table,
    _Page page,
    int? hold,
  ) => _db.transaction(() async {
    final pending = await _pendingIds(table, page.rows);
    var newHold = hold;
    // Tablonun satır sınıfı listede `Object?`'e iner; drift ise satırın
    // tipini denetler. Never her satır sınıfının alt tipi.
    final fresh = <Insertable<Never>>[];
    for (final row in page.rows) {
      if (pending.contains(row.id)) {
        newHold ??= row.seq - 1;
      } else {
        fresh.add(RawValuesInsertable<Never>(row.values));
      }
    }
    await _db.batch((batch) => batch.insertAllOnConflictUpdate(table, fresh));
    await _saveCursor(
      table,
      newHold == null ? page.nextSeq : math.min(page.nextSeq, newHold),
    );
    return (rows: fresh.length, hold: newHold);
  });

  Future<Map<String, dynamic>> _fetch(
    TableInfo<Table, Object?> table,
    int since,
  ) => _client
      .rpc<Map<String, dynamic>>(
        'sync_pull',
        params: {
          'table_name': table.actualTableName,
          'since_seq': since,
          'page_size': pullPageSize,
        },
      )
      .retry(enabled: false, requestTimeout: requestTimeout);

  Future<int> _cursor(TableInfo<Table, Object?> table) async {
    final query = _db.select(_db.syncState)
      ..where((t) => t.recordTable.equals(table.actualTableName));
    return (await query.getSingleOrNull())?.lastPulledSeq ?? 0;
  }

  Future<void> _saveCursor(TableInfo<Table, Object?> table, int seq) => _db
      .into(_db.syncState)
      .insertOnConflictUpdate(
        SyncStateCompanion.insert(
          recordTable: table.actualTableName,
          lastPulledSeq: Value(seq),
        ),
      );

  /// [rows] arasında outbox'ta gönderilmeyi bekleyen değişikliği olanlar.
  Future<Set<String>> _pendingIds(
    TableInfo<Table, Object?> table,
    List<_Row> rows,
  ) async {
    final recordId = _db.outbox.recordId;
    final query = _db.selectOnly(_db.outbox)
      ..addColumns([recordId])
      ..where(
        _db.outbox.recordTable.equals(table.actualTableName) &
            recordId.isIn(rows.map((row) => row.id)) &
            _db.outbox.lastError.isNull(),
      );
    return {for (final row in await query.get()) row.read(recordId)!};
  }

  /// Gönderim hatasının turu nasıl bitireceği; [SyncStatus.retryLater]
  /// geçici hata demek.
  static SyncStatus _statusFor(Exception error) => switch (error) {
    // Süresi dolmuş token çevrimdışı yenilenemedi.
    AuthRetryableFetchException() => SyncStatus.retryLater,
    // Refresh token reddedildi; oturum düşecek.
    AuthException() => SyncStatus.failed,
    PostgrestException(code: 'PT426' || '426') => SyncStatus.upgradeRequired,
    PostgrestException(:final code?) when _isTransient(code) =>
      SyncStatus.retryLater,
    PostgrestException() => SyncStatus.failed,
    // Bağlantı hatası (ClientException, SocketException) ya da zaman aşımı.
    _ => SyncStatus.retryLater,
  };

  /// sync_push bu SQLSTATE sınıflarında paketi geri alır: bağlantı,
  /// kilitlenme, kaynak yetersizliği, iptal ve zaman aşımı, sistem hatası.
  static const _transientSqlStateClasses = {'08', '40', '53', '57', '58'};

  /// `55P03` kilit beklenemedi. `PGRST000`–`PGRST003` PostgREST'in
  /// veritabanına ulaşamaması. Sayılar, JSON dönmeyen ağ geçidinin HTTP
  /// durumu (postgrest kodu böyle doldurur).
  static const _transientCodes = {
    '55P03',
    'PGRST000',
    'PGRST001',
    'PGRST002',
    'PGRST003',
    '408',
    '429',
    '500',
    '502',
    '503',
    '504',
  };

  static bool _isTransient(String code) =>
      _transientCodes.contains(code) ||
      (code.length == 5 &&
          _transientSqlStateClasses.contains(code.substring(0, 2)));
}

/// Turu [status] ile bitirir: [SyncService._withRetry] atar, gönderme ya da
/// çekme turu yakalayıp o durumla döner.
class _TurnEnded implements Exception {
  const new(this.status);

  final SyncStatus status;
}

/// `sync_pull` yanıtının bir sayfası, yerel kolonlara çevrilmiş.
class _Page {
  const new({required this.rows, required this.nextSeq, required this.hasMore});

  /// Yanıt beklenen biçimde değilse ya da bir değer kolonuna uymuyorsa
  /// [FormatException] atar; sayfanın hiçbir satırı yazılmaz.
  factory parse(TableInfo<Table, Object?> table, Map<String, dynamic> json) {
    if (json case {
      'rows': final List<dynamic> rows,
      'next_seq': final int nextSeq,
      'has_more': final bool hasMore,
    }) {
      return _Page(
        rows: [for (final row in rows) _Row.parse(table, row)],
        nextSeq: nextSeq,
        hasMore: hasMore,
      );
    }
    throw const FormatException('sync_pull yanıtı beklenen biçimde değil');
  }

  /// `server_seq` sırasında.
  final List<_Row> rows;
  final int nextSeq;
  final bool hasMore;
}

/// Sunucudan gelen tek satır. Kolon adları yerelde de aynı.
class _Row {
  const new(this.id, this.seq, this.values);

  factory parse(TableInfo<Table, Object?> table, Object? json) {
    if (json
        case {'id': final String id, 'server_seq': final int seq} &&
            final Map<String, Object?> row) {
      return _Row(id, seq, {
        // Sunucuda olup yerelde olmayan kolon (daha yeni şema) atlanır.
        for (final column in table.$columns)
          if (row.containsKey(column.name))
            column.name: Variable(_value(column, row[column.name])),
      });
    }
    throw FormatException(
      '${table.actualTableName}: satırda id ya da server_seq yok',
    );
  }

  final String id;
  final int seq;
  final Map<String, Expression<Object>> values;

  /// JSON değerini kolonun Dart değerine çevirir. Tanınmayan enum değeri
  /// (ör. daha yeni bir şemadan) burada reddedilir; yazılsaydı satırı okuyan
  /// her ekran hata verirdi.
  static Object? _value(GeneratedColumn<Object> column, Object? json) {
    if (json == null) {
      if (column.$nullable) return null;
      throw FormatException('${column.name} boş olamaz');
    }
    final value = switch ((column.type, json)) {
      (DriftSqlType.string, final String text) => text,
      // jsonb (ör. muayenenin `data`'sı) yerelde JSON metni.
      (DriftSqlType.string, Map<String, Object?>() || List<Object?>()) =>
        jsonEncode(json),
      (DriftSqlType.int, final int number) => number,
      (DriftSqlType.double, final num number) => number.toDouble(),
      (DriftSqlType.bool, final bool flag) => flag,
      // timestamptz: "2026-10-23T09:00:00.123456+00:00"; yerelde UTC.
      (DriftSqlType.dateTime, final String text) => DateTime.parse(
        text,
      ).toUtc(),
      _ => throw FormatException('${column.name} beklenmeyen değer', json),
    };
    if (column case GeneratedColumnWithTypeConverter<Object?, Object>(
      :final converter,
    )) {
      try {
        converter.fromSql(value);
      } on Object {
        throw FormatException('${column.name} tanınmayan değer', json);
      }
    }
    return value;
  }
}
