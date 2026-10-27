import 'dart:async';
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/core/services/document_services_provider.dart';
import 'package:mobil_arici/core/services/media_services_provider.dart';
import 'package:mobil_arici/core/utils/date_only.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/documents/domain/document.dart';
import 'package:mobil_arici/features/documents/domain/document_rules.dart';
import 'package:mobil_arici/features/documents/presentation/document_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'document_form_controller.freezed.dart';
part 'document_form_controller.g.dart';

@freezed
abstract class DocumentFormState with _$DocumentFormState {
  const factory({
    /// Seçilen tür; TR profilinde seçilene kadar boş, diğer bölgelerde
    /// hep [DocumentType.custom].
    DocumentType? type,
    @Default('') String customTypeName,
    @Default('') String name,

    /// Ad elle yazıldı ya da belge düzenleniyor; tür seçilince ad artık
    /// türden doldurulmaz.
    @Default(false) bool nameEdited,
    @Default('') String description,

    /// Son geçerlilik günü (yerel); boşsa süresiz.
    DateTime? expiresOn,

    /// Bu formda seçilen, henüz kaydedilmemiş dosya.
    DocumentFileCapture? newFile,

    /// Düzenlenen belgenin kayıtlı dosyası; yeni dosya seçilmediyse kalır.
    DocumentFileKind? savedFileKind,
    int? savedByteSize,
    @Default(false) bool saving,
  }) = _DocumentFormState;

  factory fromDocument(VaultDocument document) => DocumentFormState(
    type: document.type,
    customTypeName: document.customTypeName ?? '',
    name: document.name,
    nameEdited: true,
    description: document.description ?? '',
    expiresOn: document.expiresOn,
    savedFileKind: document.fileKind,
    savedByteSize: document.byteSize,
  );
}

extension DocumentFormProgress on DocumentFormState {
  /// Formda görünen dosyanın türü ve boyutu: yeni seçilen ya da kayıtlı.
  DocumentFileKind? get fileKind => newFile?.kind ?? savedFileKind;
  int? get fileByteSize => newFile?.byteSize ?? savedByteSize;

  bool get canSave {
    final type = this.type;
    return type != null &&
        (type != DocumentType.custom || customTypeName.trim().isNotEmpty) &&
        name.trim().isNotEmpty &&
        fileKind != null &&
        !saving;
  }
}

/// Seçilen dosya 20 MB'tan büyük ([maxDocumentFileBytes]).
class DocumentFileTooLargeException implements Exception {
  const new();
}

/// Belge ekleme ([documentId] null) ve düzenleme formu. Ekran açık kaldığı
/// sürece yaşar. Düzenlenecek belge yoksa ya da silinmişse durum null.
/// Her şey yerel DB'ye ve belge klasörüne yazılır; kaydedilmeden kapanan
/// formun seçtiği dosya silinir.
@riverpod
class DocumentFormController extends _$DocumentFormController {
  var _saved = false;

  /// Seçilen dosyanın adı; kapanırken `state` okunamadığı için ayrıca.
  String? _picked;

  @override
  Future<DocumentFormState?> build(String? documentId) async {
    final files = ref.read(documentFileStoreProvider);
    ref.onDispose(() {
      if (_picked case final fileName? when !_saved) {
        unawaited(files.delete(fileName));
      }
    });
    if (documentId == null) {
      final presets = ref.read(regionConfigProvider).features.trMigrationDocs;
      return DocumentFormState(type: presets ? null : DocumentType.custom);
    }
    final document = await ref
        .read(documentRepositoryProvider)
        .findById(documentId);
    return document == null ? null : DocumentFormState.fromDocument(document);
  }

  /// Türü seçer; ad elle yazılmadıysa türün adı [label] ad olur.
  void setType(DocumentType type, {required String label}) => _update(
    (form) =>
        form.copyWith(type: type, name: form.nameEdited ? form.name : label),
  );

  /// Kullanıcı tanımlı türün adı; ad elle yazılmadıysa ad da o olur.
  void setCustomTypeName(String name) => _update(
    (form) => form.copyWith(
      customTypeName: name,
      name: form.nameEdited ? form.name : name.trim(),
    ),
  );

  void setName(String name) =>
      _update((form) => form.copyWith(name: name, nameEdited: true));

  void setDescription(String description) =>
      _update((form) => form.copyWith(description: description));

  void setExpiresOn(DateTime? day) => _update(
    (form) => form.copyWith(expiresOn: day == null ? null : dateOnly(day)),
  );

  /// Kamerayla belgenin fotoğrafını çeker.
  Future<void> takePhoto() => _pickImage(fromGallery: false);

  /// Galeriden belgenin fotoğrafını seçtirir.
  Future<void> pickImage() => _pickImage(fromGallery: true);

  /// Telefondaki dosyalardan PDF seçtirir. 20 MB'tan büyükse
  /// [DocumentFileTooLargeException] atar ve bir şey değişmez.
  Future<void> pickPdf() async {
    final source = await ref.read(documentPickerProvider).pickPdf();
    if (source == null) return;
    // Eşzamanlı: widget testlerinin sahte zamanında da biter.
    if (File(source).lengthSync() > maxDocumentFileBytes) {
      throw const DocumentFileTooLargeException();
    }
    final fileId = generateId();
    final fileName = '$fileId.${DocumentFileKind.pdf.extension}';
    final byteSize = await ref
        .read(documentFileStoreProvider)
        .copyFrom(source, fileName);
    await _usePicked((
      fileId: fileId,
      kind: DocumentFileKind.pdf,
      byteSize: byteSize,
    ));
  }

  /// Vazgeçilirse bir şey değişmez. Hata `MediaCaptureException`.
  Future<void> _pickImage({required bool fromGallery}) async {
    final files = ref.read(documentFileStoreProvider);
    final fileId = generateId();
    final fileName = '$fileId.${DocumentFileKind.photo.extension}';
    final path = await files.pathOf(fileName);
    final camera = ref.read(cameraServiceProvider);
    final byteSize = fromGallery
        ? await camera.pickImage(path)
        : await camera.takePhoto(path);
    if (byteSize == null) return;
    await _usePicked((
      fileId: fileId,
      kind: DocumentFileKind.photo,
      byteSize: byteSize,
    ));
  }

  /// Seçilen dosya öncekinin yerine geçer; önceki seçim silinir. Form bu
  /// arada kapandıysa yeni dosya da silinir.
  Future<void> _usePicked(DocumentFileCapture file) async {
    final files = ref.read(documentFileStoreProvider);
    if (!ref.mounted || state.value == null) {
      await files.delete(file.fileName);
      return;
    }
    final previous = _picked;
    _picked = file.fileName;
    _update((form) => form.copyWith(newFile: file));
    if (previous != null) await files.delete(previous);
  }

  /// Belgeyi yazar ve döner; kaydedilemiyorsa ya da düzenlenen belge bu
  /// arada silindiyse null. Dosya değiştiyse eski dosya bu telefondan
  /// silinir (Storage'da kalır).
  Future<VaultDocument?> save() async {
    final form = state.value;
    final orgId = ref.read(currentOrgIdProvider);
    if (form == null || !form.canSave || orgId == null) return null;
    _update((form) => form.copyWith(saving: true));

    final repository = ref.read(documentRepositoryProvider);
    final type = form.type!;
    final customTypeName = type == DocumentType.custom
        ? form.customTypeName
        : null;
    final id = documentId;
    // Yazma hata atsa da Kaydet yeniden açılsın.
    try {
      if (id == null) {
        final saved = await repository.create(
          orgId: orgId,
          type: type,
          customTypeName: customTypeName,
          name: form.name,
          description: form.description,
          expiresOn: form.expiresOn,
          file: form.newFile!,
        );
        _saved = true;
        return saved;
      }
      final latest = await repository.findById(id);
      if (latest == null) {
        if (ref.mounted) state = const AsyncData(null);
        return null;
      }
      final saved = await repository.update(
        latest.copyWith(
          type: type,
          customTypeName: customTypeName,
          name: form.name,
          description: form.description,
          expiresOn: form.expiresOn,
        ),
        file: form.newFile,
      );
      _saved = true;
      if (saved.storagePath != latest.storagePath) {
        await ref
            .read(documentFileStoreProvider)
            .delete(documentFileName(latest.storagePath));
      }
      return saved;
    } finally {
      if (ref.mounted) _update((form) => form.copyWith(saving: false));
    }
  }

  void _update(DocumentFormState Function(DocumentFormState form) change) {
    if (state.value case final form?) state = AsyncData(change(form));
  }
}
