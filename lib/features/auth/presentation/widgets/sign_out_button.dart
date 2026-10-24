import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';

/// Onaysız çıkış. Kurulum ve ilk senkron ekranlarında: yanlış hesapla
/// girildiyse ya da sunucuya ulaşılamıyorsa kullanıcı orada kalmasın.
class SignOutButton extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      tooltip: AppLocalizations.of(context).settingsSignOut,
      icon: const Icon(Icons.logout_rounded),
      onPressed: () => ref.read(currentUserProvider.notifier).signOut(),
    );
  }
}
