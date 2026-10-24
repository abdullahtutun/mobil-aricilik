import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/services/location_service.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_form_controller.dart';

/// Arılık formunun alanları: ad, GPS'ten konum, arazi sahibinin adı ve
/// telefonu, notlar. Ekleme/düzenleme ekranı ve onboarding'in ilk arılık
/// adımı kullanır; kaydet butonu onlarda. Form yüklenmiş olmalı.
class ApiaryFormFields extends ConsumerStatefulWidget {
  const new({required this.apiaryId, super.key, this.autofocusName = false});

  /// Düzenlenen arılık; yeni arılıkta null.
  final String? apiaryId;
  final bool autofocusName;

  @override
  ConsumerState<ApiaryFormFields> createState() => _ApiaryFormFieldsState();
}

class _ApiaryFormFieldsState extends ConsumerState<ApiaryFormFields> {
  late final ApiaryFormState _initial = ref
      .read(apiaryFormControllerProvider(widget.apiaryId))
      .value!;
  late final _name = TextEditingController(text: _initial.name);
  late final _landownerName = TextEditingController(
    text: _initial.landownerName,
  );
  late final _landownerPhone = TextEditingController(
    text: _initial.landownerPhone,
  );
  late final _notes = TextEditingController(text: _initial.notes);

  @override
  void dispose() {
    _name.dispose();
    _landownerName.dispose();
    _landownerPhone.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final controller = ref.read(
      apiaryFormControllerProvider(widget.apiaryId).notifier,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _name,
          autofocus: widget.autofocusName,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          style: context.typography.body,
          decoration: _decoration(
            label: l10n.apiaryFormName,
            hint: l10n.apiaryFormNameHint,
          ),
          onChanged: controller.updateName,
        ),
        SizedBox(height: spacing.lg),
        _LocationSection(apiaryId: widget.apiaryId),
        SizedBox(height: spacing.lg),
        TextField(
          controller: _landownerName,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          style: context.typography.body,
          decoration: _decoration(label: l10n.apiaryFormLandownerName),
          onChanged: controller.updateLandownerName,
        ),
        SizedBox(height: spacing.lg),
        TextField(
          controller: _landownerPhone,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          style: context.typography.body,
          decoration: _decoration(label: l10n.apiaryFormLandownerPhone),
          onChanged: controller.updateLandownerPhone,
        ),
        SizedBox(height: spacing.lg),
        TextField(
          controller: _notes,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          minLines: 3,
          maxLines: null,
          style: context.typography.body,
          decoration: _decoration(label: l10n.apiaryFormNotes),
          onChanged: controller.updateNotes,
        ),
      ],
    );
  }

  static InputDecoration _decoration({required String label, String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      alignLabelWithHint: true,
    );
  }
}

/// Konum bölümündeki ikincil eylemler (kaldır, ayarları aç): tam genişlik,
/// en az dokunma hedefi yüksekliğinde.
ButtonStyle _secondaryActionStyle(BuildContext context) => TextButton.styleFrom(
  minimumSize: Size.fromHeight(context.touchTargets.minimum),
  foregroundColor: context.colors.secondary,
  textStyle: context.typography.label,
);

/// Konum: kayıtlı koordinat ya da "konum yok", GPS'ten alma ve kaldırma.
/// Konum ancak dokununca alınır; arıcı arılıkta değilken (ör. evde) yanlış
/// nokta kendiliğinden yazılmasın.
class _LocationSection extends ConsumerWidget {
  const new({required this.apiaryId});

  final String? apiaryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final provider = apiaryFormControllerProvider(apiaryId);
    final form = ref.watch(provider).value;
    if (form == null) return const SizedBox.shrink();
    final controller = ref.read(provider.notifier);
    final secondaryText = context.typography.body.copyWith(
      color: context.colors.textSecondary,
    );

    final List<Widget> children;
    if (form.locating) {
      children = [
        Semantics(
          liveRegion: true,
          child: Row(
            children: [
              SizedBox.square(
                dimension: context.sizes.icon,
                child: const CircularProgressIndicator(),
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: Text(
                  l10n.apiaryFormLocating,
                  style: context.typography.body,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: spacing.md),
        BigButton(
          variant: BigButtonVariant.secondary,
          label: l10n.actionCancel,
          icon: Icons.close_rounded,
          onPressed: controller.cancelLocate,
        ),
      ];
    } else {
      final latitude = form.latitude;
      final longitude = form.longitude;
      final accuracy = form.accuracyM;
      final failure = form.locationFailure;
      children = [
        if (latitude != null && longitude != null) ...[
          Text(
            AppFormat.of(context).coordinates(latitude, longitude),
            style: context.typography.subtitle,
          ),
          if (accuracy != null)
            Text(
              l10n.apiaryFormLocationAccuracy(accuracy.round()),
              style: secondaryText,
            ),
        ] else
          Text(l10n.apiaryFormLocationNone, style: secondaryText),
        if (failure != null) ...[
          SizedBox(height: spacing.md),
          _LocationFailureMessage(
            failure,
            onOpenSettings: controller.openLocationSettings,
          ),
        ],
        SizedBox(height: spacing.md),
        BigButton(
          variant: BigButtonVariant.secondary,
          label: form.hasLocation
              ? l10n.apiaryFormLocationRetake
              : l10n.apiaryFormLocationTake,
          icon: Icons.my_location_rounded,
          onPressed: controller.locate,
        ),
        if (form.hasLocation) ...[
          SizedBox(height: spacing.sm),
          TextButton.icon(
            style: _secondaryActionStyle(context),
            onPressed: controller.clearLocation,
            icon: const Icon(Icons.location_off_rounded),
            label: Text(l10n.apiaryFormLocationClear),
          ),
        ],
      ];
    }

    return SectionCard(
      title: l10n.apiaryFormLocation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

/// Konum alınamadı: uyarı cümlesi; ayardan çözülebilen hatada ayarları açan
/// buton.
class _LocationFailureMessage extends StatelessWidget {
  const new(this.failure, {required this.onOpenSettings});

  final LocationFailure failure;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fixableInSettings = switch (failure) {
      LocationFailure.serviceDisabled ||
      LocationFailure.permissionDeniedForever => true,
      LocationFailure.permissionDenied ||
      LocationFailure.timeout ||
      LocationFailure.unknown => false,
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StatusMessage(
          status: AppStatus.warning,
          message: _message(l10n, failure),
        ),
        if (fixableInSettings)
          TextButton.icon(
            style: _secondaryActionStyle(context),
            onPressed: onOpenSettings,
            icon: const Icon(Icons.settings_rounded),
            label: Text(l10n.apiaryFormOpenSettings),
          ),
      ],
    );
  }

  static String _message(AppLocalizations l10n, LocationFailure failure) {
    return switch (failure) {
      LocationFailure.serviceDisabled =>
        l10n.apiaryFormLocationErrorServiceDisabled,
      LocationFailure.permissionDenied =>
        l10n.apiaryFormLocationErrorPermissionDenied,
      LocationFailure.permissionDeniedForever =>
        l10n.apiaryFormLocationErrorPermissionDeniedForever,
      LocationFailure.timeout => l10n.apiaryFormLocationErrorTimeout,
      LocationFailure.unknown => l10n.apiaryFormLocationErrorUnknown,
    };
  }
}
