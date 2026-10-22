import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';

/// Geliştirici araçları. Rotası yalnızca dev flavor'da kayıtlıdır.
class DeveloperMenuScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.devMenuTitle)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.widgets_rounded),
            title: Text(l10n.componentGalleryTitle),
            subtitle: Text(l10n.componentGalleryDescription),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.go(AppRoutes.componentGallery),
          ),
        ],
      ),
    );
  }
}
