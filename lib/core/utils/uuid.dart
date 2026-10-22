import 'package:uuid/uuid.dart';

/// Yeni kayıt kimliği: UUIDv7. Zamana göre sıralanır; kimlik istemcide
/// üretildiği için kayıt çevrimdışı da oluşturulabilir.
String generateId() => const Uuid().v7();
