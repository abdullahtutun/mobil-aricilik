// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Mobil Arıcı';

  @override
  String get listSeparator => ',';

  @override
  String get stepperIncrease => 'Aumentar';

  @override
  String get stepperDecrease => 'Diminuir';

  @override
  String hiveTileLabel(String number) {
    return 'Colmeia $number';
  }

  @override
  String hiveTileStrength(int strength) {
    return 'Força $strength de 5';
  }

  @override
  String hiveTileQueenColor(String color) {
    String _temp0 = intl.Intl.selectLogic(color, {
      'white': 'branca',
      'yellow': 'amarela',
      'red': 'vermelha',
      'green': 'verde',
      'blue': 'azul',
      'other': 'desconhecida',
    });
    return 'Cor da rainha $_temp0';
  }

  @override
  String get tabToday => 'Hoje';

  @override
  String get tabApiaries => 'Apiários';

  @override
  String get tabTasks => 'Tarefas';

  @override
  String get tabMore => 'Mais';

  @override
  String get todayEmptyTitle => 'Comece adicionando seu apiário';

  @override
  String get todayEmptyMessage =>
      'Três passos e pronto: adicione seu apiário, crie suas colmeias e faça sua primeira revisão.';

  @override
  String get apiariesEmptyTitle => 'Ainda não há apiários';

  @override
  String get apiariesEmptyMessage =>
      'Um apiário agrupa suas colmeias pelo lugar onde estão; adicione o primeiro para começar.';

  @override
  String get apiariesAdd => 'Adicionar apiário';

  @override
  String get apiariesAddFirst => 'Adicione seu primeiro apiário';

  @override
  String get apiariesLoadError => 'Não foi possível ler seus apiários.';

  @override
  String get apiariesViewList => 'Lista';

  @override
  String get apiariesViewMap => 'Mapa';

  @override
  String get apiariesMapOfflineTitle => 'Mapa indisponível';

  @override
  String get apiariesMapOfflineMessage =>
      'O mapa precisa de internet. Seus apiários estão na lista abaixo.';

  @override
  String get apiariesMapNoLocation =>
      'Nenhum apiário tem localização ainda. Edite um apiário para pegar a localização do GPS ou escolhê-la no mapa.';

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
      other: '$count colmeias precisam de atenção',
      one: '1 colmeia precisa de atenção',
    );
    return '$_temp0';
  }

  @override
  String get apiaryMapDirections => 'Como chegar';

  @override
  String get apiaryMapShow => 'Ver';

  @override
  String get apiaryMapDirectionsFailed =>
      'Não foi possível abrir um app de mapas.';

  @override
  String get apiaryMapDirectionsChooseApp => 'Como chegar com';

  @override
  String apiaryHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmeias',
      one: '1 colmeia',
      zero: 'Sem colmeias',
    );
    return '$_temp0';
  }

  @override
  String apiaryLastVisit(String date) {
    return 'Última visita $date';
  }

  @override
  String get apiaryNoVisit => 'Ainda sem visitas';

  @override
  String get apiaryEdit => 'Editar';

  @override
  String get apiaryDelete => 'Excluir apiário';

  @override
  String get apiaryDeleteTitle => 'Excluir este apiário?';

  @override
  String get apiaryDeleteMessage =>
      'O apiário será removido de todos os celulares.';

  @override
  String apiaryDeleteWithHivesMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Este apiário tem $count colmeias. O apiário e as colmeias serão removidos de todos os celulares.',
      one: 'Este apiário tem 1 colmeia. O apiário e a colmeia serão removidos de todos os celulares.',
    );
    return '$_temp0';
  }

  @override
  String get apiaryDeleted => 'Apiário excluído';

  @override
  String get apiaryNotFoundTitle => 'Apiário não encontrado';

  @override
  String get apiaryNotFoundMessage =>
      'Ele pode ter sido excluído ou ainda não ter chegado a este aparelho.';

  @override
  String get apiaryFormNewTitle => 'Novo apiário';

  @override
  String get apiaryFormEditTitle => 'Editar apiário';

  @override
  String get apiaryFormName => 'Nome do apiário';

  @override
  String get apiaryFormNameHint => 'ex.: Morro Alto';

  @override
  String get apiaryFormLocation => 'Localização';

  @override
  String get apiaryFormLocationNone =>
      'Ainda sem localização. Se você está no apiário, pegue-a do GPS, sem precisar de internet; senão, escolha no mapa.';

  @override
  String get apiaryFormLocationTake => 'Pegar localização do GPS';

  @override
  String get apiaryFormLocationRetake => 'Pegar localização de novo';

  @override
  String get apiaryFormLocationClear => 'Remover localização';

  @override
  String get apiaryFormLocationPickOnMap => 'Escolher no mapa';

  @override
  String get locationPickerTitle => 'Escolher localização no mapa';

  @override
  String get locationPickerSearchHint => 'Buscar cidade ou lugar';

  @override
  String get locationPickerSearch => 'Buscar';

  @override
  String get locationPickerHint =>
      'Mova o mapa para colocar o marcador sobre o apiário.';

  @override
  String get locationPickerPinLabel => 'Localização escolhida';

  @override
  String get locationPickerConfirm => 'Usar esta localização';

  @override
  String get locationPickerNoResults =>
      'Nenhum lugar encontrado. Tente outro nome.';

  @override
  String get locationPickerSearchOffline =>
      'Não foi possível buscar. A busca precisa de internet.';

  @override
  String get locationPickerMapOfflineMessage =>
      'O mapa precisa de internet. Se você está no apiário, pegue a localização do GPS.';

  @override
  String get apiaryFormLocating =>
      'Obtendo sua localização… Ao ar livre é mais rápido.';

  @override
  String apiaryFormLocationAccuracy(int meters) {
    return 'Precisão ±$meters m';
  }

  @override
  String get apiaryFormLocationErrorServiceDisabled =>
      'A localização está desligada neste aparelho. Ligue-a e tente de novo.';

  @override
  String get apiaryFormLocationErrorPermissionDenied =>
      'A permissão de localização não foi dada. Permita para pegar a localização.';

  @override
  String get apiaryFormLocationErrorPermissionDeniedForever =>
      'A permissão de localização está desligada. Permita a localização para este app nas Configurações.';

  @override
  String get apiaryFormLocationErrorTimeout =>
      'Não foi possível encontrar sua localização. Tente de novo ao ar livre.';

  @override
  String get apiaryFormLocationErrorUnknown =>
      'Não foi possível obter sua localização. Tente de novo.';

  @override
  String get apiaryFormOpenSettings => 'Abrir configurações';

  @override
  String get apiaryFormNotes => 'Observações';

  @override
  String get apiaryFormSave => 'Salvar';

  @override
  String get hiveSortWeakestFirst => 'Mais fracas primeiro';

  @override
  String get hivesEmptyTitle => 'Ainda não há colmeias';

  @override
  String get hivesEmptyMessage =>
      'Adicione as colmeias deste apiário; você pode criar várias de uma vez.';

  @override
  String get hivesAdd => 'Adicionar colmeias';

  @override
  String get hivesAddOne => 'Uma colmeia';

  @override
  String get hivesAddOneHint => 'Informe o número, o tipo e a origem';

  @override
  String get hivesAddBulk => 'Várias de uma vez';

  @override
  String get hivesAddBulkHint => 'ex.: 20 colmeias a partir da 101';

  @override
  String hivesInactiveTitle(int count) {
    return 'Inativas ($count)';
  }

  @override
  String get hivesLoadError => 'Não foi possível ler as colmeias.';

  @override
  String hiveLabel(String number) {
    return 'Colmeia $number';
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
  String get hiveTypeLocal => 'Local';

  @override
  String get hiveTypeOther => 'Outro';

  @override
  String get hiveStatusActive => 'Ativa';

  @override
  String get hiveStatusDead => 'Morta';

  @override
  String get hiveStatusMerged => 'Unida';

  @override
  String get hiveStatusSold => 'Vendida';

  @override
  String get hiveStatusLost => 'Perdida';

  @override
  String get hiveSourceSwarm => 'Enxame';

  @override
  String get hiveSourceSplit => 'Divisão';

  @override
  String get hiveSourcePurchase => 'Comprada';

  @override
  String get hiveSourcePackage => 'Pacote de abelhas';

  @override
  String get hiveFormNewTitle => 'Nova colmeia';

  @override
  String get hiveFormEditTitle => 'Editar colmeia';

  @override
  String get hiveFormNumber => 'Número da colmeia';

  @override
  String get hiveFormNumberHint => 'ex.: 101';

  @override
  String get hiveFormType => 'Tipo de colmeia';

  @override
  String get hiveFormStatus => 'Situação';

  @override
  String get hiveFormSource => 'Origem';

  @override
  String get hiveFormSave => 'Salvar';

  @override
  String get hiveBulkTitle => 'Criar várias colmeias';

  @override
  String get hiveBulkCount => 'Quantas colmeias';

  @override
  String get hiveBulkCountHint => 'ex.: 20';

  @override
  String hiveBulkCountTooMany(int max) {
    return 'No máximo $max de uma vez';
  }

  @override
  String get hiveBulkStart => 'Primeiro número';

  @override
  String get hiveBulkStartHint => 'ex.: 101';

  @override
  String hiveBulkPreview(int count, String first, String last) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Serão criadas $count colmeias: da $first à $last.',
      one: 'A colmeia $first será criada.',
    );
    return '$_temp0';
  }

  @override
  String get hiveBulkSave => 'Criar colmeias';

  @override
  String hiveBulkCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmeias criadas',
      one: '1 colmeia criada',
    );
    return '$_temp0';
  }

  @override
  String get hiveNotFoundTitle => 'Colmeia não encontrada';

  @override
  String get hiveNotFoundMessage =>
      'Ela pode ter sido excluída ou ainda não ter chegado a este aparelho.';

  @override
  String get hiveEdit => 'Editar';

  @override
  String get hiveDelete => 'Excluir colmeia';

  @override
  String hiveDeleteTitle(String number) {
    return 'Excluir a colmeia $number?';
  }

  @override
  String get hiveDeleteMessage =>
      'A colmeia e seus registros serão removidos de todos os celulares.';

  @override
  String hiveDeleted(String number) {
    return 'Colmeia $number excluída';
  }

  @override
  String hiveCardApiary(String name) {
    return 'Apiário: $name';
  }

  @override
  String get hiveQueenTitle => 'Rainha';

  @override
  String hiveQueenStripTitle(String queen) {
    return 'Rainha · $queen';
  }

  @override
  String hiveStrengthBadge(String level, int strength) {
    return '$level · $strength/5';
  }

  @override
  String get hiveStrengthWeak => 'Fraca';

  @override
  String get hiveStrengthMedium => 'Média';

  @override
  String get hiveStrengthStrong => 'Forte';

  @override
  String get hiveStrengthNone => 'Ainda sem nota de força';

  @override
  String get hiveTimelineTitle => 'Histórico';

  @override
  String get timelineInspection => 'Revisão';

  @override
  String get timelineAdded => 'Colocada no apiário';

  @override
  String get timelineMoved => 'Transferida';

  @override
  String timelineMoveRoute(String from, String to) {
    return '$from → $to';
  }

  @override
  String get timelineUnknownApiary => 'Apiário desconhecido';

  @override
  String timelineField(String label, String value) {
    return '$label: $value';
  }

  @override
  String timelineBeeFrames(int count) {
    return '$count com abelhas';
  }

  @override
  String timelineBroodFrames(int count) {
    return '$count com cria';
  }

  @override
  String timelineHoneyFrames(int count) {
    return '$count com mel';
  }

  @override
  String get timelineActions => 'Feito';

  @override
  String get hiveMove => 'Transferir para outro apiário';

  @override
  String hiveMoveTitle(String number) {
    return 'Transferir a colmeia $number para';
  }

  @override
  String get hiveMoveNoOtherApiary =>
      'Não há outro apiário para onde transferi-la. Adicione um primeiro na aba Apiários.';

  @override
  String hiveMoved(String number, String apiary) {
    return 'Colmeia $number transferida para $apiary';
  }

  @override
  String get hiveChangeStatus => 'Mudar situação';

  @override
  String hiveStatusSheetTitle(String number) {
    return 'Nova situação da colmeia $number';
  }

  @override
  String hiveStatusConfirmTitle(String status, String number) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'dead': 'Registrar a colmeia $number como morta?',
      'merged': 'Registrar a colmeia $number como unida?',
      'sold': 'Registrar a colmeia $number como vendida?',
      'other': 'Registrar a colmeia $number como perdida?',
    });
    return '$_temp0';
  }

  @override
  String get hiveStatusConfirmMessage =>
      'Ela deixará de contar entre as colmeias ativas do apiário. Você pode reativá-la depois.';

  @override
  String get hiveStatusConfirm => 'Sim, registrar';

  @override
  String hiveStatusChanged(String number, String status) {
    return 'Colmeia $number: $status';
  }

  @override
  String get tasksEmptyTitle => 'Ainda não há tarefas';

  @override
  String get tasksEmptyMessage =>
      'Seus lembretes e tarefas aparecerão aqui por data.';

  @override
  String get scanTitle => 'Escanear';

  @override
  String get scanLongPressHint => 'abrir o menu de registro rápido';

  @override
  String get scanHint => 'Enquadre o código da etiqueta da colmeia.';

  @override
  String get scanAgain => 'Escanear de novo';

  @override
  String get cameraErrorTitle => 'Não foi possível abrir a câmera';

  @override
  String get cameraErrorPermissionDenied =>
      'A permissão da câmera não foi dada. Para escanear etiquetas, permita a câmera para este app nas Configurações.';

  @override
  String get cameraErrorUnsupported =>
      'Este aparelho não tem uma câmera que possa escanear.';

  @override
  String get cameraErrorUnknown => 'Feche esta tela e tente de novo.';

  @override
  String get labelUnknownTitle =>
      'Este código não está ligado a nenhuma colmeia';

  @override
  String get labelUnknownMessage =>
      'Não é uma etiqueta do Mobil Arıcı ou ainda não foi atribuída a uma colmeia. Se ela está numa colmeia, atribua; ao escaneá-la, a ficha da colmeia vai abrir.';

  @override
  String get labelUnknownOwnTitle =>
      'A colmeia desta etiqueta não foi encontrada';

  @override
  String get labelUnknownOwnMessage =>
      'A colmeia pode ter sido excluída ou ainda não ter chegado a este celular. Você também pode atribuir a etiqueta a outra colmeia.';

  @override
  String labelCode(String code) {
    return 'Código: $code';
  }

  @override
  String get labelAssign => 'Atribuir a uma colmeia';

  @override
  String get labelAssignTitle => 'Atribuir etiqueta a uma colmeia';

  @override
  String get labelAssignMessage =>
      'Escolha a colmeia onde está a etiqueta. Ao escaneá-la, a ficha dessa colmeia vai abrir.';

  @override
  String get labelAssignSearch => 'Número da colmeia';

  @override
  String get labelAssignNoMatch => 'Nenhuma colmeia corresponde à sua busca.';

  @override
  String get labelAssignNoHives =>
      'Ainda não há colmeias. Adicione primeiro na aba Apiários.';

  @override
  String get labelAssignHasOther => 'Tem outra etiqueta';

  @override
  String labelReplaceTitle(String number) {
    return 'Substituir a etiqueta da colmeia $number?';
  }

  @override
  String get labelReplaceMessage =>
      'Esta colmeia já tem uma etiqueta. A nova a substitui; a antiga não abrirá mais esta colmeia.';

  @override
  String get labelReplaceConfirm => 'Sim, substituir';

  @override
  String labelAssigned(String number) {
    return 'Etiqueta atribuída: colmeia $number';
  }

  @override
  String get hiveLabelsTitle => 'Imprimir etiquetas';

  @override
  String get hiveLabelsMessage =>
      'Escolha as colmeias para imprimir etiquetas. Uma página A4 tem 24 etiquetas (70 × 37 mm); imprima em escala 100%.';

  @override
  String get hiveLabelsNoHives =>
      'Este apiário não tem colmeias para imprimir etiquetas.';

  @override
  String get hiveLabelsSelectAll => 'Selecionar todas';

  @override
  String get hiveLabelsSelectNone => 'Não selecionar nenhuma';

  @override
  String get hiveLabelsNoneSelected => 'Nenhuma colmeia selecionada';

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
  String get hiveLabelsPreparing => 'Preparando o PDF…';

  @override
  String get hiveLabelsPrint => 'Imprimir';

  @override
  String get hiveLabelsShare => 'Compartilhar PDF';

  @override
  String hiveLabelsDocumentName(String apiary) {
    return 'Etiquetas das colmeias - $apiary';
  }

  @override
  String get hiveLabelsError =>
      'Não foi possível preparar o PDF. Tente de novo.';

  @override
  String get quickRecordTitle => 'Registro rápido';

  @override
  String get quickRecordInspection => 'Revisão';

  @override
  String get quickRecordFeeding => 'Alimentação';

  @override
  String get quickRecordTreatment => 'Tratamento';

  @override
  String get quickRecordHarvest => 'Colheita';

  @override
  String get quickRecordNote => 'Nota';

  @override
  String get quickRecordExpense => 'Despesa';

  @override
  String get quickRecordComingSoon => 'Este tipo de registro chega em breve.';

  @override
  String get signInSendCode => 'Enviar código';

  @override
  String get signInSending => 'Enviando…';

  @override
  String signInCodeMessage(String email) {
    return 'Enviamos um código de 6 dígitos para $email.';
  }

  @override
  String get signInCodeFieldLabel => 'Código de 6 dígitos';

  @override
  String get signInVerify => 'Entrar';

  @override
  String get signInVerifying => 'Verificando…';

  @override
  String get signInResend => 'Reenviar código';

  @override
  String signInResendIn(int seconds) {
    return 'Reenviar código ($seconds s)';
  }

  @override
  String get signInCodeResent => 'Um novo código está a caminho.';

  @override
  String get authErrorNetwork =>
      'Não foi possível conectar. Verifique sua internet e tente de novo.';

  @override
  String get authErrorInvalidEmail => 'Digite um e-mail válido.';

  @override
  String get authErrorInvalidCode =>
      'O código está errado ou expirou. Tente de novo ou peça um novo código.';

  @override
  String get authErrorTooManyRequests =>
      'Muitas tentativas. Espere um pouco e tente de novo.';

  @override
  String get authErrorUnknown => 'Algo deu errado. Tente de novo.';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsSystemDefault => 'Sistema';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsColorMode => 'Tema';

  @override
  String get settingsColorModeLight => 'Claro';

  @override
  String get settingsColorModeDark => 'Escuro';

  @override
  String get settingsColorModeSun => 'Sol';

  @override
  String get settingsAccount => 'Conta';

  @override
  String settingsSignedInAs(String email) {
    return 'Conectado como $email';
  }

  @override
  String get settingsPrivacyPolicy => 'Política de privacidade';

  @override
  String settingsVersion(String version) {
    return 'Versão $version';
  }

  @override
  String get settingsSignOut => 'Sair';

  @override
  String get settingsSignOutConfirmTitle => 'Sair?';

  @override
  String get settingsSignOutConfirmMessage =>
      'Para entrar de novo, você vai precisar de um novo código enviado ao seu e-mail, o que exige internet.';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionDelete => 'Excluir';

  @override
  String get actionRetry => 'Tentar de novo';

  @override
  String get actionUndo => 'Desfazer';

  @override
  String onboardingStepCounter(int current, int total) {
    return 'Passo $current de $total';
  }

  @override
  String get onboardingContinue => 'Continuar';

  @override
  String get onboardingFinish => 'Criar negócio';

  @override
  String get onboardingFinishing => 'Configurando…';

  @override
  String get onboardingCountrySearch => 'Buscar países';

  @override
  String get onboardingCountrySuggested => 'Sugerido para seu aparelho';

  @override
  String get onboardingCountryAll => 'Todos os países';

  @override
  String get onboardingCountryNoMatch => 'Nenhum país corresponde à sua busca.';

  @override
  String get onboardingNameMessage =>
      'Este nome aparece nos seus registros e relatórios.';

  @override
  String get onboardingNameLabel => 'Nome do negócio';

  @override
  String get onboardingNameHint => 'ex.: Apiário Favo de Ouro';

  @override
  String get onboardingHiveCountTitle => 'Quantas colmeias você tem?';

  @override
  String get onboardingHiveCountMessage =>
      'Um número aproximado basta; vamos sugerir como acompanhá-las. As colmeias você adiciona depois.';

  @override
  String get hiveCountRangeNone => 'Nenhuma ainda';

  @override
  String get hiveCountRangeUpTo10 => '1–10';

  @override
  String get hiveCountRangeUpTo50 => '11–50';

  @override
  String get hiveCountRangeUpTo200 => '51–200';

  @override
  String get hiveCountRangeOver200 => 'Mais de 200';

  @override
  String get onboardingApiaryTitle => 'Adicione seu primeiro apiário';

  @override
  String get onboardingApiaryMessage =>
      'O apiário é onde ficam suas colmeias. Salvá-lo não precisa de internet.';

  @override
  String get onboardingApiarySave => 'Salvar apiário';

  @override
  String get onboardingApiarySkip => 'Pular por enquanto';

  @override
  String get onboardingLoading => 'Carregando seu negócio';

  @override
  String get onboardingLoadErrorTitle =>
      'Não foi possível carregar seu negócio';

  @override
  String get onboardingErrorNetwork =>
      'Não foi possível conectar. Verifique sua internet e tente de novo.';

  @override
  String get onboardingErrorUnknown => 'Algo deu errado. Tente de novo.';

  @override
  String get devMenuTitle => 'Menu do desenvolvedor';

  @override
  String get componentGalleryTitle => 'Galeria de componentes';

  @override
  String get componentGalleryDescription =>
      'Componentes do sistema de design em quatro temas';

  @override
  String get galleryThemeLight => 'Claro';

  @override
  String get galleryThemeDark => 'Escuro';

  @override
  String get galleryThemeSun => 'Sol';

  @override
  String get galleryThemeGlove => 'Luva';

  @override
  String get galleryBigButton => 'Botão grande';

  @override
  String get galleryChoiceChipGroup => 'Chips de escolha';

  @override
  String get galleryBigStepper => 'Contador grande';

  @override
  String get galleryStatusBadge => 'Selo de situação';

  @override
  String get galleryHiveTile => 'Bloco de colmeia';

  @override
  String get galleryEmptyState => 'Estado vazio';

  @override
  String get gallerySectionCard => 'Cartão de seção';

  @override
  String get galleryStrengthDots => 'Pontos de força';

  @override
  String get galleryTimelineTile => 'Linha do histórico';

  @override
  String get gallerySampleApiaryHill => 'Morro Alto';

  @override
  String get gallerySampleApiaryPlain => 'Beira-Rio';

  @override
  String get gallerySampleStartInspection => 'Iniciar revisão';

  @override
  String get gallerySampleAddPhoto => 'Adicionar foto';

  @override
  String get gallerySampleSave => 'Salvar';

  @override
  String get gallerySampleQueen => 'Rainha';

  @override
  String get gallerySampleQueenSeen => 'Vista';

  @override
  String get gallerySampleEggs => 'Há ovos';

  @override
  String get gallerySampleNone => 'Nenhum';

  @override
  String get gallerySampleActions => 'Ações feitas';

  @override
  String get gallerySampleSuperAdded => 'Melgueira colocada';

  @override
  String get gallerySampleFrameAdded => 'Quadro colocado';

  @override
  String get gallerySampleFed => 'Alimentada';

  @override
  String get gallerySampleBeeFrames => 'Quadros com abelhas';

  @override
  String get gallerySampleBroodFrames => 'Quadros de cria';

  @override
  String get gallerySampleStrong => 'Forte';

  @override
  String get gallerySampleWeak => 'Fraca';

  @override
  String get gallerySampleQueenless => 'Órfã';

  @override
  String get gallerySampleTask => 'Tarefa';

  @override
  String get gallerySampleNoApiaries => 'Ainda não há apiários';

  @override
  String get gallerySampleNoApiariesMessage =>
      'Um apiário agrupa suas colmeias pelo lugar onde estão; adicione o primeiro para começar.';

  @override
  String get gallerySampleAddApiary => 'Adicione seu primeiro apiário';

  @override
  String get gallerySampleLastInspection => 'Última revisão';

  @override
  String get gallerySampleLastInspectionBody =>
      'há 3 dias · 7 quadros com abelhas · rainha vista';

  @override
  String get gallerySampleUntitledCard =>
      'Um cartão também pode não ter título; o conteúdo começa direto.';

  @override
  String get gallerySnackBar => 'Snackbar';

  @override
  String get galleryCriticalLockCard => 'Cartão de bloqueio crítico';

  @override
  String get gallerySampleInspectionSaved => 'Revisão salva';

  @override
  String get gallerySampleWithdrawalTitle => 'Em período de carência.';

  @override
  String get gallerySampleWithdrawalMessage =>
      'Não coloque melgueira nesta colmeia por mais 12 dias.';

  @override
  String get syncStatusSynced => 'Sincronizado';

  @override
  String syncStatusPending(int count) {
    return '$count pendentes';
  }

  @override
  String get syncStatusError => 'Erro';

  @override
  String syncStatusSemantics(String status) {
    return 'Sincronização: $status';
  }

  @override
  String get syncTitle => 'Sincronização';

  @override
  String get syncSyncedMessage =>
      'Todos os registros deste celular chegaram ao servidor.';

  @override
  String syncPendingMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count registros estão esperando para ser enviados.',
      one: '1 registro está esperando para ser enviado.',
    );
    return '$_temp0';
  }

  @override
  String get syncProblemOffline =>
      'Não foi possível alcançar o servidor. A sincronização vai tentar de novo quando você estiver on-line.';

  @override
  String get syncProblemFailed =>
      'A sincronização não terminou. Tente de novo um pouco mais tarde.';

  @override
  String get syncProblemUpgrade =>
      'Esta versão não consegue mais sincronizar. Atualize o app.';

  @override
  String syncLastSynced(String time) {
    return 'Última sincronização $time';
  }

  @override
  String get syncNow => 'Sincronizar agora';

  @override
  String get syncRunning => 'Sincronizando…';

  @override
  String syncRejectedTitle(int count) {
    return 'Não enviados ($count)';
  }

  @override
  String get syncRejectedMessage =>
      'O servidor não aceitou estes registros. Todo o resto continua sincronizando.';

  @override
  String syncRejectedSubtitle(String reason, String date) {
    return '$reason · $date';
  }

  @override
  String get syncRejectionForbidden =>
      'Você não tem permissão para alterar este registro';

  @override
  String get syncRejectionConflict =>
      'Conflita com outro registro (ex.: a mesma etiqueta)';

  @override
  String get syncRejectionMissingReference =>
      'Falta no servidor um registro do qual ele depende';

  @override
  String get syncRejectionUnsupported =>
      'Este tipo de registro não é sincronizado';

  @override
  String get syncRejectionInvalid => 'O registro tem dados inválidos';

  @override
  String get syncRejectionUnknown => 'Motivo desconhecido';

  @override
  String get syncTableOrganizations => 'Negócio';

  @override
  String get syncTableMemberships => 'Participação';

  @override
  String get syncTableApiaries => 'Apiário';

  @override
  String get syncTableQueens => 'Rainha';

  @override
  String get syncTableHives => 'Colmeia';

  @override
  String get syncTableHiveStatusEvents => 'Mudança de situação da colmeia';

  @override
  String get syncTableHiveLocationHistory => 'Transferência de colmeia';

  @override
  String get initialSyncTitle => 'Baixando seus registros';

  @override
  String get initialSyncMessage =>
      'Os registros do seu negócio estão sendo baixados para este celular. Isso acontece só uma vez; depois o app funciona também sem internet.';

  @override
  String initialSyncRows(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString registros baixados',
      one: '1 registro baixado',
    );
    return '$_temp0';
  }

  @override
  String get initialSyncFailedTitle => 'O download não terminou';

  @override
  String get suggestedValue => 'Do último registro';

  @override
  String get stepperNoValue => 'Não definido';

  @override
  String get hiveStartInspection => 'Iniciar revisão';

  @override
  String inspectionTitle(String number) {
    return 'Revisar colmeia $number';
  }

  @override
  String inspectionPrevious(String date) {
    return 'Última revisão $date';
  }

  @override
  String get inspectionFirst => 'Primeira revisão';

  @override
  String get inspectionSuggestedLegend =>
      'Os valores apagados são da última revisão. Mude o que estiver diferente; o resto é salvo como está.';

  @override
  String get inspectionDraftSaved => 'Guardado como rascunho neste celular';

  @override
  String get inspectionRestart => 'Recomeçar';

  @override
  String get inspectionQueen => 'Rainha';

  @override
  String get queenStateSeen => 'Vista';

  @override
  String get queenStateEggs => 'Ovos vistos';

  @override
  String get queenStateNone => 'Nenhum';

  @override
  String get inspectionFrames => 'Quadros';

  @override
  String get inspectionBeeFrames => 'Com abelhas';

  @override
  String get inspectionBroodFrames => 'Com cria';

  @override
  String get inspectionHoneyFrames => 'Com mel';

  @override
  String get inspectionTemperament => 'Temperamento';

  @override
  String get temperamentCalm => 'Mansa';

  @override
  String get temperamentNervous => 'Nervosa';

  @override
  String get inspectionSwarmSigns => 'Sinais de enxameação';

  @override
  String get inspectionQueenCells => 'Realeiras';

  @override
  String get queenCellsNone => 'Nenhuma';

  @override
  String get queenCellsSwarm => 'Enxameação';

  @override
  String get queenCellsSupersedure => 'Substituição';

  @override
  String get queenCellsEmergency => 'Emergência';

  @override
  String get inspectionDisease => 'Suspeita de doença';

  @override
  String get inspectionAnswerNo => 'Não';

  @override
  String get inspectionAnswerYes => 'Sim';

  @override
  String get inspectionActions => 'Feito hoje';

  @override
  String get inspectionActionSuperAdded => 'Melgueira colocada';

  @override
  String get inspectionActionSuperRemoved => 'Melgueira retirada';

  @override
  String get inspectionActionFramesAdded => 'Quadros colocados';

  @override
  String get inspectionActionFoundationAdded => 'Cera alveolada colocada';

  @override
  String get inspectionActionFed => 'Alimentada';

  @override
  String get inspectionActionExcluderFitted => 'Excluidor colocado';

  @override
  String get inspectionActionEntranceReduced => 'Alvado reduzido';

  @override
  String get inspectionActionPollenTrapFitted => 'Coletor de pólen colocado';

  @override
  String get inspectionSave => 'Salvar';

  @override
  String inspectionSaved(String number) {
    return 'Revisão da colmeia $number salva';
  }

  @override
  String get inspectionRemindPrompt => 'Lembrar em';

  @override
  String inspectionRemindDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dias',
      one: '1 dia',
    );
    return '$_temp0';
  }

  @override
  String get inspectionLoadError => 'Não foi possível abrir a revisão';

  @override
  String get syncTableInspections => 'Revisão';

  @override
  String get signInTagline =>
      'Seu caderno de apiário, no bolso. Funciona sem internet.';

  @override
  String get signInEmailLabelLong => 'Seu e-mail';

  @override
  String get signInEmailHelper =>
      'Sem senha. Vamos enviar um código de 6 dígitos para o seu e-mail.';

  @override
  String get signInEmailHint => 'nome@exemplo.com';

  @override
  String get signInCodeHeading => 'Digite o código do seu e-mail';

  @override
  String get signInPasteCode => 'Colar código';

  @override
  String get signInCodeSpamHint =>
      'Não chegou? Veja a pasta de spam. Depois de entrar uma vez, o app abre também sem internet.';

  @override
  String get signInChangeEmail => 'Trocar e-mail';

  @override
  String get onboardingLanguageCountryTitle => 'Idioma e país';

  @override
  String get onboardingAppLanguage => 'Idioma do app';

  @override
  String get onboardingDeviceLanguage => 'Idioma do aparelho';

  @override
  String get onboardingCountryLabel => 'País onde você cria abelhas';

  @override
  String get onboardingCountryChoose => 'Escolha um país';

  @override
  String onboardingRegionFeaturesTitle(String country) {
    return 'Ativado para $country';
  }

  @override
  String onboardingRegionDefaultsTitle(String country) {
    return 'Configurações para $country';
  }

  @override
  String get onboardingRegionDefaultsMessage =>
      'Unidades e moeda seguem o seu país.';

  @override
  String get onboardingBusinessTitle => 'Conte sobre o seu negócio';

  @override
  String get regionFeatureAks => 'dados do AKS e do registro do negócio';

  @override
  String get regionFeatureSubsidies => 'lembretes de subsídio por colmeia';

  @override
  String get regionFeatureRegulations => 'resumos da legislação';

  @override
  String get regionFeatureTrDrugList => 'lista de medicamentos licenciados';

  @override
  String get regionFeatureTrFlora => 'calendário de floradas da Turquia';

  @override
  String get regionFeatureTrMigrationDocs =>
      'documentos de apicultura migratória';

  @override
  String get unitKilogram => 'kg';

  @override
  String get unitPound => 'lb';

  @override
  String get unitCelsius => '°C';

  @override
  String get unitFahrenheit => '°F';

  @override
  String get hemisphereNorthern => 'Hemisfério Norte';

  @override
  String get hemisphereSouthern => 'Hemisfério Sul';

  @override
  String get relativeToday => 'hoje';

  @override
  String get relativeYesterday => 'ontem';

  @override
  String relativeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'há $count dias',
      one: 'há 1 dia',
    );
    return '$_temp0';
  }

  @override
  String apiariesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count apiários',
      one: '1 apiário',
    );
    return '$_temp0';
  }

  @override
  String apiariesSummary(String apiaries, String hives) {
    return '$apiaries · $hives';
  }

  @override
  String get apiaryHiveCountUnit => 'colmeias';

  @override
  String get hiveLayoutGridShort => 'Grade';

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
  String get hiveCardKind => 'Colmeia';

  @override
  String get hiveLastInspection => 'Última revisão';

  @override
  String get hiveLastInspectionNone => 'Nenhuma ainda';

  @override
  String get hiveBulkPreviewTitle => 'Prévia';

  @override
  String hiveBulkSaveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Criar $count colmeias',
      one: 'Criar 1 colmeia',
    );
    return '$_temp0';
  }

  @override
  String get listEllipsis => '…';

  @override
  String get scanOfflineHint => 'Não precisa de internet · vibra ao ler';

  @override
  String get titleSeparator => ' ·';

  @override
  String get settingsGeneral => 'Geral';

  @override
  String get settingsGloveMode => 'Modo luva';

  @override
  String get settingsGloveModeHint =>
      'Todos os alvos de toque crescem um nível.';

  @override
  String get settingsCountry => 'País';

  @override
  String settingsCountryValue(String name, String code) {
    return '$name · $code';
  }

  @override
  String get moreSectionApiary => 'Apiário';

  @override
  String get moreSectionBusiness => 'Negócio';

  @override
  String get moreSectionHelp => 'Ajuda';

  @override
  String get galleryFormFields => 'Campos de formulário';

  @override
  String get galleryRadioCardGroup => 'Cartões de escolha';

  @override
  String get gallerySegmentedTabs => 'Seletor de visualização';

  @override
  String get galleryListGroup => 'Lista agrupada';

  @override
  String get galleryNoteCard => 'Cartão de nota';

  @override
  String get gallerySummaryTile => 'Bloco de resumo';

  @override
  String get galleryActionTile => 'Blocos de ação';

  @override
  String get galleryAppLogo => 'Logo e favo';

  @override
  String get gallerySampleApiaryName => 'Nome do apiário';

  @override
  String get gallerySampleFirstNumber => 'Primeiro número';

  @override
  String get gallerySampleNoteHint =>
      'Sem senha. Vamos enviar um código de 6 dígitos para o seu e-mail.';

  @override
  String get gallerySampleGrid => 'Grade';

  @override
  String get gallerySampleList => 'Lista';

  @override
  String get gallerySampleMap => 'Mapa';

  @override
  String get gallerySampleInspections => 'Revisões';

  @override
  String get gallerySampleNoteTitle => 'Ativado para a Turquia';

  @override
  String get gallerySampleNoteMessage =>
      'Dados do AKS e do registro do negócio, resumos da legislação e a lista de medicamentos licenciados.';

  @override
  String get gallerySampleLastInspectionValue => 'há 3 dias';

  @override
  String get gallerySampleFrames => '8 quadros com abelhas · 5 de cria';

  @override
  String get gallerySampleActiveTreatment => 'Tratamento ativo';

  @override
  String get gallerySampleDaysLeft => 'faltam 12 dias';

  @override
  String get syncTableMedia => 'Foto ou nota de voz';

  @override
  String get mediaTakePhoto => 'Tirar foto';

  @override
  String get mediaRecordVoice => 'Gravar nota de voz';

  @override
  String get mediaStopRecording => 'Parar gravação';

  @override
  String mediaRecording(String duration) {
    return 'Gravando · $duration';
  }

  @override
  String mediaPhotoAdded(String number) {
    return 'Foto adicionada à colmeia $number';
  }

  @override
  String mediaVoiceAdded(String number) {
    return 'Nota de voz adicionada à colmeia $number';
  }

  @override
  String get mediaCameraDenied =>
      'Sem permissão da câmera. Você pode permitir nas configurações do celular.';

  @override
  String get mediaMicrophoneDenied =>
      'Sem permissão do microfone. Você pode permitir nas configurações do celular.';

  @override
  String get mediaCaptureFailed => 'Não foi possível salvar. Tente de novo.';

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
    return 'Salvo com a revisão: $items';
  }

  @override
  String get timelinePhoto => 'Foto';

  @override
  String get timelineVoiceNote => 'Nota de voz';

  @override
  String get mediaOpenPhoto => 'Abrir foto';

  @override
  String get mediaDownloadPhoto =>
      'A foto não está neste celular. Toque para baixar.';

  @override
  String mediaPlay(String duration) {
    return 'Ouvir · $duration';
  }

  @override
  String get mediaStopPlaying => 'Parar';

  @override
  String get mediaNotUploaded =>
      'Ainda não enviada. Chega quando o celular que a tirou estiver on-line.';

  @override
  String get mediaDownloadOffline =>
      'Não foi possível baixar. Verifique sua conexão com a internet.';

  @override
  String get mediaDownloadFailed => 'Não foi possível baixar.';

  @override
  String get mediaNotFound => 'Foto não encontrada';

  @override
  String get settingsData => 'Dados';

  @override
  String get settingsMediaWifiOnly => 'Enviar fotos só pelo Wi‑Fi';

  @override
  String get settingsMediaWifiOnlyHint =>
      'Fotos e notas de voz não vão usar dados móveis.';

  @override
  String settingsPendingUploads(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos esperando envio',
      one: '1 arquivo esperando envio',
    );
    return '$_temp0';
  }

  @override
  String get hiveQueenNone => 'Não registrada';

  @override
  String get hiveQueenNoneHint => 'Toque para adicionar uma rainha';

  @override
  String queenMarkColorName(String color) {
    String _temp0 = intl.Intl.selectLogic(color, {
      'white': 'Branca',
      'yellow': 'Amarela',
      'red': 'Vermelha',
      'green': 'Verde',
      'blue': 'Azul',
      'other': 'Desconhecida',
    });
    return '$_temp0';
  }

  @override
  String get queenYearUnknown => 'Ano desconhecido';

  @override
  String get queenUnmarked => 'Sem marcação';

  @override
  String queenAge(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: '$age anos',
      one: '1 ano',
      zero: 'Menos de um ano',
    );
    return '$_temp0';
  }

  @override
  String get queenSourceOwnRearing => 'Criação própria';

  @override
  String get queenSourcePurchased => 'Comprada';

  @override
  String get queenSourceCertifiedBreeder => 'Criador certificado';

  @override
  String get queenSource => 'Origem';

  @override
  String get queenMother => 'Rainha mãe';

  @override
  String get queenMotherUnknown => 'Desconhecida';

  @override
  String get queenBreed => 'Raça';

  @override
  String get queenBreedHint => 'ex.: Carniça';

  @override
  String get queenBreedLine => 'Linhagem';

  @override
  String get queenBreedLineHint => 'ex.: Buckfast';

  @override
  String get queenWing => 'Asa';

  @override
  String get queenWingClipped => 'Cortada';

  @override
  String get queenWingIntact => 'Não cortada';

  @override
  String get queenYear => 'Ano';

  @override
  String get queenYearHelper => 'Ano de nascimento ou compra';

  @override
  String get queenMark => 'Cor da marcação';

  @override
  String queenMarkSuggestion(String year, String color) {
    return 'Cor de $year: $color';
  }

  @override
  String get queenUnknown => 'Não informado';

  @override
  String get queenEdit => 'Editar rainha';

  @override
  String get queenReplace => 'Trocar rainha';

  @override
  String get queenGive => 'Adicionar rainha';

  @override
  String get queenNoneTitle => 'Nenhuma rainha registrada';

  @override
  String get queenNoneMessage =>
      'Registre a rainha que você deu a esta colmeia; ano, cor e linhagem aparecem aqui.';

  @override
  String queenFormNewTitle(String number) {
    return 'Nova rainha · Colmeia $number';
  }

  @override
  String get queenFormEditTitle => 'Editar rainha';

  @override
  String get queenFormSave => 'Salvar';

  @override
  String queenGiven(String number) {
    return 'A colmeia $number tem uma nova rainha';
  }

  @override
  String get oldQueensTitle => 'Rainhas velhas';

  @override
  String oldQueensIntro(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other:
          'Rainhas de colmeias ativas com $age anos ou mais. Planeje a troca.',
      one: 'Rainhas de colmeias ativas com 1 ano ou mais. Planeje a troca.',
    );
    return '$_temp0';
  }

  @override
  String get oldQueensEmptyTitle => 'Nenhuma rainha velha';

  @override
  String oldQueensEmptyMessage(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other:
          'As rainhas das colmeias ativas têm menos de $age anos ou não têm o ano informado.',
      one: 'As rainhas das colmeias ativas têm menos de 1 ano ou não têm o ano informado.',
    );
    return '$_temp0';
  }

  @override
  String get syncTableMiteCounts => 'Contagem de varroa';

  @override
  String get varroaMethodSugarRoll => 'Açúcar de confeiteiro';

  @override
  String get varroaMethodAlcoholWash => 'Lavagem com álcool';

  @override
  String get varroaMethodStickyBoard => 'Bandeja adesiva';

  @override
  String varroaFormTitle(String number) {
    return 'Varroa · Colmeia $number';
  }

  @override
  String get varroaMethod => 'Método';

  @override
  String get varroaSampleBees => 'Abelhas da amostra';

  @override
  String get varroaBoardDays => 'Dias com bandeja';

  @override
  String get varroaMites => 'Ácaros contados';

  @override
  String get varroaBoardMites => 'Ácaros caídos';

  @override
  String get varroaSave => 'Salvar';

  @override
  String varroaSaved(String number) {
    return 'Contagem de varroa salva para a colmeia $number';
  }

  @override
  String varroaPercent(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 1,
        );
    final String valueString = valueNumberFormat.format(value);

    return '$valueString%';
  }

  @override
  String varroaPerDay(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 1,
        );
    final String valueString = valueNumberFormat.format(value);

    return '$valueString ácaros/dia';
  }

  @override
  String get varroaInfestation => 'Infestação';

  @override
  String get varroaDailyDrop => 'Queda diária';

  @override
  String get varroaReached => 'No limite · planeje o tratamento';

  @override
  String get varroaBelow => 'Abaixo do limite';

  @override
  String varroaThresholdNote(String threshold) {
    return 'Limite $threshold (das Configurações).';
  }

  @override
  String get hiveVarroa => 'Varroa';

  @override
  String get hiveVarroaNone => 'Ainda sem contagem';

  @override
  String get hiveVarroaReached => 'Limite atingido';

  @override
  String get hiveVarroaCount => 'Contar varroa';

  @override
  String varroaChartTitle(String apiary) {
    return '$apiary · contagens recentes';
  }

  @override
  String varroaChartThreshold(String threshold) {
    return 'limite $threshold';
  }

  @override
  String get varroaChartEmpty =>
      'Ainda não há contagens com açúcar ou álcool. Adicione uma pela ficha de uma colmeia.';

  @override
  String varroaChartBar(String day, String value) {
    return '$day: $value';
  }

  @override
  String varroaChartSemantics(String threshold, String bars) {
    return 'Infestação média por dia, limite $threshold: $bars';
  }

  @override
  String get settingsVarroa => 'Varroa';

  @override
  String get settingsVarroaPercent => 'Limite de infestação';

  @override
  String get settingsVarroaPerDay => 'Limite da bandeja';

  @override
  String get settingsVarroaHint =>
      'Um aviso aparece quando uma contagem atinge o limite. Salvo só neste celular.';

  @override
  String get syncTableRefDrugs => 'Lista de medicamentos';

  @override
  String get syncTableDrugs => 'Medicamento';

  @override
  String get syncTableTreatments => 'Tratamento';

  @override
  String get syncTableFeedings => 'Alimentação';

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
  String get drugIngredientLacticAcid => 'Ácido lático';

  @override
  String get drugIngredientOther => 'Outro';

  @override
  String get drugUnitStrip => 'tira';

  @override
  String get drugUnitMl => 'ml';

  @override
  String get drugUnitG => 'g';

  @override
  String get drugUnitDose => 'dose';

  @override
  String get hiveTreat => 'Aplicar tratamento';

  @override
  String get treatmentFormTitle => 'Tratamento';

  @override
  String treatmentScopeHive(String number) {
    return 'Colmeia $number';
  }

  @override
  String treatmentScopeApiary(int count) {
    return 'Apiário inteiro · $count';
  }

  @override
  String get treatmentChooseDrug => 'Escolher medicamento';

  @override
  String get treatmentChangeDrug => 'Trocar';

  @override
  String treatmentDrugIngredient(String ingredient) {
    return 'Princípio ativo: $ingredient';
  }

  @override
  String treatmentDrugLicense(String number) {
    return 'registro $number';
  }

  @override
  String get treatmentDrugCustom => 'seu medicamento';

  @override
  String get treatmentAddDrug => 'Adicionar novo medicamento';

  @override
  String get drugInfoOpen => 'Informações do medicamento';

  @override
  String get drugInfoSourceTitle =>
      'Fonte: Ministério da Agricultura e Florestas da Turquia';

  @override
  String get drugInfoSourceMessage =>
      'Isto vem da bula aprovada pelo Ministério e é mostrado em turco como foi publicado. Leia o rótulo antes de usar; em caso de dúvida, consulte um veterinário.';

  @override
  String get drugInfoActiveIngredient => 'Princípio ativo';

  @override
  String get drugInfoIndications => 'Indicado para';

  @override
  String get drugInfoUsage => 'Uso e frequência';

  @override
  String get drugInfoUsageMethod => 'Modo de aplicação';

  @override
  String get drugInfoUsageMethodAndDose => 'Aplicação e dose';

  @override
  String get drugInfoUsageDiagnosis => 'Para diagnóstico';

  @override
  String get drugInfoUsageDose => 'Dose';

  @override
  String get drugInfoUsageFrequency => 'Frequência';

  @override
  String get drugInfoUsageDuration => 'Duração';

  @override
  String get drugInfoUsageOther => 'Observação';

  @override
  String get drugInfoSuitablePeriods => 'Períodos adequados';

  @override
  String get drugInfoAvoidPeriods => 'Não usar';

  @override
  String get drugInfoWithdrawal => 'Período de carência';

  @override
  String get drugInfoWarnings => 'Advertências';

  @override
  String get drugInfoClose => 'Fechar';

  @override
  String get treatmentBatchNo => 'Nº do lote';

  @override
  String get treatmentStartedOn => 'Início';

  @override
  String treatmentDose(String unit) {
    return 'Dose por colmeia ($unit)';
  }

  @override
  String treatmentDoseTotal(String total, String unit) {
    return 'Total $total $unit';
  }

  @override
  String get treatmentWithdrawalDays => 'Carência (dias)';

  @override
  String get treatmentRemoval => 'Retirada';

  @override
  String get treatmentRemovalNone => 'Nenhuma';

  @override
  String get treatmentRemovalChange => 'Lembrete nessa manhã; toque para mudar';

  @override
  String get treatmentRemovalSingle => 'Aplicação única; toque para definir';

  @override
  String get treatmentRemovalClear => 'Sem retirada (aplicação única)';

  @override
  String get treatmentNoSuper => 'Sem melgueira';

  @override
  String treatmentNoSuperUntil(String date) {
    return 'Até $date';
  }

  @override
  String treatmentNoSuperAfterRemoval(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'retirada + $days dias de carência',
      one: 'retirada + 1 dia de carência',
      zero: 'sem carência após a retirada',
    );
    return '$_temp0';
  }

  @override
  String treatmentNoSuperAfterStart(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'início + $days dias de carência',
      one: 'início + 1 dia de carência',
      zero: 'sem carência',
    );
    return '$_temp0';
  }

  @override
  String treatmentSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Salvar em $count colmeias',
      one: 'Salvar',
    );
    return '$_temp0';
  }

  @override
  String treatmentSaved(String number) {
    return 'Tratamento salvo para a colmeia $number';
  }

  @override
  String treatmentSavedMany(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tratamento salvo para $count colmeias',
      one: 'Tratamento salvo para 1 colmeia',
    );
    return '$_temp0';
  }

  @override
  String get drugFormTitle => 'Novo medicamento';

  @override
  String get drugName => 'Nome';

  @override
  String get drugActiveIngredient => 'Princípio ativo';

  @override
  String get drugDoseUnit => 'Unidade de dose';

  @override
  String get drugWithdrawalDays => 'Carência no rótulo (dias)';

  @override
  String get drugSave => 'Adicionar medicamento';

  @override
  String get withdrawalLockTitle => 'Em período de carência.';

  @override
  String withdrawalLockMessage(String number, String product, String date) {
    return 'A colmeia $number está em tratamento com $product. Nenhuma melgueira deve ser colocada antes de $date; o mel deste período pode ter resíduos.';
  }

  @override
  String get withdrawalDaysLeft => 'Faltam';

  @override
  String withdrawalDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dias',
      one: '1 dia',
    );
    return '$_temp0';
  }

  @override
  String get withdrawalApplied => 'Aplicado';

  @override
  String get withdrawalReasonPrompt =>
      'Para salvar mesmo assim, escolha um motivo';

  @override
  String get withdrawalReasonRemovedEarly => 'Medicamento retirado antes';

  @override
  String get withdrawalReasonNotForSale =>
      'A melgueira não será vendida (consumo próprio/alimento)';

  @override
  String get withdrawalCancel => 'Cancelar, não colocar melgueira';

  @override
  String get withdrawalProceed => 'Salvar mesmo assim';

  @override
  String inspectionWithdrawalOverride(String reason) {
    return 'Melgueira colocada no período de carência: $reason';
  }

  @override
  String timelineTreatment(String product) {
    return 'Tratamento · $product';
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
      other: '$days dias de carência',
      one: '1 dia de carência',
    );
    return '$_temp0';
  }

  @override
  String get hiveActiveTreatment => 'Tratamento ativo';

  @override
  String get hiveActiveTreatmentNone => 'Nenhum';

  @override
  String hiveActiveTreatmentLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'faltam $days dias',
      one: 'falta 1 dia',
    );
    return '$_temp0';
  }

  @override
  String hiveActiveTreatmentDetail(String ingredient) {
    return '$ingredient · sem melgueira';
  }

  @override
  String get treatmentRotationTitle => 'Mesmo princípio ativo.';

  @override
  String treatmentRotationMessage(int count, String ingredient) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Os últimos $count tratamentos deste apiário também foram com $ingredient. Considere outro princípio ativo para limitar a resistência.',
    );
    return '$_temp0';
  }

  @override
  String get treatmentPrescriptionAdd =>
      'Adicionar foto da receita / nota fiscal';

  @override
  String get treatmentPrescriptionAdded => 'Foto da receita adicionada';

  @override
  String get treatmentPrescriptionRemove => 'Remover';

  @override
  String get reminderChannelName => 'Lembretes';

  @override
  String get treatmentReminderDenied =>
      'As notificações estão desligadas; nenhum lembrete de retirada foi criado.';

  @override
  String get hiveFeed => 'Alimentar';

  @override
  String get feedingFormTitle => 'Alimentação';

  @override
  String feedingScopeHive(String number) {
    return 'Colmeia $number';
  }

  @override
  String feedingScopeApiary(int count) {
    return 'Apiário inteiro · $count';
  }

  @override
  String get feedingKind => 'Tipo';

  @override
  String get feedingKindSyrup1to1 => 'Xarope 1:1 · estimulante';

  @override
  String get feedingKindSyrup2to1 => 'Xarope 2:1 · inverno';

  @override
  String get feedingKindBeeCake => 'Pasta energética';

  @override
  String get feedingKindPollenSubstitute => 'Substituto de pólen';

  @override
  String feedingAmount(String unit) {
    return 'Por colmeia ($unit)';
  }

  @override
  String get feedingSuperHiveTitle => 'Esta colmeia tem melgueira.';

  @override
  String get feedingSuperHiveMessage => 'O xarope pode ir para o mel.';

  @override
  String feedingSuperSkippedTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmeias têm melgueira',
      one: '1 colmeia tem melgueira',
    );
    return '$_temp0';
  }

  @override
  String feedingSuperSkippedMessage(String numbers) {
    return '($numbers). Deixadas de fora para o xarope não ir para o mel.';
  }

  @override
  String get feedingPrepare => 'Para preparar';

  @override
  String feedingPrepareCount(int count, String amount, String unit) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmeias × $amount $unit',
      one: '1 colmeia × $amount $unit',
    );
    return '$_temp0';
  }

  @override
  String feedingTotalSyrup(String amount, String unit) {
    return '$amount $unit de xarope';
  }

  @override
  String feedingTotalBeeCake(String amount, String unit) {
    return '$amount $unit de pasta energética';
  }

  @override
  String feedingTotalPollenSubstitute(String amount, String unit) {
    return '$amount $unit de substituto de pólen';
  }

  @override
  String get feedingSugar => 'Açúcar';

  @override
  String get feedingWater => 'Água';

  @override
  String feedingApprox(String amount, String unit) {
    return '≈ $amount $unit';
  }

  @override
  String feedingSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Salvar em $count colmeias',
      one: 'Salvar',
      zero: 'Nenhuma colmeia para alimentar',
    );
    return '$_temp0';
  }

  @override
  String feedingSaved(String number) {
    return 'Alimentação salva para a colmeia $number';
  }

  @override
  String feedingSavedMany(int count) {
    return 'Alimentação salva para $count colmeias';
  }

  @override
  String get unitLiter => 'L';

  @override
  String get unitGallon => 'gal';

  @override
  String get syncTableTasks => 'Tarefa';

  @override
  String get tasksTabToday => 'Hoje';

  @override
  String get tasksTabWeek => 'Esta semana';

  @override
  String get tasksTabApiary => 'Por apiário';

  @override
  String get tasksAdd => 'Adicionar tarefa';

  @override
  String tasksOverdue(int count) {
    return 'Atrasadas · $count';
  }

  @override
  String tasksDayGroup(String day, int count) {
    return '$day · $count';
  }

  @override
  String get tasksToday => 'Hoje';

  @override
  String get tasksTomorrow => 'Amanhã';

  @override
  String get tasksNoApiary => 'Sem apiário';

  @override
  String tasksApiaryGroup(String apiary, int count) {
    return '$apiary · $count';
  }

  @override
  String get tasksEmptyTodayTitle => 'Nada para fazer hoje';

  @override
  String get tasksEmptyWeekTitle => 'Nenhuma tarefa esta semana';

  @override
  String get tasksEmptyAddHint =>
      'Adicione uma nova tarefa com + no canto superior direito.';

  @override
  String get tasksLoadError => 'Não foi possível carregar as tarefas.';

  @override
  String tasksWeekDaySemantics(String day, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tarefas',
      one: '1 tarefa',
      zero: 'sem tarefas',
    );
    return '$day, $_temp0';
  }

  @override
  String taskOverdueDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dias de atraso',
      one: '1 dia de atraso',
    );
    return '$_temp0';
  }

  @override
  String get taskSourceInspection => 'da revisão';

  @override
  String get taskSourceTreatment => 'tratamento';

  @override
  String taskInspectionTitle(String number) {
    return 'Colmeia $number · revisar de novo';
  }

  @override
  String get taskInspectionTitleNoHive => 'Revisar de novo';

  @override
  String taskTreatmentTitle(String number) {
    return 'Colmeia $number · retirar tiras';
  }

  @override
  String get taskTreatmentTitleApiary => 'Retirar tiras';

  @override
  String get taskReminderBody => 'Sua tarefa vence agora.';

  @override
  String get taskAssigneeMe => 'Eu';

  @override
  String taskAssignedTo(String name) {
    return 'Atribuída a $name';
  }

  @override
  String taskMemberNumbered(String role, int index) {
    return '$role $index';
  }

  @override
  String get roleOwner => 'Proprietário';

  @override
  String get rolePartner => 'Sócio';

  @override
  String get roleWorker => 'Funcionário';

  @override
  String get roleViewer => 'Observador';

  @override
  String taskCompleteAction(String title) {
    return 'Concluir: $title';
  }

  @override
  String get taskCompleted => 'Tarefa concluída';

  @override
  String get taskFormNewTitle => 'Nova tarefa';

  @override
  String get taskFormEditTitle => 'Editar tarefa';

  @override
  String get taskFormName => 'Tarefa';

  @override
  String get taskFormNameHint => 'ex.: Visitar o apiário da serra';

  @override
  String get taskFormDue => 'Prazo';

  @override
  String get taskFormPickDate => 'Outro dia';

  @override
  String get taskFormTime => 'Hora';

  @override
  String get taskFormApiary => 'Apiário';

  @override
  String get taskFormHive => 'Colmeia';

  @override
  String get taskFormNone => 'Nenhum';

  @override
  String get taskFormChooseApiary => 'Escolher apiário';

  @override
  String get taskFormChooseHive => 'Escolher colmeia';

  @override
  String get taskFormAssignee => 'Atribuída a';

  @override
  String get taskFormUnassigned => 'Sem responsável';

  @override
  String get taskFormCompleted => 'Feita';

  @override
  String get taskFormSave => 'Salvar';

  @override
  String get taskFormDelete => 'Excluir tarefa';

  @override
  String get taskDeleteTitle => 'Excluir esta tarefa?';

  @override
  String get taskDeleteMessage => 'A tarefa é removida de todos os celulares.';

  @override
  String get taskDeleteConfirm => 'Excluir';

  @override
  String get taskSaved => 'Tarefa salva';

  @override
  String get taskDeleted => 'Tarefa excluída';

  @override
  String get taskNotFound => 'Tarefa não encontrada; pode ter sido excluída.';

  @override
  String get taskReminderDenied =>
      'As notificações estão desligadas; o lembrete não vai tocar.';

  @override
  String get exactAlarmTitle => 'Tocar lembretes na hora certa?';

  @override
  String get exactAlarmMessage =>
      'O Android pode atrasar notificações alguns minutos para economizar bateria. Permita o Mobil Arıcı na configuração que vai abrir e os lembretes de tarefas tocam na hora certa. Não precisa de internet.';

  @override
  String get exactAlarmConfirm => 'Abrir configuração';

  @override
  String get settingsReminders => 'Lembretes';

  @override
  String get settingsExactAlarms => 'Tocar na hora certa';

  @override
  String get settingsExactAlarmsOn => 'Ligado';

  @override
  String get settingsExactAlarmsOff =>
      'Desligado · pode atrasar alguns minutos';

  @override
  String weatherTemperature(String value) {
    return '$value°';
  }

  @override
  String weatherForecastAsOf(String time) {
    return 'Previsão de $time';
  }

  @override
  String get weatherNoLocationTitle => 'Sem localização';

  @override
  String get weatherNoLocationAction => 'Adicione uma localização para o tempo';

  @override
  String get weatherPendingHint => 'Chega quando você estiver on-line';

  @override
  String weatherWind(String speed) {
    return 'Vento $speed';
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
    return '$value%';
  }

  @override
  String weatherTemperatureRange(String max, String min) {
    return '$max / $min';
  }

  @override
  String get hiveOpeningRain => 'Chuva';

  @override
  String get hiveOpeningWind => 'Vento';

  @override
  String get hiveOpeningCold => 'Frio';

  @override
  String get hiveOpeningDaySuitable => 'Abrir';

  @override
  String get weatherConditionSunny => 'Ensolarado';

  @override
  String get weatherConditionPartlyCloudy => 'Parcialmente nublado';

  @override
  String get weatherConditionCloudy => 'Nublado';

  @override
  String get weatherConditionRainy => 'Chuvoso';

  @override
  String get weatherConditionWindy => 'Ventoso';

  @override
  String get weatherConditionOther => 'Neve, neblina ou tempestade';

  @override
  String get weatherConditionFog => 'Neblina';

  @override
  String get weatherConditionThunder => 'Trovoadas';

  @override
  String get weatherConditionSleet => 'Chuva com neve';

  @override
  String get weatherConditionSnow => 'Neve';

  @override
  String weatherFeelsLike(String condition, String value) {
    return '$condition · sensação de $value';
  }

  @override
  String get weatherWindLabel => 'Vento';

  @override
  String get weatherHumidityLabel => 'Umidade';

  @override
  String get weatherPrecipitationLabel => 'Chuva';

  @override
  String get weatherScreenTitle => 'Tempo no apiário';

  @override
  String weatherScreenSubtitle(String place, String days) {
    return '$place · previsão de $days dias';
  }

  @override
  String weatherScreenSubtitleNoPlace(String days) {
    return 'Previsão de $days dias';
  }

  @override
  String weatherUpdatedAt(String time) {
    return 'Atualizado $time';
  }

  @override
  String get weatherNow => 'Agora';

  @override
  String get weatherToday => 'Hoje';

  @override
  String get weatherColumnDay => 'Dia';

  @override
  String get weatherColumnTemperature => 'Temp.';

  @override
  String get weatherColumnPrecipitation => 'Chuva';

  @override
  String get weatherColumnHive => 'Colmeias';

  @override
  String get weatherTodaySuitable => 'Bom dia para abrir colmeias';

  @override
  String get weatherTodayRain => 'Chuva hoje; não é dia de abrir colmeias';

  @override
  String get weatherTodayWind => 'Vento hoje; não é dia de abrir colmeias';

  @override
  String get weatherTodayCold => 'Frio hoje; não é dia de abrir colmeias';

  @override
  String weatherDayRange(String from, String to) {
    return '$from–$to';
  }

  @override
  String weatherPlanRain(String days) {
    return 'Chuva em $days.';
  }

  @override
  String weatherPlanWind(String days) {
    return 'Vento em $days.';
  }

  @override
  String weatherPlanMove(String weekday) {
    String _temp0 = intl.Intl.selectLogic(weekday, {
      'monday': 'Passe as revisões para segunda.',
      'tuesday': 'Passe as revisões para terça.',
      'wednesday': 'Passe as revisões para quarta.',
      'thursday': 'Passe as revisões para quinta.',
      'friday': 'Passe as revisões para sexta.',
      'saturday': 'Passe as revisões para sábado.',
      'other': 'Passe as revisões para domingo.',
    });
    return '$_temp0';
  }

  @override
  String get weatherPlanAction => 'Planejar';

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
    return 'Bom para abrir: acima de $temperature, vento abaixo de $wind, chance de chuva abaixo de $precipitation. Você pode mudar os limites nas Configurações.';
  }

  @override
  String get weatherEmptyTitle => 'Ainda sem previsão';

  @override
  String get weatherEmptyMessage =>
      'A previsão deste apiário ainda não foi baixada. Atualize quando estiver on-line.';

  @override
  String get weatherNoLocationMessage =>
      'Este apiário não tem localização. Adicione uma para receber a previsão.';

  @override
  String get weatherRefresh => 'Atualizar';

  @override
  String get weatherRefreshFailed =>
      'Não foi possível obter a previsão. Verifique sua conexão com a internet.';

  @override
  String get weatherApiaryNotFound => 'Apiário não encontrado';

  @override
  String get weatherAttributionPrefix => 'Powered by';

  @override
  String get weatherAttributionLink => 'WeatherAPI.com';

  @override
  String get settingsHiveOpening => 'Limites para abrir colmeias';

  @override
  String get settingsHiveOpeningTemperature => 'Temperatura';

  @override
  String settingsHiveOpeningTemperatureValue(String value) {
    return 'acima de $value';
  }

  @override
  String get settingsHiveOpeningWind => 'Vento';

  @override
  String get settingsHiveOpeningPrecipitation => 'Chance de chuva';

  @override
  String settingsHiveOpeningBelow(String value) {
    return 'abaixo de $value';
  }

  @override
  String get settingsHiveOpeningHint =>
      'A tela do tempo e os cartões de Hoje dizem \"Abrir\" segundo estes limites. Salvo só neste celular.';

  @override
  String get hiveOpeningSuitable => 'Bom para abrir';

  @override
  String get todayGreetingMorning => 'Bom dia';

  @override
  String get todayGreetingAfternoon => 'Boa tarde';

  @override
  String get todayGreetingEvening => 'Boa noite';

  @override
  String get todayAttentionTitle => 'Precisam de atenção';

  @override
  String todayAttentionHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmeias',
      one: '1 colmeia',
    );
    return '$_temp0';
  }

  @override
  String get todayAttentionNone => 'Nenhuma colmeia precisa de atenção';

  @override
  String get todayTasksTitle => 'Hoje';

  @override
  String todayTasksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tarefas',
      one: '1 tarefa',
    );
    return '$_temp0';
  }

  @override
  String todayTasksApiaryCount(String apiary, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tarefas',
      one: '1 tarefa',
    );
    return '$apiary · $_temp0';
  }

  @override
  String todaySetupProgress(int done, int total) {
    return 'Configuração $done/$total';
  }

  @override
  String get setupStepApiary => 'Adicione seu apiário';

  @override
  String get setupStepHives => 'Crie suas colmeias';

  @override
  String get setupStepInspection => 'Faça sua primeira revisão';

  @override
  String setupStepDone(String step) {
    return '$step: feito';
  }

  @override
  String get attentionQueenless => 'Órfã';

  @override
  String get attentionWeak => 'Fraca';

  @override
  String get attentionSwarming => 'Sinais de enxameação';

  @override
  String get attentionTreatmentRemoval => 'Tratamento a retirar';

  @override
  String get attentionQueenlessTitle => 'Colmeias órfãs';

  @override
  String get attentionWeakTitle => 'Colmeias fracas';

  @override
  String get attentionSwarmingTitle => 'Colmeias com sinais de enxameação';

  @override
  String get attentionTreatmentRemovalTitle => 'Tratamentos a retirar';

  @override
  String get attentionQueenlessIntro =>
      'Colmeias ativas em cuja última revisão não se viu rainha nem ovos.';

  @override
  String attentionWeakIntro(int max) {
    return 'Colmeias ativas com força $max/5 ou menos na última revisão.';
  }

  @override
  String get attentionSwarmingIntro =>
      'Colmeias ativas cuja última revisão mostrou sinais de enxameação ou realeiras de enxameação.';

  @override
  String get attentionTreatmentRemovalIntro =>
      'Colmeias cuja retirada das tiras já venceu e a tarefa ainda não foi feita.';

  @override
  String get attentionEmpty => 'Nenhuma colmeia neste grupo.';

  @override
  String attentionLastInspection(String date) {
    return 'Última revisão: $date';
  }

  @override
  String attentionRemovalDue(String date) {
    return 'Retirada prevista: $date';
  }

  @override
  String get syncTableHarvests => 'Colheita';

  @override
  String get syncTableHarvestHives => 'Colmeia colhida';

  @override
  String withdrawalLockHarvestMessage(
    String number,
    String product,
    String date,
  ) {
    return 'A colmeia $number está em tratamento com $product. Não deve ser colhida antes de $date; o mel deste período pode ter resíduos.';
  }

  @override
  String get withdrawalReasonNotForSaleHarvest =>
      'O mel não será vendido (consumo próprio/alimento)';

  @override
  String get withdrawalHarvestCancel => 'Cancelar, não colher';

  @override
  String get withdrawalHarvestProceed => 'Colher mesmo assim';

  @override
  String get apiaryHarvest => 'Colheita';

  @override
  String harvestFormTitle(String apiary) {
    return 'Colheita · $apiary';
  }

  @override
  String harvestSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmeias selecionadas',
      one: '1 colmeia selecionada',
      zero: 'Nenhuma colmeia selecionada',
    );
    return '$_temp0';
  }

  @override
  String harvestSelectedHint(String numbers) {
    return '$numbers · toque para mudar ou escaneie para adicionar';
  }

  @override
  String get harvestSelectedEmptyHint =>
      'Toque para escolher colmeias ou escaneie';

  @override
  String get harvestScan => 'Escanear';

  @override
  String harvestLockedTitle(String numbers) {
    return '$numbers em período de carência.';
  }

  @override
  String get harvestLockedMessage =>
      'Não colhidas. Para colher uma mesmo assim, escolha-a na lista de colmeias.';

  @override
  String get harvestDate => 'Data';

  @override
  String get harvestToday => 'Hoje';

  @override
  String get harvestYesterday => 'Ontem';

  @override
  String get harvestPickDate => 'Outro dia';

  @override
  String get harvestHoneyKind => 'Tipo de mel';

  @override
  String get honeyKindPine => 'Pinho';

  @override
  String get honeyKindFlower => 'Silvestre';

  @override
  String get honeyKindChestnut => 'Castanheiro';

  @override
  String get honeyKindCitrus => 'Laranjeira';

  @override
  String get honeyKindOther => 'Outro';

  @override
  String get harvestUnit => 'Retirado em';

  @override
  String get harvestUnitSuper => 'Melgueiras';

  @override
  String get harvestUnitFrame => 'Quadros';

  @override
  String get harvestTakenSupers => 'Melgueiras retiradas';

  @override
  String get harvestTakenFrames => 'Quadros retirados';

  @override
  String harvestWeight(String unit) {
    return 'Mel extraído ($unit)';
  }

  @override
  String get harvestWeightInvalid => 'Digite um peso como 574 ou 574,5';

  @override
  String harvestWeightTooLarge(String max, String unit) {
    return 'No máximo $max $unit';
  }

  @override
  String get harvestPerHive => 'Por colmeia';

  @override
  String harvestWeightValue(String value, String unit) {
    return '$value $unit';
  }

  @override
  String harvestSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Salvar colheita',
      zero: 'Nenhuma colmeia para colher',
    );
    return '$_temp0';
  }

  @override
  String harvestSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Colheita salva para $count colmeias',
      one: 'Colheita salva para 1 colmeia',
    );
    return '$_temp0';
  }

  @override
  String get harvestHivesTitle => 'Colmeias a colher';

  @override
  String get harvestSelectAll => 'Selecionar todas';

  @override
  String get harvestSelectNone => 'Não selecionar nenhuma';

  @override
  String harvestHiveLocked(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'faltam $days dias',
      one: 'falta 1 dia',
    );
    return 'Carência · $_temp0';
  }

  @override
  String harvestHiveOverridden(String reason) {
    return 'Colhida mesmo assim: $reason';
  }

  @override
  String get harvestHivesDone => 'Pronto';

  @override
  String get harvestNoActiveHives => 'Este apiário não tem colmeias ativas.';

  @override
  String get harvestScanTitle => 'Escanear para a colheita';

  @override
  String harvestScanAdded(String number) {
    return 'Colmeia $number adicionada';
  }

  @override
  String harvestScanAlready(String number) {
    return 'A colmeia $number já está selecionada';
  }

  @override
  String harvestScanOtherApiary(String number) {
    return 'A colmeia $number não está neste apiário';
  }

  @override
  String harvestScanInactive(String number) {
    return 'A colmeia $number não está ativa';
  }

  @override
  String get harvestScanUnknown =>
      'Esta etiqueta não está ligada a nenhuma colmeia';

  @override
  String harvestScanDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pronto · $count colmeias',
      one: 'Pronto · 1 colmeia',
      zero: 'Pronto',
    );
    return '$_temp0';
  }

  @override
  String get apiaryTourStart => 'Iniciar ronda';

  @override
  String get apiaryTourResume => 'Continuar ronda';

  @override
  String get tourReplaceTitle => 'Encerrar a ronda atual?';

  @override
  String tourReplaceMessage(String apiary) {
    return 'A ronda de $apiary ainda está em andamento. Iniciar uma nova apaga o progresso dela; as revisões continuam salvas.';
  }

  @override
  String get tourReplaceConfirm => 'Iniciar nova ronda';

  @override
  String tourTitle(String apiary) {
    return 'Ronda de $apiary';
  }

  @override
  String get tourFinish => 'Encerrar ronda';

  @override
  String tourProgress(int done, int total) {
    return '$done / $total';
  }

  @override
  String tourProgressLabel(int done, int total) {
    return '$done de $total colmeias feitas';
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
    return 'Tempo decorrido: $duration';
  }

  @override
  String get tourNext => 'A seguir';

  @override
  String tourPreviousVisit(String date) {
    return 'Da última vez · $date';
  }

  @override
  String get tourQueue => 'Ordem';

  @override
  String tourSkippedCount(int count) {
    return '$count puladas';
  }

  @override
  String get tourStateDone => 'Feita';

  @override
  String get tourStateSkipped => 'Pulada';

  @override
  String get tourStatePending => 'Aguardando';

  @override
  String get tourStateNext => 'Próxima';

  @override
  String tourHiveSemantics(String number, String state) {
    return 'Colmeia $number, $state';
  }

  @override
  String get tourSkip => 'Pular';

  @override
  String tourInspect(String number) {
    return 'Revisar $number';
  }

  @override
  String get tourAllDone => 'Todas as colmeias foram revisadas.';

  @override
  String get tourSunSuggestion =>
      'O modo sol deixa a tela mais legível sob luz forte.';

  @override
  String get tourSunOn => 'Ligar modo sol';

  @override
  String get tourSunMode => 'Modo sol';

  @override
  String get tourFinishTitle => 'Encerrar a ronda?';

  @override
  String tourFinishMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count colmeias não foram revisadas; o resumo as conta como puladas.',
      one: '1 colmeia não foi revisada; o resumo a conta como pulada.',
    );
    return '$_temp0';
  }

  @override
  String get tourNotFound => 'Não há ronda em andamento neste apiário.';

  @override
  String get tourCompleteTitle => 'Ronda concluída';

  @override
  String tourInspectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmeias revisadas',
      one: '1 colmeia revisada',
    );
    return '$_temp0';
  }

  @override
  String get tourHealthy => 'Fortes / razoáveis';

  @override
  String get tourTasksTitle => 'Tarefas';

  @override
  String tourTaskRequeen(String numbers) {
    return 'Trocar rainha: $numbers';
  }

  @override
  String tourTaskFeedWeak(String numbers) {
    return 'Alimentar com xarope 1:1: $numbers';
  }

  @override
  String tourTaskSwarmCheck(String numbers) {
    return 'Controle de enxameação: $numbers';
  }

  @override
  String tourTaskRevisit(String numbers) {
    return 'Verificar colmeias puladas: $numbers';
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
      other: 'em $days dias',
      one: 'amanhã',
      zero: 'hoje',
    );
    return '$_temp0';
  }

  @override
  String tourSaveTasks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Salvar tarefas',
      one: 'Salvar tarefa',
      zero: 'Fechar',
    );
    return '$_temp0';
  }

  @override
  String tourTasksSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tarefas salvas',
      one: '1 tarefa salva',
    );
    return '$_temp0';
  }

  @override
  String get tourNoTasks => 'Nenhuma tarefa a sugerir.';

  @override
  String get reportsTitle => 'Relatórios';

  @override
  String get reportTreatmentRegister => 'Registro de tratamentos';

  @override
  String get reportTreatmentRegisterHint => 'Para fiscalizações';

  @override
  String get reportHiveHistory => 'Histórico da colmeia';

  @override
  String get reportHiveHistoryHint => 'Uma colmeia ou um apiário';

  @override
  String get reportFrom => 'De';

  @override
  String get reportTo => 'Até';

  @override
  String get reportApiary => 'Apiário';

  @override
  String get reportAllApiaries => 'Todos os apiários';

  @override
  String get reportHive => 'Colmeia';

  @override
  String get reportAllHives => 'Todas as colmeias';

  @override
  String get reportLanguage => 'Idioma do PDF';

  @override
  String get reportRegistrationNo => 'Nº de registro do estabelecimento';

  @override
  String get reportAksNo => 'Nº AKS';

  @override
  String get reportRecordNo => 'Número de registro';

  @override
  String get reportNumbersHelper =>
      'Só aparece no cabeçalho do PDF; não é salvo.';

  @override
  String get reportShare => 'Compartilhar';

  @override
  String get reportCreate => 'Criar PDF';

  @override
  String get reportPreparing => 'Preparando o PDF…';

  @override
  String get reportError => 'Não foi possível criar o PDF. Tente de novo.';

  @override
  String get reportLoadError => 'Não foi possível ler os registros.';

  @override
  String get reportEmpty => 'Nenhum registro neste período.';

  @override
  String reportTreatmentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tratamentos',
      one: '1 tratamento',
    );
    return '$_temp0';
  }

  @override
  String reportHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmeias',
      one: '1 colmeia',
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
  String get pdfTreatmentRegisterTitle => 'Registro de Tratamentos';

  @override
  String get pdfHiveHistoryTitle => 'Histórico da Colmeia';

  @override
  String pdfRegistrationNo(String number) {
    return 'Nº de registro do estabelecimento $number';
  }

  @override
  String pdfAksNo(String number) {
    return 'Nº AKS $number';
  }

  @override
  String pdfRecordNo(String number) {
    return 'Nº de registro $number';
  }

  @override
  String pdfPeriod(String from, String to) {
    return 'Período: $from – $to';
  }

  @override
  String pdfApiary(String name) {
    return 'Apiário: $name';
  }

  @override
  String pdfCreated(String date) {
    return 'Criado em $date';
  }

  @override
  String pdfPage(int page, int pages) {
    return 'Página $page de $pages';
  }

  @override
  String get pdfColumnDate => 'Data';

  @override
  String get pdfColumnApiary => 'Apiário';

  @override
  String get pdfColumnProduct => 'Produto / lote';

  @override
  String get pdfColumnHives => 'Colmeias';

  @override
  String get pdfColumnDose => 'Dose por colmeia';

  @override
  String get pdfColumnRemoval => 'Retirada';

  @override
  String get pdfColumnWithdrawalEnd => 'Fim da carência';

  @override
  String get pdfColumnEvent => 'Registro';

  @override
  String get pdfColumnDetails => 'Detalhes';

  @override
  String get pdfEventFeeding => 'Alimentação';

  @override
  String get pdfEventVarroa => 'Contagem de varroa';

  @override
  String get pdfEventHarvest => 'Colheita';

  @override
  String pdfHarvestTotal(String amount) {
    return 'Colheita total: $amount';
  }

  @override
  String pdfDocumentName(String title, String from, String to) {
    return '$title $from–$to';
  }

  @override
  String get moreFeedback => 'Enviar comentários';

  @override
  String get feedbackTitle => 'Enviar comentários';

  @override
  String get feedbackIntro =>
      'Estamos construindo este app junto com apicultores. Lemos todas as mensagens.';

  @override
  String get feedbackKindLabel => 'Sobre o que é?';

  @override
  String get feedbackKindBug => 'Erro';

  @override
  String get feedbackKindSuggestion => 'Sugestão';

  @override
  String get feedbackKindMissingFeature => 'Recurso que falta';

  @override
  String get feedbackKindThanks => 'Agradecimento';

  @override
  String get feedbackMessageLabel => 'Sua mensagem';

  @override
  String get feedbackMessageHint => 'O que aconteceu e o que você esperava?';

  @override
  String get feedbackAddScreenshot => 'Adicionar captura de tela';

  @override
  String get feedbackScreenshotAttached => 'Captura de tela anexada';

  @override
  String get feedbackRemoveScreenshot => 'Remover';

  @override
  String get feedbackScreenshotDenied =>
      'O acesso às fotos não foi permitido. Para anexar uma captura, permita nas Configurações.';

  @override
  String get feedbackIncludeDeviceInfo =>
      'Incluir informações do aparelho e da versão';

  @override
  String get feedbackOfflineHint =>
      'Sem internet, a mensagem fica na fila e é enviada quando você estiver on-line.';

  @override
  String get feedbackSend => 'Enviar';

  @override
  String get feedbackQueued =>
      'Obrigado! Sua mensagem está na fila para envio.';

  @override
  String get settingsAnalytics => 'Compartilhar dados de uso';

  @override
  String get settingsAnalyticsHint =>
      'Números como tempo de revisão, resultados de escaneamento e atraso de sincronização; seu nome, suas colmeias e localizações nunca são enviados.';

  @override
  String get teamTitle => 'Equipe';

  @override
  String get teamRoleOwner => 'Proprietário';

  @override
  String get teamRolePartner => 'Sócio';

  @override
  String get teamRoleWorker => 'Funcionário';

  @override
  String get teamRoleViewer => 'Consultor';

  @override
  String get teamRoleViewerSubtitle => 'Só leitura';

  @override
  String get teamRoleHintPartner => 'Um sócio registra dados e vê as finanças.';

  @override
  String get teamRoleHintWorker =>
      'Um funcionário registra dados, mas não vê as finanças.';

  @override
  String get teamRoleHintViewer =>
      'Um consultor só pode ler e não pode registrar dados.';

  @override
  String teamMemberSelf(String name) {
    return '$name (você)';
  }

  @override
  String get teamMemberUnknown => 'Membro da equipe';

  @override
  String get teamMembersEmpty =>
      'Os membros aparecem quando a sincronização terminar.';

  @override
  String get teamInviteTitle => 'Convidar para a equipe';

  @override
  String get teamInviteHint => 'Diga ou envie o código. Ele vale por 48 horas.';

  @override
  String get teamInviteGenerate => 'Gerar código';

  @override
  String get teamInviteCopy => 'Copiar';

  @override
  String get teamInviteCopied => 'Código copiado.';

  @override
  String teamInviteCodeSemantics(String code) {
    return 'Código de convite $code';
  }

  @override
  String get teamHaveCode => 'Tenho um código';

  @override
  String get teamJoinTitle => 'Entrar com um código';

  @override
  String get teamJoinHint =>
      'Digite o código de 6 caracteres que você recebeu.';

  @override
  String get teamJoinCodeLabel => 'Código de convite';

  @override
  String get teamJoinAction => 'Entrar';

  @override
  String get teamJoinDone => 'Você entrou na equipe.';

  @override
  String get teamErrorOffline =>
      'Isto precisa de conexão com a internet. Tente de novo quando estiver on-line.';

  @override
  String get teamErrorInvalidCode =>
      'O código é inválido, expirou ou já foi usado.';

  @override
  String get teamErrorAlreadyMember => 'Você já é membro desta equipe.';

  @override
  String get teamErrorForbidden => 'Você não tem permissão para fazer isto.';

  @override
  String get teamErrorOwnerLocked =>
      'O papel do proprietário não pode ser mudado e o proprietário não pode ser removido.';

  @override
  String get teamErrorUnknown => 'Não deu certo. Tente de novo daqui a pouco.';

  @override
  String get teamRemoveAction => 'Remover da equipe';

  @override
  String get teamRemoveTitle => 'Remover da equipe?';

  @override
  String teamRemoveMessage(String name) {
    return '$name perderá o acesso aos registros deste negócio.';
  }

  @override
  String get teamRemoveConfirm => 'Remover';

  @override
  String teamRemoved(String name) {
    return '$name foi removido da equipe.';
  }

  @override
  String teamRoleChanged(String name, String role) {
    return '$name agora é $role.';
  }

  @override
  String get teamActivityTitle => 'Atividade recente';

  @override
  String get teamActivityEmpty => 'Ainda sem atividade.';

  @override
  String get teamActivitySelf => 'Você';

  @override
  String teamActivityInspection(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'registrou $count revisões',
      one: 'registrou 1 revisão',
    );
    return '$_temp0';
  }

  @override
  String teamActivityTreatment(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'tratou $count colmeias',
      one: 'tratou 1 colmeia',
    );
    return '$_temp0';
  }

  @override
  String teamActivityFeeding(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'alimentou $count colmeias',
      one: 'alimentou 1 colmeia',
    );
    return '$_temp0';
  }

  @override
  String teamActivityHarvest(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'registrou $count colheitas',
      one: 'registrou 1 colheita',
    );
    return '$_temp0';
  }

  @override
  String teamActivityMiteCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'registrou $count contagens de varroa',
      one: 'registrou 1 contagem de varroa',
    );
    return '$_temp0';
  }

  @override
  String teamActivityTask(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'adicionou $count tarefas',
      one: 'adicionou 1 tarefa',
    );
    return '$_temp0';
  }

  @override
  String get teamActivityJustNow => 'agora mesmo';

  @override
  String teamActivityMinutesAgo(int count) {
    return 'há $count min';
  }

  @override
  String teamActivityHoursAgo(int count) {
    return 'há $count h';
  }

  @override
  String get teamActivityYesterday => 'ontem';

  @override
  String teamActivityDaysAgo(int count) {
    return 'há $count dias';
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
  String get settingsPush => 'Notificações de tarefas';

  @override
  String get settingsPushHint =>
      'Receba uma notificação quando uma tarefa for atribuída a você. Toque nela para abrir a tarefa.';

  @override
  String get documentsTitle => 'Pasta de documentos';

  @override
  String get documentsAdd => 'Adicionar documento';

  @override
  String documentsSummaryOffline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count documentos',
      one: '1 documento',
    );
    return '$_temp0 · todos abrem off-line';
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
      other: '$missing arquivos',
      one: '1 arquivo',
    );
    return '$_temp0 · $_temp1 ainda fora deste celular';
  }

  @override
  String get documentsRegionNoteTr =>
      'Os tipos de documento dependem do país. Fora da Turquia você cria seus próprios tipos.';

  @override
  String get documentsRegionNoteOther =>
      'Você define os tipos de documento; os que você digitar são sugeridos na próxima vez.';

  @override
  String get documentsRoadCheck =>
      'Fiscalização na estrada · mostrar documentos';

  @override
  String get documentsEmptyTitle => 'Ainda não há documentos';

  @override
  String get documentsEmptyMessage =>
      'Adicione uma foto ou PDF das suas licenças e certificados. Eles abrem off-line e você é lembrado antes de vencerem.';

  @override
  String get documentsLoadError => 'Não foi possível abrir os documentos.';

  @override
  String get documentFileKindPhoto => 'FOTO';

  @override
  String get documentFileKindPdf => 'PDF';

  @override
  String get documentTypeHealthReport => 'Atestado sanitário';

  @override
  String get documentTypeTransportPermit => 'Guia de trânsito';

  @override
  String get documentTypeMigratoryCertificate =>
      'Certificado de apicultura migratória';

  @override
  String get documentTypeBusinessRegistration =>
      'Certificado de registro do estabelecimento';

  @override
  String get documentTypeLandPermit => 'Autorização do terreno';

  @override
  String get documentTypeAnalysisReport => 'Laudo de análise';

  @override
  String get documentExpiryNone => 'Sem validade';

  @override
  String get documentExpiryExpired => 'Vencido';

  @override
  String get documentExpiryToday => 'Vence hoje';

  @override
  String documentExpiryDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dias',
      one: '1 dia',
    );
    return '$_temp0';
  }

  @override
  String documentExpiryMonths(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months meses',
      one: '1 mês',
    );
    return '$_temp0';
  }

  @override
  String documentExpiresOn(String date) {
    return 'Válido até $date';
  }

  @override
  String get documentFormNewTitle => 'Adicionar documento';

  @override
  String get documentFormEditTitle => 'Editar documento';

  @override
  String get documentFormType => 'Tipo de documento';

  @override
  String get documentFormCustomTypeHint => 'ex.: Apólice de seguro';

  @override
  String get documentFormName => 'Nome';

  @override
  String get documentFormNameHint => 'ex.: Atestado sanitário 2026';

  @override
  String get documentFormDescription => 'Descrição';

  @override
  String get documentFormDescriptionHint =>
      'ex.: Escritório regional · 152 colmeias';

  @override
  String get documentFormExpiry => 'Válido até';

  @override
  String get documentFormNoExpiry => 'Sem validade';

  @override
  String get documentFormPickDate => 'Escolher data';

  @override
  String get documentFormExpiryHelper =>
      'Você será lembrado 30, 7 e 1 dia antes do vencimento.';

  @override
  String get documentFormFile => 'Arquivo';

  @override
  String get documentFormTakePhoto => 'Tirar foto';

  @override
  String get documentFormPickImage => 'Da galeria';

  @override
  String get documentFormPickPdf => 'Escolher PDF';

  @override
  String get documentFormNoFile =>
      'Tire uma foto do documento ou escolha o PDF.';

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
      'O arquivo tem mais de 20 MB; escolha um menor.';

  @override
  String get documentFileFailed =>
      'Não foi possível obter o arquivo, tente de novo.';

  @override
  String get documentFilePermissionDenied =>
      'Permissão negada. Para adicionar um documento, permita o acesso à câmera ou aos arquivos para este app nas Configurações.';

  @override
  String get documentFormSave => 'Salvar';

  @override
  String get documentFormDelete => 'Excluir documento';

  @override
  String get documentSaved => 'Documento salvo';

  @override
  String get documentReminderDenied =>
      'Documento salvo. Sem permissão de notificações, os lembretes de vencimento não tocam.';

  @override
  String get documentDeleteTitle => 'Excluir este documento?';

  @override
  String get documentDeleteMessage =>
      'O documento e seu arquivo são removidos de todos os celulares.';

  @override
  String get documentDeleteConfirm => 'Excluir';

  @override
  String get documentDeleted => 'Documento excluído';

  @override
  String get documentNotFound =>
      'Documento não encontrado; pode ter sido excluído.';

  @override
  String get documentEdit => 'Editar';

  @override
  String get documentFileMissing =>
      'O arquivo ainda não está neste celular. Ele é baixado quando você estiver on-line.';

  @override
  String get documentPdfFailed => 'Não foi possível abrir o PDF.';

  @override
  String documentPdfPage(int page, int count) {
    return 'Página $page de $count';
  }

  @override
  String get roadCheckTitle => 'Fiscalização na estrada';

  @override
  String roadCheckPosition(int index, int count) {
    return '$index / $count';
  }

  @override
  String get roadCheckSwipeHint =>
      'Deslize para o lado para ver o próximo documento';

  @override
  String get roadCheckPrevious => 'Documento anterior';

  @override
  String get roadCheckNext => 'Próximo documento';

  @override
  String documentReminderBody(int days, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dias',
      one: '1 dia',
    );
    return 'Vence em $_temp0 · $date';
  }

  @override
  String get syncTableDocuments => 'Documento';

  @override
  String get migrationsTitle => 'Planos de migração';

  @override
  String get migrationsAdd => 'Novo plano';

  @override
  String get migrationsEmptyTitle => 'Ainda não há plano de migração';

  @override
  String get migrationsEmptyMessage =>
      'Planeje a rota do ano: datas, número de colmeias e apiário de destino de cada parada.';

  @override
  String get migrationsLoadError =>
      'Não foi possível abrir os planos de migração';

  @override
  String migrationStopCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count paradas',
      one: '1 parada',
      zero: 'Sem paradas',
    );
    return '$_temp0';
  }

  @override
  String migrationTitle(String name, String year) {
    return '$name $year';
  }

  @override
  String get migrationNotFound => 'Plano de migração não encontrado';

  @override
  String get migrationDocuments => 'Documentos';

  @override
  String get migrationEdit => 'Editar plano';

  @override
  String get migrationAddStop => 'Adicionar parada';

  @override
  String get migrationNoStopsTitle => 'Ainda não há paradas';

  @override
  String get migrationNoStopsMessage =>
      'Adicione as paradas da rota em ordem: florada, lugar, datas e número de colmeias.';

  @override
  String migrationNextMoveIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'em $days dias',
      one: 'em 1 dia',
      zero: 'hoje',
    );
    return 'Próxima mudança · $_temp0';
  }

  @override
  String migrationNextMoveLate(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dias de atraso',
      one: '1 dia de atraso',
    );
    return 'Próxima mudança · $_temp0';
  }

  @override
  String migrationRoute(String from, String to) {
    return '$from → $to';
  }

  @override
  String migrationDocReady(String document) {
    return '$document pronto';
  }

  @override
  String migrationDocDays(String document, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dias',
      one: '1 dia',
      zero: 'vence hoje',
    );
    return '$document $_temp0';
  }

  @override
  String migrationDocBeforeMove(String document) {
    return '$document vence antes da mudança';
  }

  @override
  String migrationDocExpired(String document) {
    return '$document vencido';
  }

  @override
  String migrationDocMissing(String document) {
    return 'Falta $document';
  }

  @override
  String get migrationStopPast => 'Passada';

  @override
  String get migrationStopCurrent => 'Aqui agora';

  @override
  String get migrationStopPlanned => 'Planejada';

  @override
  String get migrationStopHere => 'Você está aqui';

  @override
  String migrationStopDates(String start, String end) {
    return '$start–$end';
  }

  @override
  String migrationYield(String year, String kg) {
    return '$year: $kg kg/colmeia';
  }

  @override
  String migrationYields(String values) {
    return 'Produção anterior · $values';
  }

  @override
  String get migrationNoYield => 'Nenhuma colheita anterior neste apiário';

  @override
  String get migrationFormNewTitle => 'Novo plano de migração';

  @override
  String get migrationFormEditTitle => 'Editar plano de migração';

  @override
  String get migrationFormYear => 'Ano';

  @override
  String get migrationFormName => 'Nome';

  @override
  String get migrationFormDefaultName => 'Plano de migração';

  @override
  String get migrationFormSave => 'Salvar';

  @override
  String get migrationFormDelete => 'Excluir plano';

  @override
  String get migrationDeleteTitle => 'Excluir o plano de migração?';

  @override
  String get migrationDeleteMessage =>
      'O plano e todas as suas paradas serão excluídos.';

  @override
  String get migrationDeleteConfirm => 'Excluir';

  @override
  String get migrationSaved => 'Plano salvo';

  @override
  String get migrationDeleted => 'Plano excluído';

  @override
  String get stopFormNewTitle => 'Nova parada';

  @override
  String get stopFormEditTitle => 'Editar parada';

  @override
  String get stopFormName => 'Florada';

  @override
  String get stopFormNameHint => 'ex.: Laranjeira, Eucalipto';

  @override
  String get stopFormPlace => 'Lugar';

  @override
  String get stopFormPlaceHint => 'ex.: Botucatu, SP';

  @override
  String get stopFormStart => 'Início previsto';

  @override
  String get stopFormEnd => 'Fim previsto';

  @override
  String get stopFormApiary => 'Apiário de destino';

  @override
  String get stopFormChooseApiary => 'Escolher apiário de destino';

  @override
  String get stopFormNone => 'Nenhum';

  @override
  String get stopFormHiveCount => 'Colmeias';

  @override
  String get stopFormPosition => 'Ordem na rota';

  @override
  String get stopFormStatus => 'Situação';

  @override
  String get stopFormDelete => 'Excluir parada';

  @override
  String get stopDeleteTitle => 'Excluir a parada?';

  @override
  String get stopDeleteMessage => 'A parada será removida do plano.';

  @override
  String get stopSaved => 'Parada salva';

  @override
  String get stopDeleted => 'Parada excluída';

  @override
  String get syncTableMigrations => 'Plano de migração';

  @override
  String get syncTableMigrationStops => 'Parada de migração';

  @override
  String get moveStart => 'Iniciar mudança';

  @override
  String moveTitle(String route) {
    return 'Mudança · $route';
  }

  @override
  String get moveNone => 'Nenhuma mudança prevista';

  @override
  String get moreMigratory => 'Migratória';

  @override
  String get syncTableTransports => 'Mudança';

  @override
  String get syncTableTransportItems => 'Colmeia transportada';

  @override
  String get moveStepCheck => 'Checagem';

  @override
  String get moveStepLoad => 'Carregamento';

  @override
  String get moveStepUnload => 'Descarregamento';

  @override
  String moveStepDone(String step) {
    return '$step, feito';
  }

  @override
  String get moveNoDestinationTitle => 'A parada não tem apiário';

  @override
  String get moveNoDestinationMessage =>
      'Escolha um apiário de destino para a parada, assim a localização das colmeias é atualizada após o descarregamento.';

  @override
  String get moveEditStop => 'Editar parada';

  @override
  String get moveFrom => 'De';

  @override
  String get moveTo => 'Para';

  @override
  String moveSourceHives(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmeias ativas',
      one: '1 colmeia ativa',
      zero: 'Sem colmeias ativas',
    );
    return '$_temp0';
  }

  @override
  String get moveChecklist => 'Checklist de carregamento';

  @override
  String get moveCheckEntrances => 'Alvados fechados';

  @override
  String get moveCheckVentilation => 'Ventilação aberta';

  @override
  String get moveCheckStraps => 'Cintas apertadas';

  @override
  String get moveCheckWater => 'Água pronta';

  @override
  String get moveVehicles => 'Veículos';

  @override
  String moveVehicleDefault(int number) {
    return 'Caminhão $number';
  }

  @override
  String get moveAddVehicle => 'Adicionar veículo';

  @override
  String moveRemoveVehicle(String vehicle) {
    return 'Remover $vehicle';
  }

  @override
  String get moveVehicleName => 'Nome do veículo';

  @override
  String get moveVehicleExists => 'Já existe um veículo com este nome';

  @override
  String get moveStartLoading => 'Iniciar carregamento';

  @override
  String get moveChecklistHint =>
      'Marque tudo na lista para iniciar o carregamento.';

  @override
  String moveVehicleCount(String vehicle, int count) {
    return '$vehicle · $count';
  }

  @override
  String get moveLoaded => 'Carregadas';

  @override
  String get moveUnloaded => 'Descarregadas';

  @override
  String moveCountTotal(int total) {
    return '/ $total';
  }

  @override
  String moveCountLabel(int count, int total) {
    return '$count de $total colmeias';
  }

  @override
  String moveLastScanned(String number) {
    return 'Último escaneado: $number';
  }

  @override
  String moveNotScanned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmeias ainda não escaneadas',
      one: '1 colmeia ainda não escaneada',
    );
    return '$_temp0';
  }

  @override
  String get moveAllScanned => 'Todas escaneadas';

  @override
  String get moveShowList => 'Ver lista';

  @override
  String get moveMissingTitle => 'Colmeias não escaneadas';

  @override
  String get moveLoadingHint =>
      'Você vai escanear de novo ao descarregar no destino; eu aviso se faltar alguma colmeia. A localização das colmeias é atualizada após o descarregamento.';

  @override
  String moveUnloadingHint(String destination) {
    return 'Escaneie cada colmeia de novo ao descarregar. Ao terminar, as colmeias descarregadas passam para $destination.';
  }

  @override
  String get moveEnterNumber => 'Digitar número';

  @override
  String get moveHiveNumber => 'Número da colmeia';

  @override
  String moveNumberNotFound(String number) {
    return 'Nenhuma colmeia com o número $number';
  }

  @override
  String get moveScanStart => 'Começar a escanear';

  @override
  String get moveScanContinue => 'Continuar escaneando';

  @override
  String get moveToUnloading => 'Ir para o descarregamento';

  @override
  String moveToUnloadingTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmeias não escaneadas',
      one: '1 colmeia não escaneada',
    );
    return '$_temp0';
  }

  @override
  String get moveToUnloadingMessage =>
      'As colmeias não escaneadas ficam fora desta mudança e continuam onde estão.';

  @override
  String get moveFinish => 'Encerrar mudança';

  @override
  String moveFinishTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmeias não descarregadas',
      one: '1 colmeia não descarregada',
    );
    return '$_temp0';
  }

  @override
  String moveFinishMessage(String source) {
    return 'As colmeias não descarregadas mantêm a localização em $source. A lista de faltantes fica na mudança.';
  }

  @override
  String get moveFinishConfirm => 'Encerrar';

  @override
  String get moveDoneTitle => 'Mudança encerrada';

  @override
  String moveDoneSummary(int loaded, int unloaded) {
    return 'Carregadas $loaded · Descarregadas $unloaded';
  }

  @override
  String moveDoneMoved(int count, String destination) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmeias transportadas para $destination.',
      one: '1 colmeia transportada para $destination.',
      zero: 'Nenhuma colmeia transportada.',
    );
    return '$_temp0';
  }

  @override
  String get moveDoneMissing => 'Colmeias não descarregadas';

  @override
  String moveScanLoaded(String number, String vehicle) {
    return '$number carregada · $vehicle';
  }

  @override
  String moveScanLoadedOther(String number) {
    return '$number carregada; esta colmeia não estava neste apiário';
  }

  @override
  String moveScanAlreadyLoaded(String number) {
    return '$number já está carregada';
  }

  @override
  String moveScanUnloaded(String number) {
    return '$number descarregada';
  }

  @override
  String moveScanAlreadyUnloaded(String number) {
    return '$number já está descarregada';
  }

  @override
  String moveScanNotLoaded(String number) {
    return '$number não foi carregada nesta mudança';
  }

  @override
  String get moveScanUnknown => 'Etiqueta desconhecida';

  @override
  String get moveScanDone => 'Pronto';

  @override
  String get inventoryTitle => 'Materiais e estoque';

  @override
  String get inventoryAdd => 'Adicionar item';

  @override
  String get inventoryEmptyTitle => 'Ainda não há itens no estoque';

  @override
  String get inventoryEmptyMessage =>
      'Adicione materiais como açúcar, cera alveolada e potes. Itens abaixo do mínimo são sinalizados.';

  @override
  String get inventoryCategoryEmpty => 'Nenhum item nesta categoria';

  @override
  String get inventoryLoadError => 'Não foi possível abrir o estoque.';

  @override
  String get inventoryNotFound => 'Item não encontrado';

  @override
  String get inventoryCategoryConsumable => 'Consumíveis';

  @override
  String get inventoryCategoryEquipment => 'Equipamentos';

  @override
  String get inventoryCategoryComb => 'Favos';

  @override
  String get inventoryUnitKg => 'kg';

  @override
  String get inventoryUnitLiter => 'L';

  @override
  String get inventoryUnitPiece => 'un.';

  @override
  String get inventoryUnitRoll => 'rolos';

  @override
  String get inventoryUnitPack => 'pct.';

  @override
  String get inventoryUnitNameKg => 'Quilograma';

  @override
  String get inventoryUnitNameLiter => 'Litro';

  @override
  String get inventoryUnitNamePiece => 'Unidade';

  @override
  String get inventoryUnitNameRoll => 'Rolo';

  @override
  String get inventoryUnitNamePack => 'Pacote';

  @override
  String inventoryQuantity(String quantity, String unit) {
    return '$quantity $unit';
  }

  @override
  String inventoryBelowThreshold(String threshold) {
    return 'Abaixo do mínimo · pelo menos $threshold';
  }

  @override
  String get inventoryMoveIn => 'Entrada';

  @override
  String get inventoryMoveOut => 'Saída';

  @override
  String get inventoryMoveCount => 'Contagem';

  @override
  String get inventoryMoveAdjustment => 'Ajuste';

  @override
  String inventoryInStock(String quantity) {
    return 'Em estoque: $quantity';
  }

  @override
  String inventoryAmountLabel(String unit) {
    return 'Quantidade ($unit)';
  }

  @override
  String inventoryCountedLabel(String unit) {
    return 'Quantidade contada ($unit)';
  }

  @override
  String get inventoryAmountInvalid => 'Digite uma quantidade válida';

  @override
  String get inventoryAmountWhole => 'Use um número inteiro para esta unidade';

  @override
  String get inventorySaveIn => 'Adicionar ao estoque';

  @override
  String get inventorySaveOut => 'Tirar do estoque';

  @override
  String get inventorySaveCount => 'Ajustar estoque';

  @override
  String inventoryMovedIn(String quantity) {
    return '$quantity adicionado';
  }

  @override
  String inventoryMovedOut(String quantity) {
    return '$quantity retirado';
  }

  @override
  String inventoryAdjusted(String quantity) {
    return 'Estoque agora: $quantity';
  }

  @override
  String inventoryUnchanged(String quantity) {
    return 'O estoque já é $quantity';
  }

  @override
  String get inventoryDetails => 'Detalhes e histórico';

  @override
  String get inventoryHistory => 'Histórico';

  @override
  String get inventoryHistoryEmpty => 'Ainda sem movimentações';

  @override
  String inventoryThreshold(String threshold) {
    return 'Mínimo: pelo menos $threshold';
  }

  @override
  String get inventoryNoThreshold => 'Sem mínimo';

  @override
  String get inventoryQuickMove => 'Adicionar / retirar';

  @override
  String get inventoryEdit => 'Editar item';

  @override
  String get inventoryFormNewTitle => 'Novo item';

  @override
  String get inventoryFormEditTitle => 'Editar item';

  @override
  String get inventoryFormName => 'Nome';

  @override
  String get inventoryFormCategory => 'Categoria';

  @override
  String get inventoryFormUnit => 'Unidade';

  @override
  String get inventoryFormLocation => 'Local';

  @override
  String get inventoryFormLocationHint =>
      'Depósito, caminhão, escritório… Opcional.';

  @override
  String get inventoryFormThreshold => 'Mínimo';

  @override
  String get inventoryFormThresholdHint =>
      'Você é avisado quando o estoque ficar abaixo disto. Opcional.';

  @override
  String get inventoryFormThresholdInvalid => 'Digite um mínimo válido';

  @override
  String get inventoryFormSave => 'Salvar';

  @override
  String get inventoryFormDelete => 'Excluir item';

  @override
  String get inventoryDeleteTitle => 'Excluir este item?';

  @override
  String get inventoryDeleteMessage => 'O item e seu estoque saem da lista.';

  @override
  String get inventoryDeleteConfirm => 'Excluir';

  @override
  String get inventorySaved => 'Item salvo';

  @override
  String get inventoryDeleted => 'Item excluído';

  @override
  String get syncTableInventoryItems => 'Item de estoque';

  @override
  String get syncTableInventoryMoves => 'Movimentação de estoque';

  @override
  String inventoryIncrease(String quantity) {
    return '+$quantity';
  }

  @override
  String inventoryFormThresholdUnit(String unit) {
    return 'Mínimo ($unit)';
  }

  @override
  String get stockUseTitle => 'Tirar do estoque';

  @override
  String get stockUseNone => 'Não tirar';

  @override
  String stockUseValue(String item, String quantity) {
    return '$item · −$quantity';
  }

  @override
  String get stockUseChoose => 'Tirar de qual item?';

  @override
  String get taskFormTreatment => 'Tratamento planejado';

  @override
  String get taskFormTreatmentUnknown => 'Medicamento fora da lista';

  @override
  String get taskFormTreatmentNeedsApiary =>
      'Escolha um apiário para o tratamento planejado';

  @override
  String taskTreatmentPlanTitle(String drug) {
    return 'Tratamento · $drug';
  }

  @override
  String get shoppingTitle => 'Lista de compras';

  @override
  String shoppingCardTitle(int count) {
    return 'Lista de compras · $count';
  }

  @override
  String get shoppingEmptyTitle => 'Nada para comprar';

  @override
  String get shoppingEmptyMessage =>
      'Itens abaixo do mínimo e o que os tratamentos planejados precisam aparecem aqui.';

  @override
  String get shoppingShare => 'Compartilhar';

  @override
  String get shoppingLoadError => 'Não foi possível abrir a lista de compras';

  @override
  String shoppingReasonThreshold(String stock, String threshold) {
    return '$stock em estoque · mín. $threshold';
  }

  @override
  String shoppingReasonPlanned(String quantity) {
    return 'Tratamentos planejados $quantity';
  }

  @override
  String get shoppingReasonNoItem =>
      'Tratamento planejado · sem item no estoque';

  @override
  String shoppingShareLine(String name, String quantity) {
    return '• $name: $quantity';
  }

  @override
  String get moreRearing => 'Criação de rainhas';

  @override
  String get rearingTitle => 'Criação de rainhas';

  @override
  String rearingBatchName(int number) {
    return 'Lote $number';
  }

  @override
  String rearingBatchTitle(int number) {
    return 'Criação de rainhas · Lote $number';
  }

  @override
  String get rearingAdd => 'Adicionar lote';

  @override
  String get rearingEmptyTitle => 'Ainda não há lotes';

  @override
  String get rearingEmptyMessage =>
      'Informe o dia da transferência de larvas; o cronograma da aceitação até a checagem de postura e seus lembretes são criados para você.';

  @override
  String get rearingLoadError => 'Não foi possível carregar os lotes';

  @override
  String get rearingNotFound => 'Lote não encontrado';

  @override
  String rearingListGrafted(String date) {
    return 'transferência $date';
  }

  @override
  String get rearingEdit => 'Editar lote';

  @override
  String get rearingGraftedLabel => 'Transferidas';

  @override
  String get rearingAcceptedLabel => 'Aceitas';

  @override
  String get rearingNucsLabel => 'Núcleos';

  @override
  String get rearingNotCounted => 'Não contado';

  @override
  String rearingAcceptedPercent(int percent) {
    return '$percent%';
  }

  @override
  String rearingMotherLine(String mother, String date) {
    return 'Mãe: $mother · transferência $date';
  }

  @override
  String rearingMotherUnknownLine(String date) {
    return 'Mãe desconhecida · transferência $date';
  }

  @override
  String rearingDay(int day) {
    return 'D$day';
  }

  @override
  String get rearingToday => 'Hoje';

  @override
  String get rearingStepGraft => 'Transferência de larvas';

  @override
  String get rearingStepAcceptance => 'Checagem da aceitação';

  @override
  String get rearingStepCapped => 'Realeiras operculadas';

  @override
  String get rearingStepDistribution => 'Distribuir realeiras';

  @override
  String get rearingStepEmergence => 'Nascimento das rainhas';

  @override
  String get rearingStepLayingCheck => 'Checagem de postura';

  @override
  String rearingStepGraftDetail(int count) {
    return '$count larvas';
  }

  @override
  String rearingStepAcceptanceDetail(int count) {
    return '$count realeiras aceitas';
  }

  @override
  String get rearingStepAcceptanceTodo => 'Conte as realeiras aceitas';

  @override
  String get rearingStepCappedDetail => 'Não mexer';

  @override
  String rearingStepDistributionDetail(int count) {
    return 'Antes do nascimento, para $count núcleos';
  }

  @override
  String get rearingStepDistributionTodo =>
      'Antes do nascimento, para os núcleos';

  @override
  String get rearingStepEmergenceDetail => 'Verifique os núcleos';

  @override
  String get rearingStepLayingCheckDetail => 'Anote o sucesso da fecundação';

  @override
  String get rearingStepDone => 'feito';

  @override
  String get rearingStepCurrent => 'próximo';

  @override
  String get rearingStepUpcoming => 'a seguir';

  @override
  String get rearingDistribute => 'Distribuir realeiras nos núcleos';

  @override
  String get rearingDistributeApiary => 'Apiário';

  @override
  String get rearingDistributeCount => 'Núcleos';

  @override
  String rearingDistributePlan(int reused, int created) {
    return 'Núcleos vazios reaproveitados: $reused · Núcleos novos: $created';
  }

  @override
  String get rearingDistributeSave => 'Distribuir';

  @override
  String get rearingDistributeNoApiary => 'Adicione primeiro um apiário';

  @override
  String rearingDistributed(int count) {
    return 'Distribuídas em $count núcleos';
  }

  @override
  String get rearingNucsSection => 'Núcleos de fecundação';

  @override
  String rearingNucTitle(String number) {
    return 'Núcleo $number';
  }

  @override
  String get matingNucStatusEmpty => 'Vazio';

  @override
  String get matingNucStatusCell => 'Realeira';

  @override
  String get matingNucStatusVirgin => 'Rainha virgem';

  @override
  String get matingNucStatusLaying => 'Em postura';

  @override
  String get matingNucStatusFailed => 'Falhou';

  @override
  String get matingNucStatusGiven => 'Dado a uma colmeia';

  @override
  String get rearingNucGive => 'Dar a uma colmeia';

  @override
  String get rearingNucChooseHive => 'Qual colmeia?';

  @override
  String get rearingNucNoHives => 'Nenhuma colmeia ativa';

  @override
  String get rearingFormNewTitle => 'Novo lote';

  @override
  String get rearingFormEditTitle => 'Editar lote';

  @override
  String get rearingFormGraftedOn => 'Dia da transferência';

  @override
  String get rearingFormGraftedCount => 'Larvas transferidas';

  @override
  String get rearingFormAcceptedCount => 'Realeiras aceitas';

  @override
  String get rearingFormAcceptedClear => 'Ainda não contadas';

  @override
  String get rearingFormScheduleHint =>
      'Aceitação, operculação, distribuição, nascimento e checagem de postura são adicionados como tarefas com lembrete.';

  @override
  String get rearingFormSave => 'Salvar';

  @override
  String get rearingFormDelete => 'Excluir lote';

  @override
  String get rearingDeleteTitle => 'Excluir o lote?';

  @override
  String get rearingDeleteMessage =>
      'As tarefas dele também são excluídas. Núcleos e rainhas entregues continuam.';

  @override
  String get rearingDeleteConfirm => 'Excluir';

  @override
  String get rearingDeleted => 'Lote excluído';

  @override
  String get rearingSaved => 'Lote salvo';

  @override
  String get taskSourceQueenRearing => 'criação de rainhas';

  @override
  String get syncTableQueenRearingBatches => 'Lote de criação de rainhas';

  @override
  String get syncTableMatingNucs => 'Núcleo de fecundação';

  @override
  String get lotsTitle => 'Colheita e lotes';

  @override
  String get lotsEmptyTitle => 'Ainda não há lotes';

  @override
  String get lotsEmptyMessage =>
      'Adicione uma colheita a um lote depois de salvá-la; os lotes aparecem aqui.';

  @override
  String get lotsLoadError => 'Não foi possível carregar os lotes';

  @override
  String get lotsInStock => 'Em estoque';

  @override
  String get lotsPerHive => 'Por colmeia';

  @override
  String lotNumber(String number) {
    return 'Lote $number';
  }

  @override
  String lotHoneyTitle(String kind) {
    return 'Mel · $kind';
  }

  @override
  String get lotStatusOpen => 'Aberto';

  @override
  String get lotStatusClosed => 'Fechado';

  @override
  String get lotWithdrawalBadge => 'Em carência';

  @override
  String lotMoistureValue(String value) {
    return 'Umidade $value%';
  }

  @override
  String get lotAnalyzed => 'Analisado ✓';

  @override
  String get lotAnalysisPending => 'Análise pendente';

  @override
  String lotStockValue(String weight) {
    return 'Estoque $weight';
  }

  @override
  String get lotNotFound => 'Lote não encontrado';

  @override
  String get lotEdit => 'Editar lote';

  @override
  String lotWithdrawalTitle(String hives) {
    return '$hives colhidas no período de carência.';
  }

  @override
  String get lotWithdrawalMessage =>
      'Este lote pode ter resíduos de medicamentos; faça a análise antes de vender.';

  @override
  String get lotStock => 'Estoque';

  @override
  String get lotHarvested => 'Colhido';

  @override
  String get lotSold => 'Vendido';

  @override
  String get lotInStock => 'Em estoque';

  @override
  String get lotSell => 'Registrar venda';

  @override
  String get lotAnalyses => 'Análises';

  @override
  String get lotAnalysesEmpty => 'Ainda não há análises';

  @override
  String get lotAddAnalysis => 'Adicionar análise';

  @override
  String get lotHarvests => 'Colheitas';

  @override
  String get lotHarvestsEmpty => 'Nenhuma colheita neste lote';

  @override
  String get lotTreatments => 'Último tratamento das colmeias';

  @override
  String get lotTreatmentsEmpty =>
      'Nenhum tratamento registrado para as colmeias deste lote';

  @override
  String lotTreatmentTitle(String hive, String product) {
    return 'Colmeia $hive · $product';
  }

  @override
  String lotTreatmentDetail(String date, String end) {
    return '$date · carência termina em $end';
  }

  @override
  String get lotPublicPage => 'Página pública';

  @override
  String get lotPublish => 'Publicar';

  @override
  String get lotPublishHint =>
      'Quem escanear o QR vê a página do lote. Telefone, endereço e localização nunca aparecem.';

  @override
  String get lotPublishOwnerOnly =>
      'Só o proprietário do negócio pode publicar.';

  @override
  String get lotPublished => 'Publicado';

  @override
  String get lotNotPublished => 'Não publicado';

  @override
  String get lotPublicFields => 'Aparece na página';

  @override
  String get lotPublicProducer => 'Nome do negócio e número de colmeias';

  @override
  String get lotPublicOrigin => 'Origem e mês da colheita';

  @override
  String get lotPublicLab => 'Valores da análise';

  @override
  String get lotPublicReport => 'Laudo da análise';

  @override
  String get lotJarLabels => 'Etiquetas de pote (QR)';

  @override
  String get lotJarLabelsHint =>
      '24 etiquetas por página A4 (70 × 37 mm); imprima em escala 100%.';

  @override
  String lotJarLabelsDocumentName(String number) {
    return 'Etiquetas de pote - $number';
  }

  @override
  String get lotSales => 'Vendas';

  @override
  String get lotSalesEmpty => 'Ainda não há vendas registradas';

  @override
  String lotSaleValue(String weight) {
    return '−$weight';
  }

  @override
  String lotSaleAmount(String unit) {
    return 'Mel vendido ($unit)';
  }

  @override
  String lotSaleTooMuch(String weight) {
    return 'Só há $weight em estoque';
  }

  @override
  String get lotSaleSave => 'Tirar do estoque';

  @override
  String lotSaleSaved(String weight) {
    return 'Venda de $weight registrada';
  }

  @override
  String get lotOrigin => 'Origem';

  @override
  String get lotOriginHint => 'ex.: Mata Atlântica';

  @override
  String get lotMoisture => 'Umidade %';

  @override
  String get lotMoistureHelper => 'Leitura do refratômetro; opcional';

  @override
  String get lotMoistureInvalid => 'Digite um valor entre 10 e 30, como 17,2';

  @override
  String lotEditTitle(String lot) {
    return 'Editar $lot';
  }

  @override
  String get lotStatus => 'Situação';

  @override
  String get lotStatusHelper => 'Lotes fechados não recebem novas colheitas';

  @override
  String get lotSave => 'Salvar';

  @override
  String get lotDelete => 'Excluir lote';

  @override
  String lotDeleteTitle(String lot) {
    return 'Excluir $lot?';
  }

  @override
  String get lotDeleteMessage =>
      'Análises e vendas também são excluídas; as colheitas continuam.';

  @override
  String get lotDeleted => 'Lote excluído';

  @override
  String labTitle(String lot) {
    return 'Análise · $lot';
  }

  @override
  String get labDate => 'Data da análise';

  @override
  String get labHmf => 'HMF (mg/kg)';

  @override
  String get labDiastase => 'Índice de diastase';

  @override
  String get labProline => 'Prolina (mg/kg)';

  @override
  String labHmfValue(String value) {
    return 'HMF $value';
  }

  @override
  String labDiastaseValue(String value) {
    return 'Diastase $value';
  }

  @override
  String labProlineValue(String value) {
    return 'Prolina $value';
  }

  @override
  String labValueInvalid(String min, String max) {
    return 'Digite um valor entre $min e $max';
  }

  @override
  String get labResidue => 'Resíduos';

  @override
  String get labResidueNone => 'Sem resíduos';

  @override
  String get labResidueDetected => 'Resíduos detectados';

  @override
  String get labReport => 'Laudo';

  @override
  String get labReportNone => 'Sem laudo';

  @override
  String get labReportEmpty => 'Nenhum laudo de análise na pasta de documentos';

  @override
  String get labReportAdd => 'Adicionar laudo à pasta de documentos';

  @override
  String get labSave => 'Salvar análise';

  @override
  String get labSaved => 'Análise salva';

  @override
  String get harvestLotTitle => 'Adicionar a um lote';

  @override
  String harvestLotSaved(String weight, String kind) {
    return 'Colheita salva: $weight $kind';
  }

  @override
  String get harvestLotIntro =>
      'Quando o mel entra num lote, as datas do último tratamento das colmeias ficam ligadas a ele.';

  @override
  String get harvestLotNew => 'Novo lote';

  @override
  String harvestLotNewHint(String kind) {
    return '$kind · número atribuído automaticamente';
  }

  @override
  String get harvestLotCreate => 'Criar lote';

  @override
  String get harvestLotAdd => 'Adicionar ao lote';

  @override
  String get harvestLotSkip => 'Pular por enquanto';

  @override
  String harvestLotCreated(String lot) {
    return '$lot criado';
  }

  @override
  String harvestLotAdded(String lot) {
    return 'Colheita adicionada a $lot';
  }

  @override
  String get harvestLotGone => 'A colheita foi desfeita';

  @override
  String get harvestLotBack => 'Voltar ao apiário';

  @override
  String get syncTableLots => 'Lote';

  @override
  String get syncTableLotHarvests => 'Colheita do lote';

  @override
  String get syncTableLotTreatments => 'Tratamento do lote';

  @override
  String get syncTableLabResults => 'Resultado de laboratório';

  @override
  String get syncTableLotSales => 'Venda do lote';

  @override
  String get harvestLotGoneMessage =>
      'A colheita não foi adicionada a um lote. Você pode registrá-la de novo pelo apiário.';

  @override
  String get financeTitle => 'Finanças';

  @override
  String financeYearTitle(String year) {
    return 'Finanças · $year';
  }

  @override
  String get financeSeasonNet => 'Resultado da safra';

  @override
  String get financeIncome => 'Receitas';

  @override
  String get financeExpense => 'Despesas';

  @override
  String get financeCostPerHive => 'Custo/colmeia';

  @override
  String get financeRecent => 'Lançamentos recentes';

  @override
  String get financeEmptyTitle => 'Ainda não há lançamentos';

  @override
  String get financeEmptyMessage =>
      'Registre receitas e despesas com os botões abaixo; o resultado da safra é calculado aqui.';

  @override
  String get financeLoadError => 'Não foi possível carregar os lançamentos';

  @override
  String get financeAddIncome => '+ Receita';

  @override
  String get financeAddExpense => '− Despesa';

  @override
  String financePlus(String amount) {
    return '+$amount';
  }

  @override
  String financeMinus(String amount) {
    return '−$amount';
  }

  @override
  String get financeReceiptAttached => 'comprovante anexado';

  @override
  String financeTransportRoute(String from, String to) {
    return '$from → $to';
  }

  @override
  String get financeFormIncomeTitle => 'Adicionar receita';

  @override
  String get financeFormExpenseTitle => 'Adicionar despesa';

  @override
  String financeFormAmount(String currency) {
    return 'Valor ($currency)';
  }

  @override
  String get financeFormAmountInvalid =>
      'Digite um valor acima de 0, como 17500 ou 17,50';

  @override
  String get financeFormCategory => 'Categoria';

  @override
  String get financeFormDate => 'Data';

  @override
  String get financeFormDescription => 'Descrição';

  @override
  String get financeFormDescriptionHint => 'ex.: Açúcar 500 kg';

  @override
  String get financeFormReceipt => 'Comprovante / nota';

  @override
  String get financeFormNoReceipt => 'Sem comprovante';

  @override
  String get financeFormReceiptAdded => 'Foto do comprovante adicionada';

  @override
  String get financeFormTakePhoto => 'Tirar foto';

  @override
  String get financeFormPickImage => 'Da galeria';

  @override
  String get financeFormRemoveReceipt => 'Remover comprovante';

  @override
  String get financeFormPhotoDenied =>
      'Permissão negada. Para adicionar um comprovante, permita o acesso à câmera ou às fotos para este app nas Configurações.';

  @override
  String get financeFormPhotoFailed =>
      'Não foi possível obter a foto, tente de novo.';

  @override
  String get financeFormLinks => 'Registro vinculado';

  @override
  String get financeFormApiary => 'Apiário';

  @override
  String get financeFormLot => 'Lote';

  @override
  String get financeFormTransport => 'Mudança';

  @override
  String get financeFormNone => 'Nenhum';

  @override
  String get financeFormChooseApiary => 'Escolher apiário';

  @override
  String get financeFormChooseLot => 'Escolher lote';

  @override
  String get financeFormChooseTransport => 'Escolher mudança';

  @override
  String get financeFormNoLots => 'Ainda não há lotes';

  @override
  String get financeFormNoTransports => 'Ainda não há mudanças';

  @override
  String financeFormSaleAmount(String unit) {
    return 'Mel vendido ($unit)';
  }

  @override
  String get financeFormSaleHelper =>
      'É tirado do estoque do lote; deixe vazio para manter o estoque';

  @override
  String get financeFormSave => 'Salvar';

  @override
  String get financeIncomeSaved => 'Receita salva';

  @override
  String get financeExpenseSaved => 'Despesa salva';

  @override
  String get financeNotFound => 'Lançamento não encontrado';

  @override
  String get financeReceiptPending =>
      'O comprovante ainda não chegou a este celular';

  @override
  String get financeDelete => 'Excluir lançamento';

  @override
  String get financeDeleteTitle => 'Excluir este lançamento?';

  @override
  String get financeDeleteMessage =>
      'Se ele estiver ligado a uma venda de lote, a venda também é excluída e o estoque volta.';

  @override
  String get financeDeleteConfirm => 'Excluir';

  @override
  String get financeDeleted => 'Lançamento excluído';

  @override
  String get financeCategoryFeeding => 'Alimentação';

  @override
  String get financeCategoryTreatment => 'Medicamentos';

  @override
  String get financeCategoryEquipment => 'Equipamentos';

  @override
  String get financeCategoryFuelTransport => 'Combustível / transporte';

  @override
  String get financeCategoryLandRent => 'Aluguel de terreno';

  @override
  String get financeCategoryLabor => 'Mão de obra';

  @override
  String get financeCategoryLabAnalysis => 'Análise laboratorial';

  @override
  String get financeCategoryHoney => 'Mel';

  @override
  String get financeCategoryPollen => 'Pólen';

  @override
  String get financeCategoryPropolis => 'Própolis';

  @override
  String get financeCategoryWax => 'Cera';

  @override
  String get financeCategoryNucs => 'Núcleos';

  @override
  String get financeCategoryQueens => 'Rainhas';

  @override
  String get financeCategoryOther => 'Outros';

  @override
  String get syncTableTransactions => 'Receita/despesa';

  @override
  String get customersTitle => 'Caderno de clientes';

  @override
  String get customersAdd => 'Adicionar cliente';

  @override
  String get customersEmptyTitle => 'Ainda não há clientes';

  @override
  String get customersEmptyMessage =>
      'Adicione clientes para acompanhar os pedidos e o que eles devem.';

  @override
  String customerReceivableValue(String amount) {
    return 'Deve $amount';
  }

  @override
  String get customerNoReceivable => 'Nada a receber';

  @override
  String get customerNotFound => 'Cliente não encontrado';

  @override
  String get customerEdit => 'Editar cliente';

  @override
  String get customerAddSale => 'Adicionar venda';

  @override
  String get customerOrders => 'Pedidos';

  @override
  String get customerNoOrders => 'Ainda não há vendas para este cliente.';

  @override
  String get customerPaid => 'Pago';

  @override
  String customerRemaining(String amount) {
    return 'Faltam $amount';
  }

  @override
  String get customerPaidAmount => 'Pago até agora';

  @override
  String get customerMarkPaid => 'Marcar como pago';

  @override
  String get customerMarkedPaid => 'Marcado como pago';

  @override
  String get customerAddPayment => 'Registrar pagamento';

  @override
  String get customerSendWhatsApp => 'Enviar pelo WhatsApp';

  @override
  String get customerWhatsAppNoPhone =>
      'Sem telefone; escolha o contato no WhatsApp';

  @override
  String get customerWhatsAppFailed => 'Não foi possível abrir o WhatsApp';

  @override
  String get customerOpenTransaction => 'Abrir lançamento';

  @override
  String customerWhatsAppGreeting(String name) {
    return 'Olá, $name,';
  }

  @override
  String get customerWhatsAppIntro => 'Resumo do seu pedido:';

  @override
  String customerWhatsAppAmount(String amount) {
    return 'Total: $amount';
  }

  @override
  String customerWhatsAppPaid(String amount) {
    return 'Pago: $amount';
  }

  @override
  String customerWhatsAppRemaining(String amount) {
    return 'Falta: $amount';
  }

  @override
  String get customerWhatsAppPaidInFull => 'Pago integralmente, obrigado.';

  @override
  String customerWhatsAppAddress(String address) {
    return 'Endereço de entrega: $address';
  }

  @override
  String get customerFormNewTitle => 'Novo cliente';

  @override
  String get customerFormEditTitle => 'Editar cliente';

  @override
  String get customerFormName => 'Nome';

  @override
  String get customerFormPhone => 'Telefone';

  @override
  String get customerFormPhoneHelper => 'Para WhatsApp, ex.: +55 11 91234-5678';

  @override
  String get customerFormAddress => 'Endereço de entrega';

  @override
  String get customerFormNotes => 'Observação';

  @override
  String get customerFormSave => 'Salvar';

  @override
  String get customerSaved => 'Cliente salvo';

  @override
  String get customerDelete => 'Excluir cliente';

  @override
  String get customerDeleteTitle => 'Excluir cliente?';

  @override
  String get customerDeleteMessage =>
      'As vendas dele continuam nas suas receitas.';

  @override
  String get customerDeleteConfirm => 'Excluir';

  @override
  String get customerDeleted => 'Cliente excluído';

  @override
  String get customerPaymentSave => 'Salvar pagamento';

  @override
  String get customerPaymentSaved => 'Pagamento salvo';

  @override
  String customerPaymentTooMuch(String amount) {
    return 'Só faltam $amount.';
  }

  @override
  String get financeFormCustomer => 'Cliente';

  @override
  String get financeFormChooseCustomer => 'Escolher cliente';

  @override
  String get financeFormNoCustomers => 'Ainda não há clientes';

  @override
  String get financeFormPaidNow => 'Pago agora';

  @override
  String get financeFormPaidNowHelper =>
      'Deixe vazio se o valor todo estiver em aberto.';

  @override
  String get financeFormPaidTooMuch => 'Não pode ser maior que o valor.';

  @override
  String get financeProfitTitle => 'Lucro por apiário';

  @override
  String get financeProfitUnknownApiary => 'Apiário excluído';

  @override
  String financeReceivables(String amount, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count clientes',
      one: '1 cliente',
    );
    return '$amount a receber · $_temp0';
  }

  @override
  String get syncTableCustomers => 'Cliente';

  @override
  String get syncTableCustomerPayments => 'Pagamento';

  @override
  String get customerUnpaid => 'Não pago';

  @override
  String customerPartiallyPaid(String paid, String remaining) {
    return '$paid pago, faltam $remaining';
  }

  @override
  String get taskAksUpdateTitle => 'Não esqueça de atualizar o AKS';

  @override
  String get taskSourceAks => 'AKS';

  @override
  String get syncTableRefSupportPeriods => 'Período de subsídio';

  @override
  String get subsidiesTitle => 'Subsídios';

  @override
  String get subsidiesCheckTitle => 'Antes de solicitar';

  @override
  String get subsidiesActiveHives => 'Colmeias ativas no app';

  @override
  String get subsidiesDeclaredHives => 'Declaradas no AKS';

  @override
  String get subsidiesNotDeclared => 'Não informado';

  @override
  String get subsidiesCheckNotDeclared =>
      'Informe o número de colmeias que você declarou no AKS; ele é comparado com o app antes de solicitar.';

  @override
  String subsidiesCheckDiffers(String active, String declared) {
    return 'O app tem $active colmeias ativas, mas no AKS há $declared declaradas. Atualize seu registro no AKS antes de solicitar.';
  }

  @override
  String get subsidiesCheckMatches =>
      'Os números batem: o app e o AKS concordam.';

  @override
  String get subsidiesEditDeclared => 'Informar número declarado';

  @override
  String get subsidiesDeclaredOwnerOnly =>
      'Só o proprietário pode informar o número declarado.';

  @override
  String get subsidiesPeriodsTitle => 'Períodos de solicitação';

  @override
  String get subsidiesEmptyTitle => 'Ainda não há períodos de subsídio';

  @override
  String get subsidiesEmptyMessage =>
      'Os períodos de solicitação aparecem aqui quando anunciados; você recebe uma notificação quando um abrir.';

  @override
  String get subsidiesPhaseOpen => 'Aberto';

  @override
  String get subsidiesPhaseUpcoming => 'Em breve';

  @override
  String get subsidiesPhaseClosed => 'Encerrado';

  @override
  String subsidiesPeriodDates(String start, String end) {
    return '$start – $end';
  }

  @override
  String get subsidiesOpenSource => 'Abrir aviso oficial';

  @override
  String get subsidiesOpenSourceFailed => 'Não foi possível abrir o link';

  @override
  String get aksCountTitle => 'Colmeias no AKS';

  @override
  String get aksCountLabel => 'Número de colmeias declarado no AKS';

  @override
  String get aksCountHelper => 'Deixe vazio para pular a verificação.';

  @override
  String get aksCountInvalid => 'Digite um número entre 0 e 100.000';

  @override
  String get aksCountSave => 'Salvar';

  @override
  String get aksCountSaved => 'Número de colmeias do AKS salvo';

  @override
  String get aksCountNoOrganization =>
      'Os dados do negócio ainda não foram sincronizados com este celular; aguarde a sincronização.';

  @override
  String get knowledgeTitle => 'Base de conhecimento';

  @override
  String get knowledgeSearchHint => 'Reservas de inverno, varroa…';

  @override
  String knowledgeMonthLabel(String month, String place) {
    return '$month · $place';
  }

  @override
  String get knowledgePlaceTurkey => 'Turquia';

  @override
  String get knowledgePlaceNorthern => 'Hemisfério Norte';

  @override
  String get knowledgePlaceSouthern => 'Hemisfério Sul';

  @override
  String get knowledgeMonthTitle => 'O que fazer este mês';

  @override
  String get knowledgeDiagnosisTitle => 'Ajuda no diagnóstico';

  @override
  String get knowledgeDiagnosisSubtitle =>
      'Escolha um sinal e veja as causas possíveis';

  @override
  String get knowledgeAtlasTitle => 'Atlas de doenças e pragas';

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
  String get knowledgeGuidesTitle => 'Guias técnicos';

  @override
  String get knowledgeGuidesSubtitle =>
      'Divisões, introdução de rainhas, união, invernada';

  @override
  String get knowledgeCalculatorsTitle => 'Calculadoras';

  @override
  String get knowledgeCalculatorsSubtitle =>
      'Xarope, dose de medicamento, calendário de rainhas, produção';

  @override
  String get knowledgeRegulationsTitle => 'Resumos da legislação';

  @override
  String get knowledgeRegulationsSubtitle =>
      'Regulamento, apicultura migratória, norma do mel';

  @override
  String get knowledgeTrBadge => 'TR';

  @override
  String get knowledgeFirstYearTitle => 'Meu primeiro ano';

  @override
  String get knowledgeFirstYearSubtitle => 'Passo a passo para iniciantes';

  @override
  String get knowledgeCalendarTitle => 'Calendário da safra';

  @override
  String get knowledgeOffline => 'Todo o conteúdo abre off-line';

  @override
  String get knowledgeNoResultsTitle => 'Sem resultados';

  @override
  String get knowledgeNoResultsMessage => 'Tente outra palavra.';

  @override
  String get knowledgeCategoryEmptyTitle => 'Ainda não há artigos';

  @override
  String get knowledgeCategoryEmptyMessage =>
      'O conteúdo desta seção virá numa atualização.';

  @override
  String get knowledgeArticleNotFound => 'Artigo não encontrado';

  @override
  String get knowledgeLoadError =>
      'Não foi possível abrir a base de conhecimento';

  @override
  String get knowledgeLinkFailed => 'Não foi possível abrir o link';

  @override
  String get diagnosisSymptoms => 'Sinais que você vê';

  @override
  String get diagnosisSymptomsHelper => 'Você pode escolher mais de um.';

  @override
  String get diagnosisResults => 'Doenças possíveis';

  @override
  String get diagnosisPickHint =>
      'Escolha um sinal para ver aqui as doenças possíveis.';

  @override
  String get diagnosisNoMatch =>
      'Nenhuma doença corresponde aos sinais escolhidos.';

  @override
  String diagnosisMatched(int matched, int total) {
    return 'Sinais coincidentes: $matched/$total';
  }

  @override
  String get diagnosisNotifiable => 'De notificação obrigatória';

  @override
  String get diagnosisDisclaimer =>
      'Esta é uma primeira avaliação; o diagnóstico final é dado por um veterinário ou laboratório.';

  @override
  String get diagnosisLoadError =>
      'Não foi possível abrir a tabela de diagnóstico';

  @override
  String get diagnosisNotFound => 'Doença não encontrada';

  @override
  String get diagnosisNotifiableTitle => 'Doença de notificação obrigatória.';

  @override
  String get diagnosisNotifiableMessage =>
      'Comunique a suspeita à autoridade; não compartilhe o equipamento, os quadros ou o mel desta colmeia com outras colmeias.';

  @override
  String get diagnosisAdvice => 'O que fazer';

  @override
  String get diagnosisAuthority => 'Autoridade';

  @override
  String diagnosisCall(String phone) {
    return 'Ligar para $phone';
  }

  @override
  String get diagnosisCallFailed => 'Não foi possível iniciar a ligação';

  @override
  String get diagnosisQuarantine => 'Pôr uma colmeia em quarentena';

  @override
  String get quarantinePickTitle => 'Colmeia para quarentena';

  @override
  String get quarantineSearchHint => 'Número da colmeia';

  @override
  String get quarantineNoHivesTitle => 'Sem colmeias';

  @override
  String get quarantineNoHivesMessage =>
      'Nenhuma colmeia ativa para pôr em quarentena.';

  @override
  String quarantineDone(String number) {
    return 'Colmeia $number em quarentena';
  }

  @override
  String get hiveQuarantined => 'Em quarentena';

  @override
  String hiveQuarantineDisease(String disease) {
    return 'Suspeita: $disease';
  }

  @override
  String hiveQuarantineSince(String date) {
    return 'Desde $date';
  }

  @override
  String get hiveQuarantineWarning =>
      'Não compartilhe o equipamento, os quadros ou o mel dela com outras colmeias.';

  @override
  String get hiveQuarantineEnd => 'Encerrar quarentena';

  @override
  String hiveQuarantineEnded(String number) {
    return 'A colmeia $number saiu da quarentena';
  }

  @override
  String get calculatorSyrup => 'Xarope';

  @override
  String get calculatorSyrupSubtitle => 'Açúcar e água necessários';

  @override
  String get calculatorDose => 'Dose do tratamento';

  @override
  String get calculatorDoseSubtitle => 'Total para o seu número de colmeias';

  @override
  String get calculatorQueen => 'Calendário de rainhas';

  @override
  String get calculatorQueenSubtitle =>
      'Dias de cada etapa a partir da transferência';

  @override
  String get calculatorYield => 'Produção';

  @override
  String get calculatorYieldSubtitle => 'Mel por colmeia';

  @override
  String get calculatorOffline =>
      'Os cálculos funcionam off-line e não salvam nada.';

  @override
  String get calculatorNotFound => 'Calculadora não encontrada';

  @override
  String get calculatorHives => 'Número de colmeias';

  @override
  String get calculatorSyrupKind => 'Tipo de xarope';

  @override
  String get calculatorFillHint =>
      'Informe o número de colmeias e a quantidade.';

  @override
  String get calculatorDosePerHive => 'Dose por colmeia';

  @override
  String get calculatorDoseUnit => 'Unidade';

  @override
  String get calculatorTotal => 'Total';

  @override
  String calculatorDoseTotal(String unit, String total) {
    String _temp0 = intl.Intl.selectLogic(unit, {
      'strip': '$total tiras',
      'ml': '$total ml',
      'g': '$total g',
      'other': '$total doses',
    });
    return '$_temp0';
  }

  @override
  String calculatorDoseCount(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmeias × $amount',
      one: '1 colmeia × $amount',
    );
    return '$_temp0';
  }

  @override
  String calculatorYieldTotal(String unit) {
    return 'Mel total ($unit)';
  }

  @override
  String get calculatorYieldPerHive => 'Por colmeia';

  @override
  String calculatorYieldValue(String amount, String unit) {
    return '$amount $unit';
  }

  @override
  String get calculatorQueenSteps => 'Etapas';

  @override
  String get hiveLossWintering => 'Invernada';

  @override
  String get hiveLossQueenless => 'Órfã';

  @override
  String get hiveLossVarroa => 'Varroa';

  @override
  String get hiveLossDisease => 'Doença';

  @override
  String get hiveLossStarvation => 'Fome';

  @override
  String get hiveLossRobbing => 'Pilhagem';

  @override
  String get hiveLossPredator => 'Urso / animal';

  @override
  String get hiveLossPoisoning => 'Envenenamento';

  @override
  String get hiveLossOther => 'Outra';

  @override
  String get hiveLossUnspecified => 'Não informado';

  @override
  String hiveLossReasonTitle(String number) {
    return 'Por que a colmeia $number foi perdida?';
  }

  @override
  String get hiveLossSkip => 'Pular sem motivo';

  @override
  String get hiveFormLossReason => 'Causa da perda';

  @override
  String get hiveFormLossReasonHelper =>
      'Usado no relatório da safra; pode ficar vazio.';

  @override
  String get seasonReportTile => 'Relatório da safra';

  @override
  String seasonTitle(String year) {
    return 'Safra $year';
  }

  @override
  String get seasonPdf => 'PDF';

  @override
  String get seasonExportCsv => 'Exportar para Excel (CSV)';

  @override
  String get seasonExportError =>
      'Não foi possível criar o arquivo. Tente de novo.';

  @override
  String get seasonLoadError =>
      'Não foi possível carregar o relatório da safra.';

  @override
  String get seasonHives => 'Colmeias';

  @override
  String seasonHiveChange(int start, int end) {
    return '$start → $end';
  }

  @override
  String seasonNetGain(int count) {
    return '+$count líquido';
  }

  @override
  String seasonNetLoss(int count) {
    return '−$count líquido';
  }

  @override
  String get seasonNetSame => 'Sem mudança';

  @override
  String get seasonWinterLoss => 'Perda no inverno';

  @override
  String get seasonWinterNotStarted => 'O inverno ainda não começou';

  @override
  String seasonPreviousWinter(String year) {
    return 'Perda no inverno $year';
  }

  @override
  String seasonPreviousWinterRate(String year, String rate) {
    return '$year: $rate';
  }

  @override
  String get seasonHoney => 'Mel total';

  @override
  String get seasonNewQueens => 'Rainhas novas';

  @override
  String seasonOwnReared(int count) {
    return 'criação própria $count';
  }

  @override
  String get seasonLossesTitle => 'Perdas e causas';

  @override
  String get seasonNoLosses => 'Nenhuma colmeia perdida nesta safra.';

  @override
  String seasonHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colmeias',
      one: '1 colmeia',
    );
    return '$_temp0';
  }

  @override
  String get seasonByTreatment => 'Perda no inverno · por método de tratamento';

  @override
  String get seasonByApiary => 'Perda no inverno · por apiário';

  @override
  String get seasonByQueenLine => 'Perda no inverno · por linhagem de rainha';

  @override
  String get seasonTabTreatment => 'Tratamento';

  @override
  String get seasonTabApiary => 'Apiário';

  @override
  String get seasonTabQueenLine => 'Linhagem';

  @override
  String get seasonNoWinterData =>
      'Nos seus registros ainda não há colmeias que entraram no inverno.';

  @override
  String get seasonFewData => 'poucos dados';

  @override
  String get seasonMisleadingNote =>
      'Dos seus próprios registros; com poucas colmeias pode enganar.';

  @override
  String get seasonUntreated => 'Sem tratamento';

  @override
  String get seasonMethodSeparator => ' +';

  @override
  String get seasonQueenLineUnknown => 'Linhagem desconhecida';

  @override
  String get seasonFinanceTitle => 'Custo e lucro';

  @override
  String get seasonProfit => 'Lucro';

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
    return '$count (criação própria $own)';
  }

  @override
  String seasonPdfWinterLoss(String rate, int lost, int hives) {
    return '$rate ($lost de $hives colmeias)';
  }

  @override
  String get seasonPdfReason => 'Causa';

  @override
  String get seasonPdfHives => 'Colmeias';

  @override
  String get seasonPdfLost => 'Perdidas';

  @override
  String get seasonPdfRate => 'Perda';

  @override
  String get seasonPdfGroup => 'Grupo';

  @override
  String get seasonPdfTotal => 'Total';

  @override
  String get seasonCsvHive => 'Colmeia';

  @override
  String get seasonCsvApiary => 'Apiário';

  @override
  String get seasonCsvStartStatus => 'Situação no início da safra';

  @override
  String get seasonCsvEndStatus => 'Situação no fim da safra';

  @override
  String get seasonCsvLossDate => 'Data da perda';

  @override
  String get seasonCsvLossReason => 'Causa da perda';

  @override
  String get seasonCsvInWinter => 'Entrou no inverno';

  @override
  String get seasonCsvLostInWinter => 'Perdida no inverno';

  @override
  String get seasonCsvWinterApiary => 'Apiário de inverno';

  @override
  String get seasonCsvTreatment => 'Tratamento antes do inverno';

  @override
  String get seasonCsvQueenLine => 'Linhagem da rainha';

  @override
  String get seasonCsvAddedInSeason => 'Adicionada nesta safra';

  @override
  String get seasonCsvYes => 'Sim';

  @override
  String get seasonCsvNo => 'Não';

  @override
  String get offlineMapsTitle => 'Mapas off-line';

  @override
  String get offlineMapsIntro =>
      'Baixe a região dos seus apiários; o mapa abre mesmo sem sinal.';

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
    return 'Baixado · $size';
  }

  @override
  String offlineMapsDownloadingWifi(String received, String total) {
    return 'Baixando pelo Wi‑Fi · $received / $total';
  }

  @override
  String offlineMapsDownloading(String received, String total) {
    return 'Baixando · $received / $total';
  }

  @override
  String offlineMapsDownload(String name) {
    return 'Baixar $name';
  }

  @override
  String get offlineMapsCancel => 'Parar download';

  @override
  String offlineMapsDelete(String name) {
    return 'Excluir $name';
  }

  @override
  String offlineMapsDeleteTitle(String name) {
    return 'Excluir $name?';
  }

  @override
  String get offlineMapsDeleteMessage =>
      'Sem internet, o mapa em volta deste apiário não vai abrir. Você pode baixá-lo de novo quando quiser.';

  @override
  String get offlineMapsDeleteConfirm => 'Excluir';

  @override
  String get offlineMapsWifiOnly => 'Baixar só pelo Wi‑Fi';

  @override
  String get offlineMapsWifiOnlyHint =>
      'Alguns MB por apiário; não usa dados móveis.';

  @override
  String offlineMapsStop(String name) {
    return 'Parada $name';
  }

  @override
  String offlineMapsDone(String name) {
    return 'Região de $name baixada';
  }

  @override
  String offlineMapsFailed(String name) {
    return 'Não foi possível baixar a região de $name. Verifique sua conexão e tente de novo.';
  }

  @override
  String get offlineMapsNeedsWifi =>
      'Conecte-se a um Wi‑Fi ou desligue \"Baixar só pelo Wi‑Fi\".';

  @override
  String get offlineMapsAttribution =>
      'Dados do mapa © OpenStreetMap contributors · OpenFreeMap';

  @override
  String get settingsOfflineMaps => 'Mapas off-line';

  @override
  String settingsOfflineMapsValue(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count apiários · $size',
      one: '1 apiário · $size',
      zero: 'Nenhum',
    );
    return '$_temp0';
  }

  @override
  String get offlineMapsCoverage =>
      'Cada apiário recebe 6 km em volta com detalhe e 40 km como visão geral.';

  @override
  String offlineMapsDownloadedOn(String date) {
    return 'baixado: $date';
  }

  @override
  String get offlineMapsToDownload => 'Apiários para baixar';

  @override
  String get offlineMapsMoved => 'Apiário mudou de lugar, baixe de novo';

  @override
  String get offlineMapsNoApiaries =>
      'Nenhum apiário com localização. Adicione uma localização a um apiário e ele aparece aqui.';

  @override
  String get offlineMapsAllDownloaded =>
      'Todos os apiários com localização estão baixados.';

  @override
  String get syncReminderTitle =>
      'Seus registros ainda não têm cópia de segurança';

  @override
  String syncReminderBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count registros não chegam ao servidor há 3 dias. Abra o app quando estiver on-line.',
      one: '1 registro não chega ao servidor há 3 dias. Abra o app quando estiver on-line.',
    );
    return '$_temp0';
  }

  @override
  String get syncOverdueTitle => 'Sem cópia de segurança há mais de 3 dias';

  @override
  String syncOverdueMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count registros estão só neste celular. Se o celular se perder, eles também se perdem. Conecte-se à internet e sincronize.',
      one: '1 registro está só neste celular. Se o celular se perder, ele também se perde. Conecte-se à internet e sincronize.',
    );
    return '$_temp0';
  }

  @override
  String syncDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'há $days dias',
      one: 'ontem',
      zero: 'hoje',
    );
    return '$_temp0';
  }

  @override
  String syncLastSyncedAgo(String ago, String when) {
    return 'Última sincronização $ago · $when';
  }

  @override
  String syncPendingTitle(int count) {
    return 'Esperando envio · $count';
  }

  @override
  String settingsSignOutPendingMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count registros ainda não foram enviados ao servidor e estão só neste celular. Se você sair, eles não serão enviados. Conecte-se à internet e sincronize primeiro.',
      one: '1 registro ainda não foi enviado ao servidor e está só neste celular. Se você sair, ele não será enviado. Conecte-se à internet e sincronize primeiro.',
    );
    return '$_temp0';
  }

  @override
  String get settingsSignOutAnyway => 'Sair mesmo assim';

  @override
  String get settingsExport => 'Exportar dados';

  @override
  String get settingsExportValue => 'Excel';

  @override
  String get settingsExportHint =>
      'Todos os seus registros num arquivo do Excel; compartilhe ou salve onde quiser.';

  @override
  String get exportPreparing => 'Preparando…';

  @override
  String get exportFailed =>
      'Não foi possível preparar o arquivo. Tente de novo.';

  @override
  String exportFileName(String date) {
    return 'Mobil Arıcı $date';
  }

  @override
  String get exportYes => 'Sim';

  @override
  String get exportNo => 'Não';

  @override
  String get exportSheetApiaries => 'Apiários';

  @override
  String get exportSheetHives => 'Colmeias';

  @override
  String get exportSheetQueens => 'Rainhas';

  @override
  String get exportSheetInspections => 'Revisões';

  @override
  String get exportSheetFeedings => 'Alimentações';

  @override
  String get exportSheetTreatments => 'Tratamentos';

  @override
  String get exportSheetMiteCounts => 'Contagens de varroa';

  @override
  String get exportSheetHarvests => 'Colheitas';

  @override
  String get exportSheetTasks => 'Tarefas';

  @override
  String get exportSheetInventory => 'Estoque';

  @override
  String get exportSheetFinance => 'Receitas e despesas';

  @override
  String get exportColName => 'Nome';

  @override
  String get exportColLatitude => 'Latitude';

  @override
  String get exportColLongitude => 'Longitude';

  @override
  String get exportColAltitude => 'Altitude (m)';

  @override
  String get exportColWaterSource => 'Fonte de água';

  @override
  String get exportColVehicleDistance => 'Distância do veículo (m)';

  @override
  String get exportColRoadNotes => 'Notas do caminho';

  @override
  String get exportColNotes => 'Observações';

  @override
  String get exportColActiveHives => 'Colmeias ativas';

  @override
  String get exportColCreated => 'Adicionado';

  @override
  String get exportColApiary => 'Apiário';

  @override
  String get exportColHive => 'Colmeia';

  @override
  String get exportColType => 'Tipo';

  @override
  String get exportColStatus => 'Situação';

  @override
  String get exportColBoxes => 'Caixas';

  @override
  String get exportColFrames => 'Quadros';

  @override
  String get exportColSource => 'Origem';

  @override
  String get exportColMarking => 'Marcação';

  @override
  String get exportColTag => 'Código da etiqueta';

  @override
  String get exportColQuarantine => 'Quarentena';

  @override
  String get exportColQueen => 'Rainha';

  @override
  String get exportColYear => 'Ano';

  @override
  String get exportColColor => 'Cor da marcação';

  @override
  String get exportColBreed => 'Raça';

  @override
  String get exportColLine => 'Linhagem';

  @override
  String get exportColWingClipped => 'Asa cortada';

  @override
  String get exportColDate => 'Data';

  @override
  String get exportColQueenState => 'Rainha';

  @override
  String get exportColBeeFrames => 'Quadros com abelhas';

  @override
  String get exportColBroodFrames => 'Quadros de cria';

  @override
  String get exportColHoneyFrames => 'Quadros de mel';

  @override
  String get exportColTemperament => 'Temperamento';

  @override
  String get exportColSwarmSigns => 'Sinais de enxameação';

  @override
  String get exportColQueenCells => 'Realeiras';

  @override
  String get exportColDisease => 'Suspeita de doença';

  @override
  String get exportColActions => 'Feito';

  @override
  String get exportColAmount => 'Quantidade';

  @override
  String get exportColUnit => 'Unidade';

  @override
  String get exportColProduct => 'Produto';

  @override
  String get exportColActiveIngredient => 'Princípio ativo';

  @override
  String get exportColDose => 'Dose';

  @override
  String get exportColWithdrawal => 'Carência (dias)';

  @override
  String get exportColBatch => 'Nº do lote';

  @override
  String get exportColPlannedRemoval => 'Retirada prevista';

  @override
  String get exportColMethod => 'Método';

  @override
  String get exportColMites => 'Ácaros';

  @override
  String get exportColSampleBees => 'Abelhas da amostra';

  @override
  String get exportColDays => 'Dias';

  @override
  String get exportColResult => 'Resultado';

  @override
  String get exportColHoneyKind => 'Mel';

  @override
  String get exportColUnitCount => 'Quantidade';

  @override
  String get exportColNetKg => 'Líquido (kg)';

  @override
  String get exportColHiveCount => 'Colmeias';

  @override
  String get exportColDue => 'Prazo';

  @override
  String get exportColTitle => 'Título';

  @override
  String get exportColCompleted => 'Concluída';

  @override
  String get exportColCategory => 'Categoria';

  @override
  String get exportColPlace => 'Local';

  @override
  String get exportColStock => 'Em estoque';

  @override
  String get exportColThreshold => 'Avisar abaixo de';

  @override
  String get exportColCurrency => 'Moeda';

  @override
  String get exportColDescription => 'Descrição';

  @override
  String get businessTitle => 'Negócio';

  @override
  String get businessEdit => 'Editar';

  @override
  String get businessEditTitle => 'Editar negócio';

  @override
  String get businessCancel => 'Cancelar';

  @override
  String get businessSave => 'Salvar';

  @override
  String get businessSaveError =>
      'Não foi possível salvar; o negócio ainda não está neste celular.';

  @override
  String get businessMissingTitle => 'Sem dados do negócio';

  @override
  String get businessMissingMessage =>
      'Eles aparecem aqui quando o negócio chegar a este celular.';

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
  String get businessRegionOther => 'Perfil geral';

  @override
  String get businessPendingSync => 'Ainda não sincronizado';

  @override
  String businessCountHives(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'colmeias',
      one: 'colmeia',
    );
    return '$_temp0';
  }

  @override
  String businessCountApiaries(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'apiários',
      one: 'apiário',
    );
    return '$_temp0';
  }

  @override
  String businessCountInspections(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'revisões',
      one: 'revisão',
    );
    return '$_temp0';
  }

  @override
  String get businessSectionBusiness => 'Negócio';

  @override
  String get businessSectionAccount => 'Conta';

  @override
  String get businessType => 'Tipo';

  @override
  String get businessTypeMigratory => 'Migratório';

  @override
  String get businessTypeStationary => 'Fixo';

  @override
  String get businessTypeHelp =>
      'O tipo fixo oculta planos de migração e mudanças; os registros não são excluídos.';

  @override
  String get businessCurrency => 'Moeda';

  @override
  String get businessCurrencySearch => 'Buscar código ou país';

  @override
  String get businessCurrencyNoMatch =>
      'Nenhuma moeda corresponde à sua busca.';

  @override
  String get businessCurrencyNote =>
      'Os registros anteriores não são convertidos; a nova moeda vale só para os registros daqui em diante.';

  @override
  String businessTeamTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Equipe · $count pessoas',
      one: 'Equipe · 1 pessoa',
    );
    return '$_temp0';
  }

  @override
  String get businessTeamSolo => 'Ainda não há membros na equipe';

  @override
  String businessRoleCountOwner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count proprietários',
      one: '1 proprietário',
    );
    return '$_temp0';
  }

  @override
  String businessRoleCountPartner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sócios',
      one: '1 sócio',
    );
    return '$_temp0';
  }

  @override
  String businessRoleCountWorker(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count funcionários',
      one: '1 funcionário',
    );
    return '$_temp0';
  }

  @override
  String businessRoleCountViewer(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count consultores',
      one: '1 consultor',
    );
    return '$_temp0';
  }

  @override
  String get businessEmail => 'E-mail de acesso';

  @override
  String get businessEmailSoon => 'A troca de e-mail chega em breve.';

  @override
  String get businessFirstRecord => 'Primeiro registro';

  @override
  String businessFirstRecordValue(String date, int season) {
    return '$date · safra $season';
  }

  @override
  String get businessSettingsShortcut => 'Idioma, unidades, tema e dados';

  @override
  String get businessNameLabel => 'Nome do negócio';

  @override
  String get businessAvatarLabel => 'Avatar';

  @override
  String get businessAvatarHelp =>
      'Sem logo, suas iniciais aparecem na cor que você escolher.';

  @override
  String get businessAvatarPine => 'Pinho';

  @override
  String get businessAvatarHoney => 'Mel';

  @override
  String get businessAvatarSky => 'Céu';

  @override
  String get businessAvatarSlate => 'Ardósia';

  @override
  String get businessLogoUpload => 'Enviar logo';

  @override
  String get businessLogoRemove => 'Remover logo';

  @override
  String get businessDiscardTitle => 'Descartar alterações?';

  @override
  String get businessDiscardMessage =>
      'Suas alterações não salvas serão perdidas.';

  @override
  String get businessDiscardAction => 'Descartar';

  @override
  String get businessTypeConfirmTitle => 'Mudar para fixo?';

  @override
  String businessTypeConfirmMessage(int plans, int stops) {
    String _temp0 = intl.Intl.pluralLogic(
      plans,
      locale: localeName,
      other: '$plans planos de migração',
      one: '1 plano de migração',
    );
    String _temp1 = intl.Intl.pluralLogic(
      stops,
      locale: localeName,
      other: '$stops paradas',
      one: '1 parada',
    );
    return '$_temp0 e $_temp1 serão ocultados. Os registros não são excluídos; você pode desfazer.';
  }

  @override
  String get businessTypeConfirmAction => 'Mudar';

  @override
  String get businessReadOnly =>
      'Só o proprietário e os sócios podem mudar os dados do negócio.';

  @override
  String get financeOtherCurrencies => 'Outras moedas';

  @override
  String financeOtherCurrencyLine(String currency, String amount) {
    return '$currency · líquido $amount';
  }

  @override
  String get migratoryHiddenTitle => 'O módulo migratório está desligado';

  @override
  String get migratoryHiddenMessage =>
      'Seu negócio é fixo. Planos de migração e mudanças não são excluídos; eles voltam se você mudar para migratório.';

  @override
  String get onboardingMigratoryTitle =>
      'Você muda suas colmeias de lugar (migratória)?';

  @override
  String get onboardingMigratoryMessage =>
      'Se não, planos de migração e mudanças ficam ocultos; você pode mudar isso quando quiser no perfil do negócio.';

  @override
  String get onboardingMigratoryYes => 'Sim';

  @override
  String get onboardingMigratoryNo => 'Não, fixo';

  @override
  String get settingsDeleteAccount => 'Excluir minha conta';

  @override
  String get settingsDeleteAccountOffline =>
      'Excluir sua conta precisa de conexão com a internet; tente de novo quando estiver on-line.';

  @override
  String get deletionTitle => 'Excluir minha conta';

  @override
  String deletionStepCounter(int current, int total) {
    return 'Passo $current de $total';
  }

  @override
  String get deletionContinue => 'Continuar';

  @override
  String get deletionSoloTitle => 'Sua conta e seu negócio serão excluídos';

  @override
  String deletionSoloMessage(String organization) {
    return 'Você é a única pessoa em $organization. Excluir sua conta também exclui o negócio e todos os registros dele.';
  }

  @override
  String get deletionCountsLabel => 'Registros que serão excluídos';

  @override
  String get deletionCountHives => 'Colmeias';

  @override
  String get deletionCountApiaries => 'Apiários';

  @override
  String get deletionCountInspections => 'Revisões';

  @override
  String get deletionCountHarvests => 'Colheitas';

  @override
  String get deletionCountDocuments => 'Documentos';

  @override
  String get deletionCountPhotos => 'Fotos';

  @override
  String get deletionLotWarningTitle => 'Os códigos QR vão parar de funcionar.';

  @override
  String deletionLotWarningMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count páginas públicas de lote serão excluídas e os códigos QR dos seus potes vão parar de funcionar.',
      one: '1 página pública de lote será excluída e os códigos QR dos seus potes vão parar de funcionar.',
    );
    return '$_temp0';
  }

  @override
  String get deletionTeamTitle =>
      'Você tem uma equipe: escolha o que acontece com o negócio';

  @override
  String deletionTeamMessage(int count, String organization) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Você é proprietário de $organization e há mais $count pessoas na equipe.',
      one: 'Você é proprietário de $organization e há mais 1 pessoa na equipe.',
    );
    return '$_temp0';
  }

  @override
  String get deletionChoiceTransfer => 'Transferir a propriedade e sair';

  @override
  String get deletionChoiceTransferHint =>
      'O negócio e seus registros continuam. O sócio que você escolher vira o proprietário; só sua conta é excluída.';

  @override
  String get deletionChoiceDelete => 'Excluir o negócio e todos os registros';

  @override
  String deletionChoiceDeleteHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'As outras $count pessoas da equipe também perdem o acesso.',
      one: 'A outra pessoa da equipe também perde o acesso.',
    );
    return '$_temp0';
  }

  @override
  String get deletionTransferPick => 'Novo proprietário';

  @override
  String get deletionTransferNoPartner =>
      'Para transferir, alguém da equipe precisa ser sócio. Torne um membro sócio na tela Equipe ou exclua o negócio.';

  @override
  String get deletionPartnerFallbackName => 'Sócio';

  @override
  String get deletionMemberTitle => 'Só a sua conta será excluída';

  @override
  String deletionMemberMessage(String organization) {
    return '$organization e seus registros não são excluídos. Os registros que você lançou ficam no negócio; seu nome sai da equipe.';
  }

  @override
  String get deletionUnknownMessage =>
      'Sua participação ainda não chegou a este celular. Tente de novo depois de sincronizar.';

  @override
  String get deletionGraceNote =>
      'A exclusão fica definitiva depois de 7 dias; até lá você pode entrar e mudar de ideia.';

  @override
  String get deletionBackupTitle => 'Salve seus dados primeiro';

  @override
  String get deletionBackupMessage =>
      'Registros excluídos não podem ser recuperados. Recomendamos salvar uma cópia antes.';

  @override
  String get deletionBackupReports => 'Relatórios em PDF';

  @override
  String get deletionBackupReportsHint => 'Baixe relatórios prontos em PDF.';

  @override
  String get deletionBackupJson => 'Todos os registros';

  @override
  String get deletionBackupJsonValue => 'JSON';

  @override
  String get deletionBackupJsonHint =>
      'Todos os seus registros num arquivo; salve onde quiser.';

  @override
  String get deletionBackupSaved => 'Salvo';

  @override
  String get deletionBackupDownload => 'Baixar meus registros';

  @override
  String get deletionBackupSkip => 'Pular';

  @override
  String deletionBackupFileName(String date) {
    return 'mobil-arici-registros-$date';
  }

  @override
  String get deletionVerifyTitle => 'Confirme que é você';

  @override
  String get deletionVerifyButton => 'Verificar código';

  @override
  String get deletionConfirmTitle => 'Confirmação final';

  @override
  String get deletionConfirmIntro => 'Se você confirmar:';

  @override
  String deletionConsequenceAccount(String date) {
    return 'Sua conta será excluída definitivamente em $date.';
  }

  @override
  String deletionConsequenceOrganization(String organization) {
    return '$organization e todos os registros dele também são excluídos.';
  }

  @override
  String deletionConsequenceTransfer(String name, String organization) {
    return '$name vira o novo proprietário de $organization.';
  }

  @override
  String get deletionConsequenceRecordsStay =>
      'Os registros do negócio não são excluídos.';

  @override
  String deletionConsequenceLots(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count páginas de lote são fechadas; os códigos QR delas param de funcionar.',
      one: '1 página de lote é fechada; os códigos QR dela param de funcionar.',
    );
    return '$_temp0';
  }

  @override
  String get deletionConsequenceSignOut =>
      'Você sai da conta e os dados deste celular são apagados.';

  @override
  String get deletionConsequenceCancel =>
      'Se você entrar antes disso, pode cancelar a exclusão.';

  @override
  String deletionConfirmTypeName(String organization) {
    return 'Para confirmar, digite o nome do negócio: $organization';
  }

  @override
  String deletionConfirmTypeKeyword(String keyword) {
    return 'Para confirmar, digite $keyword';
  }

  @override
  String get deletionKeyword => 'EXCLUIR';

  @override
  String get deletionConfirmButton => 'Excluir minha conta';

  @override
  String get deletionConfirmButtonWithOrganization =>
      'Excluir minha conta e o negócio';

  @override
  String get deletionSubmitting => 'Enviando…';

  @override
  String get deletionFailureNetwork =>
      'Não foi possível alcançar o servidor. Verifique sua conexão e tente de novo.';

  @override
  String get deletionFailureOwnerMustTransfer =>
      'Você também é proprietário de outro negócio com equipe. Transfira a propriedade lá primeiro.';

  @override
  String get deletionFailureInvalidTransfer =>
      'A pessoa escolhida não é mais sócia. Escolha outro sócio.';

  @override
  String get deletionFailureRateLimited =>
      'Muitas tentativas em pouco tempo. Tente de novo amanhã.';

  @override
  String get deletionFailureForbidden =>
      'Sua sessão terminou. Entre de novo e tente outra vez.';

  @override
  String get deletionFailureCodeRequired =>
      'Sua confirmação expirou. Peça um novo código e verifique de novo.';

  @override
  String get deletionFailureUnknown =>
      'Não foi possível enviar o pedido. Tente de novo daqui a pouco.';

  @override
  String get deletionDoneTitle => 'Recebemos seu pedido';

  @override
  String deletionDoneDate(String date) {
    return 'Sua conta será excluída definitivamente em $date.';
  }

  @override
  String get deletionDoneCancelHint =>
      'Se mudar de ideia, entre antes dessa data e a exclusão é cancelada.';

  @override
  String get deletionDoneEmail =>
      'Também enviamos os detalhes para o seu e-mail.';

  @override
  String get deletionDoneClearing => 'Apagando os dados deste celular…';

  @override
  String get deletionDoneSignedOut =>
      'Você saiu da conta e os dados deste celular foram apagados.';

  @override
  String get deletionDoneAction => 'Pronto';

  @override
  String get deletionPendingTitle => 'Sua conta está prestes a ser excluída';

  @override
  String deletionPendingMessage(String date) {
    return 'Sua conta será excluída em $date. Se você continuar, a exclusão é cancelada.';
  }

  @override
  String get deletionPendingContinue => 'Continuar e manter minha conta';

  @override
  String get deletionPendingSignOut => 'Sair e manter a exclusão';

  @override
  String get deletionPendingCancelled =>
      'Exclusão cancelada. Que bom ter você de volta!';

  @override
  String get deletionPendingCancelFailed =>
      'Não foi possível cancelar a exclusão. Verifique sua conexão e tente de novo.';

  @override
  String teamMemberLeaving(String date) {
    return 'Excluindo a conta · $date';
  }

  @override
  String get teamErrorMemberLeaving =>
      'Esta pessoa está excluindo a conta; durante o período de espera, o papel dela não pode ser mudado e ela não pode ser removida.';
}
