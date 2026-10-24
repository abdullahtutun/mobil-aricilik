import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_form_controller.dart';
import 'package:mobil_arici/features/apiaries/presentation/widgets/apiary_form_fields.dart';
import 'package:mobil_arici/features/apiaries/presentation/widgets/apiary_not_found.dart';

/// Arılık ekleme ([apiaryId] null) ve düzenleme: üstte Kapat ve başlık,
/// altta çizgiyle ayrılmış Kaydet. Kaydedince yeni arılığın
/// detayı açılır; düzenlemede detaya dönülür.
class ApiaryFormScreen extends ConsumerWidget {
  const new({super.key, this.apiaryId});

  final String? apiaryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final title = Text(
      apiaryId == null ? l10n.apiaryFormNewTitle : l10n.apiaryFormEditTitle,
    );

    return switch (ref.watch(apiaryFormControllerProvider(apiaryId))) {
      AsyncData(value: final form?) => Scaffold(
        appBar: AppBar(leading: const CloseButton(), title: title),
        body: BottomActionLayout(
          separated: true,
          body: ListView(
            padding: EdgeInsets.all(context.spacing.lg),
            children: [
              ApiaryFormFields(
                apiaryId: apiaryId,
                autofocusName: apiaryId == null,
              ),
            ],
          ),
          action: BigButton(
            label: l10n.apiaryFormSave,
            onPressed: form.canSave ? () => _save(context, ref) : null,
          ),
        ),
      ),
      AsyncData() => Scaffold(
        appBar: AppBar(title: title),
        body: const ApiaryNotFound(),
      ),
      AsyncError() => Scaffold(
        appBar: AppBar(title: title),
        body: Center(child: Text(l10n.apiariesLoadError)),
      ),
      // Yerel DB'den okunuyor; hemen gelir.
      AsyncValue() => Scaffold(appBar: AppBar(title: title)),
    };
  }

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final id = await ref
        .read(apiaryFormControllerProvider(apiaryId).notifier)
        .save();
    if (id == null || !context.mounted) return;
    if (apiaryId == null) {
      context.go(AppRoutes.apiary(id));
    } else {
      context.pop();
    }
  }
}
