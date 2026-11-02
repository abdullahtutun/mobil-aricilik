import 'package:flutter/services.dart';
import 'package:mobil_arici/features/health/data/diagnosis_repository.dart';
import 'package:mobil_arici/features/health/domain/diagnosis.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'diagnosis_providers.g.dart';

@Riverpod(keepAlive: true)
DiagnosisRepository diagnosisRepository(Ref ref) =>
    DiagnosisRepository(rootBundle);

/// Teşhis yardımcısının kural tablosu; bir kez okunur.
@Riverpod(keepAlive: true)
Future<DiagnosisTable> diagnosisTable(Ref ref) =>
    ref.watch(diagnosisRepositoryProvider).load();
