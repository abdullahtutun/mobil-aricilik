import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/organization/domain/business_profile.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';
import 'package:mobil_arici/features/organization/presentation/business_profile_providers.dart';

/// İşletmenin yuvarlak avatarı: logo bu telefonda varsa logo, yoksa (logo
/// seçilmemiş ya da henüz inmemiş) addaki baş harfler avatar renginde.
/// Ekran okuyucuya kapalı; adı yanındaki metin okunur.
class BusinessAvatar extends ConsumerWidget {
  const new({
    required this.name,
    required this.dimension,
    super.key,
    this.color,
    this.logoPath,
  });

  final String name;
  final double dimension;
  final OrgAvatarColor? color;
  final String? logoPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logoPath = this.logoPath;
    final logo = logoPath == null
        ? null
        : ref.watch(organizationLogoFileProvider(logoPath)).value;
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: dimension,
        child: logo != null
            ? ClipOval(child: Image.file(logo, fit: BoxFit.cover))
            : InitialsAvatar(
                text: nameInitials(name),
                color: color ?? defaultAvatarColor,
                dimension: dimension,
              ),
      ),
    );
  }
}

/// Baş harfler dairede (işletme, ekip üyesi). Yazı boyutu dairenin
/// çapına göre küçülür, taşmaz.
class InitialsAvatar extends StatelessWidget {
  const new({
    required this.text,
    required this.color,
    required this.dimension,
    super.key,
    this.border = false,
  });

  final String text;
  final OrgAvatarColor color;
  final double dimension;

  /// Üst üste binen avatarlarda araya zemin renginde çizgi.
  final bool border;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (background, foreground) = colors.orgAvatar(color);
    return SizedBox.square(
      dimension: dimension,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: background,
          border: border
              ? Border.all(color: colors.surface, width: context.strokes.focus)
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.all(context.spacing.sm),
          child: FittedBox(
            child: Text(
              AppFormat.of(context).upperCase(text),
              style: context.typography.title.copyWith(color: foreground),
            ),
          ),
        ),
      ),
    );
  }
}
