import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'supabase_client_provider.g.dart';

/// Uygulamadaki tek Supabase istemcisi; `bootstrap` Supabase'i başlattıktan
/// sonra okunur. Yalnız data katmanındaki servisler (auth, işletme) ve
/// senkron alır; ekranlar dokunmaz.
@Riverpod(keepAlive: true)
SupabaseClient supabaseClient(Ref ref) => Supabase.instance.client;
