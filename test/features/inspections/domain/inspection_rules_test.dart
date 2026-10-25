import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/tables/inspection_tables.dart';
import 'package:mobil_arici/features/health/domain/withdrawal.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_draft.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_rules.dart';

final _at = DateTime.utc(2026, 10, 20, 9);

Inspection _inspection({
  QueenState? queenState = QueenState.seen,
  int? beeFrames = 8,
  int? broodFrames,
  bool? swarmSigns = false,
  Map<String, Object?> data = const {
    'actions': ['fed'],
  },
}) => Inspection(
  id: 'inspection-1',
  orgId: 'org-1',
  hiveId: 'hive-1',
  apiaryId: 'apiary-1',
  inspectedAt: _at,
  createdAt: _at,
  updatedAt: _at,
  queenState: queenState,
  beeFrames: beeFrames,
  broodFrames: broodFrames,
  swarmSigns: swarmSigns,
  data: data,
);

void main() {
  group('prefilledDraft', () {
    test('önceki muayene yoksa form boş, öneri yok', () {
      expect(prefilledDraft(null), const InspectionDraft());
    });

    test('önceki muayenenin dolu alanları öneri olur; işlemler boş başlar', () {
      final draft = prefilledDraft(_inspection());

      expect(
        draft.values,
        const InspectionValues(
          queenState: QueenState.seen,
          beeFrames: 8,
          swarmSigns: false,
        ),
      );
      // false da bir değer: "oğul belirtisi yok" bakılmış demek.
      expect(draft.suggested, {
        InspectionField.queenState,
        InspectionField.beeFrames,
        InspectionField.swarmSigns,
      });
    });
  });

  group('change', () {
    final draft = prefilledDraft(_inspection());

    test('değişen alan öneri olmaktan çıkar, diğerleri öneri kalır', () {
      final changed = draft.change(
        InspectionField.beeFrames,
        draft.values.copyWith(beeFrames: 9),
      );

      expect(changed.values.beeFrames, 9);
      expect(changed.isSuggested(InspectionField.beeFrames), isFalse);
      expect(changed.isSuggested(InspectionField.queenState), isTrue);
    });

    test('aynı değerle dokunmak öneriyi onaylar', () {
      final confirmed = draft.change(InspectionField.queenState, draft.values);

      expect(confirmed.values, draft.values);
      expect(confirmed.isSuggested(InspectionField.queenState), isFalse);
    });

    test('işlem değişince öneriler aynı kalır', () {
      final changed = draft.change(
        null,
        draft.values.copyWith(actions: {InspectionAction.fed}),
      );

      expect(changed.suggested, draft.suggested);
    });
  });

  group('işlemler (data)', () {
    test('işlemler sabit sırada yazılır; işlem yoksa anahtar olmaz', () {
      expect(
        inspectionData({InspectionAction.fed, InspectionAction.superAdded}),
        {
          'actions': ['super_added', 'fed'],
        },
      );
      expect(inspectionData({}), isEmpty);
    });

    test('data içindeki diğer anahtarlar korunur', () {
      final data = {'later_field': 1, 'actions': <String>[]};

      expect(inspectionData({InspectionAction.fed}, data: data), {
        'later_field': 1,
        'actions': ['fed'],
      });
      expect(data, {'later_field': 1, 'actions': <String>[]});
    });

    test('bu sürümün tanımadığı işlem okunurken atlanır', () {
      final inspection = _inspection(
        data: {
          'actions': ['fed', 'new_action'],
        },
      );

      expect(inspection.actions, {InspectionAction.fed});
      expect(_inspection(data: const {}).actions, isEmpty);
    });
  });

  group('bekleme süresi gerekçesi (data)', () {
    const override = WithdrawalOverride(
      treatmentId: 'treatment-1',
      reason: WithdrawalOverrideReason.removedEarly,
    );

    test('bal katı eklendiyse uygulama ve gerekçeyle yazılır', () {
      expect(
        inspectionData({
          InspectionAction.superAdded,
        }, withdrawalOverride: override),
        {
          'actions': ['super_added'],
          'withdrawal_override': {
            'treatment_id': 'treatment-1',
            'reason': 'removed_early',
          },
        },
      );
    });

    test('bal katı yoksa gerekçe yazılmaz; eski gerekçe de silinir', () {
      final data = {
        'withdrawal_override': {'treatment_id': 'x', 'reason': 'not_for_sale'},
      };

      expect(
        inspectionData(
          {InspectionAction.fed},
          data: data,
          withdrawalOverride: override,
        ),
        {
          'actions': ['fed'],
        },
      );
    });

    test('okunurken gerekçe geri gelir; yoksa ya da tanınmıyorsa null', () {
      final saved = _inspection(
        data: inspectionData({
          InspectionAction.superAdded,
        }, withdrawalOverride: override),
      );

      expect(saved.withdrawalOverride, override);
      expect(_inspection().withdrawalOverride, isNull);
      expect(
        _inspection(
          data: const {
            'withdrawal_override': {'treatment_id': 'x', 'reason': 'later'},
          },
        ).withdrawalOverride,
        isNull,
      );
      expect(
        _inspection(data: const {'withdrawal_override': 'bozuk'})
            .withdrawalOverride,
        isNull,
      );
    });

    test('gerekçe taslakla birlikte saklanır', () {
      const converter = InspectionDraftConverter();
      const draft = InspectionDraft(
        values: InspectionValues(actions: {InspectionAction.superAdded}),
        withdrawalOverride: WithdrawalOverride(
          treatmentId: 'treatment-1',
          reason: WithdrawalOverrideReason.notForSale,
        ),
      );

      expect(converter.fromSql(converter.toSql(draft)), draft);
      // Gerekçe alanı olmadan yazılmış eski taslak da okunur.
      expect(
        converter.fromSql('{"values": {"actions": ["fed"]}}'),
        const InspectionDraft(
          values: InspectionValues(actions: {InspectionAction.fed}),
        ),
      );
    });
  });

  test('taslak JSON metni olarak saklanır ve aynen geri okunur', () {
    const converter = InspectionDraftConverter();
    final draft = prefilledDraft(_inspection()).change(
      null,
      const InspectionValues(
        queenState: QueenState.seen,
        beeFrames: 8,
        swarmSigns: false,
        queenCells: QueenCells.supersedure,
        actions: {InspectionAction.excluderFitted},
      ),
    );

    final stored = converter.toSql(draft);

    expect(jsonDecode(stored), isA<Map<String, Object?>>());
    expect(converter.fromSql(stored), draft);
  });

  group('reminderAt', () {
    test('yerel takvimde gün sayar, saat aynı kalır', () {
      final inspectedAt = DateTime(2026, 10, 28, 14, 30).toUtc();

      final at = reminderAt(inspectedAt, 7).toLocal();

      expect(at, DateTime(2026, 11, 4, 14, 30));
      expect(reminderAt(inspectedAt, 7).isUtc, isTrue);
    });

    test('ay ve yıl sonunu geçer', () {
      final inspectedAt = DateTime(2026, 12, 25, 8).toUtc();

      expect(reminderAt(inspectedAt, 14).toLocal(), DateTime(2027, 1, 8, 8));
    });
  });

  test('yalnız aktif kovan muayene edilir', () {
    Hive hive(HiveStatus status) => Hive(
      id: 'hive-1',
      orgId: 'org-1',
      number: '101',
      type: HiveType.langstroth,
      apiaryId: 'apiary-1',
      status: status,
      createdAt: _at,
      updatedAt: _at,
    );

    expect(
      {
        for (final status in HiveStatus.values)
          status: canInspect(hive(status)),
      },
      {
        HiveStatus.active: true,
        HiveStatus.dead: false,
        HiveStatus.merged: false,
        HiveStatus.sold: false,
        HiveStatus.lost: false,
      },
    );
  });
}
