import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/db/server_enum.dart';
import 'package:mobil_arici/core/db/synced_record.dart';

part 'task.freezed.dart';
part 'task.g.dart';

/// Görevi kim açtı (`public.task_source`).
@JsonEnum(valueField: 'value')
enum TaskSource implements ServerEnum {
  /// Elle; başlığı var.
  manual('manual'),

  /// Muayenedeki "X gün sonra tekrar bak"; kaynak muayene.
  inspection('inspection'),

  /// İlaç şeridini çıkarma günü; kaynak uygulama grubu.
  treatment('treatment');

  new(this.value);

  @override
  final String value;
}

/// Yapılacak iş (`tasks`). Durum kaydı: son yazan kazanır. Son tarih bir
/// an; hatırlatma o an çalar. Kovana bağlı görev kovanın arılığını da
/// taşır. Otomatik görevin (kaynağı manual değil) başlığı yok; ekran
/// kaynaktan üretir.
@freezed
abstract class Task with _$Task implements SyncedRecord {
  const factory({
    required String id,
    required String orgId,
    required DateTime dueAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(TaskSource.manual) TaskSource source,

    /// Elle açılan görevde dolu, otomatik görevde boş.
    String? title,
    String? apiaryId,
    String? hiveId,

    /// Atanan üyenin kullanıcı kimliği; boşsa atanmamış.
    String? assignedTo,

    /// Tamamlanma anı; açık görevde boş.
    DateTime? completedAt,

    /// Otomatik görevin kaynağı: muayene ya da uygulama grubu.
    String? sourceId,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _Task;

  factory fromJson(Map<String, Object?> json) => _$TaskFromJson(json);
}

/// Listede ve bildirimde gösterilen görev: bağlı arılığın adı ve kovanın
/// numarası birlikte.
typedef TaskView = ({Task task, String? apiaryName, String? hiveNumber});
