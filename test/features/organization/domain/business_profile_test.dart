import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/business/business_config.dart';
import 'package:mobil_arici/features/finance/domain/finance_rules.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';
import 'package:mobil_arici/features/organization/domain/business_profile.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';
import 'package:mobil_arici/features/organization/domain/role_permissions.dart';

FinanceTransaction _tx(
  String id,
  TransactionKind kind,
  double amount,
  String currency, {
  int year = 2026,
}) => FinanceTransaction(
  id: id,
  orgId: 'org-1',
  kind: kind,
  category: TransactionCategory.equipment,
  amount: amount,
  currency: currency,
  occurredOn: DateTime(year, 5),
  createdAt: DateTime.utc(year, 5),
  updatedAt: DateTime.utc(year, 5),
);

void main() {
  group('nameInitials', () {
    test('ilk iki kelimenin baş harfleri', () {
      expect(nameInitials('Yılmaz Arıcılık'), 'YA');
      expect(nameInitials('  ahmet   yılmaz kaya '), 'ay');
      expect(nameInitials('Petek'), 'P');
      expect(nameInitials('   '), '');
    });
  });

  group('seasonNumber', () {
    test('ilk kaydın yılı 1. sezon, her takvim yılı bir artar', () {
      expect(seasonNumber(DateTime(2026, 3), DateTime(2026, 11)), 1);
      expect(seasonNumber(DateTime(2024, 3), DateTime(2026)), 3);
    });

    test('saat geri kalmışsa da en az 1', () {
      expect(seasonNumber(DateTime(2027), DateTime(2026)), 1);
    });
  });

  test('roleDistribution owner dışındaki rolleri rol sırasıyla sayar', () {
    expect(
      roleDistribution([
        MembershipRole.viewer,
        MembershipRole.owner,
        MembershipRole.worker,
        MembershipRole.partner,
        MembershipRole.worker,
      ]),
      [
        (MembershipRole.partner, 1),
        (MembershipRole.worker, 2),
        (MembershipRole.viewer, 1),
      ],
    );
    expect(roleDistribution([MembershipRole.owner]), isEmpty);
  });

  test('yalnız gezginciden sabite geçiş onay ister', () {
    const migratory = OperationType.migratory;
    const stationary = OperationType.stationary;
    expect(operationTypeChangeNeedsConfirmation(migratory, stationary), isTrue);
    expect(
      operationTypeChangeNeedsConfirmation(stationary, migratory),
      isFalse,
    );
    expect(operationTypeChangeNeedsConfirmation(migratory, migratory), isFalse);
  });

  test('logo yolu işletme klasöründe, dosya adı son parça', () {
    final path = logoStoragePath(orgId: 'org-1', id: 'logo-1');
    expect(path, 'org-1/logo-1.jpg');
    expect(logoFileName(path), 'logo-1.jpg');
  });

  test('para birimi listesi sıralı, tekrarsız ve mevcut kodu içerir', () {
    final codes = currencyChoices('XYZ');
    expect(codes, containsAll(['TRY', 'EUR', 'USD', 'XYZ']));
    expect(codes.toSet().length, codes.length);
    expect(codes, [...codes]..sort());
  });

  group('BusinessConfig', () {
    test('gezginci işletmede gezginci modülleri açık', () {
      final config = resolveBusinessConfig(OperationType.migratory);
      expect(config.operationType, OperationType.migratory);
      expect(config.features.migratory, isTrue);
    });

    test('sabit işletmede kapalı', () {
      expect(
        resolveBusinessConfig(OperationType.stationary).features.migratory,
        isFalse,
      );
    });
  });

  test('işletmeyi yalnız owner ve partner düzenler (4 rol)', () {
    expect(canEditOrganization(MembershipRole.owner), isTrue);
    expect(canEditOrganization(MembershipRole.partner), isTrue);
    expect(canEditOrganization(MembershipRole.worker), isFalse);
    expect(canEditOrganization(MembershipRole.viewer), isFalse);
    expect(canEditOrganization(null), isFalse);
  });

  group('seasonSummariesByCurrency', () {
    test('para birimleri ayrı toplanır, dönüştürülmez', () {
      final summaries = seasonSummariesByCurrency([
        _tx('1', TransactionKind.income, 1000, 'TRY'),
        _tx('2', TransactionKind.expense, 250.5, 'TRY'),
        _tx('3', TransactionKind.income, 40, 'EUR'),
        _tx('4', TransactionKind.expense, 10, 'EUR'),
        _tx('5', TransactionKind.income, 999, 'USD', year: 2025),
      ], year: 2026);

      expect(summaries.keys, ['EUR', 'TRY']);
      expect(summaries['TRY']!.net, 749.5);
      expect(summaries['EUR']!.income, 40);
      expect(summaries['EUR']!.net, 30);
    });
  });
}
