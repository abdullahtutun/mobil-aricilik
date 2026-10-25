// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Foto çekme ve kovan kartından eklenen medya. Geri al bildirimi ekran
/// kapandıktan sonra da çalışsın diye sürekli yaşar. Kayıtlar yerel DB'ye,
/// dosyalar uygulamanın medya klasörüne yazılır.

@ProviderFor(MediaActions)
final mediaActionsProvider = MediaActionsProvider._();

/// Foto çekme ve kovan kartından eklenen medya. Geri al bildirimi ekran
/// kapandıktan sonra da çalışsın diye sürekli yaşar. Kayıtlar yerel DB'ye,
/// dosyalar uygulamanın medya klasörüne yazılır.
final class MediaActionsProvider extends $NotifierProvider<MediaActions, void> {
  /// Foto çekme ve kovan kartından eklenen medya. Geri al bildirimi ekran
  /// kapandıktan sonra da çalışsın diye sürekli yaşar. Kayıtlar yerel DB'ye,
  /// dosyalar uygulamanın medya klasörüne yazılır.
  MediaActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaActionsHash();

  @$internal
  @override
  MediaActions create() => MediaActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$mediaActionsHash() => r'697334bf3f6df84d0fdee5e0a7f7c8da1d6887b4';

/// Foto çekme ve kovan kartından eklenen medya. Geri al bildirimi ekran
/// kapandıktan sonra da çalışsın diye sürekli yaşar. Kayıtlar yerel DB'ye,
/// dosyalar uygulamanın medya klasörüne yazılır.

abstract class _$MediaActions extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Bir ekrandaki ([target]: kovan kartı ya da muayene) sesli not kaydı.
/// Kayıt yokken durum null. Ekran kapanınca (provider bırakılınca) süren
/// kayıt atılır.

@ProviderFor(VoiceRecordingController)
final voiceRecordingControllerProvider = VoiceRecordingControllerFamily._();

/// Bir ekrandaki ([target]: kovan kartı ya da muayene) sesli not kaydı.
/// Kayıt yokken durum null. Ekran kapanınca (provider bırakılınca) süren
/// kayıt atılır.
final class VoiceRecordingControllerProvider
    extends $NotifierProvider<VoiceRecordingController, VoiceRecording?> {
  /// Bir ekrandaki ([target]: kovan kartı ya da muayene) sesli not kaydı.
  /// Kayıt yokken durum null. Ekran kapanınca (provider bırakılınca) süren
  /// kayıt atılır.
  VoiceRecordingControllerProvider._({
    required VoiceRecordingControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'voiceRecordingControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$voiceRecordingControllerHash();

  @override
  String toString() {
    return r'voiceRecordingControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  VoiceRecordingController create() => VoiceRecordingController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VoiceRecording? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VoiceRecording?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is VoiceRecordingControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$voiceRecordingControllerHash() =>
    r'793b9f068e36b29d0c5f016dd8a30651c02158a3';

/// Bir ekrandaki ([target]: kovan kartı ya da muayene) sesli not kaydı.
/// Kayıt yokken durum null. Ekran kapanınca (provider bırakılınca) süren
/// kayıt atılır.

final class VoiceRecordingControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          VoiceRecordingController,
          VoiceRecording?,
          VoiceRecording?,
          VoiceRecording?,
          String
        > {
  VoiceRecordingControllerFamily._()
    : super(
        retry: null,
        name: r'voiceRecordingControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Bir ekrandaki ([target]: kovan kartı ya da muayene) sesli not kaydı.
  /// Kayıt yokken durum null. Ekran kapanınca (provider bırakılınca) süren
  /// kayıt atılır.

  VoiceRecordingControllerProvider call(String target) =>
      VoiceRecordingControllerProvider._(argument: target, from: this);

  @override
  String toString() => r'voiceRecordingControllerProvider';
}

/// Bir ekrandaki ([target]: kovan kartı ya da muayene) sesli not kaydı.
/// Kayıt yokken durum null. Ekran kapanınca (provider bırakılınca) süren
/// kayıt atılır.

abstract class _$VoiceRecordingController extends $Notifier<VoiceRecording?> {
  late final _$args = ref.$arg as String;
  String get target => _$args;

  VoiceRecording? build(String target);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<VoiceRecording?, VoiceRecording?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<VoiceRecording?, VoiceRecording?>,
              VoiceRecording?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// Medyanın bu telefondaki dosyası; başka telefonda çekildiyse ve henüz
/// indirilmediyse null. [download] istenince indirir.

@ProviderFor(MediaFileController)
final mediaFileControllerProvider = MediaFileControllerFamily._();

/// Medyanın bu telefondaki dosyası; başka telefonda çekildiyse ve henüz
/// indirilmediyse null. [download] istenince indirir.
final class MediaFileControllerProvider
    extends $AsyncNotifierProvider<MediaFileController, File?> {
  /// Medyanın bu telefondaki dosyası; başka telefonda çekildiyse ve henüz
  /// indirilmediyse null. [download] istenince indirir.
  MediaFileControllerProvider._({
    required MediaFileControllerFamily super.from,
    required MediaItem super.argument,
  }) : super(
         retry: null,
         name: r'mediaFileControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mediaFileControllerHash();

  @override
  String toString() {
    return r'mediaFileControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  MediaFileController create() => MediaFileController();

  @override
  bool operator ==(Object other) {
    return other is MediaFileControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mediaFileControllerHash() =>
    r'836d3ce7611ea85fb0e8a45e19dda84bab1a6ecd';

/// Medyanın bu telefondaki dosyası; başka telefonda çekildiyse ve henüz
/// indirilmediyse null. [download] istenince indirir.

final class MediaFileControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          MediaFileController,
          AsyncValue<File?>,
          File?,
          FutureOr<File?>,
          MediaItem
        > {
  MediaFileControllerFamily._()
    : super(
        retry: null,
        name: r'mediaFileControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Medyanın bu telefondaki dosyası; başka telefonda çekildiyse ve henüz
  /// indirilmediyse null. [download] istenince indirir.

  MediaFileControllerProvider call(MediaItem media) =>
      MediaFileControllerProvider._(argument: media, from: this);

  @override
  String toString() => r'mediaFileControllerProvider';
}

/// Medyanın bu telefondaki dosyası; başka telefonda çekildiyse ve henüz
/// indirilmediyse null. [download] istenince indirir.

abstract class _$MediaFileController extends $AsyncNotifier<File?> {
  late final _$args = ref.$arg as MediaItem;
  MediaItem get media => _$args;

  FutureOr<File?> build(MediaItem media);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<File?>, File?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<File?>, File?>,
              AsyncValue<File?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// Çalan sesli notun kimliği; çalan yoksa null. Aynı anda tek not çalar.

@ProviderFor(VoicePlayback)
final voicePlaybackProvider = VoicePlaybackProvider._();

/// Çalan sesli notun kimliği; çalan yoksa null. Aynı anda tek not çalar.
final class VoicePlaybackProvider
    extends $NotifierProvider<VoicePlayback, String?> {
  /// Çalan sesli notun kimliği; çalan yoksa null. Aynı anda tek not çalar.
  VoicePlaybackProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'voicePlaybackProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$voicePlaybackHash();

  @$internal
  @override
  VoicePlayback create() => VoicePlayback();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$voicePlaybackHash() => r'4938680da6316c426e5503b72feaf642c621a6c1';

/// Çalan sesli notun kimliği; çalan yoksa null. Aynı anda tek not çalar.

abstract class _$VoicePlayback extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
