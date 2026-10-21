import 'package:flutter/material.dart';
import 'package:mobil_aricilik/core/design_system/gallery/component_samples.dart';
import 'package:mobil_aricilik/core/design_system/gallery/gallery_theme.dart';
import 'package:mobil_aricilik/core/design_system/theme_context.dart';
import 'package:mobil_aricilik/core/l10n/generated/app_localizations.dart';

/// Tüm tasarım sistemi bileşenlerini dört temada gösterir. Yalnızca dev
/// flavor'da, geliştirici menüsünden açılır.
class ComponentGalleryScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).componentGalleryTitle),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(spacing.lg),
        itemCount: GalleryComponent.values.length,
        separatorBuilder: (context, index) => SizedBox(height: spacing.xxl),
        itemBuilder: (context, index) =>
            GallerySection(component: GalleryComponent.values[index]),
      ),
    );
  }
}

/// Bir bileşenin başlığı ve dört temadaki örnekleri.
class GallerySection extends StatelessWidget {
  const new({required this.component, super.key});

  final GalleryComponent component;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(
            component.title(AppLocalizations.of(context)),
            style: context.typography.title,
          ),
        ),
        SizedBox(height: context.spacing.md),
        GalleryThemePanels(child: component.samples),
      ],
    );
  }
}
