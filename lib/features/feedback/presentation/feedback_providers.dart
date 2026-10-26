import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/features/feedback/data/feedback_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feedback_providers.g.dart';

@Riverpod(keepAlive: true)
FeedbackRepository feedbackRepository(Ref ref) =>
    FeedbackRepository(ref.watch(appDatabaseProvider));
