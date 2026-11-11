import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../../tool/publish_knowledge.dart';

const _pbUrl = 'http://pb.test';
const _email = 'admin@example.com';
const _password = 'super-secret-password';
const _token = 'superuser-token-xyz';
const _records = '/api/collections/knowledge_packs/records';

const _article = '''
---
id: ana-verme
region: GLOBAL
category: guides
title: Ana verme
summary: Anasız koloniye kafesle yeni ana arı tanıtma.
---

Kafesi iki çerçevenin arasına asın.
''';

const Map<String, String> _pbEnv = {
  'PB_URL': '$_pbUrl/',
  'PB_SUPERUSER_EMAIL': _email,
  'PB_SUPERUSER_PASSWORD': _password,
};

http.Response _json(Object body, [int status = 200]) => http.Response(
  jsonEncode(body),
  status,
  headers: {'content-type': 'application/json; charset=utf-8'},
);

void main() {
  late Directory directory;
  late List<http.Request> requests;
  late List<String> logs;
  // Adı kayıtlı olanlar: ad → id.
  late Map<String, String> existing;

  setUp(() {
    directory = Directory.systemTemp.createTempSync('publish_knowledge_test');
    addTearDown(() => directory.deleteSync(recursive: true));
    File('${directory.path}/manifest.json')
        .writeAsStringSync(jsonEncode({'format': 1, 'version': 1}));
    File('${directory.path}/tr/ana-verme.md')
      ..createSync(recursive: true)
      ..writeAsStringSync(_article);
    requests = [];
    logs = [];
    existing = {};
  });

  /// Sahte PocketBase: giriş, ada göre arama, oluşturma ve güncelleme.
  MockClient pocketBase({int authStatus = 200}) => MockClient((request) async {
    requests.add(request);
    final path = request.url.path;
    if (path == '/api/collections/_superusers/auth-with-password') {
      return authStatus == 200
          ? _json({'token': _token, 'record': <String, Object?>{}})
          : _json({
              'status': 400,
              'message': 'Failed to authenticate.',
              'data': <String, Object?>{},
            }, 400);
    }
    if (request.headers['Authorization'] != _token) {
      return _json({'status': 403, 'message': 'forbidden'}, 403);
    }
    if (path == _records && request.method == 'GET') {
      final name = RegExp(r"^\(name='(.*)'\)$")
          .firstMatch(request.url.queryParameters['filter']!)![1]!;
      final id = existing[name];
      return _json({
        'items': [
          if (id != null) {'id': id},
        ],
      });
    }
    return _json({'id': 'new-id'});
  });

  Future<void> run(
    List<String> args, {
    required Map<String, String> environment,
    required http.Client client,
  }) => publishKnowledge(
    [...args, '--dir', directory.path],
    environment: environment,
    client: client,
    log: logs.add,
  );

  String bodyOf(http.Request request) => latin1.decode(request.bodyBytes);

  group('--backend pocketbase', () {
    test('logs in, then uploads the package before the manifest', () async {
      await run(
        ['--version', '2', '--backend', 'pocketbase'],
        environment: _pbEnv,
        client: pocketBase(),
      );

      expect(requests.map((r) => '${r.method} ${r.url.path}'), [
        'POST /api/collections/_superusers/auth-with-password',
        'GET $_records',
        'POST $_records',
        'GET $_records',
        'POST $_records',
      ]);
      expect(jsonDecode(requests.first.body), {
        'identity': _email,
        'password': _password,
      });
      expect(
        requests[1].url.queryParameters['filter'],
        "(name='knowledge-v2.json')",
      );
      expect(
        requests[3].url.queryParameters['filter'],
        "(name='manifest.json')",
      );

      final package = bodyOf(requests[2]);
      expect(package, contains('name="name"\r\n\r\nknowledge-v2.json'));
      expect(package, contains('filename="knowledge-v2.json"'));
      expect(package, contains('"version":2'));

      final manifest = bodyOf(requests[4]);
      expect(manifest, contains('name="name"\r\n\r\nmanifest.json'));
      expect(manifest, contains('filename="manifest.json"'));
      final packageJson = utf8.encode(
        jsonEncode({
          'format': 1,
          'version': 2,
          'files': {'tr/ana-verme.md': _article},
        }),
      );
      expect(manifest, contains('"path":"knowledge-v2.json"'));
      expect(manifest, contains(sha256.convert(packageJson).toString()));

      expect(logs, [
        startsWith('1 makale, sürüm 2'),
        'knowledge-v2.json yüklendi',
        'manifest.json yüklendi',
      ]);
    });

    test('replaces the file of a name that exists', () async {
      existing['manifest.json'] = 'manifest-id';
      await run(
        ['--version', '3', '--backend', 'pocketbase'],
        environment: _pbEnv,
        client: pocketBase(),
      );

      final writes = requests.where((r) => r.method != 'GET').toList();
      expect(writes.map((r) => '${r.method} ${r.url.path}'), [
        'POST /api/collections/_superusers/auth-with-password',
        'POST $_records',
        'PATCH $_records/manifest-id',
      ]);
      // Güncellemede ad değişmez, yalnız dosya gider.
      expect(bodyOf(writes.last), isNot(contains('name="name"')));
      expect(bodyOf(writes.last), contains('filename="manifest.json"'));
    });

    test('a failed login stops before any upload, without secrets', () async {
      await expectLater(
        run(
          ['--version', '2', '--backend', 'pocketbase'],
          environment: _pbEnv,
          client: pocketBase(authStatus: 400),
        ),
        throwsA(
          isA<PublishKnowledgeException>().having(
            (e) => e.message,
            'message',
            allOf(
              startsWith('Süper kullanıcı girişi başarısız: 400'),
              isNot(contains(_password)),
              isNot(contains(_email)),
            ),
          ),
        ),
      );
      expect(requests, hasLength(1));
    });

    test('a refused upload stops before the manifest', () async {
      final client = MockClient((request) async {
        requests.add(request);
        if (request.url.path.endsWith('auth-with-password')) {
          return _json({'token': _token});
        }
        if (request.method == 'GET') return _json({'items': <Object?>[]});
        return _json({
          'status': 400,
          'message': 'Failed to create record.',
        }, 400);
      });
      await expectLater(
        run(
          ['--version', '2', '--backend', 'pocketbase'],
          environment: _pbEnv,
          client: client,
        ),
        throwsA(
          isA<PublishKnowledgeException>().having(
            (e) => e.message,
            'message',
            startsWith('knowledge-v2.json yüklenemedi: 400'),
          ),
        ),
      );
      expect(
        requests.where((r) => bodyOf(r).contains('manifest.json')),
        isEmpty,
      );
    });

    test('needs all three variables', () async {
      for (final missing in _pbEnv.keys) {
        requests.clear();
        await expectLater(
          run(
            ['--version', '2', '--backend', 'pocketbase'],
            environment: {..._pbEnv}..remove(missing),
            client: pocketBase(),
          ),
          throwsA(isA<PublishKnowledgeException>()),
        );
        expect(requests, isEmpty, reason: missing);
      }
    });

    test('logs neither the password nor the token', () async {
      await run(
        ['--version', '2', '--backend', 'pocketbase'],
        environment: _pbEnv,
        client: pocketBase(),
      );
      for (final secret in [_password, _token]) {
        expect(logs.where((line) => line.contains(secret)), isEmpty);
      }
    });
  });

  test('Supabase stays the default backend', () async {
    final client = MockClient((request) async {
      requests.add(request);
      return _json({'Key': request.url.path});
    });
    await run(
      ['--version', '2'],
      environment: {
        'SUPABASE_URL': 'http://sb.test',
        'SUPABASE_SERVICE_ROLE_KEY': 'k',
      },
      client: client,
    );
    expect(requests.map((r) => '${r.url.path} ${r.headers['x-upsert']}'), [
      '/storage/v1/object/knowledge/knowledge-v2.json false',
      '/storage/v1/object/knowledge/manifest.json true',
    ]);
  });

  test('--dry-run sends nothing', () async {
    await run(
      ['--version', '2', '--backend', 'pocketbase', '--dry-run'],
      environment: const {},
      client: pocketBase(),
    );
    expect(requests, isEmpty);
    expect(logs, [startsWith('1 makale')]);
  });

  test('an unknown backend is a usage error', () async {
    await expectLater(
      run(
        ['--version', '2', '--backend', 'firebase'],
        environment: _pbEnv,
        client: pocketBase(),
      ),
      throwsA(
        isA<PublishKnowledgeException>().having(
          (e) => e.message,
          'message',
          startsWith('Kullanım:'),
        ),
      ),
    );
  });
}
