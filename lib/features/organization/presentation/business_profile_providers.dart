import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:mobil_arici/core/services/logo_file_store_provider.dart';
import 'package:mobil_arici/core/sync/sync_providers.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/organization/domain/business_profile.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'business_profile_providers.g.dart';

/// Oturumdaki işletmenin profili; işletme yoksa null. Offline açılır: yalnız
/// yerel DB ve cihazdaki işletme kopyası okunur.
@riverpod
OrganizationProfile? businessProfile(Ref ref) {
  final local = ref.watch(localOrganizationProfileProvider).value;
  if (local != null) return local;
  final organization = ref.watch(currentOrganizationProvider).value;
  if (organization == null) return null;
  return (
    id: organization.id,
    name: organization.name,
    countryCode: organization.countryCode,
    currency: organization.currency,
    operationType: organization.operationType,
    avatarColor: null,
    logoPath: null,
    createdAt: null,
  );
}

/// Kovan, arılık ve muayene sayısı; kayıtlardan canlı. İşletme yoksa sıfır.
@riverpod
Stream<BusinessCounts> businessCounts(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) {
    return Stream.value((hives: 0, apiaries: 0, inspections: 0));
  }
  return ref.watch(organizationRepositoryProvider).watchCounts(orgId);
}

/// Üyeler adlarıyla (ekip kartı); işletme yoksa boş.
@riverpod
Stream<List<MemberProfile>> memberProfiles(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) return Stream.value(const []);
  return ref.watch(membershipRepositoryProvider).watchProfiles(orgId);
}

/// Oturumdaki kullanıcının üyeliği (adı ve rolü); üyelik henüz inmemişse
/// null.
@riverpod
MemberProfile? ownMemberProfile(Ref ref) {
  final userId = ref.watch(currentUserProvider.select((user) => user?.id));
  final members = ref.watch(memberProfilesProvider).value ?? const [];
  for (final member in members) {
    if (member.userId == userId) return member;
  }
  return null;
}

/// İşletme satırı ya da kullanıcının adı outbox'ta gönderilmeyi bekliyor
/// mu ("eşitlenecek" rozeti).
@riverpod
Stream<bool> businessProfilePending(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  final membershipId = ref.watch(
    ownMemberProfileProvider.select((member) => member?.membershipId),
  );
  return ref.watch(syncRepositoryProvider).watchAnyPending([
    ?(orgId == null ? null : ('organizations', orgId)),
    ?(membershipId == null ? null : ('memberships', membershipId)),
  ]);
}

/// Logo dosyası bu telefonda varsa; yoksa (henüz inmedi) null.
@riverpod
Future<File?> organizationLogoFile(Ref ref, String storagePath) =>
    ref.watch(logoFileStoreProvider).find(logoFileName(storagePath));
