import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/team/domain/invite.dart';
import 'package:mobil_arici/features/team/domain/team_failure.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';
import 'package:mobil_arici/features/team/presentation/team_rules.dart';

/// "Koda sahibim" sayfasını kök navigator'da açar; kullanıcı katılırsa true,
/// vazgeçerse false döner. Ekip ekranından ve onboarding'den açılır.
Future<bool> showJoinCodeSheet(BuildContext context) async {
  final joined = await showModalBottomSheet<bool>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => const _JoinSheet(),
  );
  return joined ?? false;
}

/// "Koda sahibim": 6 haneli kodu alır, katılır. Başarıda true ile kapanır;
/// hata sayfada, kodun altında yazılır.
class _JoinSheet extends ConsumerStatefulWidget {
  const new();

  @override
  ConsumerState<_JoinSheet> createState() => _JoinSheetState();
}

class _JoinSheetState extends ConsumerState<_JoinSheet> {
  final _controller = TextEditingController();
  var _busy = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _valid => isInviteCode(normalizeInviteCode(_controller.text));

  Future<void> _join() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(teamActionsProvider).join(_controller.text);
      if (mounted) Navigator.of(context).pop(true);
    } on TeamServiceException catch (error) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = failureMessage(l10n, error.failure);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final error = _error;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.lg,
        0,
        spacing.lg,
        spacing.lg + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.teamJoinTitle, style: context.typography.title),
          SizedBox(height: spacing.sm),
          Text(
            l10n.teamJoinHint,
            style: context.typography.body.copyWith(
              color: colors.textSecondary,
            ),
          ),
          SizedBox(height: spacing.lg),
          LabeledField(
            label: l10n.teamJoinCodeLabel,
            child: TextField(
              controller: _controller,
              autofocus: true,
              enabled: !_busy,
              textCapitalization: TextCapitalization.characters,
              autocorrect: false,
              enableSuggestions: false,
              inputFormatters: [
                // Boşluk ve tireyle yapıştırılan kod da sığsın.
                LengthLimitingTextInputFormatter(inviteCodeLength + 4),
              ],
              style: context.typography.number,
              onChanged: (_) => setState(() => _error = null),
              onSubmitted: (_) {
                if (_valid && !_busy) unawaited(_join());
              },
            ),
          ),
          if (error != null) ...[
            SizedBox(height: spacing.md),
            Semantics(
              liveRegion: true,
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: context.sizes.iconSmall,
                    color: colors.statusCritical,
                  ),
                  SizedBox(width: spacing.sm),
                  Expanded(
                    child: Text(
                      error,
                      style: context.typography.body.copyWith(
                        color: colors.statusCritical,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: spacing.lg),
          BigButton(
            label: l10n.teamJoinAction,
            onPressed: _valid && !_busy ? _join : null,
          ),
        ],
      ),
    );
  }
}
