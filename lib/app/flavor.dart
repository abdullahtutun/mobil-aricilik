import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flavor.g.dart';

// Prod projesi açılana kadar iki flavor da aynı Supabase projesine bağlı.
// Anon key istemciye açık bir anahtar; veriyi RLS korur.
const _sharedSupabaseUrl = 'https://jcddnelaboueazhordfz.supabase.co';
const _sharedSupabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im'
    'pjZGRuZWxhYm91ZWF6aG9yZGZ6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTI1Mjc2ODYsIm'
    'V4cCI6MjEwODEwMzY4Nn0.M0XvUNlPpZHQBWA9Uq3-vlusrUWjnxow_a5WV87OzGo';

enum Flavor {
  dev(supabaseUrl: _sharedSupabaseUrl, supabaseAnonKey: _sharedSupabaseAnonKey),
  prod(
    supabaseUrl: _sharedSupabaseUrl,
    supabaseAnonKey: _sharedSupabaseAnonKey,
  );

  new({required this.supabaseUrl, required this.supabaseAnonKey});

  final String supabaseUrl;
  final String supabaseAnonKey;
}

/// Çalışan flavor. `bootstrap` gerçek değerle override eder; override
/// edilmezse (ör. testlerde) geliştirici araçları kapalı kalsın diye prod.
@Riverpod(keepAlive: true)
Flavor flavor(Ref ref) => Flavor.prod;
