import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/app/sync/sync_messages.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/sync/sync_controller.dart';
import 'package:mobil_arici/core/sync/sync_providers.dart';
import 'package:mobil_arici/core/sync/sync_result.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';

/// İlk girişte tam çekme (teknik.md §3): işletmenin kayıtları bu telefona
/// inene kadar sekmeler açılmaz; yeni cihazda boş listeyi görüp aynı
/// arılığı ikinci kez açma riski olmaz. Çekme bitince router asıl konuma
/// geçer.
///
/// Turu genelde açılış tetikleyicisi başlatmıştır; ekran açılınca yine de
/// bir tur ister (süren tur varsa ona katılır). Tur biterse ama çekme
/// tamamlanmazsa nedeni ve "Yeniden dene" çıkar; ağ gelince tetikleyiciler
/// de yeniden dener.
class InitialSyncScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<InitialSyncScreen> createState() => _InitialSyncScreenState();
}

class _InitialSyncScreenState extends ConsumerState<InitialSyncScreen> {
  @override
  void initState() {
    super.initState();
    // Build sırasında başka bir provider'ın durumu değişemez.
    scheduleMicrotask(() {
      if (mounted) _sync();
    });
  }

  void _sync() => unawaited(ref.read(syncControllerProvider.notifier).sync());

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final activity = ref.watch(syncControllerProvider);
    final lastResult = activity.lastResult;
    final problem = activity.running || lastResult == null
        ? null
        : syncProblemText(l10n, lastResult.status);

    final Widget content;
    // Yerel DB okunurken ya da çekme bitip router geçerken bir an görünür.
    if (ref.watch(fullPullDoneProvider).value ?? true) {
      content = CircularProgressIndicator(
        semanticsLabel: l10n.initialSyncTitle,
      );
    } else if (problem != null) {
      content = EmptyState(
        icon: Icons.cloud_off_rounded,
        title: l10n.initialSyncFailedTitle,
        message: problem,
        actionLabel: l10n.actionRetry,
        onAction: _sync,
      );
    } else {
      content = _Progress(activity.progress);
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: const [_SignOutButton()],
      ),
      body: SafeArea(
        child: Center(child: SingleChildScrollView(child: content)),
      ),
    );
  }
}

/// İndirilen tablo oranı ve satır sayısı. Gönderme sürerken ya da çekme
/// başlamadan çubuk belirsiz döner.
class _Progress extends StatelessWidget {
  const new(this.progress);

  final SyncProgress? progress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final colors = context.colors;
    final typography = context.typography;
    final progress = this.progress;
    final fraction = progress == null
        ? null
        : progress.tablesDone / progress.tableCount;

    return Padding(
      padding: EdgeInsets.all(spacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.cloud_download_rounded,
            size: context.sizes.illustrationIcon,
            color: colors.primary,
          ),
          SizedBox(height: spacing.lg),
          Semantics(
            header: true,
            child: Text(
              l10n.initialSyncTitle,
              textAlign: TextAlign.center,
              style: typography.title,
            ),
          ),
          SizedBox(height: spacing.sm),
          Text(
            l10n.initialSyncMessage,
            textAlign: TextAlign.center,
            style: typography.body.copyWith(color: colors.textSecondary),
          ),
          SizedBox(height: spacing.xl),
          LinearProgressIndicator(
            value: fraction,
            semanticsLabel: l10n.initialSyncTitle,
            semanticsValue: fraction == null
                ? null
                : AppFormat.of(context).percent(fraction),
          ),
          if (progress != null) ...[
            SizedBox(height: spacing.sm),
            Text(
              l10n.initialSyncRows(progress.rowsPulled),
              textAlign: TextAlign.center,
              style: typography.body.copyWith(color: colors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}

/// Çıkış: sunucuya hiç ulaşılamıyorsa ya da yanlış hesapla girildiyse
/// kullanıcı burada kalmasın.
class _SignOutButton extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      tooltip: AppLocalizations.of(context).settingsSignOut,
      icon: const Icon(Icons.logout_rounded),
      onPressed: () => ref.read(currentUserProvider.notifier).signOut(),
    );
  }
}
