import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/onboarding/presentation/onboarding_controller.dart';
import 'package:mobil_arici/features/onboarding/presentation/widgets/step_header.dart';

/// İşletme adı. Klavyedeki tamam tuşu da sonraki adıma geçer.
class NameStep extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<NameStep> createState() => _NameStepState();
}

class _NameStepState extends ConsumerState<NameStep> {
  // Geri dönülüp yeniden gelinince yazılan ad korunur.
  late final _name = TextEditingController(
    text: ref.read(onboardingControllerProvider).name,
  );

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(onboardingControllerProvider.notifier);

    return ListView(
      padding: EdgeInsets.all(context.spacing.lg),
      children: [
        StepHeader(
          title: l10n.onboardingNameTitle,
          message: l10n.onboardingNameMessage,
        ),
        SizedBox(height: context.spacing.xl),
        TextField(
          controller: _name,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          style: context.typography.body,
          decoration: InputDecoration(
            labelText: l10n.onboardingNameLabel,
            hintText: l10n.onboardingNameHint,
          ),
          onChanged: controller.updateName,
          onSubmitted: (_) => controller.next(),
        ),
      ],
    );
  }
}
