import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';

/// Giriş yapmış kullanıcı. SDK türleri data katmanında kalır.
@freezed
abstract class AppUser with _$AppUser {
  const factory({
    /// `auth.users.id`; tablolardaki `user_id` ve `created_by` bununla dolar.
    required String id,
    String? email,
  }) = _AppUser;
}
