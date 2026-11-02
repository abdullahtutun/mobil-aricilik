import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/features/finance/domain/customer.dart';
import 'package:mobil_arici/features/finance/presentation/finance_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'customer_form_controller.freezed.dart';
part 'customer_form_controller.g.dart';

@freezed
abstract class CustomerFormState with _$CustomerFormState {
  const factory({
    @Default('') String name,
    @Default('') String phone,
    @Default('') String address,
    @Default('') String notes,
    @Default(false) bool saving,
  }) = _CustomerFormState;
}

extension CustomerFormProgress on CustomerFormState {
  bool get canSave => name.trim().isNotEmpty && !saving;
}

/// Müşteri ekleme ([customerId] null) ve düzenleme formu: ad, telefon,
/// adres ve not. Düzenlenecek müşteri yoksa ya da silinmişse durum null.
@riverpod
class CustomerFormController extends _$CustomerFormController {
  @override
  Future<CustomerFormState?> build(String? customerId) async {
    if (customerId == null) return const CustomerFormState();
    final customer = await ref
        .read(customerRepositoryProvider)
        .findById(customerId);
    return customer == null
        ? null
        : CustomerFormState(
            name: customer.name,
            phone: customer.phone ?? '',
            address: customer.address ?? '',
            notes: customer.notes ?? '',
          );
  }

  void setName(String name) => _update((form) => form.copyWith(name: name));

  void setPhone(String phone) => _update((form) => form.copyWith(phone: phone));

  void setAddress(String address) =>
      _update((form) => form.copyWith(address: address));

  void setNotes(String notes) => _update((form) => form.copyWith(notes: notes));

  /// Müşteriyi yazar ve döner; kaydedilemiyorsa ya da düzenlenen müşteri bu
  /// arada silindiyse null.
  Future<Customer?> save() async {
    final form = state.value;
    final orgId = ref.read(currentOrgIdProvider);
    if (form == null || !form.canSave || orgId == null) return null;
    _update((form) => form.copyWith(saving: true));

    final repository = ref.read(customerRepositoryProvider);
    final id = customerId;
    // Yazma hata atsa da Kaydet yeniden açılsın.
    try {
      if (id == null) {
        return await repository.create(
          orgId: orgId,
          name: form.name,
          phone: form.phone,
          address: form.address,
          notes: form.notes,
        );
      }
      final latest = await repository.findById(id);
      if (latest == null) {
        if (ref.mounted) state = const AsyncData(null);
        return null;
      }
      return await repository.update(
        latest.copyWith(
          name: form.name,
          phone: form.phone,
          address: form.address,
          notes: form.notes,
        ),
      );
    } finally {
      if (ref.mounted) _update((form) => form.copyWith(saving: false));
    }
  }

  void _update(CustomerFormState Function(CustomerFormState form) change) {
    if (state.value case final form?) state = AsyncData(change(form));
  }
}
