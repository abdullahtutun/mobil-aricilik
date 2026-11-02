import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/subsidies/domain/subsidy_rules.dart';
import 'package:mobil_arici/features/subsidies/presentation/subsidy_providers.dart';

/// AKS'de beyan edilen kovan sayısı (yalnız owner, Destekler'den açılır):
/// tek sayı alanı; boş bırakılırsa sayı silinir ve kontrol yapılmaz.
/// Kaydedince önceki ekrana dönülür.
class AksHiveCountFormScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final title = Text(l10n.aksCountTitle);
    return switch (ref.watch(aksHiveCountProvider)) {
      AsyncData(:final value) => Scaffold(
        appBar: AppBar(leading: const CloseButton(), title: title),
        body: _AksHiveCountForm(initial: value),
      ),
      // Yerel DB'den okunuyor; hemen gelir.
      AsyncValue() => Scaffold(appBar: AppBar(title: title)),
    };
  }
}

class _AksHiveCountForm extends ConsumerStatefulWidget {
  const new({required this.initial});

  final int? initial;

  @override
  ConsumerState<_AksHiveCountForm> createState() => _AksHiveCountFormState();
}

class _AksHiveCountFormState extends ConsumerState<_AksHiveCountForm> {
  late final _count = TextEditingController(
    text: widget.initial?.toString() ?? '',
  );
  var _invalid = false;

  @override
  void dispose() {
    _count.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BottomActionLayout(
      separated: true,
      body: ListView(
        padding: EdgeInsets.all(context.spacing.lg),
        children: [
          LabeledField(
            label: l10n.aksCountLabel,
            helper: l10n.aksCountHelper,
            child: TextField(
              controller: _count,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                errorText: _invalid ? l10n.aksCountInvalid : null,
              ),
              onChanged: (_) {
                if (_invalid) setState(() => _invalid = false);
              },
              onSubmitted: (_) => unawaited(_save()),
            ),
          ),
        ],
      ),
      action: BigButton(
        label: l10n.aksCountSave,
        onPressed: () => unawaited(_save()),
      ),
    );
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final orgId = ref.read(currentOrgIdProvider);
    if (orgId == null) return;
    final int? count;
    try {
      count = parseAksHiveCount(_count.text);
    } on FormatException {
      setState(() => _invalid = true);
      return;
    }
    final saved = await ref
        .read(organizationRepositoryProvider)
        .setAksHiveCount(orgId, count);
    if (!mounted) return;
    if (!saved) {
      showMessageSnackBar(context, l10n.aksCountNoOrganization);
      return;
    }
    showMessageSnackBar(context, l10n.aksCountSaved);
    context.pop();
  }
}
