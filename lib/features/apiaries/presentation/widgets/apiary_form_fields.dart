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
  const new({required this.apiaryId, super.key});

  /// Düzenlenen arılık; yeni arılıkta null.
  final String? apiaryId;

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

    final fieldStyle = context.typography.subtitle.copyWith(
      fontWeight: context.typography.body.fontWeight,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabeledField(
          label: l10n.apiaryFormName,
          child: TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            style: fieldStyle,
            decoration: InputDecoration(hintText: l10n.apiaryFormNameHint),
            onChanged: controller.updateName,
          ),
        ),
        SizedBox(height: spacing.xl),
        _LocationSection(apiaryId: widget.apiaryId),
        SizedBox(height: spacing.xl),
        // Ad ve telefon yan yana; ikisi de kısa.
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: spacing.md,
          children: [
            Expanded(
              child: LabeledField(
                label: l10n.apiaryFormLandownerName,
                child: TextField(
                  controller: _landownerName,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  style: context.typography.body,
                  onChanged: controller.updateLandownerName,
                ),
              ),
            ),
            Expanded(
              child: LabeledField(
                label: l10n.apiaryFormLandownerPhone,
                child: TextField(
                  controller: _landownerPhone,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  style: context.typography.body,
                  onChanged: controller.updateLandownerPhone,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: spacing.xl),
        LabeledField(
          label: l10n.apiaryFormNotes,
          child: TextField(
            controller: _notes,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            minLines: 2,
            maxLines: null,
            style: context.typography.body,
            onChanged: controller.updateNotes,
          ),
        ),
      ],
    );
  }
}

/// Konum kartındaki eylemler: kart zemininde koyu bal yazılı, en az
/// dokunma hedefi yüksekliğinde.
ButtonStyle _locationActionStyle(BuildContext context) => TextButton.styleFrom(
  minimumSize: Size.square(context.touchTargets.minimum),
  backgroundColor: context.colors.surfaceContainer,
  foregroundColor: context.colors.primary,
  textStyle: context.typography.label,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(context.radii.button),
  ),
);

/// Konum: solda konum işareti, yanında kayıtlı koordinat ve doğruluğu ya da
/// "konum yok"; altında GPS'ten alma ve kaldırma. Konum ancak dokununca
/// alınır; arıcı arılıkta değilken (ör. evde) yanlış nokta kendiliğinden
/// yazılmasın.
class _LocationSection extends ConsumerWidget {
  const new({required this.apiaryId});

  final String? apiaryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final provider = apiaryFormControllerProvider(apiaryId);
    final form = ref.watch(provider).value;
    if (form == null) return const SizedBox.shrink();
    final controller = ref.read(provider.notifier);
    final secondaryText = context.typography.bodySmall.copyWith(
      color: colors.textSecondary,
    );
    final latitude = form.latitude;
    final longitude = form.longitude;
    final accuracy = form.accuracyM;
    final failure = form.locationFailure;
    final action = _locationActionStyle(context);

    final Widget details;
    final List<Widget> actions;
    if (form.locating) {
      details = Semantics(
        liveRegion: true,
        child: Text(l10n.apiaryFormLocating, style: context.typography.body),
      );
      actions = [
        TextButton(
          style: action,
          onPressed: controller.cancelLocate,
          child: Text(l10n.actionCancel),
        ),
      ];
    } else {
      details = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (latitude != null && longitude != null) ...[
            Text(
              AppFormat.of(context).coordinates(latitude, longitude),
              style: context.typography.label,
            ),
            if (accuracy != null)
              Text(
                l10n.apiaryFormLocationAccuracy(accuracy.round()),
                style: secondaryText,
              ),
          ] else
            Text(l10n.apiaryFormLocationNone, style: secondaryText),
        ],
      );
      actions = [
        TextButton(
          style: action,
          onPressed: controller.locate,
          child: Text(
            form.hasLocation
                ? l10n.apiaryFormLocationRetake
                : l10n.apiaryFormLocationTake,
          ),
        ),
        if (form.hasLocation)
          TextButton(
            style: action.copyWith(
              foregroundColor: WidgetStatePropertyAll(colors.textSecondary),
            ),
            onPressed: controller.clearLocation,
            child: Text(l10n.apiaryFormLocationClear),
          ),
      ];
    }

    return LabeledField(
      label: l10n.apiaryFormLocation,
      group: true,
      child: AppCard(
        child: Padding(
          padding: EdgeInsets.all(spacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  SizedBox.square(
                    dimension: context.touchTargets.fieldLarge,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: colors.surfaceContainer,
                        borderRadius: BorderRadius.circular(
                          context.radii.button,
                        ),
                      ),
                      child: Center(
                        child: form.locating
                            ? SizedBox.square(
                                dimension: context.sizes.icon,
                                child: const CircularProgressIndicator(),
                              )
                            : Icon(
                                form.hasLocation
                                    ? Icons.location_on_rounded
                                    : Icons.location_off_outlined,
                                size: context.sizes.icon,
                                color: form.hasLocation
                                    ? colors.primary
                                    : colors.textSecondary,
                              ),
                      ),
                    ),
                  ),
                  SizedBox(width: spacing.md),
                  Expanded(child: details),
                ],
              ),
              if (failure != null) ...[
                SizedBox(height: spacing.md),
                _LocationFailureMessage(
                  failure,
                  onOpenSettings: controller.openLocationSettings,
                ),
              ],
              SizedBox(height: spacing.md),
              Wrap(
                spacing: spacing.sm,
                runSpacing: spacing.sm,
                children: actions,
              ),
            ],
          ),
        ),
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
            style: _locationActionStyle(context),
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
