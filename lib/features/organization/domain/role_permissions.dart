import 'package:mobil_arici/features/organization/domain/membership_role.dart';

/// Rol kısıtlarının arayüzdeki karşılığı. Asıl yetki sunucuda (RLS); bunlar
/// yalnız kullanıcıya yapamayacağı eylemi göstermemek içindir. Rol henüz
/// bilinmiyorsa (üyelik senkronla inmedi) [role] null'dır ve hiçbir şey
/// gizlenmez; sunucu zaten reddeder.

/// Kayıt ekleme ve düzenleme: viewer dışındaki herkes.
bool canWriteRecords(MembershipRole? role) => role != MembershipRole.viewer;

/// Finans menüsü: yalnız owner ve partner. Worker kayıt girer ama finansı
/// görmez; viewer da görmez.
bool canSeeFinance(MembershipRole? role) =>
    role == null ||
    role == MembershipRole.owner ||
    role == MembershipRole.partner;

/// Arılık ve kovan silme: yalnız owner ve partner (kullanıcı kararı). Rol
/// bilinmiyorsa gösterilmez; geri dönüşü olmayan bir eylem.
bool canDeleteApiariesAndHives(MembershipRole? role) =>
    role == MembershipRole.owner || role == MembershipRole.partner;

/// Davet kodu üretme: owner ve partner.
bool canInvite(MembershipRole? role) =>
    role == MembershipRole.owner || role == MembershipRole.partner;

/// Rol değiştirme ve üyeyi çıkarma: yalnız owner.
bool canManageMembers(MembershipRole? role) => role == MembershipRole.owner;

/// İşletme bilgilerini değiştirme (ör. AKS'de beyan edilen kovan sayısı):
/// yalnız owner; sunucu da yalnız owner'ın güncellemesini kabul eder.
bool canEditOrganization(MembershipRole? role) => role == MembershipRole.owner;

/// Davetle verilebilen roller; owner davetle verilmez.
const invitableRoles = <MembershipRole>[
  MembershipRole.partner,
  MembershipRole.worker,
  MembershipRole.viewer,
];
