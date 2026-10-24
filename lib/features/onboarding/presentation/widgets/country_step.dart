import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/region/country_currencies.dart';
import 'package:mobil_arici/core/region/country_names.dart';
import 'package:mobil_arici/features/onboarding/domain/onboarding_rules.dart';
import 'package:mobil_arici/features/onboarding/presentation/onboarding_controller.dart';
import 'package:mobil_arici/features/onboarding/presentation/widgets/step_header.dart';

/// Ülke seçimi: aranabilir liste, adlar uygulamanın dilinde ve alfabe
/// sırasında. Cihazdan önerilen ülke arama boşken en üstte durur.
class CountryStep extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<CountryStep> createState() => _CountryStepState();
}

class _CountryStepState extends ConsumerState<CountryStep> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final state = ref.watch(onboardingControllerProvider);
    final names = countryNamesFor(Localizations.localeOf(context).languageCode);
    final query = _search.text;
    final suggested = query.trim().isEmpty ? state.suggestedCountryCode : null;
    final matches = [
      for (final MapEntry(key: code, value: name) in names.entries)
        if (code != suggested &&
            matchesCountryQuery(code: code, name: name, query: query))
          code,
    ];

    Widget label(String text) => Padding(
      padding: EdgeInsets.fromLTRB(spacing.lg, spacing.lg, spacing.lg, 0),
      child: Text(
        text,
        style: context.typography.label.copyWith(
          color: context.colors.textSecondary,
        ),
      ),
    );

    Widget tile(String code) {
      final selected = code == state.countryCode;
      return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: spacing.lg),
        title: Text(names[code]!, style: context.typography.body),
        subtitle: Text(currencyCodeFor(code)),
        trailing: selected ? const Icon(Icons.check_rounded) : null,
        selected: selected,
        onTap: () =>
            ref.read(onboardingControllerProvider.notifier).selectCountry(code),
      );
    }

    return ListView(
      padding: EdgeInsets.symmetric(vertical: spacing.lg),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing.lg),
          child: StepHeader(
            title: l10n.onboardingCountryTitle,
            message: l10n.onboardingCountryMessage,
          ),
        ),
        SizedBox(height: spacing.lg),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing.lg),
          child: TextField(
            controller: _search,
            textInputAction: TextInputAction.search,
            autocorrect: false,
            style: context.typography.body,
            decoration: InputDecoration(
              labelText: l10n.onboardingCountrySearch,
              prefixIcon: const Icon(Icons.search_rounded),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
        if (suggested != null) ...[
          label(l10n.onboardingCountrySuggested),
          tile(suggested),
          label(l10n.onboardingCountryAll),
        ],
        if (matches.isEmpty)
          Padding(
            padding: EdgeInsets.all(spacing.lg),
            child: Text(
              l10n.onboardingCountryNoMatch,
              style: context.typography.body,
            ),
          ),
        for (final code in matches) tile(code),
      ],
    );
  }
}
