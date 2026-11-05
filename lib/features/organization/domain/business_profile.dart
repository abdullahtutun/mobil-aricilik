import 'package:mobil_arici/core/region/country_currencies.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';

/// İşletme profili formunun yazdığı alanlar. Ad soyad üyelikte durduğu için
/// burada yok (`MembershipRepository.setOwnName`).
typedef BusinessProfileChange = ({
  String name,
  OrgAvatarColor? avatarColor,
  String? logoPath,
  OperationType operationType,
  String currency,
});

/// İşletmenin profil alanları. Yerel satırdan gelir; satır henüz inmemişse
/// cihazdaki işletme kopyasından (o zaman ilk kayıt tarihi, avatar ve logo
/// boş).
typedef OrganizationProfile = ({
  String id,
  String name,
  String countryCode,
  String currency,
  OperationType operationType,
  OrgAvatarColor? avatarColor,
  String? logoPath,
  DateTime? createdAt,
});

/// Profil ekranının üç sayısı; kayıtlardan hesaplanır, elle girilmez.
typedef BusinessCounts = ({int hives, int apiaries, int inspections});

/// Sabite geçerken gizlenecek gezginci kayıtları.
typedef MigratoryRecordCounts = ({int plans, int stops});

/// Ekip kartı ve profil için üye: kimlik, rol, (yazdıysa) adı soyadı ve
/// hesabını silmeyi onayladıysa kalıcı silme zamanı.
typedef MemberProfile = ({
  String membershipId,
  String userId,
  MembershipRole role,
  String? fullName,
  DateTime? deletionScheduledFor,
});

/// Logo yokken varsayılan avatar rengi (çam yeşili; docs/design).
const OrgAvatarColor defaultAvatarColor = OrgAvatarColor.pine;

/// Ad soyadın en çok uzunluğu; sunucu da CHECK ile denetler.
const maxFullNameLength = 80;

/// Addaki ilk iki kelimenin baş harfleri ("Yılmaz Arıcılık" → "YA");
/// büyük harfe çevirme dile göre yapıldığı için çağırana bırakılır. Ad boşsa
/// boş metin.
String nameInitials(String name) => name
    .trim()
    .split(RegExp(r'\s+'))
    .where((word) => word.isNotEmpty)
    .take(2)
    .map((word) => String.fromCharCode(word.runes.first))
    .join();

/// İlk kayıttan bu yana kaçıncı sezon: ilk kaydın yılı 1. sezon, her yeni
/// takvim yılı bir sonraki. Saat geri kalmışsa da en az 1.
int seasonNumber(DateTime firstRecord, DateTime now) {
  final seasons = now.year - firstRecord.year + 1;
  return seasons < 1 ? 1 : seasons;
}

/// Ekip kartındaki rol dağılımı: owner dışındaki roller, rol sırasıyla, en
/// az bir üyesi olanlar (ör. 1 ortak, 1 işçi, 1 danışman).
List<(MembershipRole, int)> roleDistribution(Iterable<MembershipRole> roles) {
  final counts = <MembershipRole, int>{};
  for (final role in roles) {
    counts[role] = (counts[role] ?? 0) + 1;
  }
  return [
    for (final role in MembershipRole.values)
      if (role != MembershipRole.owner && (counts[role] ?? 0) > 0)
        (role, counts[role]!),
  ];
}

/// Türü gezginciden sabite çevirmek onay ister (göç kayıtları gizlenir);
/// tersi ve değişmeyen tür istemez.
bool operationTypeChangeNeedsConfirmation(
  OperationType from,
  OperationType to,
) => from == OperationType.migratory && to == OperationType.stationary;

/// Logonun `org-logos` bucket'ındaki yolu: `org_id/id.jpg`. Sunucu aynı
/// kuralı CHECK ve politikayla denetler.
String logoStoragePath({required String orgId, required String id}) =>
    '$orgId/$id.jpg';

/// Logonun bu telefondaki dosya adı: yolun son parçası.
String logoFileName(String storagePath) => storagePath.split('/').last;

/// Para birimi seçeneği: ISO 4217 kodları, alfabe sırasıyla, tekrarsız.
/// İşletmenin mevcut kodu listede yoksa (eski kayıt) o da eklenir.
List<String> currencyChoices([String? current]) {
  final codes = {...countryCurrencyCodes.values, ?current}.toList()..sort();
  return codes;
}
