import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/region/country_names.dart';
import 'package:mobil_arici/features/organization/domain/business_profile.dart';

/// Para birimi seçicisini alttan, ekranın çoğunu kaplayan sayfa olarak açar;
/// seçilen ISO 4217 kodunu, kapatılırsa null döner.
Future<String?> showCurrencyPicker(
  BuildContext context, {
  required String selected,
  required String regionDefault,
}) => showOptionSheet<String>(
  context,
  (context) => CurrencyPicker(selected: selected, regionDefault: regionDefault),
);

/// Aranabilir para birimi listesi: yalnız kodlar (TRY, USD). Seçili ve
/// bölgenin birimi en üstte, kalanı alfabe sırasıyla. Kodla ya da birimi
/// kullanan ülkenin adıyla aranır.
class CurrencyPicker extends StatefulWidget {
  const new({required this.selected, required this.regionDefault, super.key});

  final String selected;
  final String regionDefault;

  @override
  State<CurrencyPicker> createState() => _CurrencyPickerState();
}

class _CurrencyPickerState extends State<CurrencyPicker> {
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
    final ordered = {
      widget.selected,
      widget.regionDefault,
      ...currencyChoices(widget.selected),
    };
    final matches = [
      for (final code in ordered)
        if (matchesCurrencyQuery(code: code, countryNames: names, query: query))
          code,
    ];

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.85,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.lg),
              child: Semantics(
                header: true,
                child: Text(
                  l10n.businessCurrency,
                  style: context.typography.title,
                ),
              ),
            ),
            SizedBox(height: spacing.md),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.lg),
              child: TextField(
                controller: _search,
                textInputAction: TextInputAction.search,
                textCapitalization: TextCapitalization.characters,
                autocorrect: false,
                style: context.typography.body,
                decoration: InputDecoration(
                  hintText: l10n.businessCurrencySearch,
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
                  if (matches.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing.lg),
                      child: Text(
                        l10n.businessCurrencyNoMatch,
                        style: context.typography.body,
                      ),
                    ),
                  for (final code in matches)
                    OptionTile(
                      icon: code == widget.selected
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      iconColor: code == widget.selected
                          ? null
                          : context.colors.outline,
                      label: code,
                      selected: code == widget.selected,
                      onTap: () => Navigator.of(context).pop(code),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
