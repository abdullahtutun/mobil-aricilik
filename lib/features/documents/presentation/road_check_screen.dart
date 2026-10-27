import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/services/screen_awake.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/documents/domain/document.dart';
import 'package:mobil_arici/features/documents/presentation/document_providers.dart';
import 'package:mobil_arici/features/documents/presentation/widgets/document_expiry_badge.dart';
import 'package:mobil_arici/features/documents/presentation/widgets/document_file_view.dart';
import 'package:mobil_arici/features/documents/presentation/widgets/document_labels.dart';

/// Yol kontrolü: kasadaki belgeler tam ekran, alt gezinmesiz, kasa
/// sırasıyla. Yana kaydırarak ya da alttaki büyük butonlarla belgeler
/// arasında geçilir. Her sayfada büyük ad, tür, geçerlilik rozeti ve
/// dosyanın kendisi (internetsiz). Ekran açıkken telefon kararmaz.
class RoadCheckScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<RoadCheckScreen> createState() => _RoadCheckScreenState();
}

class _RoadCheckScreenState extends ConsumerState<RoadCheckScreen> {
  final _pages = PageController();
  late final ScreenAwake _awake;
  var _index = 0;

  @override
  void initState() {
    super.initState();
    _awake = ref.read(screenAwakeProvider);
    unawaited(_awake.keepOn(enabled: true));
  }

  @override
  void dispose() {
    unawaited(_awake.keepOn(enabled: false));
    _pages.dispose();
    super.dispose();
  }

  void _go(int index) => _pages.animateToPage(
    index,
    duration: kTabScrollDuration,
    curve: Curves.easeOut,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final documents = ref.watch(documentsProvider).value ?? const [];
    final count = documents.length;
    final index = count == 0 ? 0 : _index.clamp(0, count - 1);

    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: Text(l10n.roadCheckTitle),
        actions: [
          if (count > 0)
            Padding(
              padding: EdgeInsetsDirectional.only(end: context.spacing.lg),
              child: Center(
                child: Text(
                  l10n.roadCheckPosition(index + 1, count),
                  style: context.typography.number,
                ),
              ),
            ),
        ],
      ),
      body: count == 0
          ? Center(child: Text(l10n.documentsEmptyTitle))
          : SafeArea(
              top: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pages,
                      itemCount: count,
                      onPageChanged: (page) => setState(() => _index = page),
                      itemBuilder: (context, page) =>
                          _RoadCheckPage(documents[page]),
                    ),
                  ),
                  _Navigation(
                    onPrevious: index > 0 ? () => _go(index - 1) : null,
                    onNext: index < count - 1 ? () => _go(index + 1) : null,
                  ),
                ],
              ),
            ),
    );
  }
}

/// Tek belge: büyük ad, tür ve geçerlilik, altında dosya.
class _RoadCheckPage extends StatelessWidget {
  const new(this.document);

  final VaultDocument document;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final spacing = context.spacing;
    final expiresOn = document.expiresOn;

    // Büyük yazıda bilgiler sayfanın en çok %45'ini alır ve kayar; dosyaya
    // yer kalır.
    return LayoutBuilder(
      builder: (context, constraints) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: constraints.maxHeight * 0.45,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                spacing.lg,
                0,
                spacing.lg,
                spacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: spacing.xs,
                children: [
                  Text(document.name, style: context.typography.headline),
                  Text(
                    documentTypeLabel(l10n, document),
                    style: context.typography.subtitle.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                  Wrap(
                    spacing: spacing.md,
                    runSpacing: spacing.xs,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      DocumentExpiryBadge(document),
                      if (expiresOn != null)
                        Text(
                          l10n.documentExpiresOn(format.date(expiresOn)),
                          style: context.typography.subtitle,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ColoredBox(
              color: context.colors.surfaceContainer,
              child: DocumentFileView(document),
            ),
          ),
        ],
      ),
    );
  }
}

/// Önceki / sonraki belge butonları ve kaydırma ipucu.
class _Navigation extends StatelessWidget {
  const new({required this.onPrevious, required this.onNext});

  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    return Padding(
      padding: EdgeInsets.all(spacing.lg),
      child: Row(
        children: [
          BigIconButton(
            icon: Icons.chevron_left_rounded,
            label: l10n.roadCheckPrevious,
            onPressed: onPrevious,
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Text(
              l10n.roadCheckSwipeHint,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.typography.body.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ),
          SizedBox(width: spacing.md),
          BigIconButton(
            icon: Icons.chevron_right_rounded,
            label: l10n.roadCheckNext,
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}
