import 'package:mobil_arici/features/organization/domain/membership_role.dart';

/// Üretilmiş davet kodu: `code`, `role` rolüyle `expiresAt`'e kadar geçerli.
typedef Invite = ({String code, MembershipRole role, DateTime expiresAt});

/// Davet kodu alfabesi; 0/O ve 1/I/L gibi karışanlar yok. Sunucudaki
/// `invites.code` kısıtıyla aynı küme.
const inviteCodeAlphabet = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';
const inviteCodeLength = 6;

/// Yazılan ya da yapıştırılan kodu düzenler: boşluk ve tireler atılır,
/// harfler büyütülür ("ar7-k2q" → "AR7K2Q").
String normalizeInviteCode(String input) =>
    input.replaceAll(RegExp(r'[\s-]'), '').toUpperCase();

/// [code] (düzenlenmiş) geçerli biçimde mi: altı karakter, alfabeden.
bool isInviteCode(String code) =>
    code.length == inviteCodeLength &&
    code.split('').every(inviteCodeAlphabet.contains);
