/// Bir Postgres enum'unun aynası olan Dart enum'u. Yerel DB'ye, outbox
/// payload'una ve JSON'a sunucudaki değer ([value]) yazılır; Dart adı
/// (`ownRearing`) ile sunucu değeri (`own_rearing`) farklı olabilir.
abstract interface class ServerEnum {
  String get value;
}
