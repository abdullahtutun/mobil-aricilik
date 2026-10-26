import 'package:mobil_arici/core/db/server_enum.dart';

/// Görüşün konusu (`feedback_kind`).
enum FeedbackKind implements ServerEnum {
  bug('bug'),
  suggestion('suggestion'),
  missingFeature('missing_feature'),
  thanks('thanks');

  new(this.value);

  @override
  final String value;
}
