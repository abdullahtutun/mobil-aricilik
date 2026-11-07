// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Mobil Arıcı';

  @override
  String get listSeparator => ',';

  @override
  String get stepperIncrease => 'Aumentar';

  @override
  String get stepperDecrease => 'Disminuir';

  @override
  String hiveTileLabel(String number) {
    return 'Colmena $number';
  }

  @override
  String hiveTileStrength(int strength) {
    return 'Fuerza $strength de 5';
  }

  @override
  String hiveTileQueenColor(String color) {
    String _temp0 = intl.Intl.selectLogic(color, {
      'white': 'blanco',
      'yellow': 'amarillo',
      'red': 'rojo',
      'green': 'verde',
      'blue': 'azul',
      'other': 'desconocido',
    });
    return 'Color de la reina $_temp0';
  }

  @override
  String get tabToday => 'Hoy';

  @override
  String get tabApiaries => 'Colmenares';

  @override
  String get tabTasks => 'Tareas';

  @override
  String get tabMore => 'Más';

  @override
  String get todayEmptyTitle => 'Empieza añadiendo tu colmenar';

  @override
  String get todayEmptyMessage =>
      'Tres pasos y listo: añade tu colmenar, crea tus colmenas y haz tu primera revisión.';

  @override
  String get apiariesEmptyTitle => 'Aún no hay colmenares';

  @override
  String get apiariesEmptyMessage =>
      'Un colmenar agrupa tus colmenas según dónde están; añade el primero para empezar.';

  @override
  String get apiariesAdd => 'Añadir colmenar';

  @override
  String get apiariesAddFirst => 'Añade tu primer colmenar';

  @override
  String get apiariesLoadError => 'No se pudieron leer tus colmenares.';

  @override
  String get apiariesViewList => 'Lista';

  @override
  String get apiariesViewMap => 'Mapa';

  @override
  String get apiariesMapOfflineTitle => 'Mapa no disponible';

  @override
  String get apiariesMapOfflineMessage =>
      'El mapa necesita internet. Tus colmenares están en la lista de abajo.';

  @override
  String get apiariesMapNoLocation =>
      'Ningún colmenar tiene ubicación todavía. Edita un colmenar para tomar la ubicación del GPS o elegirla en el mapa.';

  @override
  String get apiariesMapAttribution =>
      '© OpenFreeMap © OpenMapTiles © OpenStreetMap contributors';

  @override
  String apiaryMapPinLabel(String name, String hives) {
    return '$name, $hives';
  }

  @override
  String apiaryMapPinAttention(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmenas necesitan atención',
      one: '1 colmena necesita atención',
    );
    return '$_temp0';
  }

  @override
  String get apiaryMapDirections => 'Cómo llegar';

  @override
  String get apiaryMapShow => 'Ver';

  @override
  String get apiaryMapDirectionsFailed => 'No se pudo abrir una app de mapas.';

  @override
  String get apiaryMapDirectionsChooseApp => 'Cómo llegar con';

  @override
  String apiaryHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmenas',
      one: '1 colmena',
      zero: 'Sin colmenas',
    );
    return '$_temp0';
  }

  @override
  String apiaryLastVisit(String date) {
    return 'Última visita $date';
  }

  @override
  String get apiaryNoVisit => 'Aún sin visitas';

  @override
  String get apiaryEdit => 'Editar';

  @override
  String get apiaryDelete => 'Eliminar colmenar';

  @override
  String get apiaryDeleteTitle => '¿Eliminar este colmenar?';

  @override
  String get apiaryDeleteMessage =>
      'El colmenar se eliminará de todos los teléfonos.';

  @override
  String apiaryDeleteWithHivesMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Este colmenar tiene $count colmenas. El colmenar y sus colmenas se eliminarán de todos los teléfonos.',
      one: 'Este colmenar tiene 1 colmena. El colmenar y su colmena se eliminarán de todos los teléfonos.',
    );
    return '$_temp0';
  }

  @override
  String get apiaryDeleted => 'Colmenar eliminado';

  @override
  String get apiaryNotFoundTitle => 'Colmenar no encontrado';

  @override
  String get apiaryNotFoundMessage =>
      'Puede que se haya eliminado o que aún no haya llegado a este dispositivo.';

  @override
  String get apiaryFormNewTitle => 'Nuevo colmenar';

  @override
  String get apiaryFormEditTitle => 'Editar colmenar';

  @override
  String get apiaryFormName => 'Nombre del colmenar';

  @override
  String get apiaryFormNameHint => 'p. ej. La Loma';

  @override
  String get apiaryFormLocation => 'Ubicación';

  @override
  String get apiaryFormLocationNone =>
      'Aún sin ubicación. Si estás en el colmenar, tómala del GPS, sin necesidad de internet; si no, elígela en el mapa.';

  @override
  String get apiaryFormLocationTake => 'Tomar ubicación del GPS';

  @override
  String get apiaryFormLocationRetake => 'Volver a tomar la ubicación';

  @override
  String get apiaryFormLocationClear => 'Quitar ubicación';

  @override
  String get apiaryFormLocationPickOnMap => 'Elegir en el mapa';

  @override
  String get locationPickerTitle => 'Elegir ubicación en el mapa';

  @override
  String get locationPickerSearchHint => 'Busca un pueblo o lugar';

  @override
  String get locationPickerSearch => 'Buscar';

  @override
  String get locationPickerHint =>
      'Mueve el mapa para poner el marcador sobre el colmenar.';

  @override
  String get locationPickerPinLabel => 'Ubicación elegida';

  @override
  String get locationPickerConfirm => 'Usar esta ubicación';

  @override
  String get locationPickerNoResults =>
      'No se encontraron lugares. Prueba con otro nombre.';

  @override
  String get locationPickerSearchOffline =>
      'No se pudo buscar. La búsqueda necesita internet.';

  @override
  String get locationPickerMapOfflineMessage =>
      'El mapa necesita internet. Si estás en el colmenar, toma la ubicación del GPS.';

  @override
  String get apiaryFormLocating =>
      'Obteniendo tu ubicación… Al aire libre es más rápido.';

  @override
  String apiaryFormLocationAccuracy(int meters) {
    return 'Precisión ±$meters m';
  }

  @override
  String get apiaryFormLocationErrorServiceDisabled =>
      'La ubicación está desactivada en este dispositivo. Actívala y vuelve a intentarlo.';

  @override
  String get apiaryFormLocationErrorPermissionDenied =>
      'No se dio permiso de ubicación. Permítelo para tomar la ubicación.';

  @override
  String get apiaryFormLocationErrorPermissionDeniedForever =>
      'El permiso de ubicación está desactivado. Permite la ubicación para esta app en Ajustes.';

  @override
  String get apiaryFormLocationErrorTimeout =>
      'No se encontró tu ubicación. Vuelve a intentarlo al aire libre.';

  @override
  String get apiaryFormLocationErrorUnknown =>
      'No se pudo obtener tu ubicación. Vuelve a intentarlo.';

  @override
  String get apiaryFormOpenSettings => 'Abrir ajustes';

  @override
  String get apiaryFormLandownerName => 'Nombre del propietario del terreno';

  @override
  String get apiaryFormLandownerPhone => 'Teléfono del propietario del terreno';

  @override
  String get apiaryFormNotes => 'Notas';

  @override
  String get apiaryFormSave => 'Guardar';

  @override
  String get hiveSortWeakestFirst => 'Más débiles primero';

  @override
  String get hivesEmptyTitle => 'Aún no hay colmenas';

  @override
  String get hivesEmptyMessage =>
      'Añade las colmenas que hay en este colmenar; puedes crear muchas a la vez.';

  @override
  String get hivesAdd => 'Añadir colmenas';

  @override
  String get hivesAddOne => 'Una colmena';

  @override
  String get hivesAddOneHint => 'Indica su número, tipo y origen';

  @override
  String get hivesAddBulk => 'Varias a la vez';

  @override
  String get hivesAddBulkHint => 'p. ej. 20 colmenas desde la 101';

  @override
  String hivesInactiveTitle(int count) {
    return 'No activas ($count)';
  }

  @override
  String get hivesLoadError => 'No se pudieron leer las colmenas.';

  @override
  String hiveLabel(String number) {
    return 'Colmena $number';
  }

  @override
  String hiveTypeAndSource(String type, String source) {
    return '$type · $source';
  }

  @override
  String get hiveTypeLangstroth => 'Langstroth';

  @override
  String get hiveTypeDadant => 'Dadant';

  @override
  String get hiveTypeLocal => 'Tradicional';

  @override
  String get hiveTypeOther => 'Otro';

  @override
  String get hiveStatusActive => 'Activa';

  @override
  String get hiveStatusDead => 'Muerta';

  @override
  String get hiveStatusMerged => 'Unida';

  @override
  String get hiveStatusSold => 'Vendida';

  @override
  String get hiveStatusLost => 'Perdida';

  @override
  String get hiveSourceSwarm => 'Enjambre';

  @override
  String get hiveSourceSplit => 'División';

  @override
  String get hiveSourcePurchase => 'Comprada';

  @override
  String get hiveSourcePackage => 'Paquete de abejas';

  @override
  String get hiveFormNewTitle => 'Nueva colmena';

  @override
  String get hiveFormEditTitle => 'Editar colmena';

  @override
  String get hiveFormNumber => 'Número de colmena';

  @override
  String get hiveFormNumberHint => 'p. ej. 101';

  @override
  String get hiveFormType => 'Tipo de colmena';

  @override
  String get hiveFormStatus => 'Estado';

  @override
  String get hiveFormSource => 'Origen';

  @override
  String get hiveFormSave => 'Guardar';

  @override
  String get hiveBulkTitle => 'Crear varias colmenas';

  @override
  String get hiveBulkCount => 'Cuántas colmenas';

  @override
  String get hiveBulkCountHint => 'p. ej. 20';

  @override
  String hiveBulkCountTooMany(int max) {
    return 'Como máximo $max a la vez';
  }

  @override
  String get hiveBulkStart => 'Primer número';

  @override
  String get hiveBulkStartHint => 'p. ej. 101';

  @override
  String hiveBulkPreview(int count, String first, String last) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se crearán $count colmenas: de la $first a la $last.',
      one: 'Se creará la colmena $first.',
    );
    return '$_temp0';
  }

  @override
  String get hiveBulkSave => 'Crear colmenas';

  @override
  String hiveBulkCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmenas creadas',
      one: '1 colmena creada',
    );
    return '$_temp0';
  }

  @override
  String get hiveNotFoundTitle => 'Colmena no encontrada';

  @override
  String get hiveNotFoundMessage =>
      'Puede que se haya eliminado o que aún no haya llegado a este dispositivo.';

  @override
  String get hiveEdit => 'Editar';

  @override
  String get hiveDelete => 'Eliminar colmena';

  @override
  String hiveDeleteTitle(String number) {
    return '¿Eliminar la colmena $number?';
  }

  @override
  String get hiveDeleteMessage =>
      'La colmena y sus registros se eliminarán de todos los teléfonos.';

  @override
  String hiveDeleted(String number) {
    return 'Colmena $number eliminada';
  }

  @override
  String hiveCardApiary(String name) {
    return 'Colmenar: $name';
  }

  @override
  String get hiveQueenTitle => 'Reina';

  @override
  String hiveQueenStripTitle(String queen) {
    return 'Reina · $queen';
  }

  @override
  String hiveStrengthBadge(String level, int strength) {
    return '$level · $strength/5';
  }

  @override
  String get hiveStrengthWeak => 'Débil';

  @override
  String get hiveStrengthMedium => 'Media';

  @override
  String get hiveStrengthStrong => 'Fuerte';

  @override
  String get hiveStrengthNone => 'Aún sin puntuación de fuerza';

  @override
  String get hiveTimelineTitle => 'Historial';

  @override
  String get timelineInspection => 'Revisión';

  @override
  String get timelineAdded => 'Colocada en el colmenar';

  @override
  String get timelineMoved => 'Trasladada';

  @override
  String timelineMoveRoute(String from, String to) {
    return '$from → $to';
  }

  @override
  String get timelineUnknownApiary => 'Colmenar desconocido';

  @override
  String timelineField(String label, String value) {
    return '$label: $value';
  }

  @override
  String timelineBeeFrames(int count) {
    return '$count con abejas';
  }

  @override
  String timelineBroodFrames(int count) {
    return '$count con cría';
  }

  @override
  String timelineHoneyFrames(int count) {
    return '$count con miel';
  }

  @override
  String get timelineActions => 'Hecho';

  @override
  String get hiveMove => 'Trasladar a otro colmenar';

  @override
  String hiveMoveTitle(String number) {
    return 'Trasladar la colmena $number a';
  }

  @override
  String get hiveMoveNoOtherApiary =>
      'No hay otro colmenar al que trasladarla. Añade uno primero desde la pestaña Colmenares.';

  @override
  String hiveMoved(String number, String apiary) {
    return 'Colmena $number trasladada a $apiary';
  }

  @override
  String get hiveChangeStatus => 'Cambiar estado';

  @override
  String hiveStatusSheetTitle(String number) {
    return 'Nuevo estado de la colmena $number';
  }

  @override
  String hiveStatusConfirmTitle(String status, String number) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'dead': '¿Registrar la colmena $number como muerta?',
      'merged': '¿Registrar la colmena $number como unida?',
      'sold': '¿Registrar la colmena $number como vendida?',
      'other': '¿Registrar la colmena $number como perdida?',
    });
    return '$_temp0';
  }

  @override
  String get hiveStatusConfirmMessage =>
      'Dejará de contar entre las colmenas activas del colmenar. Puedes volver a activarla más tarde.';

  @override
  String get hiveStatusConfirm => 'Sí, registrar';

  @override
  String hiveStatusChanged(String number, String status) {
    return 'Colmena $number: $status';
  }

  @override
  String get tasksEmptyTitle => 'Aún no hay tareas';

  @override
  String get tasksEmptyMessage =>
      'Tus recordatorios y tareas aparecerán aquí por fecha.';

  @override
  String get scanTitle => 'Escanear';

  @override
  String get scanLongPressHint => 'abrir el menú de registro rápido';

  @override
  String get scanHint => 'Encuadra el código de la etiqueta de la colmena.';

  @override
  String get scanAgain => 'Escanear de nuevo';

  @override
  String get cameraErrorTitle => 'No se pudo abrir la cámara';

  @override
  String get cameraErrorPermissionDenied =>
      'No se dio permiso de cámara. Para escanear etiquetas, permite la cámara para esta app en Ajustes.';

  @override
  String get cameraErrorUnsupported =>
      'Este dispositivo no tiene una cámara que pueda escanear.';

  @override
  String get cameraErrorUnknown =>
      'Cierra esta pantalla y vuelve a intentarlo.';

  @override
  String get labelUnknownTitle =>
      'Este código no está vinculado a ninguna colmena';

  @override
  String get labelUnknownMessage =>
      'No es una etiqueta de Mobil Arıcı o aún no se ha asignado a una colmena. Si está en una colmena, asígnala; al escanearla se abrirá la ficha de la colmena.';

  @override
  String get labelUnknownOwnTitle =>
      'No se encontró la colmena de esta etiqueta';

  @override
  String get labelUnknownOwnMessage =>
      'Puede que la colmena se haya eliminado o que aún no haya llegado a este teléfono. También puedes asignar la etiqueta a otra colmena.';

  @override
  String labelCode(String code) {
    return 'Código: $code';
  }

  @override
  String get labelAssign => 'Asignar a una colmena';

  @override
  String get labelAssignTitle => 'Asignar etiqueta a una colmena';

  @override
  String get labelAssignMessage =>
      'Elige la colmena que lleva la etiqueta. Al escanearla se abrirá la ficha de esa colmena.';

  @override
  String get labelAssignSearch => 'Número de colmena';

  @override
  String get labelAssignNoMatch => 'Ninguna colmena coincide con tu búsqueda.';

  @override
  String get labelAssignNoHives =>
      'Aún no hay colmenas. Añádelas primero desde la pestaña Colmenares.';

  @override
  String get labelAssignHasOther => 'Tiene otra etiqueta';

  @override
  String labelReplaceTitle(String number) {
    return '¿Reemplazar la etiqueta de la colmena $number?';
  }

  @override
  String get labelReplaceMessage =>
      'Esta colmena ya tiene una etiqueta. La nueva la reemplaza; la antigua dejará de abrir esta colmena.';

  @override
  String get labelReplaceConfirm => 'Sí, reemplazar';

  @override
  String labelAssigned(String number) {
    return 'Etiqueta asignada: colmena $number';
  }

  @override
  String get hiveLabelsTitle => 'Imprimir etiquetas';

  @override
  String get hiveLabelsMessage =>
      'Elige las colmenas para las que quieres imprimir etiquetas. Una página A4 tiene 24 etiquetas (70 × 37 mm); imprime a escala 100 %.';

  @override
  String get hiveLabelsNoHives =>
      'Este colmenar no tiene colmenas para imprimir etiquetas.';

  @override
  String get hiveLabelsSelectAll => 'Seleccionar todas';

  @override
  String get hiveLabelsSelectNone => 'No seleccionar ninguna';

  @override
  String get hiveLabelsNoneSelected => 'Ninguna colmena seleccionada';

  @override
  String hiveLabelsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count etiquetas',
      one: '1 etiqueta',
    );
    return '$_temp0';
  }

  @override
  String hiveLabelsPages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count páginas',
      one: '1 página',
    );
    return '$_temp0';
  }

  @override
  String hiveLabelsSummary(String labels, String pages) {
    return '$labels · $pages';
  }

  @override
  String get hiveLabelsPreparing => 'Preparando el PDF…';

  @override
  String get hiveLabelsPrint => 'Imprimir';

  @override
  String get hiveLabelsShare => 'Compartir PDF';

  @override
  String hiveLabelsDocumentName(String apiary) {
    return 'Etiquetas de colmenas - $apiary';
  }

  @override
  String get hiveLabelsError =>
      'No se pudo preparar el PDF. Vuelve a intentarlo.';

  @override
  String get quickRecordTitle => 'Registro rápido';

  @override
  String get quickRecordInspection => 'Revisión';

  @override
  String get quickRecordFeeding => 'Alimentación';

  @override
  String get quickRecordTreatment => 'Tratamiento';

  @override
  String get quickRecordHarvest => 'Cosecha';

  @override
  String get quickRecordNote => 'Nota';

  @override
  String get quickRecordExpense => 'Gasto';

  @override
  String get quickRecordComingSoon => 'Este tipo de registro llegará pronto.';

  @override
  String get signInSendCode => 'Enviar código';

  @override
  String get signInSending => 'Enviando…';

  @override
  String signInCodeMessage(String email) {
    return 'Hemos enviado un código de 6 dígitos a $email.';
  }

  @override
  String get signInCodeFieldLabel => 'Código de 6 dígitos';

  @override
  String get signInVerify => 'Iniciar sesión';

  @override
  String get signInVerifying => 'Comprobando…';

  @override
  String get signInResend => 'Reenviar código';

  @override
  String signInResendIn(int seconds) {
    return 'Reenviar código ($seconds s)';
  }

  @override
  String get signInCodeResent => 'Un nuevo código está en camino.';

  @override
  String get authErrorNetwork =>
      'No se pudo conectar. Revisa tu internet y vuelve a intentarlo.';

  @override
  String get authErrorInvalidEmail => 'Introduce un correo electrónico válido.';

  @override
  String get authErrorInvalidCode =>
      'El código es incorrecto o ha caducado. Vuelve a intentarlo o pide un código nuevo.';

  @override
  String get authErrorTooManyRequests =>
      'Demasiados intentos. Espera un poco y vuelve a intentarlo.';

  @override
  String get authErrorUnknown => 'Algo salió mal. Vuelve a intentarlo.';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsSystemDefault => 'Sistema';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsColorMode => 'Tema';

  @override
  String get settingsColorModeLight => 'Claro';

  @override
  String get settingsColorModeDark => 'Oscuro';

  @override
  String get settingsColorModeSun => 'Sol';

  @override
  String get settingsAccount => 'Cuenta';

  @override
  String settingsSignedInAs(String email) {
    return 'Sesión iniciada como $email';
  }

  @override
  String get settingsPrivacyPolicy => 'Política de privacidad';

  @override
  String settingsVersion(String version) {
    return 'Versión $version';
  }

  @override
  String get settingsSignOut => 'Cerrar sesión';

  @override
  String get settingsSignOutConfirmTitle => '¿Cerrar sesión?';

  @override
  String get settingsSignOutConfirmMessage =>
      'Para volver a entrar necesitarás un código nuevo enviado a tu correo, lo que requiere internet.';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionDelete => 'Eliminar';

  @override
  String get actionRetry => 'Reintentar';

  @override
  String get actionUndo => 'Deshacer';

  @override
  String onboardingStepCounter(int current, int total) {
    return 'Paso $current de $total';
  }

  @override
  String get onboardingContinue => 'Continuar';

  @override
  String get onboardingFinish => 'Crear explotación';

  @override
  String get onboardingFinishing => 'Configurando…';

  @override
  String get onboardingCountrySearch => 'Buscar países';

  @override
  String get onboardingCountrySuggested => 'Sugerido para tu dispositivo';

  @override
  String get onboardingCountryAll => 'Todos los países';

  @override
  String get onboardingCountryNoMatch =>
      'Ningún país coincide con tu búsqueda.';

  @override
  String get onboardingNameMessage =>
      'Este nombre aparece en tus registros e informes.';

  @override
  String get onboardingNameLabel => 'Nombre de la explotación';

  @override
  String get onboardingNameHint => 'p. ej. Apícola Panal de Oro';

  @override
  String get onboardingHiveCountTitle => '¿Cuántas colmenas tienes?';

  @override
  String get onboardingHiveCountMessage =>
      'Basta con un número aproximado; te sugeriremos cómo llevarlas. Las colmenas las añadirás después.';

  @override
  String get hiveCountRangeNone => 'Aún ninguna';

  @override
  String get hiveCountRangeUpTo10 => '1–10';

  @override
  String get hiveCountRangeUpTo50 => '11–50';

  @override
  String get hiveCountRangeUpTo200 => '51–200';

  @override
  String get hiveCountRangeOver200 => 'Más de 200';

  @override
  String get onboardingApiaryTitle => 'Añade tu primer colmenar';

  @override
  String get onboardingApiaryMessage =>
      'Un colmenar es donde están tus colmenas. Guardarlo no necesita internet.';

  @override
  String get onboardingApiarySave => 'Guardar colmenar';

  @override
  String get onboardingApiarySkip => 'Omitir por ahora';

  @override
  String get onboardingLoading => 'Cargando tu explotación';

  @override
  String get onboardingLoadErrorTitle => 'No se pudo cargar tu explotación';

  @override
  String get onboardingErrorNetwork =>
      'No se pudo conectar. Revisa tu internet y vuelve a intentarlo.';

  @override
  String get onboardingErrorUnknown => 'Algo salió mal. Vuelve a intentarlo.';

  @override
  String get devMenuTitle => 'Menú de desarrollador';

  @override
  String get componentGalleryTitle => 'Galería de componentes';

  @override
  String get componentGalleryDescription =>
      'Componentes del sistema de diseño en cuatro temas';

  @override
  String get galleryThemeLight => 'Claro';

  @override
  String get galleryThemeDark => 'Oscuro';

  @override
  String get galleryThemeSun => 'Sol';

  @override
  String get galleryThemeGlove => 'Guantes';

  @override
  String get galleryBigButton => 'Botón grande';

  @override
  String get galleryChoiceChipGroup => 'Chips de opciones';

  @override
  String get galleryBigStepper => 'Contador grande';

  @override
  String get galleryStatusBadge => 'Insignia de estado';

  @override
  String get galleryHiveTile => 'Tarjeta de colmena';

  @override
  String get galleryEmptyState => 'Estado vacío';

  @override
  String get gallerySectionCard => 'Tarjeta de sección';

  @override
  String get galleryStrengthDots => 'Puntos de fuerza';

  @override
  String get galleryTimelineTile => 'Fila del historial';

  @override
  String get gallerySampleApiaryHill => 'La Loma';

  @override
  String get gallerySampleApiaryPlain => 'La Ribera';

  @override
  String get gallerySampleStartInspection => 'Iniciar revisión';

  @override
  String get gallerySampleAddPhoto => 'Añadir foto';

  @override
  String get gallerySampleSave => 'Guardar';

  @override
  String get gallerySampleQueen => 'Reina';

  @override
  String get gallerySampleQueenSeen => 'Vista';

  @override
  String get gallerySampleEggs => 'Hay huevos';

  @override
  String get gallerySampleNone => 'Ninguno';

  @override
  String get gallerySampleActions => 'Acciones realizadas';

  @override
  String get gallerySampleSuperAdded => 'Alza añadida';

  @override
  String get gallerySampleFrameAdded => 'Cuadro añadido';

  @override
  String get gallerySampleFed => 'Alimentada';

  @override
  String get gallerySampleBeeFrames => 'Cuadros con abejas';

  @override
  String get gallerySampleBroodFrames => 'Cuadros de cría';

  @override
  String get gallerySampleStrong => 'Fuerte';

  @override
  String get gallerySampleWeak => 'Débil';

  @override
  String get gallerySampleQueenless => 'Huérfana';

  @override
  String get gallerySampleTask => 'Tarea';

  @override
  String get gallerySampleNoApiaries => 'Aún no hay colmenares';

  @override
  String get gallerySampleNoApiariesMessage =>
      'Un colmenar agrupa tus colmenas según dónde están; añade el primero para empezar.';

  @override
  String get gallerySampleAddApiary => 'Añade tu primer colmenar';

  @override
  String get gallerySampleLastInspection => 'Última revisión';

  @override
  String get gallerySampleLastInspectionBody =>
      'hace 3 días · 7 cuadros con abejas · reina vista';

  @override
  String get gallerySampleUntitledCard =>
      'Una tarjeta también puede ir sin título; el contenido empieza directamente.';

  @override
  String get gallerySnackBar => 'Snackbar';

  @override
  String get galleryCriticalLockCard => 'Tarjeta de bloqueo crítico';

  @override
  String get gallerySampleInspectionSaved => 'Revisión guardada';

  @override
  String get gallerySampleWithdrawalTitle => 'En tiempo de espera.';

  @override
  String get gallerySampleWithdrawalMessage =>
      'No pongas un alza de miel en esta colmena durante 12 días más.';

  @override
  String get syncStatusSynced => 'Sincronizado';

  @override
  String syncStatusPending(int count) {
    return '$count pendientes';
  }

  @override
  String get syncStatusError => 'Error';

  @override
  String syncStatusSemantics(String status) {
    return 'Sincronización: $status';
  }

  @override
  String get syncTitle => 'Sincronización';

  @override
  String get syncSyncedMessage =>
      'Todos los registros de este teléfono han llegado al servidor.';

  @override
  String syncPendingMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count registros están esperando para enviarse.',
      one: '1 registro está esperando para enviarse.',
    );
    return '$_temp0';
  }

  @override
  String get syncProblemOffline =>
      'No se pudo contactar con el servidor. La sincronización lo volverá a intentar cuando vuelvas a tener conexión.';

  @override
  String get syncProblemFailed =>
      'La sincronización no pudo terminar. Vuelve a intentarlo un poco más tarde.';

  @override
  String get syncProblemUpgrade =>
      'Esta versión ya no puede sincronizar. Actualiza la app.';

  @override
  String syncLastSynced(String time) {
    return 'Última sincronización $time';
  }

  @override
  String get syncNow => 'Sincronizar ahora';

  @override
  String get syncRunning => 'Sincronizando…';

  @override
  String syncRejectedTitle(int count) {
    return 'No se pudieron enviar ($count)';
  }

  @override
  String get syncRejectedMessage =>
      'El servidor no aceptó estos registros. Todo lo demás se sigue sincronizando.';

  @override
  String syncRejectedSubtitle(String reason, String date) {
    return '$reason · $date';
  }

  @override
  String get syncRejectionForbidden =>
      'No tienes permiso para cambiar este registro';

  @override
  String get syncRejectionConflict =>
      'Choca con otro registro (p. ej., la misma etiqueta)';

  @override
  String get syncRejectionMissingReference =>
      'Falta en el servidor un registro del que depende';

  @override
  String get syncRejectionUnsupported =>
      'Este tipo de registro no se sincroniza';

  @override
  String get syncRejectionInvalid => 'El registro tiene datos no válidos';

  @override
  String get syncRejectionUnknown => 'Motivo desconocido';

  @override
  String get syncTableOrganizations => 'Explotación';

  @override
  String get syncTableMemberships => 'Membresía';

  @override
  String get syncTableApiaries => 'Colmenar';

  @override
  String get syncTableQueens => 'Reina';

  @override
  String get syncTableHives => 'Colmena';

  @override
  String get syncTableHiveStatusEvents => 'Cambio de estado de colmena';

  @override
  String get syncTableHiveLocationHistory => 'Traslado de colmena';

  @override
  String get initialSyncTitle => 'Descargando tus registros';

  @override
  String get initialSyncMessage =>
      'Los registros de tu explotación se están descargando en este teléfono. Solo ocurre una vez; después la app también funciona sin internet.';

  @override
  String initialSyncRows(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString registros descargados',
      one: '1 registro descargado',
    );
    return '$_temp0';
  }

  @override
  String get initialSyncFailedTitle => 'La descarga no pudo terminar';

  @override
  String get suggestedValue => 'Del último registro';

  @override
  String get stepperNoValue => 'Sin indicar';

  @override
  String get hiveStartInspection => 'Iniciar revisión';

  @override
  String inspectionTitle(String number) {
    return 'Revisar colmena $number';
  }

  @override
  String inspectionPrevious(String date) {
    return 'Última revisión $date';
  }

  @override
  String get inspectionFirst => 'Primera revisión';

  @override
  String get inspectionSuggestedLegend =>
      'Los valores atenuados son de la última revisión. Cambia lo que sea distinto; el resto se guarda tal cual.';

  @override
  String get inspectionDraftSaved => 'Guardado como borrador en este teléfono';

  @override
  String get inspectionRestart => 'Empezar de nuevo';

  @override
  String get inspectionQueen => 'Reina';

  @override
  String get queenStateSeen => 'Vista';

  @override
  String get queenStateEggs => 'Huevos vistos';

  @override
  String get queenStateNone => 'Ninguna';

  @override
  String get inspectionFrames => 'Cuadros';

  @override
  String get inspectionBeeFrames => 'Con abejas';

  @override
  String get inspectionBroodFrames => 'Con cría';

  @override
  String get inspectionHoneyFrames => 'Con miel';

  @override
  String get inspectionTemperament => 'Temperamento';

  @override
  String get temperamentCalm => 'Tranquila';

  @override
  String get temperamentNervous => 'Nerviosa';

  @override
  String get inspectionSwarmSigns => 'Señales de enjambrazón';

  @override
  String get inspectionQueenCells => 'Celdas reales';

  @override
  String get queenCellsNone => 'Ninguna';

  @override
  String get queenCellsSwarm => 'Enjambrazón';

  @override
  String get queenCellsSupersedure => 'Sustitución';

  @override
  String get queenCellsEmergency => 'Emergencia';

  @override
  String get inspectionDisease => 'Sospecha de enfermedad';

  @override
  String get inspectionAnswerNo => 'No';

  @override
  String get inspectionAnswerYes => 'Sí';

  @override
  String get inspectionActions => 'Hecho hoy';

  @override
  String get inspectionActionSuperAdded => 'Alza añadida';

  @override
  String get inspectionActionSuperRemoved => 'Alza retirada';

  @override
  String get inspectionActionFramesAdded => 'Cuadros añadidos';

  @override
  String get inspectionActionFoundationAdded => 'Cera estampada puesta';

  @override
  String get inspectionActionFed => 'Alimentada';

  @override
  String get inspectionActionExcluderFitted => 'Excluidor colocado';

  @override
  String get inspectionActionEntranceReduced => 'Piquera reducida';

  @override
  String get inspectionActionPollenTrapFitted => 'Trampa de polen colocada';

  @override
  String get inspectionSave => 'Guardar';

  @override
  String inspectionSaved(String number) {
    return 'Revisión de la colmena $number guardada';
  }

  @override
  String get inspectionRemindPrompt => 'Recordar en';

  @override
  String inspectionRemindDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '1 día',
    );
    return '$_temp0';
  }

  @override
  String get inspectionLoadError => 'No se pudo abrir la revisión';

  @override
  String get syncTableInspections => 'Revisión';

  @override
  String get signInTagline =>
      'Tu cuaderno de colmenar, en el bolsillo. Funciona sin internet.';

  @override
  String get signInEmailLabelLong => 'Tu correo electrónico';

  @override
  String get signInEmailHelper =>
      'Sin contraseña. Te enviaremos un código de 6 dígitos a tu correo.';

  @override
  String get signInEmailHint => 'nombre@ejemplo.com';

  @override
  String get signInCodeHeading => 'Introduce el código de tu correo';

  @override
  String get signInPasteCode => 'Pegar código';

  @override
  String get signInCodeSpamHint =>
      '¿No llega? Revisa la carpeta de spam. Después de iniciar sesión una vez, la app se abre también sin internet.';

  @override
  String get signInChangeEmail => 'Cambiar correo';

  @override
  String get onboardingLanguageCountryTitle => 'Idioma y país';

  @override
  String get onboardingAppLanguage => 'Idioma de la app';

  @override
  String get onboardingDeviceLanguage => 'Idioma del dispositivo';

  @override
  String get onboardingCountryLabel => 'País donde tienes tus colmenas';

  @override
  String get onboardingCountryChoose => 'Elige un país';

  @override
  String onboardingRegionFeaturesTitle(String country) {
    return 'Activado para $country';
  }

  @override
  String onboardingRegionDefaultsTitle(String country) {
    return 'Ajustes para $country';
  }

  @override
  String get onboardingRegionDefaultsMessage =>
      'Las unidades y la moneda siguen a tu país.';

  @override
  String get onboardingBusinessTitle => 'Háblanos de tu explotación';

  @override
  String get regionFeatureAks =>
      'datos del AKS y del registro de la explotación';

  @override
  String get regionFeatureSubsidies => 'recordatorios de ayudas por colmena';

  @override
  String get regionFeatureRegulations => 'resúmenes de la normativa';

  @override
  String get regionFeatureTrDrugList => 'lista de medicamentos autorizados';

  @override
  String get regionFeatureTrFlora => 'calendario de flora de Turquía';

  @override
  String get regionFeatureTrMigrationDocs => 'documentos de trashumancia';

  @override
  String get unitKilogram => 'kg';

  @override
  String get unitPound => 'lb';

  @override
  String get unitCelsius => '°C';

  @override
  String get unitFahrenheit => '°F';

  @override
  String get hemisphereNorthern => 'Hemisferio norte';

  @override
  String get hemisphereSouthern => 'Hemisferio sur';

  @override
  String get relativeToday => 'hoy';

  @override
  String get relativeYesterday => 'ayer';

  @override
  String relativeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hace $count días',
      one: 'hace 1 día',
    );
    return '$_temp0';
  }

  @override
  String apiariesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmenares',
      one: '1 colmenar',
    );
    return '$_temp0';
  }

  @override
  String apiariesSummary(String apiaries, String hives) {
    return '$apiaries · $hives';
  }

  @override
  String get apiaryHiveCountUnit => 'colmenas';

  @override
  String get hiveLayoutGridShort => 'Cuadrícula';

  @override
  String get hiveLayoutListShort => 'Lista';

  @override
  String apiaryDetailSubtitle(String hives, String visit) {
    return '$hives · $visit';
  }

  @override
  String apiaryDetailSubtitlePlace(String hives, String visit, String place) {
    return '$hives · $visit · $place';
  }

  @override
  String get apiaryBulkFeed => 'Alimentar todas';

  @override
  String get apiaryBulkTreat => 'Tratar todas';

  @override
  String get hiveCardKind => 'Colmena';

  @override
  String get hiveLastInspection => 'Última revisión';

  @override
  String get hiveLastInspectionNone => 'Aún ninguna';

  @override
  String get hiveBulkPreviewTitle => 'Vista previa';

  @override
  String hiveBulkSaveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Crear $count colmenas',
      one: 'Crear 1 colmena',
    );
    return '$_temp0';
  }

  @override
  String get listEllipsis => '…';

  @override
  String get scanOfflineHint => 'No necesita internet · vibra al leer';

  @override
  String get titleSeparator => ' ·';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsGloveMode => 'Modo guantes';

  @override
  String get settingsGloveModeHint => 'Todos los botones crecen un nivel.';

  @override
  String get settingsCountry => 'País';

  @override
  String settingsCountryValue(String name, String code) {
    return '$name · $code';
  }

  @override
  String get moreSectionApiary => 'Colmenar';

  @override
  String get moreSectionBusiness => 'Explotación';

  @override
  String get moreSectionHelp => 'Ayuda';

  @override
  String get galleryFormFields => 'Campos de formulario';

  @override
  String get galleryRadioCardGroup => 'Tarjetas de opción';

  @override
  String get gallerySegmentedTabs => 'Selector de vista';

  @override
  String get galleryListGroup => 'Lista agrupada';

  @override
  String get galleryNoteCard => 'Tarjeta de nota';

  @override
  String get gallerySummaryTile => 'Tarjeta de resumen';

  @override
  String get galleryActionTile => 'Tarjetas de acción';

  @override
  String get galleryAppLogo => 'Logo y panal';

  @override
  String get gallerySampleApiaryName => 'Nombre del colmenar';

  @override
  String get gallerySampleFirstNumber => 'Primer número';

  @override
  String get gallerySampleNoteHint =>
      'Sin contraseña. Te enviaremos un código de 6 dígitos a tu correo.';

  @override
  String get gallerySampleGrid => 'Cuadrícula';

  @override
  String get gallerySampleList => 'Lista';

  @override
  String get gallerySampleMap => 'Mapa';

  @override
  String get gallerySampleInspections => 'Revisiones';

  @override
  String get gallerySampleNoteTitle => 'Activado para Turquía';

  @override
  String get gallerySampleNoteMessage =>
      'Datos del AKS y del registro de la explotación, resúmenes de la normativa y la lista de medicamentos autorizados.';

  @override
  String get gallerySampleLastInspectionValue => 'hace 3 días';

  @override
  String get gallerySampleFrames => '8 cuadros con abejas · 5 de cría';

  @override
  String get gallerySampleActiveTreatment => 'Tratamiento activo';

  @override
  String get gallerySampleDaysLeft => 'quedan 12 días';

  @override
  String get syncTableMedia => 'Foto o nota de voz';

  @override
  String get mediaTakePhoto => 'Hacer una foto';

  @override
  String get mediaRecordVoice => 'Grabar una nota de voz';

  @override
  String get mediaStopRecording => 'Detener grabación';

  @override
  String mediaRecording(String duration) {
    return 'Grabando · $duration';
  }

  @override
  String mediaPhotoAdded(String number) {
    return 'Foto añadida a la colmena $number';
  }

  @override
  String mediaVoiceAdded(String number) {
    return 'Nota de voz añadida a la colmena $number';
  }

  @override
  String get mediaCameraDenied =>
      'Sin permiso de cámara. Puedes permitirlo en los ajustes del teléfono.';

  @override
  String get mediaMicrophoneDenied =>
      'Sin permiso de micrófono. Puedes permitirlo en los ajustes del teléfono.';

  @override
  String get mediaCaptureFailed => 'No se pudo guardar. Vuelve a intentarlo.';

  @override
  String mediaPhotoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fotos',
      one: '1 foto',
    );
    return '$_temp0';
  }

  @override
  String mediaVoiceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count notas de voz',
      one: '1 nota de voz',
    );
    return '$_temp0';
  }

  @override
  String inspectionMediaAttached(String items) {
    return 'Guardado con la revisión: $items';
  }

  @override
  String get timelinePhoto => 'Foto';

  @override
  String get timelineVoiceNote => 'Nota de voz';

  @override
  String get mediaOpenPhoto => 'Abrir foto';

  @override
  String get mediaDownloadPhoto =>
      'La foto no está en este teléfono. Toca para descargarla.';

  @override
  String mediaPlay(String duration) {
    return 'Reproducir · $duration';
  }

  @override
  String get mediaStopPlaying => 'Detener';

  @override
  String get mediaNotUploaded =>
      'Aún no se ha subido. Llegará cuando el teléfono que la tomó tenga conexión.';

  @override
  String get mediaDownloadOffline =>
      'No se pudo descargar. Revisa tu conexión a internet.';

  @override
  String get mediaDownloadFailed => 'No se pudo descargar.';

  @override
  String get mediaNotFound => 'Foto no encontrada';

  @override
  String get settingsData => 'Datos';

  @override
  String get settingsMediaWifiOnly => 'Subir fotos solo con Wi‑Fi';

  @override
  String get settingsMediaWifiOnlyHint =>
      'Las fotos y notas de voz no usarán datos móviles.';

  @override
  String settingsPendingUploads(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count archivos pendientes de subir',
      one: '1 archivo pendiente de subir',
    );
    return '$_temp0';
  }

  @override
  String get hiveQueenNone => 'No registrada';

  @override
  String get hiveQueenNoneHint => 'Toca para añadir una reina';

  @override
  String queenMarkColorName(String color) {
    String _temp0 = intl.Intl.selectLogic(color, {
      'white': 'Blanco',
      'yellow': 'Amarillo',
      'red': 'Rojo',
      'green': 'Verde',
      'blue': 'Azul',
      'other': 'Desconocido',
    });
    return '$_temp0';
  }

  @override
  String get queenYearUnknown => 'Año desconocido';

  @override
  String get queenUnmarked => 'Sin marcar';

  @override
  String queenAge(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: '$age años',
      one: '1 año',
      zero: 'Menos de un año',
    );
    return '$_temp0';
  }

  @override
  String get queenSourceOwnRearing => 'Cría propia';

  @override
  String get queenSourcePurchased => 'Comprada';

  @override
  String get queenSourceCertifiedBreeder => 'Criador certificado';

  @override
  String get queenSource => 'Origen';

  @override
  String get queenMother => 'Reina madre';

  @override
  String get queenMotherUnknown => 'Desconocida';

  @override
  String get queenBreed => 'Raza';

  @override
  String get queenBreedHint => 'p. ej. Carniola';

  @override
  String get queenBreedLine => 'Línea';

  @override
  String get queenBreedLineHint => 'p. ej. Buckfast';

  @override
  String get queenWing => 'Ala';

  @override
  String get queenWingClipped => 'Cortada';

  @override
  String get queenWingIntact => 'Sin cortar';

  @override
  String get queenYear => 'Año';

  @override
  String get queenYearHelper => 'Año de nacimiento o compra';

  @override
  String get queenMark => 'Color de marca';

  @override
  String queenMarkSuggestion(String year, String color) {
    return 'Color de $year: $color';
  }

  @override
  String get queenUnknown => 'Sin indicar';

  @override
  String get queenEdit => 'Editar reina';

  @override
  String get queenReplace => 'Cambiar reina';

  @override
  String get queenGive => 'Añadir reina';

  @override
  String get queenNoneTitle => 'No hay reina registrada';

  @override
  String get queenNoneMessage =>
      'Registra la reina que diste a esta colmena; aquí verás su año, color y linaje.';

  @override
  String queenFormNewTitle(String number) {
    return 'Nueva reina · Colmena $number';
  }

  @override
  String get queenFormEditTitle => 'Editar reina';

  @override
  String get queenFormSave => 'Guardar';

  @override
  String queenGiven(String number) {
    return 'La colmena $number tiene una reina nueva';
  }

  @override
  String get oldQueensTitle => 'Reinas viejas';

  @override
  String oldQueensIntro(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other:
          'Reinas de colmenas activas con $age años o más. Planifica su cambio.',
      one: 'Reinas de colmenas activas con 1 año o más. Planifica su cambio.',
    );
    return '$_temp0';
  }

  @override
  String get oldQueensEmptyTitle => 'No hay reinas viejas';

  @override
  String oldQueensEmptyMessage(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other:
          'Las reinas de las colmenas activas tienen menos de $age años o no tienen el año indicado.',
      one: 'Las reinas de las colmenas activas tienen menos de 1 año o no tienen el año indicado.',
    );
    return '$_temp0';
  }

  @override
  String get syncTableMiteCounts => 'Conteo de varroa';

  @override
  String get varroaMethodSugarRoll => 'Azúcar glas';

  @override
  String get varroaMethodAlcoholWash => 'Lavado con alcohol';

  @override
  String get varroaMethodStickyBoard => 'Bandeja de diagnóstico';

  @override
  String varroaFormTitle(String number) {
    return 'Varroa · Colmena $number';
  }

  @override
  String get varroaMethod => 'Método';

  @override
  String get varroaSampleBees => 'Abejas de la muestra';

  @override
  String get varroaBoardDays => 'Días con bandeja';

  @override
  String get varroaMites => 'Ácaros contados';

  @override
  String get varroaBoardMites => 'Ácaros caídos';

  @override
  String get varroaSave => 'Guardar';

  @override
  String varroaSaved(String number) {
    return 'Conteo de varroa guardado para la colmena $number';
  }

  @override
  String varroaPercent(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 1,
        );
    final String valueString = valueNumberFormat.format(value);

    return '$valueString %';
  }

  @override
  String varroaPerDay(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 1,
        );
    final String valueString = valueNumberFormat.format(value);

    return '$valueString ácaros/día';
  }

  @override
  String get varroaInfestation => 'Infestación';

  @override
  String get varroaDailyDrop => 'Caída diaria';

  @override
  String get varroaReached => 'En el umbral · planifica el tratamiento';

  @override
  String get varroaBelow => 'Por debajo del umbral';

  @override
  String varroaThresholdNote(String threshold) {
    return 'Umbral $threshold (de Ajustes).';
  }

  @override
  String get hiveVarroa => 'Varroa';

  @override
  String get hiveVarroaNone => 'Aún sin conteo';

  @override
  String get hiveVarroaReached => 'Umbral alcanzado';

  @override
  String get hiveVarroaCount => 'Contar varroa';

  @override
  String varroaChartTitle(String apiary) {
    return '$apiary · conteos recientes';
  }

  @override
  String varroaChartThreshold(String threshold) {
    return 'umbral $threshold';
  }

  @override
  String get varroaChartEmpty =>
      'Aún no hay conteos con azúcar glas o alcohol. Añade uno desde la ficha de una colmena.';

  @override
  String varroaChartBar(String day, String value) {
    return '$day: $value';
  }

  @override
  String varroaChartSemantics(String threshold, String bars) {
    return 'Infestación media por día, umbral $threshold: $bars';
  }

  @override
  String get settingsVarroa => 'Varroa';

  @override
  String get settingsVarroaPercent => 'Umbral de infestación';

  @override
  String get settingsVarroaPerDay => 'Umbral de bandeja';

  @override
  String get settingsVarroaHint =>
      'Se muestra un aviso cuando un conteo alcanza el umbral. Solo se guarda en este teléfono.';

  @override
  String get syncTableRefDrugs => 'Lista de medicamentos';

  @override
  String get syncTableDrugs => 'Medicamento';

  @override
  String get syncTableTreatments => 'Tratamiento';

  @override
  String get syncTableFeedings => 'Alimentación';

  @override
  String get drugIngredientAmitraz => 'Amitraz';

  @override
  String get drugIngredientOxalicAcid => 'Ácido oxálico';

  @override
  String get drugIngredientFormicAcid => 'Ácido fórmico';

  @override
  String get drugIngredientThymol => 'Timol';

  @override
  String get drugIngredientFlumethrin => 'Flumetrina';

  @override
  String get drugIngredientTauFluvalinate => 'Tau-fluvalinato';

  @override
  String get drugIngredientCoumaphos => 'Cumafós';

  @override
  String get drugIngredientLacticAcid => 'Ácido láctico';

  @override
  String get drugIngredientOther => 'Otro';

  @override
  String get drugUnitStrip => 'tira';

  @override
  String get drugUnitMl => 'ml';

  @override
  String get drugUnitG => 'g';

  @override
  String get drugUnitDose => 'dosis';

  @override
  String get hiveTreat => 'Aplicar tratamiento';

  @override
  String get treatmentFormTitle => 'Tratamiento';

  @override
  String treatmentScopeHive(String number) {
    return 'Colmena $number';
  }

  @override
  String treatmentScopeApiary(int count) {
    return 'Todo el colmenar · $count';
  }

  @override
  String get treatmentChooseDrug => 'Elegir medicamento';

  @override
  String get treatmentChangeDrug => 'Cambiar';

  @override
  String treatmentDrugIngredient(String ingredient) {
    return 'Principio activo: $ingredient';
  }

  @override
  String treatmentDrugLicense(String number) {
    return 'registro $number';
  }

  @override
  String get treatmentDrugCustom => 'tu medicamento';

  @override
  String get treatmentAddDrug => 'Añadir un medicamento nuevo';

  @override
  String get drugInfoOpen => 'Información del medicamento';

  @override
  String get drugInfoSourceTitle =>
      'Fuente: Ministerio de Agricultura y Silvicultura de Turquía';

  @override
  String get drugInfoSourceMessage =>
      'Esta información procede de la ficha del producto aprobada por el Ministerio y se muestra en turco tal como se publicó. Lee la etiqueta antes de usarlo; si tienes dudas, consulta a un veterinario.';

  @override
  String get drugInfoActiveIngredient => 'Principio activo';

  @override
  String get drugInfoIndications => 'Indicado para';

  @override
  String get drugInfoUsage => 'Uso y frecuencia';

  @override
  String get drugInfoUsageMethod => 'Forma de aplicación';

  @override
  String get drugInfoUsageMethodAndDose => 'Aplicación y dosis';

  @override
  String get drugInfoUsageDiagnosis => 'Para diagnóstico';

  @override
  String get drugInfoUsageDose => 'Dosis';

  @override
  String get drugInfoUsageFrequency => 'Frecuencia';

  @override
  String get drugInfoUsageDuration => 'Duración';

  @override
  String get drugInfoUsageOther => 'Nota';

  @override
  String get drugInfoSuitablePeriods => 'Periodos adecuados';

  @override
  String get drugInfoAvoidPeriods => 'No usar';

  @override
  String get drugInfoWithdrawal => 'Tiempo de espera';

  @override
  String get drugInfoWarnings => 'Advertencias';

  @override
  String get drugInfoClose => 'Cerrar';

  @override
  String get treatmentBatchNo => 'N.º de lote';

  @override
  String get treatmentStartedOn => 'Inicio';

  @override
  String treatmentDose(String unit) {
    return 'Dosis por colmena ($unit)';
  }

  @override
  String treatmentDoseTotal(String total, String unit) {
    return 'Total $total $unit';
  }

  @override
  String get treatmentWithdrawalDays => 'Tiempo de espera (días)';

  @override
  String get treatmentRemoval => 'Retirada';

  @override
  String get treatmentRemovalNone => 'Ninguna';

  @override
  String get treatmentRemovalChange =>
      'Recordatorio esa mañana; toca para cambiar';

  @override
  String get treatmentRemovalSingle => 'Aplicación única; toca para fijar';

  @override
  String get treatmentRemovalClear => 'Sin retirada (aplicación única)';

  @override
  String get treatmentNoSuper => 'Sin alza de miel';

  @override
  String treatmentNoSuperUntil(String date) {
    return 'Hasta el $date';
  }

  @override
  String treatmentNoSuperAfterRemoval(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'retirada + $days días de espera',
      one: 'retirada + 1 día de espera',
      zero: 'sin espera tras la retirada',
    );
    return '$_temp0';
  }

  @override
  String treatmentNoSuperAfterStart(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'inicio + $days días de espera',
      one: 'inicio + 1 día de espera',
      zero: 'sin espera',
    );
    return '$_temp0';
  }

  @override
  String treatmentSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Guardar en $count colmenas',
      one: 'Guardar',
    );
    return '$_temp0';
  }

  @override
  String treatmentSaved(String number) {
    return 'Tratamiento guardado para la colmena $number';
  }

  @override
  String treatmentSavedMany(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tratamiento guardado para $count colmenas',
      one: 'Tratamiento guardado para 1 colmena',
    );
    return '$_temp0';
  }

  @override
  String get drugFormTitle => 'Nuevo medicamento';

  @override
  String get drugName => 'Nombre';

  @override
  String get drugActiveIngredient => 'Principio activo';

  @override
  String get drugDoseUnit => 'Unidad de dosis';

  @override
  String get drugWithdrawalDays => 'Tiempo de espera de la etiqueta (días)';

  @override
  String get drugSave => 'Añadir medicamento';

  @override
  String get withdrawalLockTitle => 'En tiempo de espera.';

  @override
  String withdrawalLockMessage(String number, String product, String date) {
    return 'La colmena $number está en tratamiento con $product. No se debe poner un alza de miel antes del $date; la miel de este periodo puede contener residuos.';
  }

  @override
  String get withdrawalDaysLeft => 'Quedan';

  @override
  String withdrawalDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '1 día',
    );
    return '$_temp0';
  }

  @override
  String get withdrawalApplied => 'Aplicado';

  @override
  String get withdrawalReasonPrompt =>
      'Para guardar de todos modos, elige un motivo';

  @override
  String get withdrawalReasonRemovedEarly => 'Medicamento retirado antes';

  @override
  String get withdrawalReasonNotForSale =>
      'El alza no se venderá (consumo propio/alimento)';

  @override
  String get withdrawalCancel => 'Cancelar, no poner alza';

  @override
  String get withdrawalProceed => 'Guardar de todos modos';

  @override
  String inspectionWithdrawalOverride(String reason) {
    return 'Alza de miel puesta durante el tiempo de espera: $reason';
  }

  @override
  String timelineTreatment(String product) {
    return 'Tratamiento · $product';
  }

  @override
  String timelineTreatmentBatch(String batch) {
    return 'Lote $batch';
  }

  @override
  String treatmentDoseValue(String dose, String unit) {
    return '$dose $unit';
  }

  @override
  String timelineTreatmentRemoval(String date) {
    return 'retirada $date';
  }

  @override
  String timelineTreatmentWithdrawal(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días de espera',
      one: '1 día de espera',
    );
    return '$_temp0';
  }

  @override
  String get hiveActiveTreatment => 'Tratamiento activo';

  @override
  String get hiveActiveTreatmentNone => 'Ninguno';

  @override
  String hiveActiveTreatmentLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'quedan $days días',
      one: 'queda 1 día',
    );
    return '$_temp0';
  }

  @override
  String hiveActiveTreatmentDetail(String ingredient) {
    return '$ingredient · sin alza de miel';
  }

  @override
  String get treatmentRotationTitle => 'Mismo principio activo.';

  @override
  String treatmentRotationMessage(int count, String ingredient) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Los últimos $count tratamientos de este colmenar también fueron con $ingredient. Considera otro principio activo para limitar la resistencia.',
    );
    return '$_temp0';
  }

  @override
  String get treatmentPrescriptionAdd => 'Añadir foto de receta / factura';

  @override
  String get treatmentPrescriptionAdded => 'Foto de receta añadida';

  @override
  String get treatmentPrescriptionRemove => 'Quitar';

  @override
  String get reminderChannelName => 'Recordatorios';

  @override
  String get treatmentReminderDenied =>
      'Las notificaciones están desactivadas; no se puso recordatorio de retirada.';

  @override
  String get hiveFeed => 'Alimentar';

  @override
  String get feedingFormTitle => 'Alimentación';

  @override
  String feedingScopeHive(String number) {
    return 'Colmena $number';
  }

  @override
  String feedingScopeApiary(int count) {
    return 'Todo el colmenar · $count';
  }

  @override
  String get feedingKind => 'Tipo';

  @override
  String get feedingKindSyrup1to1 => 'Jarabe 1:1 · estimulante';

  @override
  String get feedingKindSyrup2to1 => 'Jarabe 2:1 · invierno';

  @override
  String get feedingKindBeeCake => 'Candi';

  @override
  String get feedingKindPollenSubstitute => 'Sustituto de polen';

  @override
  String feedingAmount(String unit) {
    return 'Por colmena ($unit)';
  }

  @override
  String get feedingSuperHiveTitle => 'Esta colmena tiene alza de miel.';

  @override
  String get feedingSuperHiveMessage => 'El jarabe podría pasar a la miel.';

  @override
  String feedingSuperSkippedTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmenas tienen alza de miel',
      one: '1 colmena tiene alza de miel',
    );
    return '$_temp0';
  }

  @override
  String feedingSuperSkippedMessage(String numbers) {
    return '($numbers). Se omiten para que el jarabe no pase a la miel.';
  }

  @override
  String get feedingPrepare => 'A preparar';

  @override
  String feedingPrepareCount(int count, String amount, String unit) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmenas × $amount $unit',
      one: '1 colmena × $amount $unit',
    );
    return '$_temp0';
  }

  @override
  String feedingTotalSyrup(String amount, String unit) {
    return '$amount $unit de jarabe';
  }

  @override
  String feedingTotalBeeCake(String amount, String unit) {
    return '$amount $unit de candi';
  }

  @override
  String feedingTotalPollenSubstitute(String amount, String unit) {
    return '$amount $unit de sustituto de polen';
  }

  @override
  String get feedingSugar => 'Azúcar';

  @override
  String get feedingWater => 'Agua';

  @override
  String feedingApprox(String amount, String unit) {
    return '≈ $amount $unit';
  }

  @override
  String feedingSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Guardar en $count colmenas',
      one: 'Guardar',
      zero: 'No hay colmenas que alimentar',
    );
    return '$_temp0';
  }

  @override
  String feedingSaved(String number) {
    return 'Alimentación guardada para la colmena $number';
  }

  @override
  String feedingSavedMany(int count) {
    return 'Alimentación guardada para $count colmenas';
  }

  @override
  String get unitLiter => 'L';

  @override
  String get unitGallon => 'gal';

  @override
  String get syncTableTasks => 'Tarea';

  @override
  String get tasksTabToday => 'Hoy';

  @override
  String get tasksTabWeek => 'Esta semana';

  @override
  String get tasksTabApiary => 'Por colmenar';

  @override
  String get tasksAdd => 'Añadir tarea';

  @override
  String tasksOverdue(int count) {
    return 'Atrasadas · $count';
  }

  @override
  String tasksDayGroup(String day, int count) {
    return '$day · $count';
  }

  @override
  String get tasksToday => 'Hoy';

  @override
  String get tasksTomorrow => 'Mañana';

  @override
  String get tasksNoApiary => 'Sin colmenar';

  @override
  String tasksApiaryGroup(String apiary, int count) {
    return '$apiary · $count';
  }

  @override
  String get tasksEmptyTodayTitle => 'Nada que hacer hoy';

  @override
  String get tasksEmptyWeekTitle => 'No hay tareas esta semana';

  @override
  String get tasksEmptyAddHint =>
      'Añade una tarea nueva con + arriba a la derecha.';

  @override
  String get tasksLoadError => 'No se pudieron cargar las tareas.';

  @override
  String tasksWeekDaySemantics(String day, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tareas',
      one: '1 tarea',
      zero: 'sin tareas',
    );
    return '$day, $_temp0';
  }

  @override
  String taskOverdueDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días de retraso',
      one: '1 día de retraso',
    );
    return '$_temp0';
  }

  @override
  String get taskSourceInspection => 'de la revisión';

  @override
  String get taskSourceTreatment => 'tratamiento';

  @override
  String taskInspectionTitle(String number) {
    return 'Colmena $number · volver a revisar';
  }

  @override
  String get taskInspectionTitleNoHive => 'Volver a revisar';

  @override
  String taskTreatmentTitle(String number) {
    return 'Colmena $number · retirar tiras';
  }

  @override
  String get taskTreatmentTitleApiary => 'Retirar tiras';

  @override
  String get taskReminderBody => 'Tu tarea vence hoy.';

  @override
  String get taskAssigneeMe => 'Yo';

  @override
  String taskAssignedTo(String name) {
    return 'Asignada a $name';
  }

  @override
  String taskMemberNumbered(String role, int index) {
    return '$role $index';
  }

  @override
  String get roleOwner => 'Titular';

  @override
  String get rolePartner => 'Socio';

  @override
  String get roleWorker => 'Trabajador';

  @override
  String get roleViewer => 'Observador';

  @override
  String taskCompleteAction(String title) {
    return 'Completar: $title';
  }

  @override
  String get taskCompleted => 'Tarea completada';

  @override
  String get taskFormNewTitle => 'Nueva tarea';

  @override
  String get taskFormEditTitle => 'Editar tarea';

  @override
  String get taskFormName => 'Tarea';

  @override
  String get taskFormNameHint => 'p. ej. Visitar el colmenar de la sierra';

  @override
  String get taskFormDue => 'Vence';

  @override
  String get taskFormPickDate => 'Otro día';

  @override
  String get taskFormTime => 'Hora';

  @override
  String get taskFormApiary => 'Colmenar';

  @override
  String get taskFormHive => 'Colmena';

  @override
  String get taskFormNone => 'Ninguno';

  @override
  String get taskFormChooseApiary => 'Elegir colmenar';

  @override
  String get taskFormChooseHive => 'Elegir colmena';

  @override
  String get taskFormAssignee => 'Asignada a';

  @override
  String get taskFormUnassigned => 'Sin asignar';

  @override
  String get taskFormCompleted => 'Hecha';

  @override
  String get taskFormSave => 'Guardar';

  @override
  String get taskFormDelete => 'Eliminar tarea';

  @override
  String get taskDeleteTitle => '¿Eliminar esta tarea?';

  @override
  String get taskDeleteMessage => 'La tarea se elimina de todos los teléfonos.';

  @override
  String get taskDeleteConfirm => 'Eliminar';

  @override
  String get taskSaved => 'Tarea guardada';

  @override
  String get taskDeleted => 'Tarea eliminada';

  @override
  String get taskNotFound =>
      'Tarea no encontrada; puede que se haya eliminado.';

  @override
  String get taskReminderDenied =>
      'Las notificaciones están desactivadas; el recordatorio no sonará.';

  @override
  String get exactAlarmTitle => '¿Recordatorios a la hora exacta?';

  @override
  String get exactAlarmMessage =>
      'Android puede retrasar las notificaciones unos minutos para ahorrar batería. Permite Mobil Arıcı en el ajuste que se abre y los recordatorios de tareas sonarán a su hora. No necesita internet.';

  @override
  String get exactAlarmConfirm => 'Abrir ajuste';

  @override
  String get settingsReminders => 'Recordatorios';

  @override
  String get settingsExactAlarms => 'Sonar a la hora exacta';

  @override
  String get settingsExactAlarmsOn => 'Activado';

  @override
  String get settingsExactAlarmsOff =>
      'Desactivado · puede llegar unos minutos tarde';

  @override
  String weatherTemperature(String value) {
    return '$value°';
  }

  @override
  String weatherForecastAsOf(String time) {
    return 'Previsión de las $time';
  }

  @override
  String get weatherNoLocationTitle => 'Sin ubicación';

  @override
  String get weatherNoLocationAction => 'Añade una ubicación para el tiempo';

  @override
  String get weatherPendingHint => 'Llegará cuando tengas conexión';

  @override
  String weatherWind(String speed) {
    return 'Viento $speed';
  }

  @override
  String weatherSpeed(String value, String unit) {
    return '$value $unit';
  }

  @override
  String get unitKmh => 'km/h';

  @override
  String get unitMph => 'mph';

  @override
  String weatherPercent(String value) {
    return '$value %';
  }

  @override
  String weatherTemperatureRange(String max, String min) {
    return '$max / $min';
  }

  @override
  String get hiveOpeningRain => 'Lluvia';

  @override
  String get hiveOpeningWind => 'Viento';

  @override
  String get hiveOpeningCold => 'Frío';

  @override
  String get hiveOpeningDaySuitable => 'Abrir';

  @override
  String get weatherConditionSunny => 'Soleado';

  @override
  String get weatherConditionPartlyCloudy => 'Parcialmente nublado';

  @override
  String get weatherConditionCloudy => 'Nublado';

  @override
  String get weatherConditionRainy => 'Lluvioso';

  @override
  String get weatherConditionWindy => 'Ventoso';

  @override
  String get weatherConditionOther => 'Nieve, niebla o tormenta';

  @override
  String get weatherConditionFog => 'Niebla';

  @override
  String get weatherConditionThunder => 'Tormentas';

  @override
  String get weatherConditionSleet => 'Aguanieve';

  @override
  String get weatherConditionSnow => 'Nieve';

  @override
  String weatherFeelsLike(String condition, String value) {
    return '$condition · sensación de $value';
  }

  @override
  String get weatherWindLabel => 'Viento';

  @override
  String get weatherHumidityLabel => 'Humedad';

  @override
  String get weatherPrecipitationLabel => 'Lluvia';

  @override
  String get weatherScreenTitle => 'Tiempo en el colmenar';

  @override
  String weatherScreenSubtitle(String place, String days) {
    return '$place · previsión de $days días';
  }

  @override
  String weatherScreenSubtitleNoPlace(String days) {
    return 'Previsión de $days días';
  }

  @override
  String weatherUpdatedAt(String time) {
    return 'Actualizado $time';
  }

  @override
  String get weatherNow => 'Ahora';

  @override
  String get weatherToday => 'Hoy';

  @override
  String get weatherColumnDay => 'Día';

  @override
  String get weatherColumnTemperature => 'Temp.';

  @override
  String get weatherColumnPrecipitation => 'Lluvia';

  @override
  String get weatherColumnHive => 'Colmenas';

  @override
  String get weatherTodaySuitable => 'Buen día para abrir colmenas';

  @override
  String get weatherTodayRain => 'Lluvia hoy; no es día de abrir colmenas';

  @override
  String get weatherTodayWind => 'Viento hoy; no es día de abrir colmenas';

  @override
  String get weatherTodayCold => 'Frío hoy; no es día de abrir colmenas';

  @override
  String weatherDayRange(String from, String to) {
    return '$from–$to';
  }

  @override
  String weatherPlanRain(String days) {
    return 'Lluvia el $days.';
  }

  @override
  String weatherPlanWind(String days) {
    return 'Viento el $days.';
  }

  @override
  String weatherPlanMove(String weekday) {
    String _temp0 = intl.Intl.selectLogic(weekday, {
      'monday': 'Pasa las revisiones al lunes.',
      'tuesday': 'Pasa las revisiones al martes.',
      'wednesday': 'Pasa las revisiones al miércoles.',
      'thursday': 'Pasa las revisiones al jueves.',
      'friday': 'Pasa las revisiones al viernes.',
      'saturday': 'Pasa las revisiones al sábado.',
      'other': 'Pasa las revisiones al domingo.',
    });
    return '$_temp0';
  }

  @override
  String get weatherPlanAction => 'Planificar';

  @override
  String weatherPlanTaskTitle(String apiary) {
    return 'Revisar $apiary';
  }

  @override
  String weatherThresholdsHint(
    String temperature,
    String wind,
    String precipitation,
  ) {
    return 'Bueno para abrir: más de $temperature, viento por debajo de $wind, probabilidad de lluvia por debajo de $precipitation. Puedes cambiar los umbrales en Ajustes.';
  }

  @override
  String get weatherEmptyTitle => 'Aún sin previsión';

  @override
  String get weatherEmptyMessage =>
      'La previsión de este colmenar aún no se ha descargado. Actualiza cuando tengas conexión.';

  @override
  String get weatherNoLocationMessage =>
      'Este colmenar no tiene ubicación. Añade una para recibir la previsión.';

  @override
  String get weatherRefresh => 'Actualizar';

  @override
  String get weatherRefreshFailed =>
      'No se pudo obtener la previsión. Revisa tu conexión a internet.';

  @override
  String get weatherApiaryNotFound => 'Colmenar no encontrado';

  @override
  String get weatherAttributionPrefix => 'Powered by';

  @override
  String get weatherAttributionLink => 'WeatherAPI.com';

  @override
  String get settingsHiveOpening => 'Umbrales para abrir colmenas';

  @override
  String get settingsHiveOpeningTemperature => 'Temperatura';

  @override
  String settingsHiveOpeningTemperatureValue(String value) {
    return 'más de $value';
  }

  @override
  String get settingsHiveOpeningWind => 'Viento';

  @override
  String get settingsHiveOpeningPrecipitation => 'Probabilidad de lluvia';

  @override
  String settingsHiveOpeningBelow(String value) {
    return 'menos de $value';
  }

  @override
  String get settingsHiveOpeningHint =>
      'La pantalla del tiempo y las tarjetas de Hoy dicen «Abrir» según estos umbrales. Solo se guarda en este teléfono.';

  @override
  String get hiveOpeningSuitable => 'Bueno para abrir';

  @override
  String get todayGreetingMorning => 'Buenos días';

  @override
  String get todayGreetingAfternoon => 'Buenas tardes';

  @override
  String get todayGreetingEvening => 'Buenas noches';

  @override
  String get todayAttentionTitle => 'Necesitan atención';

  @override
  String todayAttentionHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmenas',
      one: '1 colmena',
    );
    return '$_temp0';
  }

  @override
  String get todayAttentionNone => 'Ninguna colmena necesita atención';

  @override
  String get todayTasksTitle => 'Hoy';

  @override
  String todayTasksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tareas',
      one: '1 tarea',
    );
    return '$_temp0';
  }

  @override
  String todayTasksApiaryCount(String apiary, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tareas',
      one: '1 tarea',
    );
    return '$apiary · $_temp0';
  }

  @override
  String todaySetupProgress(int done, int total) {
    return 'Configuración $done/$total';
  }

  @override
  String get setupStepApiary => 'Añade tu colmenar';

  @override
  String get setupStepHives => 'Crea tus colmenas';

  @override
  String get setupStepInspection => 'Haz tu primera revisión';

  @override
  String setupStepDone(String step) {
    return '$step: hecho';
  }

  @override
  String get attentionQueenless => 'Huérfana';

  @override
  String get attentionWeak => 'Débil';

  @override
  String get attentionSwarming => 'Señales de enjambrazón';

  @override
  String get attentionTreatmentRemoval => 'Tratamiento por retirar';

  @override
  String get attentionQueenlessTitle => 'Colmenas huérfanas';

  @override
  String get attentionWeakTitle => 'Colmenas débiles';

  @override
  String get attentionSwarmingTitle => 'Colmenas con señales de enjambrazón';

  @override
  String get attentionTreatmentRemovalTitle => 'Tratamientos por retirar';

  @override
  String get attentionQueenlessIntro =>
      'Colmenas activas en cuya última revisión no se vio reina ni huevos.';

  @override
  String attentionWeakIntro(int max) {
    return 'Colmenas activas con fuerza $max/5 o menos en su última revisión.';
  }

  @override
  String get attentionSwarmingIntro =>
      'Colmenas activas cuya última revisión mostró señales de enjambrazón o celdas de enjambre.';

  @override
  String get attentionTreatmentRemovalIntro =>
      'Colmenas cuya retirada de tiras ya toca y la tarea aún no está hecha.';

  @override
  String get attentionEmpty => 'No hay colmenas en este grupo.';

  @override
  String attentionLastInspection(String date) {
    return 'Última revisión: $date';
  }

  @override
  String attentionRemovalDue(String date) {
    return 'Retirada prevista: $date';
  }

  @override
  String get syncTableHarvests => 'Cosecha';

  @override
  String get syncTableHarvestHives => 'Colmena cosechada';

  @override
  String withdrawalLockHarvestMessage(
    String number,
    String product,
    String date,
  ) {
    return 'La colmena $number está en tratamiento con $product. No se debería cosechar antes del $date; la miel de este periodo puede contener residuos.';
  }

  @override
  String get withdrawalReasonNotForSaleHarvest =>
      'La miel no se venderá (consumo propio/alimento)';

  @override
  String get withdrawalHarvestCancel => 'Cancelar, no cosechar';

  @override
  String get withdrawalHarvestProceed => 'Cosechar de todos modos';

  @override
  String get apiaryHarvest => 'Cosecha';

  @override
  String harvestFormTitle(String apiary) {
    return 'Cosecha · $apiary';
  }

  @override
  String harvestSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmenas seleccionadas',
      one: '1 colmena seleccionada',
      zero: 'Ninguna colmena seleccionada',
    );
    return '$_temp0';
  }

  @override
  String harvestSelectedHint(String numbers) {
    return '$numbers · toca para cambiar o escanea para añadir';
  }

  @override
  String get harvestSelectedEmptyHint =>
      'Toca para elegir colmenas o escanéalas';

  @override
  String get harvestScan => 'Escanear';

  @override
  String harvestLockedTitle(String numbers) {
    return '$numbers en tiempo de espera.';
  }

  @override
  String get harvestLockedMessage =>
      'No cosechadas. Para cosechar una de todos modos, elígela en la lista de colmenas.';

  @override
  String get harvestDate => 'Fecha';

  @override
  String get harvestToday => 'Hoy';

  @override
  String get harvestYesterday => 'Ayer';

  @override
  String get harvestPickDate => 'Otro día';

  @override
  String get harvestHoneyKind => 'Tipo de miel';

  @override
  String get honeyKindPine => 'Pino';

  @override
  String get honeyKindFlower => 'Milflores';

  @override
  String get honeyKindChestnut => 'Castaño';

  @override
  String get honeyKindCitrus => 'Azahar';

  @override
  String get honeyKindOther => 'Otra';

  @override
  String get harvestUnit => 'Retirado en';

  @override
  String get harvestUnitSuper => 'Alzas';

  @override
  String get harvestUnitFrame => 'Cuadros';

  @override
  String get harvestTakenSupers => 'Alzas retiradas';

  @override
  String get harvestTakenFrames => 'Cuadros retirados';

  @override
  String harvestWeight(String unit) {
    return 'Miel extraída ($unit)';
  }

  @override
  String get harvestWeightInvalid => 'Introduce un peso como 574 o 574,5';

  @override
  String harvestWeightTooLarge(String max, String unit) {
    return 'Como máximo $max $unit';
  }

  @override
  String get harvestPerHive => 'Por colmena';

  @override
  String harvestWeightValue(String value, String unit) {
    return '$value $unit';
  }

  @override
  String harvestSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Guardar cosecha',
      zero: 'No hay colmenas que cosechar',
    );
    return '$_temp0';
  }

  @override
  String harvestSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Cosecha guardada para $count colmenas',
      one: 'Cosecha guardada para 1 colmena',
    );
    return '$_temp0';
  }

  @override
  String get harvestHivesTitle => 'Colmenas a cosechar';

  @override
  String get harvestSelectAll => 'Seleccionar todas';

  @override
  String get harvestSelectNone => 'No seleccionar ninguna';

  @override
  String harvestHiveLocked(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'quedan $days días',
      one: 'queda 1 día',
    );
    return 'Espera · $_temp0';
  }

  @override
  String harvestHiveOverridden(String reason) {
    return 'Cosechada de todos modos: $reason';
  }

  @override
  String get harvestHivesDone => 'Hecho';

  @override
  String get harvestNoActiveHives => 'Este colmenar no tiene colmenas activas.';

  @override
  String get harvestScanTitle => 'Escanear para la cosecha';

  @override
  String harvestScanAdded(String number) {
    return 'Colmena $number añadida';
  }

  @override
  String harvestScanAlready(String number) {
    return 'La colmena $number ya está seleccionada';
  }

  @override
  String harvestScanOtherApiary(String number) {
    return 'La colmena $number no está en este colmenar';
  }

  @override
  String harvestScanInactive(String number) {
    return 'La colmena $number no está activa';
  }

  @override
  String get harvestScanUnknown =>
      'Esta etiqueta no está vinculada a ninguna colmena';

  @override
  String harvestScanDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hecho · $count colmenas',
      one: 'Hecho · 1 colmena',
      zero: 'Hecho',
    );
    return '$_temp0';
  }

  @override
  String get apiaryTourStart => 'Iniciar recorrido';

  @override
  String get apiaryTourResume => 'Continuar recorrido';

  @override
  String get tourReplaceTitle => '¿Terminar el recorrido actual?';

  @override
  String tourReplaceMessage(String apiary) {
    return 'El recorrido de $apiary sigue en curso. Empezar uno nuevo borra su progreso; las revisiones quedan guardadas.';
  }

  @override
  String get tourReplaceConfirm => 'Iniciar nuevo recorrido';

  @override
  String tourTitle(String apiary) {
    return 'Recorrido de $apiary';
  }

  @override
  String get tourFinish => 'Terminar recorrido';

  @override
  String tourProgress(int done, int total) {
    return '$done / $total';
  }

  @override
  String tourProgressLabel(int done, int total) {
    return '$done de $total colmenas hechas';
  }

  @override
  String tourMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String tourHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String tourElapsedLabel(String duration) {
    return 'Tiempo transcurrido: $duration';
  }

  @override
  String get tourNext => 'Siguiente';

  @override
  String tourPreviousVisit(String date) {
    return 'La última vez · $date';
  }

  @override
  String get tourQueue => 'Orden';

  @override
  String tourSkippedCount(int count) {
    return '$count omitidas';
  }

  @override
  String get tourStateDone => 'Hecha';

  @override
  String get tourStateSkipped => 'Omitida';

  @override
  String get tourStatePending => 'Pendiente';

  @override
  String get tourStateNext => 'Siguiente';

  @override
  String tourHiveSemantics(String number, String state) {
    return 'Colmena $number, $state';
  }

  @override
  String get tourSkip => 'Omitir';

  @override
  String tourInspect(String number) {
    return 'Revisar $number';
  }

  @override
  String get tourAllDone => 'Se han revisado todas las colmenas.';

  @override
  String get tourSunSuggestion =>
      'El modo sol hace que la pantalla se lea mejor con mucha luz.';

  @override
  String get tourSunOn => 'Activar modo sol';

  @override
  String get tourSunMode => 'Modo sol';

  @override
  String get tourFinishTitle => '¿Terminar el recorrido?';

  @override
  String tourFinishMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count colmenas no se han revisado; el resumen las cuenta como omitidas.',
      one: '1 colmena no se ha revisado; el resumen la cuenta como omitida.',
    );
    return '$_temp0';
  }

  @override
  String get tourNotFound =>
      'No hay ningún recorrido en curso en este colmenar.';

  @override
  String get tourCompleteTitle => 'Recorrido completado';

  @override
  String tourInspectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmenas revisadas',
      one: '1 colmena revisada',
    );
    return '$_temp0';
  }

  @override
  String get tourHealthy => 'Fuertes / normales';

  @override
  String get tourTasksTitle => 'Tareas';

  @override
  String tourTaskRequeen(String numbers) {
    return 'Cambiar reina: $numbers';
  }

  @override
  String tourTaskFeedWeak(String numbers) {
    return 'Alimentar con jarabe 1:1: $numbers';
  }

  @override
  String tourTaskSwarmCheck(String numbers) {
    return 'Control de enjambrazón: $numbers';
  }

  @override
  String tourTaskRevisit(String numbers) {
    return 'Revisar colmenas omitidas: $numbers';
  }

  @override
  String tourTaskMoreNumbers(String numbers, int count) {
    return '$numbers +$count';
  }

  @override
  String tourTaskDue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'en $days días',
      one: 'mañana',
      zero: 'hoy',
    );
    return '$_temp0';
  }

  @override
  String tourSaveTasks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Guardar tareas',
      one: 'Guardar tarea',
      zero: 'Cerrar',
    );
    return '$_temp0';
  }

  @override
  String tourTasksSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tareas guardadas',
      one: '1 tarea guardada',
    );
    return '$_temp0';
  }

  @override
  String get tourNoTasks => 'No hay tareas que sugerir.';

  @override
  String get reportsTitle => 'Informes';

  @override
  String get reportTreatmentRegister => 'Libro de tratamientos';

  @override
  String get reportTreatmentRegisterHint => 'Para inspecciones oficiales';

  @override
  String get reportHiveHistory => 'Historial de colmena';

  @override
  String get reportHiveHistoryHint => 'Una colmena o un colmenar';

  @override
  String get reportFrom => 'Desde';

  @override
  String get reportTo => 'Hasta';

  @override
  String get reportApiary => 'Colmenar';

  @override
  String get reportAllApiaries => 'Todos los colmenares';

  @override
  String get reportHive => 'Colmena';

  @override
  String get reportAllHives => 'Todas las colmenas';

  @override
  String get reportLanguage => 'Idioma del PDF';

  @override
  String get reportRegistrationNo => 'N.º de registro de la explotación';

  @override
  String get reportAksNo => 'N.º AKS';

  @override
  String get reportRecordNo => 'Número de registro';

  @override
  String get reportNumbersHelper =>
      'Solo se imprime en el encabezado del PDF; no se guarda.';

  @override
  String get reportShare => 'Compartir';

  @override
  String get reportCreate => 'Crear PDF';

  @override
  String get reportPreparing => 'Preparando el PDF…';

  @override
  String get reportError => 'No se pudo crear el PDF. Vuelve a intentarlo.';

  @override
  String get reportLoadError => 'No se pudieron leer los registros.';

  @override
  String get reportEmpty => 'No hay registros en este periodo.';

  @override
  String reportTreatmentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tratamientos',
      one: '1 tratamiento',
    );
    return '$_temp0';
  }

  @override
  String reportHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmenas',
      one: '1 colmena',
    );
    return '$_temp0';
  }

  @override
  String reportRecordCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count registros',
      one: '1 registro',
    );
    return '$_temp0';
  }

  @override
  String get reportNoValue => '—';

  @override
  String get pdfTreatmentRegisterTitle => 'Libro de tratamientos';

  @override
  String get pdfHiveHistoryTitle => 'Historial de colmena';

  @override
  String pdfRegistrationNo(String number) {
    return 'N.º de registro de la explotación $number';
  }

  @override
  String pdfAksNo(String number) {
    return 'N.º AKS $number';
  }

  @override
  String pdfRecordNo(String number) {
    return 'N.º de registro $number';
  }

  @override
  String pdfPeriod(String from, String to) {
    return 'Periodo: $from – $to';
  }

  @override
  String pdfApiary(String name) {
    return 'Colmenar: $name';
  }

  @override
  String pdfCreated(String date) {
    return 'Creado el $date';
  }

  @override
  String pdfPage(int page, int pages) {
    return 'Página $page de $pages';
  }

  @override
  String get pdfColumnDate => 'Fecha';

  @override
  String get pdfColumnApiary => 'Colmenar';

  @override
  String get pdfColumnProduct => 'Producto / lote';

  @override
  String get pdfColumnHives => 'Colmenas';

  @override
  String get pdfColumnDose => 'Dosis por colmena';

  @override
  String get pdfColumnRemoval => 'Retirada';

  @override
  String get pdfColumnWithdrawalEnd => 'Fin de la espera';

  @override
  String get pdfColumnEvent => 'Registro';

  @override
  String get pdfColumnDetails => 'Detalles';

  @override
  String get pdfEventFeeding => 'Alimentación';

  @override
  String get pdfEventVarroa => 'Conteo de varroa';

  @override
  String get pdfEventHarvest => 'Cosecha';

  @override
  String pdfHarvestTotal(String amount) {
    return 'Cosecha total: $amount';
  }

  @override
  String pdfDocumentName(String title, String from, String to) {
    return '$title $from–$to';
  }

  @override
  String get moreFeedback => 'Enviar comentarios';

  @override
  String get feedbackTitle => 'Enviar comentarios';

  @override
  String get feedbackIntro =>
      'Estamos creando esta app junto con apicultores. Leemos todos los mensajes.';

  @override
  String get feedbackKindLabel => '¿De qué se trata?';

  @override
  String get feedbackKindBug => 'Error';

  @override
  String get feedbackKindSuggestion => 'Sugerencia';

  @override
  String get feedbackKindMissingFeature => 'Función que falta';

  @override
  String get feedbackKindThanks => 'Agradecimiento';

  @override
  String get feedbackMessageLabel => 'Tu mensaje';

  @override
  String get feedbackMessageHint => '¿Qué pasó y qué esperabas?';

  @override
  String get feedbackAddScreenshot => 'Añadir captura de pantalla';

  @override
  String get feedbackScreenshotAttached => 'Captura adjunta';

  @override
  String get feedbackRemoveScreenshot => 'Quitar';

  @override
  String get feedbackScreenshotDenied =>
      'No se permitió el acceso a las fotos. Para adjuntar una captura, permítelo en Ajustes.';

  @override
  String get feedbackIncludeDeviceInfo =>
      'Incluir información del dispositivo y la versión';

  @override
  String get feedbackOfflineHint =>
      'Sin internet, el mensaje queda en cola y se envía cuando tengas conexión.';

  @override
  String get feedbackSend => 'Enviar';

  @override
  String get feedbackQueued =>
      '¡Gracias! Tu mensaje está en cola para enviarse.';

  @override
  String get settingsAnalytics => 'Compartir datos de uso';

  @override
  String get settingsAnalyticsHint =>
      'Cifras como el tiempo de revisión, los resultados del escaneo y el retraso de sincronización; nunca se envían tu nombre, tus colmenas ni tus ubicaciones.';

  @override
  String get teamTitle => 'Equipo';

  @override
  String get teamRoleOwner => 'Titular';

  @override
  String get teamRolePartner => 'Socio';

  @override
  String get teamRoleWorker => 'Trabajador';

  @override
  String get teamRoleViewer => 'Asesor';

  @override
  String get teamRoleViewerSubtitle => 'Solo lectura';

  @override
  String get teamRoleHintPartner =>
      'Un socio registra datos y ve las finanzas.';

  @override
  String get teamRoleHintWorker =>
      'Un trabajador registra datos pero no ve las finanzas.';

  @override
  String get teamRoleHintViewer =>
      'Un asesor solo puede leer y no puede registrar datos.';

  @override
  String teamMemberSelf(String name) {
    return '$name (tú)';
  }

  @override
  String get teamMemberUnknown => 'Miembro del equipo';

  @override
  String get teamMembersEmpty =>
      'Los miembros aparecerán cuando termine la sincronización.';

  @override
  String get teamInviteTitle => 'Invitar al equipo';

  @override
  String get teamInviteHint =>
      'Di o envía el código. Es válido durante 48 horas.';

  @override
  String get teamInviteGenerate => 'Generar código';

  @override
  String get teamInviteCopy => 'Copiar';

  @override
  String get teamInviteCopied => 'Código copiado.';

  @override
  String teamInviteCodeSemantics(String code) {
    return 'Código de invitación $code';
  }

  @override
  String get teamHaveCode => 'Tengo un código';

  @override
  String get teamJoinTitle => 'Unirse con un código';

  @override
  String get teamJoinHint =>
      'Introduce el código de 6 caracteres que te enviaron.';

  @override
  String get teamJoinCodeLabel => 'Código de invitación';

  @override
  String get teamJoinAction => 'Unirse';

  @override
  String get teamJoinDone => 'Te has unido al equipo.';

  @override
  String get teamErrorOffline =>
      'Esto necesita conexión a internet. Vuelve a intentarlo cuando tengas conexión.';

  @override
  String get teamErrorInvalidCode =>
      'El código no es válido, ha caducado o ya se usó.';

  @override
  String get teamErrorAlreadyMember => 'Ya eres miembro de este equipo.';

  @override
  String get teamErrorForbidden => 'No tienes permiso para hacer esto.';

  @override
  String get teamErrorOwnerLocked =>
      'El rol del titular no se puede cambiar y el titular no se puede quitar.';

  @override
  String get teamErrorUnknown =>
      'No ha funcionado. Vuelve a intentarlo en un momento.';

  @override
  String get teamRemoveAction => 'Quitar del equipo';

  @override
  String get teamRemoveTitle => '¿Quitar del equipo?';

  @override
  String teamRemoveMessage(String name) {
    return '$name perderá el acceso a los registros de esta explotación.';
  }

  @override
  String get teamRemoveConfirm => 'Quitar';

  @override
  String teamRemoved(String name) {
    return '$name ya no está en el equipo.';
  }

  @override
  String teamRoleChanged(String name, String role) {
    return '$name ahora es $role.';
  }

  @override
  String get teamActivityTitle => 'Actividad reciente';

  @override
  String get teamActivityEmpty => 'Aún no hay actividad.';

  @override
  String get teamActivitySelf => 'Tú';

  @override
  String teamActivityInspection(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'registró $count revisiones',
      one: 'registró 1 revisión',
    );
    return '$_temp0';
  }

  @override
  String teamActivityTreatment(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'trató $count colmenas',
      one: 'trató 1 colmena',
    );
    return '$_temp0';
  }

  @override
  String teamActivityFeeding(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'alimentó $count colmenas',
      one: 'alimentó 1 colmena',
    );
    return '$_temp0';
  }

  @override
  String teamActivityHarvest(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'registró $count cosechas',
      one: 'registró 1 cosecha',
    );
    return '$_temp0';
  }

  @override
  String teamActivityMiteCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'registró $count conteos de varroa',
      one: 'registró 1 conteo de varroa',
    );
    return '$_temp0';
  }

  @override
  String teamActivityTask(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'añadió $count tareas',
      one: 'añadió 1 tarea',
    );
    return '$_temp0';
  }

  @override
  String get teamActivityJustNow => 'ahora mismo';

  @override
  String teamActivityMinutesAgo(int count) {
    return 'hace $count min';
  }

  @override
  String teamActivityHoursAgo(int count) {
    return 'hace $count h';
  }

  @override
  String get teamActivityYesterday => 'ayer';

  @override
  String teamActivityDaysAgo(int count) {
    return 'hace $count días';
  }

  @override
  String teamActivityLine(String what, String where, String when) {
    return '$what$where · $when';
  }

  @override
  String teamActivitySemantics(
    String who,
    String what,
    String where,
    String when,
  ) {
    return '$who $what$where, $when';
  }

  @override
  String get settingsPush => 'Notificaciones de tareas';

  @override
  String get settingsPushHint =>
      'Recibe una notificación cuando te asignen una tarea. Tócala para abrir la tarea.';

  @override
  String get documentsTitle => 'Archivo de documentos';

  @override
  String get documentsAdd => 'Añadir documento';

  @override
  String documentsSummaryOffline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count documentos',
      one: '1 documento',
    );
    return '$_temp0 · todos disponibles sin conexión';
  }

  @override
  String documentsSummaryMissing(int count, int missing) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count documentos',
      one: '1 documento',
    );
    String _temp1 = intl.Intl.pluralLogic(
      missing,
      locale: localeName,
      other: '$missing archivos',
      one: '1 archivo',
    );
    return '$_temp0 · $_temp1 aún no está en este teléfono';
  }

  @override
  String get documentsRegionNoteTr =>
      'Los tipos de documento dependen del país. Fuera de Turquía creas tus propios tipos de documento.';

  @override
  String get documentsRegionNoteOther =>
      'Tú defines los tipos de documento; los que introduzcas se sugerirán la próxima vez.';

  @override
  String get documentsRoadCheck => 'Control en carretera · mostrar documentos';

  @override
  String get documentsEmptyTitle => 'Aún no hay documentos';

  @override
  String get documentsEmptyMessage =>
      'Añade una foto o un PDF de tus permisos y certificados. Se abren sin conexión y te avisamos antes de que caduquen.';

  @override
  String get documentsLoadError => 'No se pudieron abrir los documentos.';

  @override
  String get documentFileKindPhoto => 'FOTO';

  @override
  String get documentFileKindPdf => 'PDF';

  @override
  String get documentTypeHealthReport => 'Certificado sanitario';

  @override
  String get documentTypeTransportPermit => 'Permiso de transporte';

  @override
  String get documentTypeMigratoryCertificate => 'Certificado de trashumancia';

  @override
  String get documentTypeBusinessRegistration =>
      'Certificado de registro de la explotación';

  @override
  String get documentTypeLandPermit => 'Permiso del terreno';

  @override
  String get documentTypeAnalysisReport => 'Informe de análisis';

  @override
  String get documentExpiryNone => 'Sin caducidad';

  @override
  String get documentExpiryExpired => 'Caducado';

  @override
  String get documentExpiryToday => 'Vence hoy';

  @override
  String documentExpiryDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '1 día',
    );
    return '$_temp0';
  }

  @override
  String documentExpiryMonths(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months meses',
      one: '1 mes',
    );
    return '$_temp0';
  }

  @override
  String documentExpiresOn(String date) {
    return 'Válido hasta el $date';
  }

  @override
  String get documentFormNewTitle => 'Añadir documento';

  @override
  String get documentFormEditTitle => 'Editar documento';

  @override
  String get documentFormType => 'Tipo de documento';

  @override
  String get documentFormCustomTypeHint => 'p. ej. Póliza de seguro';

  @override
  String get documentFormName => 'Nombre';

  @override
  String get documentFormNameHint => 'p. ej. Certificado sanitario 2026';

  @override
  String get documentFormDescription => 'Descripción';

  @override
  String get documentFormDescriptionHint =>
      'p. ej. Oficina comarcal · 152 colmenas';

  @override
  String get documentFormExpiry => 'Válido hasta';

  @override
  String get documentFormNoExpiry => 'Sin caducidad';

  @override
  String get documentFormPickDate => 'Elegir fecha';

  @override
  String get documentFormExpiryHelper =>
      'Te avisaremos 30, 7 y 1 día antes de que caduque.';

  @override
  String get documentFormFile => 'Archivo';

  @override
  String get documentFormTakePhoto => 'Hacer foto';

  @override
  String get documentFormPickImage => 'De la galería';

  @override
  String get documentFormPickPdf => 'Elegir PDF';

  @override
  String get documentFormNoFile => 'Haz una foto del documento o elige su PDF.';

  @override
  String documentFileSizeKb(String size) {
    return '$size KB';
  }

  @override
  String documentFileSizeMb(String size) {
    return '$size MB';
  }

  @override
  String get documentFileTooLarge =>
      'El archivo pesa más de 20 MB; elige uno más pequeño.';

  @override
  String get documentFileFailed =>
      'No se pudo obtener el archivo, vuelve a intentarlo.';

  @override
  String get documentFilePermissionDenied =>
      'Permiso denegado. Para añadir un documento, permite el acceso a la cámara o a los archivos para esta app en Ajustes.';

  @override
  String get documentFormSave => 'Guardar';

  @override
  String get documentFormDelete => 'Eliminar documento';

  @override
  String get documentSaved => 'Documento guardado';

  @override
  String get documentReminderDenied =>
      'Documento guardado. Sin permiso de notificaciones no sonarán los avisos de caducidad.';

  @override
  String get documentDeleteTitle => '¿Eliminar este documento?';

  @override
  String get documentDeleteMessage =>
      'El documento y su archivo se eliminan de todos los teléfonos.';

  @override
  String get documentDeleteConfirm => 'Eliminar';

  @override
  String get documentDeleted => 'Documento eliminado';

  @override
  String get documentNotFound =>
      'Documento no encontrado; puede que se haya eliminado.';

  @override
  String get documentEdit => 'Editar';

  @override
  String get documentFileMissing =>
      'El archivo aún no está en este teléfono. Se descarga cuando tengas conexión.';

  @override
  String get documentPdfFailed => 'No se pudo abrir el PDF.';

  @override
  String documentPdfPage(int page, int count) {
    return 'Página $page de $count';
  }

  @override
  String get roadCheckTitle => 'Control en carretera';

  @override
  String roadCheckPosition(int index, int count) {
    return '$index / $count';
  }

  @override
  String get roadCheckSwipeHint =>
      'Desliza hacia el lado para ver el siguiente documento';

  @override
  String get roadCheckPrevious => 'Documento anterior';

  @override
  String get roadCheckNext => 'Documento siguiente';

  @override
  String documentReminderBody(int days, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '1 día',
    );
    return 'Caduca en $_temp0 · $date';
  }

  @override
  String get syncTableDocuments => 'Documento';

  @override
  String get migrationsTitle => 'Planes de trashumancia';

  @override
  String get migrationsAdd => 'Nuevo plan';

  @override
  String get migrationsEmptyTitle => 'Aún no hay plan de trashumancia';

  @override
  String get migrationsEmptyMessage =>
      'Planifica la ruta del año: fechas, número de colmenas y colmenar de destino de cada parada.';

  @override
  String get migrationsLoadError =>
      'No se pudieron abrir los planes de trashumancia';

  @override
  String migrationStopCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count paradas',
      one: '1 parada',
      zero: 'Sin paradas',
    );
    return '$_temp0';
  }

  @override
  String migrationTitle(String name, String year) {
    return '$name $year';
  }

  @override
  String get migrationNotFound => 'Plan de trashumancia no encontrado';

  @override
  String get migrationDocuments => 'Documentos';

  @override
  String get migrationEdit => 'Editar plan';

  @override
  String get migrationAddStop => 'Añadir parada';

  @override
  String get migrationNoStopsTitle => 'Aún no hay paradas';

  @override
  String get migrationNoStopsMessage =>
      'Añade las paradas de la ruta en orden: floración, lugar, fechas y número de colmenas.';

  @override
  String migrationNextMoveIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'en $days días',
      one: 'en 1 día',
      zero: 'hoy',
    );
    return 'Próximo traslado · $_temp0';
  }

  @override
  String migrationNextMoveLate(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días de retraso',
      one: '1 día de retraso',
    );
    return 'Próximo traslado · $_temp0';
  }

  @override
  String migrationRoute(String from, String to) {
    return '$from → $to';
  }

  @override
  String migrationDocReady(String document) {
    return '$document listo';
  }

  @override
  String migrationDocDays(String document, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '1 día',
      zero: 'caduca hoy',
    );
    return '$document $_temp0';
  }

  @override
  String migrationDocBeforeMove(String document) {
    return '$document caduca antes del traslado';
  }

  @override
  String migrationDocExpired(String document) {
    return '$document caducado';
  }

  @override
  String migrationDocMissing(String document) {
    return 'Falta $document';
  }

  @override
  String get migrationStopPast => 'Pasada';

  @override
  String get migrationStopCurrent => 'Aquí ahora';

  @override
  String get migrationStopPlanned => 'Prevista';

  @override
  String get migrationStopHere => 'Estás aquí';

  @override
  String migrationStopDates(String start, String end) {
    return '$start–$end';
  }

  @override
  String migrationYield(String year, String kg) {
    return '$year: $kg kg/colmena';
  }

  @override
  String migrationYields(String values) {
    return 'Rendimiento anterior · $values';
  }

  @override
  String get migrationNoYield => 'No hay cosechas anteriores en este colmenar';

  @override
  String get migrationFormNewTitle => 'Nuevo plan de trashumancia';

  @override
  String get migrationFormEditTitle => 'Editar plan de trashumancia';

  @override
  String get migrationFormYear => 'Año';

  @override
  String get migrationFormName => 'Nombre';

  @override
  String get migrationFormDefaultName => 'Plan de trashumancia';

  @override
  String get migrationFormSave => 'Guardar';

  @override
  String get migrationFormDelete => 'Eliminar plan';

  @override
  String get migrationDeleteTitle => '¿Eliminar el plan de trashumancia?';

  @override
  String get migrationDeleteMessage =>
      'Se eliminarán el plan y todas sus paradas.';

  @override
  String get migrationDeleteConfirm => 'Eliminar';

  @override
  String get migrationSaved => 'Plan guardado';

  @override
  String get migrationDeleted => 'Plan eliminado';

  @override
  String get stopFormNewTitle => 'Nueva parada';

  @override
  String get stopFormEditTitle => 'Editar parada';

  @override
  String get stopFormName => 'Floración';

  @override
  String get stopFormNameHint => 'p. ej. Azahar, Romero';

  @override
  String get stopFormPlace => 'Lugar';

  @override
  String get stopFormPlaceHint => 'p. ej. Valencia';

  @override
  String get stopFormStart => 'Inicio previsto';

  @override
  String get stopFormEnd => 'Fin previsto';

  @override
  String get stopFormApiary => 'Colmenar de destino';

  @override
  String get stopFormChooseApiary => 'Elegir colmenar de destino';

  @override
  String get stopFormNone => 'Ninguno';

  @override
  String get stopFormHiveCount => 'Colmenas';

  @override
  String get stopFormPosition => 'Orden en la ruta';

  @override
  String get stopFormStatus => 'Estado';

  @override
  String get stopFormDelete => 'Eliminar parada';

  @override
  String get stopDeleteTitle => '¿Eliminar la parada?';

  @override
  String get stopDeleteMessage => 'La parada se quitará del plan.';

  @override
  String get stopSaved => 'Parada guardada';

  @override
  String get stopDeleted => 'Parada eliminada';

  @override
  String get syncTableMigrations => 'Plan de trashumancia';

  @override
  String get syncTableMigrationStops => 'Parada de trashumancia';

  @override
  String get moveStart => 'Iniciar traslado';

  @override
  String moveTitle(String route) {
    return 'Traslado · $route';
  }

  @override
  String get moveNone => 'No hay traslados próximos';

  @override
  String get moreMigratory => 'Trashumancia';

  @override
  String get syncTableTransports => 'Traslado';

  @override
  String get syncTableTransportItems => 'Colmena trasladada';

  @override
  String get moveStepCheck => 'Revisión';

  @override
  String get moveStepLoad => 'Carga';

  @override
  String get moveStepUnload => 'Descarga';

  @override
  String moveStepDone(String step) {
    return '$step, hecho';
  }

  @override
  String get moveNoDestinationTitle => 'La parada no tiene colmenar';

  @override
  String get moveNoDestinationMessage =>
      'Elige un colmenar de destino para la parada, así la ubicación de las colmenas se actualiza tras la descarga.';

  @override
  String get moveEditStop => 'Editar parada';

  @override
  String get moveFrom => 'Desde';

  @override
  String get moveTo => 'Hasta';

  @override
  String moveSourceHives(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmenas activas',
      one: '1 colmena activa',
      zero: 'Sin colmenas activas',
    );
    return '$_temp0';
  }

  @override
  String get moveChecklist => 'Lista de carga';

  @override
  String get moveCheckEntrances => 'Piqueras cerradas';

  @override
  String get moveCheckVentilation => 'Ventilación abierta';

  @override
  String get moveCheckStraps => 'Cinchas apretadas';

  @override
  String get moveCheckWater => 'Agua preparada';

  @override
  String get moveVehicles => 'Vehículos';

  @override
  String moveVehicleDefault(int number) {
    return 'Camión $number';
  }

  @override
  String get moveAddVehicle => 'Añadir vehículo';

  @override
  String moveRemoveVehicle(String vehicle) {
    return 'Quitar $vehicle';
  }

  @override
  String get moveVehicleName => 'Nombre del vehículo';

  @override
  String get moveVehicleExists => 'Ya existe un vehículo con este nombre';

  @override
  String get moveStartLoading => 'Empezar la carga';

  @override
  String get moveChecklistHint =>
      'Marca todo lo de la lista para empezar la carga.';

  @override
  String moveVehicleCount(String vehicle, int count) {
    return '$vehicle · $count';
  }

  @override
  String get moveLoaded => 'Cargadas';

  @override
  String get moveUnloaded => 'Descargadas';

  @override
  String moveCountTotal(int total) {
    return '/ $total';
  }

  @override
  String moveCountLabel(int count, int total) {
    return '$count de $total colmenas';
  }

  @override
  String moveLastScanned(String number) {
    return 'Último escaneo: $number';
  }

  @override
  String moveNotScanned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmenas sin escanear',
      one: '1 colmena sin escanear',
    );
    return '$_temp0';
  }

  @override
  String get moveAllScanned => 'Todas escaneadas';

  @override
  String get moveShowList => 'Ver lista';

  @override
  String get moveMissingTitle => 'Colmenas sin escanear';

  @override
  String get moveLoadingHint =>
      'Volverás a escanear al descargar en el destino; te avisaré si falta alguna colmena. La ubicación de las colmenas se actualiza tras la descarga.';

  @override
  String moveUnloadingHint(String destination) {
    return 'Escanea de nuevo cada colmena al descargarla. Al terminar, las colmenas descargadas pasan a $destination.';
  }

  @override
  String get moveEnterNumber => 'Introducir número';

  @override
  String get moveHiveNumber => 'Número de colmena';

  @override
  String moveNumberNotFound(String number) {
    return 'No hay ninguna colmena con el número $number';
  }

  @override
  String get moveScanStart => 'Empezar a escanear';

  @override
  String get moveScanContinue => 'Seguir escaneando';

  @override
  String get moveToUnloading => 'Ir a la descarga';

  @override
  String moveToUnloadingTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmenas sin escanear',
      one: '1 colmena sin escanear',
    );
    return '$_temp0';
  }

  @override
  String get moveToUnloadingMessage =>
      'Las colmenas sin escanear quedan fuera de este traslado y se quedan donde están.';

  @override
  String get moveFinish => 'Terminar traslado';

  @override
  String moveFinishTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmenas sin descargar',
      one: '1 colmena sin descargar',
    );
    return '$_temp0';
  }

  @override
  String moveFinishMessage(String source) {
    return 'Las colmenas sin descargar mantienen su ubicación en $source. La lista de faltantes queda en el traslado.';
  }

  @override
  String get moveFinishConfirm => 'Terminar';

  @override
  String get moveDoneTitle => 'Traslado terminado';

  @override
  String moveDoneSummary(int loaded, int unloaded) {
    return 'Cargadas $loaded · Descargadas $unloaded';
  }

  @override
  String moveDoneMoved(int count, String destination) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmenas trasladadas a $destination.',
      one: '1 colmena trasladada a $destination.',
      zero: 'No se trasladó ninguna colmena.',
    );
    return '$_temp0';
  }

  @override
  String get moveDoneMissing => 'Colmenas sin descargar';

  @override
  String moveScanLoaded(String number, String vehicle) {
    return '$number cargada · $vehicle';
  }

  @override
  String moveScanLoadedOther(String number) {
    return '$number cargada; esta colmena no estaba en este colmenar';
  }

  @override
  String moveScanAlreadyLoaded(String number) {
    return '$number ya está cargada';
  }

  @override
  String moveScanUnloaded(String number) {
    return '$number descargada';
  }

  @override
  String moveScanAlreadyUnloaded(String number) {
    return '$number ya está descargada';
  }

  @override
  String moveScanNotLoaded(String number) {
    return '$number no se cargó en este traslado';
  }

  @override
  String get moveScanUnknown => 'Etiqueta desconocida';

  @override
  String get moveScanDone => 'Hecho';

  @override
  String get inventoryTitle => 'Material y existencias';

  @override
  String get inventoryAdd => 'Añadir artículo';

  @override
  String get inventoryEmptyTitle => 'Aún no hay artículos';

  @override
  String get inventoryEmptyMessage =>
      'Añade material como azúcar, cera estampada y tarros. Los artículos por debajo de su mínimo se marcan.';

  @override
  String get inventoryCategoryEmpty => 'No hay artículos en esta categoría';

  @override
  String get inventoryLoadError => 'No se pudieron abrir las existencias.';

  @override
  String get inventoryNotFound => 'Artículo no encontrado';

  @override
  String get inventoryCategoryConsumable => 'Consumibles';

  @override
  String get inventoryCategoryEquipment => 'Equipo';

  @override
  String get inventoryCategoryComb => 'Panales';

  @override
  String get inventoryUnitKg => 'kg';

  @override
  String get inventoryUnitLiter => 'L';

  @override
  String get inventoryUnitPiece => 'uds.';

  @override
  String get inventoryUnitRoll => 'rollos';

  @override
  String get inventoryUnitPack => 'paq.';

  @override
  String get inventoryUnitNameKg => 'Kilogramo';

  @override
  String get inventoryUnitNameLiter => 'Litro';

  @override
  String get inventoryUnitNamePiece => 'Unidad';

  @override
  String get inventoryUnitNameRoll => 'Rollo';

  @override
  String get inventoryUnitNamePack => 'Paquete';

  @override
  String inventoryQuantity(String quantity, String unit) {
    return '$quantity $unit';
  }

  @override
  String inventoryBelowThreshold(String threshold) {
    return 'Por debajo del mínimo · al menos $threshold';
  }

  @override
  String get inventoryMoveIn => 'Entrada';

  @override
  String get inventoryMoveOut => 'Salida';

  @override
  String get inventoryMoveCount => 'Recuento';

  @override
  String get inventoryMoveAdjustment => 'Corrección';

  @override
  String inventoryInStock(String quantity) {
    return 'En existencias: $quantity';
  }

  @override
  String inventoryAmountLabel(String unit) {
    return 'Cantidad ($unit)';
  }

  @override
  String inventoryCountedLabel(String unit) {
    return 'Cantidad contada ($unit)';
  }

  @override
  String get inventoryAmountInvalid => 'Introduce una cantidad válida';

  @override
  String get inventoryAmountWhole => 'Usa un número entero para esta unidad';

  @override
  String get inventorySaveIn => 'Añadir a existencias';

  @override
  String get inventorySaveOut => 'Restar de existencias';

  @override
  String get inventorySaveCount => 'Corregir existencias';

  @override
  String inventoryMovedIn(String quantity) {
    return '$quantity añadido';
  }

  @override
  String inventoryMovedOut(String quantity) {
    return '$quantity restado';
  }

  @override
  String inventoryAdjusted(String quantity) {
    return 'Existencias ahora: $quantity';
  }

  @override
  String inventoryUnchanged(String quantity) {
    return 'Las existencias ya son $quantity';
  }

  @override
  String get inventoryDetails => 'Detalles e historial';

  @override
  String get inventoryHistory => 'Historial';

  @override
  String get inventoryHistoryEmpty => 'Aún sin movimientos';

  @override
  String inventoryThreshold(String threshold) {
    return 'Mínimo: al menos $threshold';
  }

  @override
  String get inventoryNoThreshold => 'Sin mínimo';

  @override
  String get inventoryQuickMove => 'Añadir / restar';

  @override
  String get inventoryEdit => 'Editar artículo';

  @override
  String get inventoryFormNewTitle => 'Nuevo artículo';

  @override
  String get inventoryFormEditTitle => 'Editar artículo';

  @override
  String get inventoryFormName => 'Nombre';

  @override
  String get inventoryFormCategory => 'Categoría';

  @override
  String get inventoryFormUnit => 'Unidad';

  @override
  String get inventoryFormLocation => 'Ubicación';

  @override
  String get inventoryFormLocationHint => 'Almacén, camión, oficina… Opcional.';

  @override
  String get inventoryFormThreshold => 'Mínimo';

  @override
  String get inventoryFormThresholdHint =>
      'Te avisamos cuando las existencias bajen de aquí. Opcional.';

  @override
  String get inventoryFormThresholdInvalid => 'Introduce un mínimo válido';

  @override
  String get inventoryFormSave => 'Guardar';

  @override
  String get inventoryFormDelete => 'Eliminar artículo';

  @override
  String get inventoryDeleteTitle => '¿Eliminar este artículo?';

  @override
  String get inventoryDeleteMessage =>
      'El artículo y sus existencias salen de la lista.';

  @override
  String get inventoryDeleteConfirm => 'Eliminar';

  @override
  String get inventorySaved => 'Artículo guardado';

  @override
  String get inventoryDeleted => 'Artículo eliminado';

  @override
  String get syncTableInventoryItems => 'Artículo de existencias';

  @override
  String get syncTableInventoryMoves => 'Movimiento de existencias';

  @override
  String inventoryIncrease(String quantity) {
    return '+$quantity';
  }

  @override
  String inventoryFormThresholdUnit(String unit) {
    return 'Mínimo ($unit)';
  }

  @override
  String get stockUseTitle => 'Restar de existencias';

  @override
  String get stockUseNone => 'No restar';

  @override
  String stockUseValue(String item, String quantity) {
    return '$item · −$quantity';
  }

  @override
  String get stockUseChoose => '¿De qué artículo restar?';

  @override
  String get taskFormTreatment => 'Tratamiento previsto';

  @override
  String get taskFormTreatmentUnknown => 'Medicamento fuera de la lista';

  @override
  String get taskFormTreatmentNeedsApiary =>
      'Elige un colmenar para el tratamiento previsto';

  @override
  String taskTreatmentPlanTitle(String drug) {
    return 'Tratamiento · $drug';
  }

  @override
  String get shoppingTitle => 'Lista de compras';

  @override
  String shoppingCardTitle(int count) {
    return 'Lista de compras · $count';
  }

  @override
  String get shoppingEmptyTitle => 'Nada que comprar';

  @override
  String get shoppingEmptyMessage =>
      'Aquí aparecen los artículos por debajo de su mínimo y lo que necesitan los tratamientos previstos.';

  @override
  String get shoppingShare => 'Compartir';

  @override
  String get shoppingLoadError => 'No se pudo abrir la lista de compras';

  @override
  String shoppingReasonThreshold(String stock, String threshold) {
    return '$stock en existencias · mín. $threshold';
  }

  @override
  String shoppingReasonPlanned(String quantity) {
    return 'Tratamientos previstos $quantity';
  }

  @override
  String get shoppingReasonNoItem =>
      'Tratamiento previsto · sin artículo en existencias';

  @override
  String shoppingShareLine(String name, String quantity) {
    return '• $name: $quantity';
  }

  @override
  String get moreRearing => 'Cría de reinas';

  @override
  String get rearingTitle => 'Cría de reinas';

  @override
  String rearingBatchName(int number) {
    return 'Serie $number';
  }

  @override
  String rearingBatchTitle(int number) {
    return 'Cría de reinas · Serie $number';
  }

  @override
  String get rearingAdd => 'Añadir serie';

  @override
  String get rearingEmptyTitle => 'Aún no hay series';

  @override
  String get rearingEmptyMessage =>
      'Indica el día del traslarve; el calendario desde la aceptación hasta el control de puesta y sus recordatorios se crean solos.';

  @override
  String get rearingLoadError => 'No se pudieron cargar las series';

  @override
  String get rearingNotFound => 'Serie no encontrada';

  @override
  String rearingListGrafted(String date) {
    return 'traslarvada el $date';
  }

  @override
  String get rearingEdit => 'Editar serie';

  @override
  String get rearingGraftedLabel => 'Traslarvadas';

  @override
  String get rearingAcceptedLabel => 'Aceptadas';

  @override
  String get rearingNucsLabel => 'Núcleos';

  @override
  String get rearingNotCounted => 'Sin contar';

  @override
  String rearingAcceptedPercent(int percent) {
    return '$percent %';
  }

  @override
  String rearingMotherLine(String mother, String date) {
    return 'Madre: $mother · traslarvada el $date';
  }

  @override
  String rearingMotherUnknownLine(String date) {
    return 'Madre desconocida · traslarvada el $date';
  }

  @override
  String rearingDay(int day) {
    return 'D$day';
  }

  @override
  String get rearingToday => 'Hoy';

  @override
  String get rearingStepGraft => 'Traslarve';

  @override
  String get rearingStepAcceptance => 'Control de aceptación';

  @override
  String get rearingStepCapped => 'Celdas operculadas';

  @override
  String get rearingStepDistribution => 'Repartir celdas';

  @override
  String get rearingStepEmergence => 'Nacimiento de reinas';

  @override
  String get rearingStepLayingCheck => 'Control de puesta';

  @override
  String rearingStepGraftDetail(int count) {
    return '$count larvas';
  }

  @override
  String rearingStepAcceptanceDetail(int count) {
    return '$count celdas aceptadas';
  }

  @override
  String get rearingStepAcceptanceTodo => 'Cuenta las celdas aceptadas';

  @override
  String get rearingStepCappedDetail => 'No molestar';

  @override
  String rearingStepDistributionDetail(int count) {
    return 'Antes del nacimiento, a $count núcleos';
  }

  @override
  String get rearingStepDistributionTodo =>
      'Antes del nacimiento, a los núcleos';

  @override
  String get rearingStepEmergenceDetail => 'Revisa los núcleos';

  @override
  String get rearingStepLayingCheckDetail => 'Anota el éxito de la fecundación';

  @override
  String get rearingStepDone => 'hecho';

  @override
  String get rearingStepCurrent => 'siguiente';

  @override
  String get rearingStepUpcoming => 'próximo';

  @override
  String get rearingDistribute => 'Repartir celdas en núcleos';

  @override
  String get rearingDistributeApiary => 'Colmenar';

  @override
  String get rearingDistributeCount => 'Núcleos';

  @override
  String rearingDistributePlan(int reused, int created) {
    return 'Núcleos vacíos reutilizados: $reused · Núcleos nuevos: $created';
  }

  @override
  String get rearingDistributeSave => 'Repartir';

  @override
  String get rearingDistributeNoApiary => 'Añade primero un colmenar';

  @override
  String rearingDistributed(int count) {
    return 'Repartidas en $count núcleos';
  }

  @override
  String get rearingNucsSection => 'Núcleos de fecundación';

  @override
  String rearingNucTitle(String number) {
    return 'Núcleo $number';
  }

  @override
  String get matingNucStatusEmpty => 'Vacío';

  @override
  String get matingNucStatusCell => 'Celda';

  @override
  String get matingNucStatusVirgin => 'Reina virgen';

  @override
  String get matingNucStatusLaying => 'En puesta';

  @override
  String get matingNucStatusFailed => 'Fallido';

  @override
  String get matingNucStatusGiven => 'Dado a una colmena';

  @override
  String get rearingNucGive => 'Dar a una colmena';

  @override
  String get rearingNucChooseHive => '¿Qué colmena?';

  @override
  String get rearingNucNoHives => 'No hay colmenas activas';

  @override
  String get rearingFormNewTitle => 'Nueva serie';

  @override
  String get rearingFormEditTitle => 'Editar serie';

  @override
  String get rearingFormGraftedOn => 'Día del traslarve';

  @override
  String get rearingFormGraftedCount => 'Larvas traslarvadas';

  @override
  String get rearingFormAcceptedCount => 'Celdas aceptadas';

  @override
  String get rearingFormAcceptedClear => 'Aún sin contar';

  @override
  String get rearingFormScheduleHint =>
      'La aceptación, el operculado, el reparto, el nacimiento y el control de puesta se añaden como tareas con recordatorio.';

  @override
  String get rearingFormSave => 'Guardar';

  @override
  String get rearingFormDelete => 'Eliminar serie';

  @override
  String get rearingDeleteTitle => '¿Eliminar la serie?';

  @override
  String get rearingDeleteMessage =>
      'También se eliminan sus tareas. Los núcleos y las reinas entregadas se mantienen.';

  @override
  String get rearingDeleteConfirm => 'Eliminar';

  @override
  String get rearingDeleted => 'Serie eliminada';

  @override
  String get rearingSaved => 'Serie guardada';

  @override
  String get taskSourceQueenRearing => 'cría de reinas';

  @override
  String get syncTableQueenRearingBatches => 'Serie de cría de reinas';

  @override
  String get syncTableMatingNucs => 'Núcleo de fecundación';

  @override
  String get lotsTitle => 'Cosecha y lotes';

  @override
  String get lotsEmptyTitle => 'Aún no hay lotes';

  @override
  String get lotsEmptyMessage =>
      'Añade una cosecha a un lote después de guardarla; los lotes aparecen aquí.';

  @override
  String get lotsLoadError => 'No se pudieron cargar los lotes';

  @override
  String get lotsInStock => 'En existencias';

  @override
  String get lotsPerHive => 'Por colmena';

  @override
  String lotNumber(String number) {
    return 'Lote $number';
  }

  @override
  String lotHoneyTitle(String kind) {
    return 'Miel · $kind';
  }

  @override
  String get lotStatusOpen => 'Abierto';

  @override
  String get lotStatusClosed => 'Cerrado';

  @override
  String get lotWithdrawalBadge => 'En tiempo de espera';

  @override
  String lotMoistureValue(String value) {
    return 'Humedad $value %';
  }

  @override
  String get lotAnalyzed => 'Analizado ✓';

  @override
  String get lotAnalysisPending => 'Análisis pendiente';

  @override
  String lotStockValue(String weight) {
    return 'Existencias $weight';
  }

  @override
  String get lotNotFound => 'Lote no encontrado';

  @override
  String get lotEdit => 'Editar lote';

  @override
  String lotWithdrawalTitle(String hives) {
    return '$hives cosechadas durante el tiempo de espera.';
  }

  @override
  String get lotWithdrawalMessage =>
      'Este lote puede contener residuos de medicamentos; hazlo analizar antes de venderlo.';

  @override
  String get lotStock => 'Existencias';

  @override
  String get lotHarvested => 'Cosechado';

  @override
  String get lotSold => 'Vendido';

  @override
  String get lotInStock => 'En existencias';

  @override
  String get lotSell => 'Registrar una venta';

  @override
  String get lotAnalyses => 'Análisis';

  @override
  String get lotAnalysesEmpty => 'Aún no hay análisis';

  @override
  String get lotAddAnalysis => 'Añadir análisis';

  @override
  String get lotHarvests => 'Cosechas';

  @override
  String get lotHarvestsEmpty => 'No hay cosechas en este lote';

  @override
  String get lotTreatments => 'Último tratamiento de las colmenas';

  @override
  String get lotTreatmentsEmpty =>
      'No hay tratamientos registrados para las colmenas de este lote';

  @override
  String lotTreatmentTitle(String hive, String product) {
    return 'Colmena $hive · $product';
  }

  @override
  String lotTreatmentDetail(String date, String end) {
    return '$date · la espera termina el $end';
  }

  @override
  String get lotPublicPage => 'Página pública';

  @override
  String get lotPublish => 'Publicar';

  @override
  String get lotPublishHint =>
      'Quien escanee el QR verá la página del lote. Nunca se muestran el teléfono, la dirección ni la ubicación.';

  @override
  String get lotPublishOwnerOnly =>
      'Solo el titular de la explotación puede publicar.';

  @override
  String get lotPublished => 'Publicado';

  @override
  String get lotNotPublished => 'No publicado';

  @override
  String get lotPublicFields => 'Se muestra en la página';

  @override
  String get lotPublicProducer =>
      'Nombre de la explotación y número de colmenas';

  @override
  String get lotPublicOrigin => 'Origen y mes de cosecha';

  @override
  String get lotPublicLab => 'Valores del análisis';

  @override
  String get lotPublicReport => 'Informe del análisis';

  @override
  String get lotJarLabels => 'Etiquetas para tarros (QR)';

  @override
  String get lotJarLabelsHint =>
      '24 etiquetas por página A4 (70 × 37 mm); imprime a escala 100 %.';

  @override
  String lotJarLabelsDocumentName(String number) {
    return 'Etiquetas de tarros - $number';
  }

  @override
  String get lotSales => 'Ventas';

  @override
  String get lotSalesEmpty => 'Aún no hay ventas registradas';

  @override
  String lotSaleValue(String weight) {
    return '−$weight';
  }

  @override
  String lotSaleAmount(String unit) {
    return 'Miel vendida ($unit)';
  }

  @override
  String lotSaleTooMuch(String weight) {
    return 'Solo hay $weight en existencias';
  }

  @override
  String get lotSaleSave => 'Restar de existencias';

  @override
  String lotSaleSaved(String weight) {
    return 'Venta de $weight registrada';
  }

  @override
  String get lotOrigin => 'Origen';

  @override
  String get lotOriginHint => 'p. ej. Pinar de montaña';

  @override
  String get lotMoisture => 'Humedad %';

  @override
  String get lotMoistureHelper => 'Lectura del refractómetro; opcional';

  @override
  String get lotMoistureInvalid =>
      'Introduce un valor entre 10 y 30, como 17,2';

  @override
  String lotEditTitle(String lot) {
    return 'Editar $lot';
  }

  @override
  String get lotStatus => 'Estado';

  @override
  String get lotStatusHelper => 'Los lotes cerrados no admiten cosechas nuevas';

  @override
  String get lotSave => 'Guardar';

  @override
  String get lotDelete => 'Eliminar lote';

  @override
  String lotDeleteTitle(String lot) {
    return '¿Eliminar $lot?';
  }

  @override
  String get lotDeleteMessage =>
      'También se eliminan los análisis y las ventas; las cosechas se mantienen.';

  @override
  String get lotDeleted => 'Lote eliminado';

  @override
  String labTitle(String lot) {
    return 'Análisis · $lot';
  }

  @override
  String get labDate => 'Fecha del análisis';

  @override
  String get labHmf => 'HMF (mg/kg)';

  @override
  String get labDiastase => 'Índice de diastasa';

  @override
  String get labProline => 'Prolina (mg/kg)';

  @override
  String labHmfValue(String value) {
    return 'HMF $value';
  }

  @override
  String labDiastaseValue(String value) {
    return 'Diastasa $value';
  }

  @override
  String labProlineValue(String value) {
    return 'Prolina $value';
  }

  @override
  String labValueInvalid(String min, String max) {
    return 'Introduce un valor entre $min y $max';
  }

  @override
  String get labResidue => 'Residuos';

  @override
  String get labResidueNone => 'Sin residuos';

  @override
  String get labResidueDetected => 'Residuos detectados';

  @override
  String get labReport => 'Informe';

  @override
  String get labReportNone => 'Sin informe';

  @override
  String get labReportEmpty =>
      'No hay informes de análisis en el archivo de documentos';

  @override
  String get labReportAdd => 'Añadir informe al archivo de documentos';

  @override
  String get labSave => 'Guardar análisis';

  @override
  String get labSaved => 'Análisis guardado';

  @override
  String get harvestLotTitle => 'Añadir a un lote';

  @override
  String harvestLotSaved(String weight, String kind) {
    return 'Cosecha guardada: $weight $kind';
  }

  @override
  String get harvestLotIntro =>
      'Cuando la miel entra en un lote, se vinculan a él las fechas del último tratamiento de las colmenas.';

  @override
  String get harvestLotNew => 'Nuevo lote';

  @override
  String harvestLotNewHint(String kind) {
    return '$kind · número asignado automáticamente';
  }

  @override
  String get harvestLotCreate => 'Crear lote';

  @override
  String get harvestLotAdd => 'Añadir al lote';

  @override
  String get harvestLotSkip => 'Omitir por ahora';

  @override
  String harvestLotCreated(String lot) {
    return '$lot creado';
  }

  @override
  String harvestLotAdded(String lot) {
    return 'Cosecha añadida a $lot';
  }

  @override
  String get harvestLotGone => 'Se deshizo la cosecha';

  @override
  String get harvestLotBack => 'Volver al colmenar';

  @override
  String get syncTableLots => 'Lote';

  @override
  String get syncTableLotHarvests => 'Cosecha del lote';

  @override
  String get syncTableLotTreatments => 'Tratamiento del lote';

  @override
  String get syncTableLabResults => 'Resultado de laboratorio';

  @override
  String get syncTableLotSales => 'Venta del lote';

  @override
  String get harvestLotGoneMessage =>
      'La cosecha no se añadió a ningún lote. Puedes volver a registrarla desde el colmenar.';

  @override
  String get financeTitle => 'Finanzas';

  @override
  String financeYearTitle(String year) {
    return 'Finanzas · $year';
  }

  @override
  String get financeSeasonNet => 'Resultado de la temporada';

  @override
  String get financeIncome => 'Ingresos';

  @override
  String get financeExpense => 'Gastos';

  @override
  String get financeCostPerHive => 'Coste/colmena';

  @override
  String get financeRecent => 'Últimos movimientos';

  @override
  String get financeEmptyTitle => 'Aún no hay movimientos';

  @override
  String get financeEmptyMessage =>
      'Registra ingresos y gastos con los botones de abajo; aquí se calcula el resultado de la temporada.';

  @override
  String get financeLoadError => 'No se pudieron cargar los movimientos';

  @override
  String get financeAddIncome => '+ Ingreso';

  @override
  String get financeAddExpense => '− Gasto';

  @override
  String financePlus(String amount) {
    return '+$amount';
  }

  @override
  String financeMinus(String amount) {
    return '−$amount';
  }

  @override
  String get financeReceiptAttached => 'recibo adjunto';

  @override
  String financeTransportRoute(String from, String to) {
    return '$from → $to';
  }

  @override
  String get financeFormIncomeTitle => 'Añadir ingreso';

  @override
  String get financeFormExpenseTitle => 'Añadir gasto';

  @override
  String financeFormAmount(String currency) {
    return 'Importe ($currency)';
  }

  @override
  String get financeFormAmountInvalid =>
      'Introduce un importe mayor que 0, como 17500 o 17,50';

  @override
  String get financeFormCategory => 'Categoría';

  @override
  String get financeFormDate => 'Fecha';

  @override
  String get financeFormDescription => 'Descripción';

  @override
  String get financeFormDescriptionHint => 'p. ej. Azúcar 500 kg';

  @override
  String get financeFormReceipt => 'Recibo / factura';

  @override
  String get financeFormNoReceipt => 'Sin recibo';

  @override
  String get financeFormReceiptAdded => 'Foto del recibo añadida';

  @override
  String get financeFormTakePhoto => 'Hacer foto';

  @override
  String get financeFormPickImage => 'De la galería';

  @override
  String get financeFormRemoveReceipt => 'Quitar recibo';

  @override
  String get financeFormPhotoDenied =>
      'Permiso denegado. Para añadir un recibo, permite el acceso a la cámara o a las fotos para esta app en Ajustes.';

  @override
  String get financeFormPhotoFailed =>
      'No se pudo obtener la foto, vuelve a intentarlo.';

  @override
  String get financeFormLinks => 'Registro vinculado';

  @override
  String get financeFormApiary => 'Colmenar';

  @override
  String get financeFormLot => 'Lote';

  @override
  String get financeFormTransport => 'Traslado';

  @override
  String get financeFormNone => 'Ninguno';

  @override
  String get financeFormChooseApiary => 'Elegir colmenar';

  @override
  String get financeFormChooseLot => 'Elegir lote';

  @override
  String get financeFormChooseTransport => 'Elegir traslado';

  @override
  String get financeFormNoLots => 'Aún no hay lotes';

  @override
  String get financeFormNoTransports => 'Aún no hay traslados';

  @override
  String financeFormSaleAmount(String unit) {
    return 'Miel vendida ($unit)';
  }

  @override
  String get financeFormSaleHelper =>
      'Se resta de las existencias del lote; déjalo vacío para no cambiarlas';

  @override
  String get financeFormSave => 'Guardar';

  @override
  String get financeIncomeSaved => 'Ingreso guardado';

  @override
  String get financeExpenseSaved => 'Gasto guardado';

  @override
  String get financeNotFound => 'Movimiento no encontrado';

  @override
  String get financeReceiptPending =>
      'El recibo aún no ha llegado a este teléfono';

  @override
  String get financeDelete => 'Eliminar movimiento';

  @override
  String get financeDeleteTitle => '¿Eliminar este movimiento?';

  @override
  String get financeDeleteMessage =>
      'Si está vinculado a una venta de un lote, la venta también se elimina y las existencias vuelven.';

  @override
  String get financeDeleteConfirm => 'Eliminar';

  @override
  String get financeDeleted => 'Movimiento eliminado';

  @override
  String get financeCategoryFeeding => 'Alimentación';

  @override
  String get financeCategoryTreatment => 'Medicamentos';

  @override
  String get financeCategoryEquipment => 'Equipo';

  @override
  String get financeCategoryFuelTransport => 'Combustible / transporte';

  @override
  String get financeCategoryLandRent => 'Alquiler de terreno';

  @override
  String get financeCategoryLabor => 'Mano de obra';

  @override
  String get financeCategoryLabAnalysis => 'Análisis de laboratorio';

  @override
  String get financeCategoryHoney => 'Miel';

  @override
  String get financeCategoryPollen => 'Polen';

  @override
  String get financeCategoryPropolis => 'Propóleo';

  @override
  String get financeCategoryWax => 'Cera';

  @override
  String get financeCategoryNucs => 'Núcleos';

  @override
  String get financeCategoryQueens => 'Reinas';

  @override
  String get financeCategoryOther => 'Otros';

  @override
  String get syncTableTransactions => 'Ingreso/gasto';

  @override
  String get customersTitle => 'Libro de clientes';

  @override
  String get customersAdd => 'Añadir cliente';

  @override
  String get customersEmptyTitle => 'Aún no hay clientes';

  @override
  String get customersEmptyMessage =>
      'Añade clientes para seguir sus pedidos y lo que te deben.';

  @override
  String customerReceivableValue(String amount) {
    return 'Debe $amount';
  }

  @override
  String get customerNoReceivable => 'No debe nada';

  @override
  String get customerNotFound => 'Cliente no encontrado';

  @override
  String get customerEdit => 'Editar cliente';

  @override
  String get customerAddSale => 'Añadir venta';

  @override
  String get customerOrders => 'Pedidos';

  @override
  String get customerNoOrders => 'Aún no hay ventas a este cliente.';

  @override
  String get customerPaid => 'Pagado';

  @override
  String customerRemaining(String amount) {
    return 'Quedan $amount';
  }

  @override
  String get customerPaidAmount => 'Pagado hasta ahora';

  @override
  String get customerMarkPaid => 'Marcar como pagado';

  @override
  String get customerMarkedPaid => 'Marcado como pagado';

  @override
  String get customerAddPayment => 'Registrar pago';

  @override
  String get customerSendWhatsApp => 'Enviar por WhatsApp';

  @override
  String get customerWhatsAppNoPhone =>
      'Sin teléfono; elige el contacto en WhatsApp';

  @override
  String get customerWhatsAppFailed => 'No se pudo abrir WhatsApp';

  @override
  String get customerOpenTransaction => 'Abrir movimiento';

  @override
  String customerWhatsAppGreeting(String name) {
    return 'Hola, $name:';
  }

  @override
  String get customerWhatsAppIntro => 'Resumen de tu pedido:';

  @override
  String customerWhatsAppAmount(String amount) {
    return 'Total: $amount';
  }

  @override
  String customerWhatsAppPaid(String amount) {
    return 'Pagado: $amount';
  }

  @override
  String customerWhatsAppRemaining(String amount) {
    return 'Pendiente: $amount';
  }

  @override
  String get customerWhatsAppPaidInFull => 'Pagado por completo, gracias.';

  @override
  String customerWhatsAppAddress(String address) {
    return 'Dirección de envío: $address';
  }

  @override
  String get customerFormNewTitle => 'Nuevo cliente';

  @override
  String get customerFormEditTitle => 'Editar cliente';

  @override
  String get customerFormName => 'Nombre';

  @override
  String get customerFormPhone => 'Teléfono';

  @override
  String get customerFormPhoneHelper => 'Para WhatsApp, p. ej. +34 612 345 678';

  @override
  String get customerFormAddress => 'Dirección de envío';

  @override
  String get customerFormNotes => 'Nota';

  @override
  String get customerFormSave => 'Guardar';

  @override
  String get customerSaved => 'Cliente guardado';

  @override
  String get customerDelete => 'Eliminar cliente';

  @override
  String get customerDeleteTitle => '¿Eliminar cliente?';

  @override
  String get customerDeleteMessage =>
      'Sus ventas se mantienen en tus ingresos.';

  @override
  String get customerDeleteConfirm => 'Eliminar';

  @override
  String get customerDeleted => 'Cliente eliminado';

  @override
  String get customerPaymentSave => 'Guardar pago';

  @override
  String get customerPaymentSaved => 'Pago guardado';

  @override
  String customerPaymentTooMuch(String amount) {
    return 'Solo quedan $amount.';
  }

  @override
  String get financeFormCustomer => 'Cliente';

  @override
  String get financeFormChooseCustomer => 'Elegir cliente';

  @override
  String get financeFormNoCustomers => 'Aún no hay clientes';

  @override
  String get financeFormPaidNow => 'Pagado ahora';

  @override
  String get financeFormPaidNowHelper =>
      'Déjalo vacío si se debe el importe completo.';

  @override
  String get financeFormPaidTooMuch => 'No puede superar el importe.';

  @override
  String get financeProfitTitle => 'Beneficio por colmenar';

  @override
  String get financeProfitUnknownApiary => 'Colmenar eliminado';

  @override
  String financeReceivables(String amount, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count clientes',
      one: '1 cliente',
    );
    return 'Se deben $amount · $_temp0';
  }

  @override
  String get syncTableCustomers => 'Cliente';

  @override
  String get syncTableCustomerPayments => 'Pago';

  @override
  String get customerUnpaid => 'Sin pagar';

  @override
  String customerPartiallyPaid(String paid, String remaining) {
    return '$paid pagado, quedan $remaining';
  }

  @override
  String get taskAksUpdateTitle => 'No olvides actualizar el AKS';

  @override
  String get taskSourceAks => 'AKS';

  @override
  String get syncTableRefSupportPeriods => 'Periodo de ayudas';

  @override
  String get subsidiesTitle => 'Ayudas';

  @override
  String get subsidiesCheckTitle => 'Antes de solicitar';

  @override
  String get subsidiesActiveHives => 'Colmenas activas en la app';

  @override
  String get subsidiesDeclaredHives => 'Declaradas en el AKS';

  @override
  String get subsidiesNotDeclared => 'Sin indicar';

  @override
  String get subsidiesCheckNotDeclared =>
      'Introduce el número de colmenas que declaraste en el AKS; se compara con la app antes de solicitar.';

  @override
  String subsidiesCheckDiffers(String active, String declared) {
    return 'La app tiene $active colmenas activas, pero en el AKS hay $declared declaradas. Actualiza tu registro del AKS antes de solicitar.';
  }

  @override
  String get subsidiesCheckMatches =>
      'Los números coinciden: la app y el AKS cuadran.';

  @override
  String get subsidiesEditDeclared => 'Introducir número declarado';

  @override
  String get subsidiesDeclaredOwnerOnly =>
      'Solo el titular puede introducir el número declarado.';

  @override
  String get subsidiesPeriodsTitle => 'Periodos de solicitud';

  @override
  String get subsidiesEmptyTitle => 'Aún no hay periodos de ayudas';

  @override
  String get subsidiesEmptyMessage =>
      'Los periodos de solicitud aparecen aquí cuando se anuncian; recibirás una notificación cuando se abra uno.';

  @override
  String get subsidiesPhaseOpen => 'Abierto';

  @override
  String get subsidiesPhaseUpcoming => 'Próximo';

  @override
  String get subsidiesPhaseClosed => 'Cerrado';

  @override
  String subsidiesPeriodDates(String start, String end) {
    return '$start – $end';
  }

  @override
  String get subsidiesOpenSource => 'Abrir anuncio oficial';

  @override
  String get subsidiesOpenSourceFailed => 'No se pudo abrir el enlace';

  @override
  String get aksCountTitle => 'Colmenas en el AKS';

  @override
  String get aksCountLabel => 'Número de colmenas declarado en el AKS';

  @override
  String get aksCountHelper => 'Déjalo vacío para omitir la comprobación.';

  @override
  String get aksCountInvalid => 'Introduce un número entre 0 y 100.000';

  @override
  String get aksCountSave => 'Guardar';

  @override
  String get aksCountSaved => 'Número de colmenas del AKS guardado';

  @override
  String get aksCountNoOrganization =>
      'Los datos de la explotación aún no se han sincronizado con este teléfono; espera a la sincronización.';

  @override
  String get knowledgeTitle => 'Base de conocimientos';

  @override
  String get knowledgeSearchHint => 'Reservas de invierno, varroa…';

  @override
  String knowledgeMonthLabel(String month, String place) {
    return '$month · $place';
  }

  @override
  String get knowledgePlaceTurkey => 'Turquía';

  @override
  String get knowledgePlaceNorthern => 'Hemisferio norte';

  @override
  String get knowledgePlaceSouthern => 'Hemisferio sur';

  @override
  String get knowledgeMonthTitle => 'Qué hacer este mes';

  @override
  String get knowledgeDiagnosisTitle => 'Ayuda al diagnóstico';

  @override
  String get knowledgeDiagnosisSubtitle =>
      'Elige un síntoma y mira las posibles causas';

  @override
  String get knowledgeAtlasTitle => 'Atlas de enfermedades y plagas';

  @override
  String knowledgeTopicCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count temas',
      one: '1 tema',
    );
    return '$_temp0';
  }

  @override
  String get knowledgeGuidesTitle => 'Guías técnicas';

  @override
  String get knowledgeGuidesSubtitle =>
      'Divisiones, introducción de reinas, unión de colmenas, invernada';

  @override
  String get knowledgeCalculatorsTitle => 'Calculadoras';

  @override
  String get knowledgeCalculatorsSubtitle =>
      'Jarabe, dosis de medicamento, calendario de reinas, rendimiento';

  @override
  String get knowledgeRegulationsTitle => 'Resúmenes de la normativa';

  @override
  String get knowledgeRegulationsSubtitle =>
      'Reglamento, trashumancia, norma de la miel';

  @override
  String get knowledgeTrBadge => 'TR';

  @override
  String get knowledgeFirstYearTitle => 'Mi primer año';

  @override
  String get knowledgeFirstYearSubtitle => 'Paso a paso para principiantes';

  @override
  String get knowledgeCalendarTitle => 'Calendario de temporada';

  @override
  String get knowledgeOffline => 'Todo el contenido se abre sin conexión';

  @override
  String get knowledgeNoResultsTitle => 'Sin resultados';

  @override
  String get knowledgeNoResultsMessage => 'Prueba con otra palabra.';

  @override
  String get knowledgeCategoryEmptyTitle => 'Aún no hay artículos';

  @override
  String get knowledgeCategoryEmptyMessage =>
      'El contenido de esta sección llegará con una actualización.';

  @override
  String get knowledgeArticleNotFound => 'Artículo no encontrado';

  @override
  String get knowledgeLoadError => 'No se pudo abrir la base de conocimientos';

  @override
  String get knowledgeLinkFailed => 'No se pudo abrir el enlace';

  @override
  String get diagnosisSymptoms => 'Síntomas que ves';

  @override
  String get diagnosisSymptomsHelper => 'Puedes elegir más de uno.';

  @override
  String get diagnosisResults => 'Enfermedades posibles';

  @override
  String get diagnosisPickHint =>
      'Elige un síntoma para ver aquí las enfermedades posibles.';

  @override
  String get diagnosisNoMatch =>
      'Ninguna enfermedad coincide con los síntomas elegidos.';

  @override
  String diagnosisMatched(int matched, int total) {
    return 'Síntomas coincidentes: $matched/$total';
  }

  @override
  String get diagnosisNotifiable => 'De declaración obligatoria';

  @override
  String get diagnosisDisclaimer =>
      'Es una primera valoración; el diagnóstico definitivo lo da un veterinario o un laboratorio.';

  @override
  String get diagnosisLoadError => 'No se pudo abrir la tabla de diagnóstico';

  @override
  String get diagnosisNotFound => 'Enfermedad no encontrada';

  @override
  String get diagnosisNotifiableTitle =>
      'Enfermedad de declaración obligatoria.';

  @override
  String get diagnosisNotifiableMessage =>
      'Comunica la sospecha a la autoridad; no compartas el material, los cuadros ni la miel de esta colmena con otras colmenas.';

  @override
  String get diagnosisAdvice => 'Qué hacer';

  @override
  String get diagnosisAuthority => 'Autoridad';

  @override
  String diagnosisCall(String phone) {
    return 'Llamar al $phone';
  }

  @override
  String get diagnosisCallFailed => 'No se pudo iniciar la llamada';

  @override
  String get diagnosisQuarantine => 'Poner una colmena en cuarentena';

  @override
  String get quarantinePickTitle => 'Colmena para cuarentena';

  @override
  String get quarantineSearchHint => 'Número de colmena';

  @override
  String get quarantineNoHivesTitle => 'No hay colmenas';

  @override
  String get quarantineNoHivesMessage =>
      'No hay colmenas activas para poner en cuarentena.';

  @override
  String quarantineDone(String number) {
    return 'Colmena $number en cuarentena';
  }

  @override
  String get hiveQuarantined => 'En cuarentena';

  @override
  String hiveQuarantineDisease(String disease) {
    return 'Sospecha: $disease';
  }

  @override
  String hiveQuarantineSince(String date) {
    return 'Desde el $date';
  }

  @override
  String get hiveQuarantineWarning =>
      'No compartas su material, cuadros ni miel con otras colmenas.';

  @override
  String get hiveQuarantineEnd => 'Terminar cuarentena';

  @override
  String hiveQuarantineEnded(String number) {
    return 'La colmena $number ya no está en cuarentena';
  }

  @override
  String get calculatorSyrup => 'Jarabe';

  @override
  String get calculatorSyrupSubtitle => 'Azúcar y agua necesarias';

  @override
  String get calculatorDose => 'Dosis de tratamiento';

  @override
  String get calculatorDoseSubtitle => 'Total para tu número de colmenas';

  @override
  String get calculatorQueen => 'Calendario de reinas';

  @override
  String get calculatorQueenSubtitle => 'Días de cada paso desde el traslarve';

  @override
  String get calculatorYield => 'Rendimiento';

  @override
  String get calculatorYieldSubtitle => 'Miel por colmena';

  @override
  String get calculatorOffline =>
      'Las calculadoras funcionan sin conexión y no guardan nada.';

  @override
  String get calculatorNotFound => 'Calculadora no encontrada';

  @override
  String get calculatorHives => 'Número de colmenas';

  @override
  String get calculatorSyrupKind => 'Tipo de jarabe';

  @override
  String get calculatorFillHint =>
      'Introduce el número de colmenas y la cantidad.';

  @override
  String get calculatorDosePerHive => 'Dosis por colmena';

  @override
  String get calculatorDoseUnit => 'Unidad';

  @override
  String get calculatorTotal => 'Total';

  @override
  String calculatorDoseTotal(String unit, String total) {
    String _temp0 = intl.Intl.selectLogic(unit, {
      'strip': '$total tiras',
      'ml': '$total ml',
      'g': '$total g',
      'other': '$total dosis',
    });
    return '$_temp0';
  }

  @override
  String calculatorDoseCount(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmenas × $amount',
      one: '1 colmena × $amount',
    );
    return '$_temp0';
  }

  @override
  String calculatorYieldTotal(String unit) {
    return 'Miel total ($unit)';
  }

  @override
  String get calculatorYieldPerHive => 'Por colmena';

  @override
  String calculatorYieldValue(String amount, String unit) {
    return '$amount $unit';
  }

  @override
  String get calculatorQueenSteps => 'Pasos';

  @override
  String get hiveLossWintering => 'Invernada';

  @override
  String get hiveLossQueenless => 'Huérfana';

  @override
  String get hiveLossVarroa => 'Varroa';

  @override
  String get hiveLossDisease => 'Enfermedad';

  @override
  String get hiveLossStarvation => 'Hambre';

  @override
  String get hiveLossRobbing => 'Pillaje';

  @override
  String get hiveLossPredator => 'Oso / animal';

  @override
  String get hiveLossPoisoning => 'Intoxicación';

  @override
  String get hiveLossOther => 'Otra';

  @override
  String get hiveLossUnspecified => 'Sin indicar';

  @override
  String hiveLossReasonTitle(String number) {
    return '¿Por qué se perdió la colmena $number?';
  }

  @override
  String get hiveLossSkip => 'Omitir sin motivo';

  @override
  String get hiveFormLossReason => 'Causa de la pérdida';

  @override
  String get hiveFormLossReasonHelper =>
      'Se usa en el informe de temporada; puede quedar vacío.';

  @override
  String get seasonReportTile => 'Informe de temporada';

  @override
  String seasonTitle(String year) {
    return 'Temporada $year';
  }

  @override
  String get seasonPdf => 'PDF';

  @override
  String get seasonExportCsv => 'Exportar a Excel (CSV)';

  @override
  String get seasonExportError =>
      'No se pudo crear el archivo. Vuelve a intentarlo.';

  @override
  String get seasonLoadError => 'No se pudo cargar el informe de temporada.';

  @override
  String get seasonHives => 'Colmenas';

  @override
  String seasonHiveChange(int start, int end) {
    return '$start → $end';
  }

  @override
  String seasonNetGain(int count) {
    return '+$count neto';
  }

  @override
  String seasonNetLoss(int count) {
    return '−$count neto';
  }

  @override
  String get seasonNetSame => 'Sin cambios';

  @override
  String get seasonWinterLoss => 'Pérdida invernal';

  @override
  String get seasonWinterNotStarted => 'El invierno no ha empezado';

  @override
  String seasonPreviousWinter(String year) {
    return 'Pérdida invernal $year';
  }

  @override
  String seasonPreviousWinterRate(String year, String rate) {
    return '$year: $rate';
  }

  @override
  String get seasonHoney => 'Miel total';

  @override
  String get seasonNewQueens => 'Reinas nuevas';

  @override
  String seasonOwnReared(int count) {
    return 'cría propia $count';
  }

  @override
  String get seasonLossesTitle => 'Pérdidas y causas';

  @override
  String get seasonNoLosses => 'No se perdió ninguna colmena esta temporada.';

  @override
  String seasonHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmenas',
      one: '1 colmena',
    );
    return '$_temp0';
  }

  @override
  String get seasonByTreatment =>
      'Pérdida invernal · por método de tratamiento';

  @override
  String get seasonByApiary => 'Pérdida invernal · por colmenar';

  @override
  String get seasonByQueenLine => 'Pérdida invernal · por línea de reina';

  @override
  String get seasonTabTreatment => 'Tratamiento';

  @override
  String get seasonTabApiary => 'Colmenar';

  @override
  String get seasonTabQueenLine => 'Línea de reina';

  @override
  String get seasonNoWinterData =>
      'En tus registros aún no hay colmenas que hayan pasado el invierno.';

  @override
  String get seasonFewData => 'pocos datos';

  @override
  String get seasonMisleadingNote =>
      'Según tus propios registros; con pocas colmenas puede ser engañoso.';

  @override
  String get seasonUntreated => 'Sin tratar';

  @override
  String get seasonMethodSeparator => ' +';

  @override
  String get seasonQueenLineUnknown => 'Línea desconocida';

  @override
  String get seasonFinanceTitle => 'Coste y beneficio';

  @override
  String get seasonProfit => 'Beneficio';

  @override
  String get seasonPdfFigure => 'Indicador';

  @override
  String get seasonPdfValue => 'Valor';

  @override
  String seasonPdfHiveChange(int start, int end, String net) {
    return '$start → $end ($net)';
  }

  @override
  String seasonPdfNewQueens(int count, int own) {
    return '$count (cría propia $own)';
  }

  @override
  String seasonPdfWinterLoss(String rate, int lost, int hives) {
    return '$rate ($lost de $hives colmenas)';
  }

  @override
  String get seasonPdfReason => 'Causa';

  @override
  String get seasonPdfHives => 'Colmenas';

  @override
  String get seasonPdfLost => 'Perdidas';

  @override
  String get seasonPdfRate => 'Pérdida';

  @override
  String get seasonPdfGroup => 'Grupo';

  @override
  String get seasonPdfTotal => 'Total';

  @override
  String get seasonCsvHive => 'Colmena';

  @override
  String get seasonCsvApiary => 'Colmenar';

  @override
  String get seasonCsvStartStatus => 'Estado al inicio de la temporada';

  @override
  String get seasonCsvEndStatus => 'Estado al final de la temporada';

  @override
  String get seasonCsvLossDate => 'Fecha de la pérdida';

  @override
  String get seasonCsvLossReason => 'Causa de la pérdida';

  @override
  String get seasonCsvInWinter => 'Entró en invierno';

  @override
  String get seasonCsvLostInWinter => 'Perdida en invierno';

  @override
  String get seasonCsvWinterApiary => 'Colmenar de invierno';

  @override
  String get seasonCsvTreatment => 'Tratamiento antes del invierno';

  @override
  String get seasonCsvQueenLine => 'Línea de reina';

  @override
  String get seasonCsvAddedInSeason => 'Añadida esta temporada';

  @override
  String get seasonCsvYes => 'Sí';

  @override
  String get seasonCsvNo => 'No';

  @override
  String get offlineMapsTitle => 'Mapas sin conexión';

  @override
  String get offlineMapsIntro =>
      'Descarga la zona de tus colmenares; el mapa se abre incluso sin cobertura.';

  @override
  String offlineMapsMegabytes(String size) {
    return '$size MB';
  }

  @override
  String offlineMapsApproxSize(String size) {
    return '≈ $size';
  }

  @override
  String offlineMapsDownloaded(String size) {
    return 'Descargado · $size';
  }

  @override
  String offlineMapsDownloadingWifi(String received, String total) {
    return 'Descargando por Wi‑Fi · $received / $total';
  }

  @override
  String offlineMapsDownloading(String received, String total) {
    return 'Descargando · $received / $total';
  }

  @override
  String offlineMapsDownload(String name) {
    return 'Descargar $name';
  }

  @override
  String get offlineMapsCancel => 'Detener descarga';

  @override
  String offlineMapsDelete(String name) {
    return 'Eliminar $name';
  }

  @override
  String offlineMapsDeleteTitle(String name) {
    return '¿Eliminar $name?';
  }

  @override
  String get offlineMapsDeleteMessage =>
      'Sin internet, el mapa de este colmenar no se abrirá. Puedes volver a descargarlo cuando quieras.';

  @override
  String get offlineMapsDeleteConfirm => 'Eliminar';

  @override
  String get offlineMapsWifiOnly => 'Descargar solo con Wi‑Fi';

  @override
  String get offlineMapsWifiOnlyHint =>
      'Unos MB por colmenar; no se usan datos móviles.';

  @override
  String offlineMapsStop(String name) {
    return 'Parada $name';
  }

  @override
  String offlineMapsDone(String name) {
    return 'Zona de $name descargada';
  }

  @override
  String offlineMapsFailed(String name) {
    return 'No se pudo descargar la zona de $name. Revisa tu conexión y vuelve a intentarlo.';
  }

  @override
  String get offlineMapsNeedsWifi =>
      'Conéctate a una Wi‑Fi o desactiva «Descargar solo con Wi‑Fi».';

  @override
  String get offlineMapsAttribution =>
      'Datos del mapa © OpenStreetMap contributors · OpenFreeMap';

  @override
  String get settingsOfflineMaps => 'Mapas sin conexión';

  @override
  String settingsOfflineMapsValue(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmenares · $size',
      one: '1 colmenar · $size',
      zero: 'Ninguno',
    );
    return '$_temp0';
  }

  @override
  String get offlineMapsCoverage =>
      'Cada colmenar recibe 6 km a su alrededor con detalle y 40 km como vista general.';

  @override
  String offlineMapsDownloadedOn(String date) {
    return 'descargado: $date';
  }

  @override
  String get offlineMapsToDownload => 'Colmenares por descargar';

  @override
  String get offlineMapsMoved => 'Colmenar trasladado, vuelve a descargar';

  @override
  String get offlineMapsNoApiaries =>
      'No hay colmenares con ubicación. Añade una ubicación a un colmenar y aparecerá aquí.';

  @override
  String get offlineMapsAllDownloaded =>
      'Todos los colmenares con ubicación están descargados.';

  @override
  String get syncReminderTitle =>
      'Tus registros aún no tienen copia de seguridad';

  @override
  String syncReminderBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count registros llevan 3 días sin llegar al servidor. Abre la app cuando tengas conexión.',
      one: '1 registro lleva 3 días sin llegar al servidor. Abre la app cuando tengas conexión.',
    );
    return '$_temp0';
  }

  @override
  String get syncOverdueTitle => 'Más de 3 días sin copia de seguridad';

  @override
  String syncOverdueMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count registros están solo en este teléfono. Si pierdes el teléfono, también se pierden. Conéctate a internet y sincroniza.',
      one: '1 registro está solo en este teléfono. Si pierdes el teléfono, también se pierde. Conéctate a internet y sincroniza.',
    );
    return '$_temp0';
  }

  @override
  String syncDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'hace $days días',
      one: 'ayer',
      zero: 'hoy',
    );
    return '$_temp0';
  }

  @override
  String syncLastSyncedAgo(String ago, String when) {
    return 'Última sincronización $ago · $when';
  }

  @override
  String syncPendingTitle(int count) {
    return 'Pendientes de envío · $count';
  }

  @override
  String settingsSignOutPendingMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count registros aún no se han enviado al servidor y están solo en este teléfono. Si cierras sesión, no se enviarán. Conéctate a internet y sincroniza primero.',
      one: '1 registro aún no se ha enviado al servidor y está solo en este teléfono. Si cierras sesión, no se enviará. Conéctate a internet y sincroniza primero.',
    );
    return '$_temp0';
  }

  @override
  String get settingsSignOutAnyway => 'Cerrar sesión de todos modos';

  @override
  String get settingsExport => 'Exportar datos';

  @override
  String get settingsExportValue => 'Excel';

  @override
  String get settingsExportHint =>
      'Todos tus registros en un archivo de Excel; compártelo o guárdalo donde quieras.';

  @override
  String get exportPreparing => 'Preparando…';

  @override
  String get exportFailed =>
      'No se pudo preparar el archivo. Vuelve a intentarlo.';

  @override
  String exportFileName(String date) {
    return 'Mobil Arıcı $date';
  }

  @override
  String get exportYes => 'Sí';

  @override
  String get exportNo => 'No';

  @override
  String get exportSheetApiaries => 'Colmenares';

  @override
  String get exportSheetHives => 'Colmenas';

  @override
  String get exportSheetQueens => 'Reinas';

  @override
  String get exportSheetInspections => 'Revisiones';

  @override
  String get exportSheetFeedings => 'Alimentaciones';

  @override
  String get exportSheetTreatments => 'Tratamientos';

  @override
  String get exportSheetMiteCounts => 'Conteos de varroa';

  @override
  String get exportSheetHarvests => 'Cosechas';

  @override
  String get exportSheetTasks => 'Tareas';

  @override
  String get exportSheetInventory => 'Existencias';

  @override
  String get exportSheetFinance => 'Ingresos y gastos';

  @override
  String get exportColName => 'Nombre';

  @override
  String get exportColLatitude => 'Latitud';

  @override
  String get exportColLongitude => 'Longitud';

  @override
  String get exportColAltitude => 'Altitud (m)';

  @override
  String get exportColLandowner => 'Propietario del terreno';

  @override
  String get exportColLandownerPhone => 'Teléfono del propietario';

  @override
  String get exportColWaterSource => 'Fuente de agua';

  @override
  String get exportColVehicleDistance => 'Distancia al vehículo (m)';

  @override
  String get exportColRoadNotes => 'Notas del camino';

  @override
  String get exportColNotes => 'Notas';

  @override
  String get exportColActiveHives => 'Colmenas activas';

  @override
  String get exportColCreated => 'Añadido';

  @override
  String get exportColApiary => 'Colmenar';

  @override
  String get exportColHive => 'Colmena';

  @override
  String get exportColType => 'Tipo';

  @override
  String get exportColStatus => 'Estado';

  @override
  String get exportColBoxes => 'Cuerpos';

  @override
  String get exportColFrames => 'Cuadros';

  @override
  String get exportColSource => 'Origen';

  @override
  String get exportColMarking => 'Marcado';

  @override
  String get exportColTag => 'Código de etiqueta';

  @override
  String get exportColQuarantine => 'Cuarentena';

  @override
  String get exportColQueen => 'Reina';

  @override
  String get exportColYear => 'Año';

  @override
  String get exportColColor => 'Color de marca';

  @override
  String get exportColBreed => 'Raza';

  @override
  String get exportColLine => 'Línea';

  @override
  String get exportColWingClipped => 'Ala cortada';

  @override
  String get exportColDate => 'Fecha';

  @override
  String get exportColQueenState => 'Reina';

  @override
  String get exportColBeeFrames => 'Cuadros con abejas';

  @override
  String get exportColBroodFrames => 'Cuadros de cría';

  @override
  String get exportColHoneyFrames => 'Cuadros de miel';

  @override
  String get exportColTemperament => 'Temperamento';

  @override
  String get exportColSwarmSigns => 'Señales de enjambrazón';

  @override
  String get exportColQueenCells => 'Celdas reales';

  @override
  String get exportColDisease => 'Sospecha de enfermedad';

  @override
  String get exportColActions => 'Hecho';

  @override
  String get exportColAmount => 'Cantidad';

  @override
  String get exportColUnit => 'Unidad';

  @override
  String get exportColProduct => 'Producto';

  @override
  String get exportColActiveIngredient => 'Principio activo';

  @override
  String get exportColDose => 'Dosis';

  @override
  String get exportColWithdrawal => 'Espera (días)';

  @override
  String get exportColBatch => 'N.º de lote';

  @override
  String get exportColPlannedRemoval => 'Retirada prevista';

  @override
  String get exportColMethod => 'Método';

  @override
  String get exportColMites => 'Ácaros';

  @override
  String get exportColSampleBees => 'Abejas de la muestra';

  @override
  String get exportColDays => 'Días';

  @override
  String get exportColResult => 'Resultado';

  @override
  String get exportColHoneyKind => 'Miel';

  @override
  String get exportColUnitCount => 'Cantidad';

  @override
  String get exportColNetKg => 'Neto (kg)';

  @override
  String get exportColHiveCount => 'Colmenas';

  @override
  String get exportColDue => 'Vence';

  @override
  String get exportColTitle => 'Título';

  @override
  String get exportColCompleted => 'Completada';

  @override
  String get exportColCategory => 'Categoría';

  @override
  String get exportColPlace => 'Lugar';

  @override
  String get exportColStock => 'En existencias';

  @override
  String get exportColThreshold => 'Aviso por debajo de';

  @override
  String get exportColCurrency => 'Moneda';

  @override
  String get exportColDescription => 'Descripción';

  @override
  String get businessTitle => 'Explotación';

  @override
  String get businessEdit => 'Editar';

  @override
  String get businessEditTitle => 'Editar explotación';

  @override
  String get businessCancel => 'Cancelar';

  @override
  String get businessSave => 'Guardar';

  @override
  String get businessSaveError =>
      'No se pudo guardar; la explotación aún no está en este teléfono.';

  @override
  String get businessMissingTitle => 'Sin datos de la explotación';

  @override
  String get businessMissingMessage =>
      'Aparecerán aquí cuando la explotación llegue a este teléfono.';

  @override
  String businessPersonRole(String person, String role) {
    return '$person · $role';
  }

  @override
  String get businessDetailSeparator => ' ·';

  @override
  String businessRegionBadge(String country, String profile) {
    return '$country · $profile';
  }

  @override
  String get businessRegionTr => 'Perfil TR';

  @override
  String get businessRegionOther => 'Perfil general';

  @override
  String get businessPendingSync => 'Aún sin sincronizar';

  @override
  String businessCountHives(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'colmenas',
      one: 'colmena',
    );
    return '$_temp0';
  }

  @override
  String businessCountApiaries(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'colmenares',
      one: 'colmenar',
    );
    return '$_temp0';
  }

  @override
  String businessCountInspections(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'revisiones',
      one: 'revisión',
    );
    return '$_temp0';
  }

  @override
  String get businessSectionBusiness => 'Explotación';

  @override
  String get businessSectionAccount => 'Cuenta';

  @override
  String get businessType => 'Tipo';

  @override
  String get businessTypeMigratory => 'Trashumante';

  @override
  String get businessTypeStationary => 'Estante';

  @override
  String get businessTypeHelp =>
      'Una explotación estante oculta los planes y traslados de trashumancia; los registros no se eliminan.';

  @override
  String get businessCurrency => 'Moneda';

  @override
  String get businessCurrencySearch => 'Buscar código o país';

  @override
  String get businessCurrencyNoMatch =>
      'Ninguna moneda coincide con tu búsqueda.';

  @override
  String get businessCurrencyNote =>
      'Los registros anteriores no se convierten; la moneda nueva solo se aplica a los registros a partir de ahora.';

  @override
  String businessTeamTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Equipo · $count personas',
      one: 'Equipo · 1 persona',
    );
    return '$_temp0';
  }

  @override
  String get businessTeamSolo => 'Aún no hay miembros en el equipo';

  @override
  String businessRoleCountOwner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titulares',
      one: '1 titular',
    );
    return '$_temp0';
  }

  @override
  String businessRoleCountPartner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count socios',
      one: '1 socio',
    );
    return '$_temp0';
  }

  @override
  String businessRoleCountWorker(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trabajadores',
      one: '1 trabajador',
    );
    return '$_temp0';
  }

  @override
  String businessRoleCountViewer(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count asesores',
      one: '1 asesor',
    );
    return '$_temp0';
  }

  @override
  String get businessEmail => 'Correo de inicio de sesión';

  @override
  String get businessEmailSoon => 'Pronto podrás cambiar tu correo.';

  @override
  String get businessFirstRecord => 'Primer registro';

  @override
  String businessFirstRecordValue(String date, int season) {
    return '$date · temporada $season';
  }

  @override
  String get businessSettingsShortcut => 'Idioma, unidades, tema y datos';

  @override
  String get businessNameLabel => 'Nombre de la explotación';

  @override
  String get businessFullNameLabel => 'Nombre completo';

  @override
  String get businessFullNameHelp => 'Tu equipo te ve con este nombre.';

  @override
  String get businessAvatarLabel => 'Avatar';

  @override
  String get businessAvatarHelp =>
      'Sin logo, tus iniciales aparecen en el color que elijas.';

  @override
  String get businessAvatarPine => 'Pino';

  @override
  String get businessAvatarHoney => 'Miel';

  @override
  String get businessAvatarSky => 'Cielo';

  @override
  String get businessAvatarSlate => 'Pizarra';

  @override
  String get businessLogoUpload => 'Subir logo';

  @override
  String get businessLogoRemove => 'Quitar logo';

  @override
  String get businessDiscardTitle => '¿Descartar los cambios?';

  @override
  String get businessDiscardMessage => 'Se perderán los cambios sin guardar.';

  @override
  String get businessDiscardAction => 'Descartar';

  @override
  String get businessTypeConfirmTitle => '¿Cambiar a estante?';

  @override
  String businessTypeConfirmMessage(int plans, int stops) {
    String _temp0 = intl.Intl.pluralLogic(
      plans,
      locale: localeName,
      other: '$plans planes de trashumancia',
      one: '1 plan de trashumancia',
    );
    String _temp1 = intl.Intl.pluralLogic(
      stops,
      locale: localeName,
      other: '$stops paradas',
      one: '1 parada',
    );
    return 'Se ocultarán $_temp0 y $_temp1. Los registros no se eliminan; puedes deshacerlo.';
  }

  @override
  String get businessTypeConfirmAction => 'Cambiar';

  @override
  String get businessReadOnly =>
      'Solo el titular y los socios pueden cambiar los datos de la explotación.';

  @override
  String get financeOtherCurrencies => 'Otras monedas';

  @override
  String financeOtherCurrencyLine(String currency, String amount) {
    return '$currency · neto $amount';
  }

  @override
  String get migratoryHiddenTitle =>
      'El módulo de trashumancia está desactivado';

  @override
  String get migratoryHiddenMessage =>
      'Tu explotación es estante. Los planes y traslados no se eliminan; vuelven si cambias a trashumante.';

  @override
  String get onboardingMigratoryTitle =>
      '¿Trasladas tus colmenas (trashumancia)?';

  @override
  String get onboardingMigratoryMessage =>
      'Si no, se ocultan los planes y traslados de trashumancia; puedes cambiarlo cuando quieras en el perfil de la explotación.';

  @override
  String get onboardingMigratoryYes => 'Sí';

  @override
  String get onboardingMigratoryNo => 'No, estante';

  @override
  String get settingsDeleteAccount => 'Eliminar mi cuenta';

  @override
  String get settingsDeleteAccountOffline =>
      'Para eliminar tu cuenta necesitas conexión a internet; vuelve a intentarlo cuando tengas conexión.';

  @override
  String get deletionTitle => 'Eliminar mi cuenta';

  @override
  String deletionStepCounter(int current, int total) {
    return 'Paso $current de $total';
  }

  @override
  String get deletionContinue => 'Continuar';

  @override
  String get deletionSoloTitle => 'Se eliminarán tu cuenta y tu explotación';

  @override
  String deletionSoloMessage(String organization) {
    return 'Eres la única persona en $organization. Al eliminar tu cuenta también se eliminan la explotación y todos sus registros.';
  }

  @override
  String get deletionCountsLabel => 'Registros que se eliminarán';

  @override
  String get deletionCountHives => 'Colmenas';

  @override
  String get deletionCountApiaries => 'Colmenares';

  @override
  String get deletionCountInspections => 'Revisiones';

  @override
  String get deletionCountHarvests => 'Cosechas';

  @override
  String get deletionCountDocuments => 'Documentos';

  @override
  String get deletionCountPhotos => 'Fotos';

  @override
  String get deletionLotWarningTitle => 'Los códigos QR dejarán de funcionar.';

  @override
  String deletionLotWarningMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Se eliminarán $count páginas públicas de lotes y los códigos QR de tus tarros dejarán de funcionar.',
      one: 'Se eliminará 1 página pública de lote y los códigos QR de tus tarros dejarán de funcionar.',
    );
    return '$_temp0';
  }

  @override
  String get deletionTeamTitle =>
      'Tienes un equipo: elige qué pasa con la explotación';

  @override
  String deletionTeamMessage(int count, String organization) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Eres titular de $organization y hay $count personas más en el equipo.',
      one: 'Eres titular de $organization y hay 1 persona más en el equipo.',
    );
    return '$_temp0';
  }

  @override
  String get deletionChoiceTransfer => 'Transferir la titularidad y salir';

  @override
  String get deletionChoiceTransferHint =>
      'La explotación y sus registros se mantienen. El socio que elijas pasa a ser titular; solo se elimina tu cuenta.';

  @override
  String get deletionChoiceDelete =>
      'Eliminar la explotación y todos los registros';

  @override
  String deletionChoiceDeleteHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Las otras $count personas del equipo también pierden el acceso.',
      one: 'La otra persona del equipo también pierde el acceso.',
    );
    return '$_temp0';
  }

  @override
  String get deletionTransferPick => 'Nuevo titular';

  @override
  String get deletionTransferNoPartner =>
      'Para transferir, alguien del equipo debe ser socio. Haz socio a un miembro en la pantalla Equipo o elimina la explotación.';

  @override
  String get deletionPartnerFallbackName => 'Socio';

  @override
  String get deletionMemberTitle => 'Solo se eliminará tu cuenta';

  @override
  String deletionMemberMessage(String organization) {
    return '$organization y sus registros no se eliminan. Los registros que introdujiste se quedan en la explotación; tu nombre se quita del equipo.';
  }

  @override
  String get deletionUnknownMessage =>
      'Tu membresía aún no ha llegado a este teléfono. Vuelve a intentarlo después de sincronizar.';

  @override
  String get deletionGraceNote =>
      'La eliminación es definitiva a los 7 días; hasta entonces puedes iniciar sesión y cambiar de opinión.';

  @override
  String get deletionBackupTitle => 'Guarda antes tus datos';

  @override
  String get deletionBackupMessage =>
      'Los registros eliminados no se pueden recuperar. Te recomendamos guardar antes una copia.';

  @override
  String get deletionBackupReports => 'Informes PDF';

  @override
  String get deletionBackupReportsHint => 'Descarga informes listos en PDF.';

  @override
  String get deletionBackupJson => 'Todos los registros';

  @override
  String get deletionBackupJsonValue => 'JSON';

  @override
  String get deletionBackupJsonHint =>
      'Todos tus registros en un archivo; guárdalo donde quieras.';

  @override
  String get deletionBackupSaved => 'Guardado';

  @override
  String get deletionBackupDownload => 'Descargar mis registros';

  @override
  String get deletionBackupSkip => 'Omitir';

  @override
  String deletionBackupFileName(String date) {
    return 'mobil-arici-registros-$date';
  }

  @override
  String get deletionVerifyTitle => 'Confirma que eres tú';

  @override
  String get deletionVerifyButton => 'Verificar código';

  @override
  String get deletionConfirmTitle => 'Confirmación final';

  @override
  String get deletionConfirmIntro => 'Si confirmas:';

  @override
  String deletionConsequenceAccount(String date) {
    return 'Tu cuenta se eliminará definitivamente el $date.';
  }

  @override
  String deletionConsequenceOrganization(String organization) {
    return 'También se eliminan $organization y todos sus registros.';
  }

  @override
  String deletionConsequenceTransfer(String name, String organization) {
    return '$name pasa a ser el nuevo titular de $organization.';
  }

  @override
  String get deletionConsequenceRecordsStay =>
      'Los registros de la explotación no se eliminan.';

  @override
  String deletionConsequenceLots(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Se cierran $count páginas de lotes; sus códigos QR dejan de funcionar.',
      one: 'Se cierra 1 página de lote; sus códigos QR dejan de funcionar.',
    );
    return '$_temp0';
  }

  @override
  String get deletionConsequenceSignOut =>
      'Se cerrará tu sesión y se borrarán los datos de este teléfono.';

  @override
  String get deletionConsequenceCancel =>
      'Si inicias sesión antes de esa fecha, puedes cancelar la eliminación.';

  @override
  String deletionConfirmTypeName(String organization) {
    return 'Para confirmar, escribe el nombre de la explotación: $organization';
  }

  @override
  String deletionConfirmTypeKeyword(String keyword) {
    return 'Para confirmar, escribe $keyword';
  }

  @override
  String get deletionKeyword => 'ELIMINAR';

  @override
  String get deletionConfirmButton => 'Eliminar mi cuenta';

  @override
  String get deletionConfirmButtonWithOrganization =>
      'Eliminar mi cuenta y la explotación';

  @override
  String get deletionSubmitting => 'Enviando…';

  @override
  String get deletionFailureNetwork =>
      'No se pudo contactar con el servidor. Revisa tu conexión y vuelve a intentarlo.';

  @override
  String get deletionFailureOwnerMustTransfer =>
      'También eres titular de otra explotación con equipo. Transfiere primero la titularidad allí.';

  @override
  String get deletionFailureInvalidTransfer =>
      'La persona que elegiste ya no es socia. Elige otro socio.';

  @override
  String get deletionFailureRateLimited =>
      'Demasiados intentos en poco tiempo. Vuelve a intentarlo mañana.';

  @override
  String get deletionFailureForbidden =>
      'Tu sesión ha terminado. Vuelve a iniciar sesión e inténtalo de nuevo.';

  @override
  String get deletionFailureCodeRequired =>
      'Tu confirmación ha caducado. Pide un código nuevo y vuelve a verificar.';

  @override
  String get deletionFailureUnknown =>
      'No se pudo enviar la solicitud. Vuelve a intentarlo dentro de un rato.';

  @override
  String get deletionDoneTitle => 'Hemos recibido tu solicitud';

  @override
  String deletionDoneDate(String date) {
    return 'Tu cuenta se eliminará definitivamente el $date.';
  }

  @override
  String get deletionDoneCancelHint =>
      'Si cambias de opinión, inicia sesión antes de esa fecha y la eliminación se cancela.';

  @override
  String get deletionDoneEmail =>
      'También te hemos enviado los detalles por correo.';

  @override
  String get deletionDoneClearing => 'Borrando los datos de este teléfono…';

  @override
  String get deletionDoneSignedOut =>
      'Se ha cerrado tu sesión y se han borrado los datos de este teléfono.';

  @override
  String get deletionDoneAction => 'Hecho';

  @override
  String get deletionPendingTitle => 'Tu cuenta está a punto de eliminarse';

  @override
  String deletionPendingMessage(String date) {
    return 'Tu cuenta se eliminará el $date. Si continúas, la eliminación se cancela.';
  }

  @override
  String get deletionPendingContinue => 'Continuar y conservar mi cuenta';

  @override
  String get deletionPendingSignOut =>
      'Cerrar sesión y mantener la eliminación';

  @override
  String get deletionPendingCancelled =>
      'Eliminación cancelada. ¡Bienvenido de nuevo!';

  @override
  String get deletionPendingCancelFailed =>
      'No se pudo cancelar la eliminación. Revisa tu conexión y vuelve a intentarlo.';

  @override
  String teamMemberLeaving(String date) {
    return 'Eliminando su cuenta · $date';
  }

  @override
  String get teamErrorMemberLeaving =>
      'Esta persona está eliminando su cuenta; durante el periodo de espera no se puede cambiar su rol ni quitarla.';
}
