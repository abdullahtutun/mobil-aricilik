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
  treatment('treatment'),

  /// Ana yetiştirme takviminin bir adımı; kaynak seri, gün `sourceStep`.
  queenRearing('queen_rearing'),

  /// Kovan sayısı ya da arılık konumu değişti: "AKS'de güncellemeyi
  /// unutma" (yalnız TR); kaynak işletme. İşletmede aynı anda tek açık
  /// görev olur.
  aksUpdate('aks_update');

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

    /// Otomatik görevin kaynağı: muayene, uygulama grubu ya da ana
    /// yetiştirme serisi.
    String? sourceId,

    /// Ana yetiştirme görevinin takvim günü (aktarmadan sonraki gün: 1, 5,
    /// 10, 12, 24); diğer görevlerde boş.
    int? sourceStep,

    /// Planlı ilaçlama: referans listeden ya da işletmenin listesinden
    /// ilaç (en çok biri) ve kovan başı doz (birimi ilacın). İlaçla doz
    /// birlikte dolu; ilaçlı görev elle açılır ve arılığa bağlıdır.
    String? refDrugId,
    String? drugId,
    double? dose,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _Task;

  factory fromJson(Map<String, Object?> json) => _$TaskFromJson(json);
}

extension TaskPlan on Task {
  /// Planlı ilaçlama görevi: ilacı ve dozu var.
  bool get isPlannedTreatment => dose != null;

  /// Planlanan ilacın kimliği (referans ya da işletmenin); yoksa null.
  String? get plannedDrugKey => refDrugId ?? drugId;
}

/// Listede ve bildirimde gösterilen görev: bağlı arılığın adı ve kovanın
/// numarası birlikte.
typedef TaskView = ({Task task, String? apiaryName, String? hiveNumber});
