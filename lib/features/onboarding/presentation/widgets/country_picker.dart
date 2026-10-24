import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/region/country_currencies.dart';
import 'package:mobil_arici/core/region/country_names.dart';
import 'package:mobil_arici/features/onboarding/domain/onboarding_rules.dart';

/// Ülke seçicisini alttan, ekranın çoğunu kaplayan sayfa olarak açar;
/// seçilen ülke kodunu, kapatılırsa null döner.
Future<String?> showCountryPicker(
  BuildContext context, {
  required String? selected,
  required String? suggested,
}) => showOptionSheet<String>(
  context,
  (context) => CountryPicker(selected: selected, suggested: suggested),
);

/// Aranabilir ülke listesi: adlar uygulamanın dilinde ve alfabe sırasında.
/// Cihazdan önerilen ülke arama boşken en üstte durur.
class CountryPicker extends StatefulWidget {
  const new({required this.selected, required this.suggested, super.key});

  final String? selected;
  final String? suggested;

  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
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
    final names = countryNamesFor(Localizations.localeOf(context).languageCode);
    final query = _search.text;
    final suggested = query.trim().isEmpty ? widget.suggested : null;
    final matches = [
      for (final MapEntry(key: code, value: name) in names.entries)
        if (code != suggested &&
            matchesCountryQuery(code: code, name: name, query: query))
          code,
    ];

    Widget tile(String code) => OptionTile(
      icon: code == widget.selected
          ? Icons.check_circle_rounded
          : Icons.radio_button_unchecked_rounded,
      iconColor: code == widget.selected ? null : context.colors.outline,
      label: names[code]!,
      hint: currencyCodeFor(code),
      selected: code == widget.selected,
      onTap: () => Navigator.of(context).pop(code),
    );

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.85,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.lg),
              child: TextField(
                controller: _search,
                textInputAction: TextInputAction.search,
                autocorrect: false,
                style: context.typography.body,
                decoration: InputDecoration(
                  hintText: l10n.onboardingCountrySearch,
                  prefixIcon: const Icon(Icons.search_rounded),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            SizedBox(height: spacing.sm),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: spacing.lg),
                children: [
                  if (suggested != null) ...[
                    _Label(l10n.onboardingCountrySuggested),
                    tile(suggested),
                    _Label(l10n.onboardingCountryAll),
                  ],
                  if (matches.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing.lg),
                      child: Text(
                        l10n.onboardingCountryNoMatch,
                        style: context.typography.body,
                      ),
                    ),
                  for (final code in matches) tile(code),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const new(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return Padding(
      padding: EdgeInsets.only(top: spacing.md, bottom: spacing.xs),
      child: SectionLabel(text),
    );
  }
}
