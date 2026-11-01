import 'package:mobil_arici/core/services/share_service.dart';

/// Paylaşılan metinleri biriktirir.
class FakeShareService implements ShareService {
  final shared = <({String text, String? subject})>[];

  @override
  Future<void> shareText(String text, {String? subject}) async {
    shared.add((text: text, subject: subject));
  }
}
