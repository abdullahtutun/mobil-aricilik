import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:mobil_arici/core/business/business_config.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'business_provider.g.dart';

/// Ekranların dinlediği işletme türü yapılandırması. Tür yerel işletme
/// satırından gelir (profilde değişince hemen uygulanır); satır henüz
/// inmemişse cihazdaki işletme kopyasından, o da yoksa gezginci (hiçbir
/// şey gizlenmez).
@Riverpod(keepAlive: true)
BusinessConfig businessConfig(Ref ref) {
  final local = ref.watch(
    localOrganizationProfileProvider.select(
      (profile) => profile.value?.operationType,
    ),
  );
  final cached = ref.watch(
    currentOrganizationProvider.select(
      (organization) => organization.value?.operationType,
    ),
  );
  return resolveBusinessConfig(local ?? cached ?? OperationType.migratory);
}
