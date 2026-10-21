import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_aricilik/core/l10n/generated/app_localizations.dart';
import 'package:mobil_aricilik/core/region/country_currencies.dart';
import 'package:mobil_aricilik/core/region/region_provider.dart';

/// Geçici ülke seçici: para birimi tablosundaki tüm kodlar, adsız. Ülke
/// ileride işletme kaydından (`organizations.country_code`) gelecek.
class CountryPickerScreen extends ConsumerWidget {
  const new({super.key});

  static final List<String> _countryCodes = countryCurrencyCodes.keys.toList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selectedCode = ref.watch(regionConfigProvider).countryCode;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsCountryPickerTitle)),
      body: ListView.builder(
        itemCount: _countryCodes.length,
        itemBuilder: (context, index) {
          final code = _countryCodes[index];
          final selected = code == selectedCode;
          return ListTile(
            title: Text(
              l10n.settingsCountryOption(code, currencyCodeFor(code)),
            ),
            trailing: selected ? const Icon(Icons.check_rounded) : null,
            selected: selected,
            onTap: () {
              ref.read(regionSelectionProvider.notifier).setCountry(code);
              context.pop();
            },
          );
        },
      ),
    );
  }
}
