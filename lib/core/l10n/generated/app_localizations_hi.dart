// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Mobil Arıcı';

  @override
  String get listSeparator => ',';

  @override
  String get stepperIncrease => 'बढ़ाएँ';

  @override
  String get stepperDecrease => 'घटाएँ';

  @override
  String hiveTileLabel(String number) {
    return 'छत्ता $number';
  }

  @override
  String hiveTileStrength(int strength) {
    return 'ताक़त 5 में से $strength';
  }

  @override
  String hiveTileQueenColor(String color) {
    String _temp0 = intl.Intl.selectLogic(color, {
      'white': 'सफ़ेद',
      'yellow': 'पीला',
      'red': 'लाल',
      'green': 'हरा',
      'blue': 'नीला',
      'other': 'अज्ञात',
    });
    return 'रानी का रंग $_temp0';
  }

  @override
  String get tabToday => 'आज';

  @override
  String get tabApiaries => 'फार्म';

  @override
  String get tabTasks => 'काम';

  @override
  String get tabMore => 'और';

  @override
  String get todayEmptyTitle => 'अपना मधुमक्खी फार्म जोड़कर शुरू करें';

  @override
  String get todayEmptyMessage =>
      'तीन कदम में तैयार: फार्म जोड़ें, छत्ते बनाएँ, पहला निरीक्षण करें।';

  @override
  String get apiariesEmptyTitle => 'अभी कोई फार्म नहीं';

  @override
  String get apiariesEmptyMessage =>
      'फार्म आपके छत्तों को उनकी जगह के हिसाब से समूह में रखता है; शुरू करने के लिए पहला जोड़ें।';

  @override
  String get apiariesAdd => 'फार्म जोड़ें';

  @override
  String get apiariesAddFirst => 'पहला फार्म जोड़ें';

  @override
  String get apiariesLoadError => 'आपके फार्म पढ़े नहीं जा सके।';

  @override
  String get apiariesViewList => 'सूची';

  @override
  String get apiariesViewMap => 'नक्शा';

  @override
  String get apiariesMapOfflineTitle => 'नक्शा उपलब्ध नहीं';

  @override
  String get apiariesMapOfflineMessage =>
      'नक्शे के लिए इंटरनेट चाहिए। आपके फार्म नीचे सूची में हैं।';

  @override
  String get apiariesMapNoLocation =>
      'अभी किसी फार्म की लोकेशन नहीं है। किसी फार्म को संपादित करके GPS से लोकेशन लें या नक्शे पर चुनें।';

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
      other: '$count छत्तों पर ध्यान चाहिए',
      one: '1 छत्ते पर ध्यान चाहिए',
    );
    return '$_temp0';
  }

  @override
  String get apiaryMapDirections => 'रास्ता';

  @override
  String get apiaryMapShow => 'दिखाएँ';

  @override
  String get apiaryMapDirectionsFailed => 'नक्शा ऐप नहीं खुल सका।';

  @override
  String get apiaryMapDirectionsChooseApp => 'रास्ता देखें इसमें';

  @override
  String apiaryHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count छत्ते',
      one: '1 छत्ता',
      zero: 'कोई छत्ता नहीं',
    );
    return '$_temp0';
  }

  @override
  String apiaryLastVisit(String date) {
    return 'पिछली विज़िट $date';
  }

  @override
  String get apiaryNoVisit => 'अभी कोई विज़िट नहीं';

  @override
  String get apiaryEdit => 'संपादित करें';

  @override
  String get apiaryDelete => 'फार्म हटाएँ';

  @override
  String get apiaryDeleteTitle => 'यह फार्म हटाएँ?';

  @override
  String get apiaryDeleteMessage => 'फार्म हर फ़ोन से हट जाएगा।';

  @override
  String apiaryDeleteWithHivesMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'इस फार्म में $count छत्ते हैं। फार्म और उसके छत्ते हर फ़ोन से हट जाएँगे।',
      one: 'इस फार्म में 1 छत्ता है। फार्म और उसका छत्ता हर फ़ोन से हट जाएँगे।',
    );
    return '$_temp0';
  }

  @override
  String get apiaryDeleted => 'फार्म हटा दिया गया';

  @override
  String get apiaryNotFoundTitle => 'फार्म नहीं मिला';

  @override
  String get apiaryNotFoundMessage =>
      'हो सकता है यह हटा दिया गया हो या अभी इस डिवाइस तक न पहुँचा हो।';

  @override
  String get apiaryFormNewTitle => 'नया फार्म';

  @override
  String get apiaryFormEditTitle => 'फार्म संपादित करें';

  @override
  String get apiaryFormName => 'फार्म का नाम';

  @override
  String get apiaryFormNameHint => 'जैसे पहाड़ी वाला';

  @override
  String get apiaryFormLocation => 'लोकेशन';

  @override
  String get apiaryFormLocationNone =>
      'अभी कोई लोकेशन नहीं। अगर आप फार्म पर हैं, तो GPS से लें, इंटरनेट की ज़रूरत नहीं; वरना नक्शे पर चुनें।';

  @override
  String get apiaryFormLocationTake => 'GPS से लोकेशन लें';

  @override
  String get apiaryFormLocationRetake => 'लोकेशन फिर से लें';

  @override
  String get apiaryFormLocationClear => 'लोकेशन हटाएँ';

  @override
  String get apiaryFormLocationPickOnMap => 'नक्शे पर चुनें';

  @override
  String get locationPickerTitle => 'नक्शे पर लोकेशन चुनें';

  @override
  String get locationPickerSearchHint => 'गाँव या जगह खोजें';

  @override
  String get locationPickerSearch => 'खोजें';

  @override
  String get locationPickerHint => 'पिन को फार्म पर लाने के लिए नक्शा खिसकाएँ।';

  @override
  String get locationPickerPinLabel => 'चुनी गई लोकेशन';

  @override
  String get locationPickerConfirm => 'यह लोकेशन इस्तेमाल करें';

  @override
  String get locationPickerNoResults =>
      'कोई जगह नहीं मिली। कोई दूसरा नाम आज़माएँ।';

  @override
  String get locationPickerSearchOffline =>
      'खोज नहीं हो सकी। खोज के लिए इंटरनेट चाहिए।';

  @override
  String get locationPickerMapOfflineMessage =>
      'नक्शे के लिए इंटरनेट चाहिए। अगर आप फार्म पर हैं, तो GPS से लोकेशन लें।';

  @override
  String get apiaryFormLocating =>
      'आपकी लोकेशन ली जा रही है… खुली जगह में जल्दी मिलती है।';

  @override
  String apiaryFormLocationAccuracy(int meters) {
    return 'सटीकता ±$meters मी';
  }

  @override
  String get apiaryFormLocationErrorServiceDisabled =>
      'इस डिवाइस पर लोकेशन बंद है। इसे चालू करें और फिर कोशिश करें।';

  @override
  String get apiaryFormLocationErrorPermissionDenied =>
      'लोकेशन की अनुमति नहीं दी गई। लोकेशन लेने के लिए अनुमति दें।';

  @override
  String get apiaryFormLocationErrorPermissionDeniedForever =>
      'लोकेशन की अनुमति बंद है। सेटिंग्स में इस ऐप के लिए लोकेशन की अनुमति दें।';

  @override
  String get apiaryFormLocationErrorTimeout =>
      'लोकेशन नहीं मिली। खुली जगह में फिर कोशिश करें।';

  @override
  String get apiaryFormLocationErrorUnknown =>
      'लोकेशन नहीं मिल सकी। फिर कोशिश करें।';

  @override
  String get apiaryFormOpenSettings => 'सेटिंग्स खोलें';

  @override
  String get apiaryFormLandownerName => 'ज़मीन मालिक का नाम';

  @override
  String get apiaryFormLandownerPhone => 'ज़मीन मालिक का फ़ोन';

  @override
  String get apiaryFormNotes => 'नोट्स';

  @override
  String get apiaryFormSave => 'सहेजें';

  @override
  String get hiveSortWeakestFirst => 'सबसे कमज़ोर पहले';

  @override
  String get hivesEmptyTitle => 'अभी कोई छत्ता नहीं';

  @override
  String get hivesEmptyMessage =>
      'इस फार्म में रखे छत्ते जोड़ें; आप एक साथ कई बना सकते हैं।';

  @override
  String get hivesAdd => 'छत्ते जोड़ें';

  @override
  String get hivesAddOne => 'एक छत्ता';

  @override
  String get hivesAddOneHint => 'नंबर, प्रकार और स्रोत डालें';

  @override
  String get hivesAddBulk => 'एक साथ कई';

  @override
  String get hivesAddBulkHint => 'जैसे 101 से 20 छत्ते';

  @override
  String hivesInactiveTitle(int count) {
    return 'निष्क्रिय ($count)';
  }

  @override
  String get hivesLoadError => 'छत्ते पढ़े नहीं जा सके।';

  @override
  String hiveLabel(String number) {
    return 'छत्ता $number';
  }

  @override
  String hiveTypeAndSource(String type, String source) {
    return '$type · $source';
  }

  @override
  String get hiveTypeLangstroth => 'लैंगस्ट्रॉथ';

  @override
  String get hiveTypeDadant => 'डाडांट';

  @override
  String get hiveTypeLocal => 'देसी';

  @override
  String get hiveTypeOther => 'अन्य';

  @override
  String get hiveStatusActive => 'सक्रिय';

  @override
  String get hiveStatusDead => 'मर गया';

  @override
  String get hiveStatusMerged => 'मिलाया गया';

  @override
  String get hiveStatusSold => 'बेचा गया';

  @override
  String get hiveStatusLost => 'खो गया';

  @override
  String get hiveSourceSwarm => 'झुंड';

  @override
  String get hiveSourceSplit => 'विभाजन';

  @override
  String get hiveSourcePurchase => 'ख़रीदा';

  @override
  String get hiveSourcePackage => 'पैकेज मधुमक्खियाँ';

  @override
  String get hiveFormNewTitle => 'नया छत्ता';

  @override
  String get hiveFormEditTitle => 'छत्ता संपादित करें';

  @override
  String get hiveFormNumber => 'छत्ता नंबर';

  @override
  String get hiveFormNumberHint => 'जैसे 101';

  @override
  String get hiveFormType => 'छत्ते का प्रकार';

  @override
  String get hiveFormStatus => 'स्थिति';

  @override
  String get hiveFormSource => 'स्रोत';

  @override
  String get hiveFormSave => 'सहेजें';

  @override
  String get hiveBulkTitle => 'कई छत्ते बनाएँ';

  @override
  String get hiveBulkCount => 'कितने छत्ते';

  @override
  String get hiveBulkCountHint => 'जैसे 20';

  @override
  String hiveBulkCountTooMany(int max) {
    return 'एक बार में अधिकतम $max';
  }

  @override
  String get hiveBulkStart => 'पहला नंबर';

  @override
  String get hiveBulkStartHint => 'जैसे 101';

  @override
  String hiveBulkPreview(int count, String first, String last) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count छत्ते बनाए जाएँगे: $first से $last तक।',
      one: 'छत्ता $first बनाया जाएगा।',
    );
    return '$_temp0';
  }

  @override
  String get hiveBulkSave => 'छत्ते बनाएँ';

  @override
  String hiveBulkCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count छत्ते बनाए गए',
      one: '1 छत्ता बनाया गया',
    );
    return '$_temp0';
  }

  @override
  String get hiveNotFoundTitle => 'छत्ता नहीं मिला';

  @override
  String get hiveNotFoundMessage =>
      'हो सकता है यह हटा दिया गया हो या अभी इस डिवाइस तक न पहुँचा हो।';

  @override
  String get hiveEdit => 'संपादित करें';

  @override
  String get hiveDelete => 'छत्ता हटाएँ';

  @override
  String hiveDeleteTitle(String number) {
    return 'छत्ता $number हटाएँ?';
  }

  @override
  String get hiveDeleteMessage => 'छत्ता और उसके रिकॉर्ड हर फ़ोन से हट जाएँगे।';

  @override
  String hiveDeleted(String number) {
    return 'छत्ता $number हटाया गया';
  }

  @override
  String hiveCardApiary(String name) {
    return 'फार्म: $name';
  }

  @override
  String get hiveQueenTitle => 'रानी';

  @override
  String hiveQueenStripTitle(String queen) {
    return 'रानी · $queen';
  }

  @override
  String hiveStrengthBadge(String level, int strength) {
    return '$level · $strength/5';
  }

  @override
  String get hiveStrengthWeak => 'कमज़ोर';

  @override
  String get hiveStrengthMedium => 'मध्यम';

  @override
  String get hiveStrengthStrong => 'मज़बूत';

  @override
  String get hiveStrengthNone => 'अभी ताक़त का स्कोर नहीं';

  @override
  String get hiveTimelineTitle => 'इतिहास';

  @override
  String get timelineInspection => 'निरीक्षण';

  @override
  String get timelineAdded => 'फार्म में रखा गया';

  @override
  String get timelineMoved => 'स्थानांतरित';

  @override
  String timelineMoveRoute(String from, String to) {
    return '$from → $to';
  }

  @override
  String get timelineUnknownApiary => 'अज्ञात फार्म';

  @override
  String timelineField(String label, String value) {
    return '$label: $value';
  }

  @override
  String timelineBeeFrames(int count) {
    return '$count मधुमक्खियों वाले';
  }

  @override
  String timelineBroodFrames(int count) {
    return '$count ब्रूड वाले';
  }

  @override
  String timelineHoneyFrames(int count) {
    return '$count शहद वाले';
  }

  @override
  String get timelineActions => 'किया गया';

  @override
  String get hiveMove => 'दूसरे फार्म में ले जाएँ';

  @override
  String hiveMoveTitle(String number) {
    return 'छत्ता $number यहाँ ले जाएँ';
  }

  @override
  String get hiveMoveNoOtherApiary =>
      'ले जाने के लिए कोई दूसरा फार्म नहीं है। पहले फार्म टैब से एक जोड़ें।';

  @override
  String hiveMoved(String number, String apiary) {
    return 'छत्ता $number को $apiary में ले जाया गया';
  }

  @override
  String get hiveChangeStatus => 'स्थिति बदलें';

  @override
  String hiveStatusSheetTitle(String number) {
    return 'छत्ता $number की नई स्थिति';
  }

  @override
  String hiveStatusConfirmTitle(String status, String number) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'dead': 'छत्ता $number को मरा हुआ दर्ज करें?',
      'merged': 'छत्ता $number को मिलाया गया दर्ज करें?',
      'sold': 'छत्ता $number को बेचा गया दर्ज करें?',
      'other': 'छत्ता $number को खोया हुआ दर्ज करें?',
    });
    return '$_temp0';
  }

  @override
  String get hiveStatusConfirmMessage =>
      'यह फार्म के सक्रिय छत्तों में नहीं गिना जाएगा। बाद में आप इसे फिर सक्रिय कर सकते हैं।';

  @override
  String get hiveStatusConfirm => 'हाँ, दर्ज करें';

  @override
  String hiveStatusChanged(String number, String status) {
    return 'छत्ता $number: $status';
  }

  @override
  String get tasksEmptyTitle => 'अभी कोई काम नहीं';

  @override
  String get tasksEmptyMessage =>
      'आपके रिमाइंडर और काम यहाँ तारीख़ के हिसाब से दिखेंगे।';

  @override
  String get scanTitle => 'स्कैन';

  @override
  String get scanLongPressHint => 'तेज़ रिकॉर्ड मेन्यू खोलें';

  @override
  String get scanHint => 'छत्ते के लेबल का कोड फ़्रेम में रखें।';

  @override
  String get scanAgain => 'फिर स्कैन करें';

  @override
  String get cameraErrorTitle => 'कैमरा नहीं खुल सका';

  @override
  String get cameraErrorPermissionDenied =>
      'कैमरे की अनुमति नहीं दी गई। लेबल स्कैन करने के लिए सेटिंग्स में इस ऐप को कैमरे की अनुमति दें।';

  @override
  String get cameraErrorUnsupported =>
      'इस डिवाइस में स्कैन कर सकने वाला कैमरा नहीं है।';

  @override
  String get cameraErrorUnknown => 'यह स्क्रीन बंद करें और फिर कोशिश करें।';

  @override
  String get labelUnknownTitle => 'यह कोड किसी छत्ते से जुड़ा नहीं है';

  @override
  String get labelUnknownMessage =>
      'यह Mobil Arıcı का लेबल नहीं है या अभी किसी छत्ते को नहीं दिया गया। अगर यह किसी छत्ते पर है, तो उसे दें; फिर स्कैन करने पर छत्ते का कार्ड खुलेगा।';

  @override
  String get labelUnknownOwnTitle => 'इस लेबल का छत्ता नहीं मिला';

  @override
  String get labelUnknownOwnMessage =>
      'हो सकता है छत्ता हटा दिया गया हो या अभी इस फ़ोन तक न पहुँचा हो। आप लेबल किसी दूसरे छत्ते को भी दे सकते हैं।';

  @override
  String labelCode(String code) {
    return 'कोड: $code';
  }

  @override
  String get labelAssign => 'किसी छत्ते को दें';

  @override
  String get labelAssignTitle => 'लेबल किसी छत्ते को दें';

  @override
  String get labelAssignMessage =>
      'वह छत्ता चुनें जिस पर लेबल लगा है। फिर लेबल स्कैन करने पर उसी छत्ते का कार्ड खुलेगा।';

  @override
  String get labelAssignSearch => 'छत्ता नंबर';

  @override
  String get labelAssignNoMatch => 'आपकी खोज से कोई छत्ता नहीं मिला।';

  @override
  String get labelAssignNoHives =>
      'अभी कोई छत्ता नहीं। पहले फार्म टैब से छत्ते जोड़ें।';

  @override
  String get labelAssignHasOther => 'दूसरा लेबल है';

  @override
  String labelReplaceTitle(String number) {
    return 'छत्ता $number का लेबल बदलें?';
  }

  @override
  String get labelReplaceMessage =>
      'इस छत्ते पर पहले से लेबल है। नया लेबल उसकी जगह लेगा; पुराना लेबल अब यह छत्ता नहीं खोलेगा।';

  @override
  String get labelReplaceConfirm => 'हाँ, बदलें';

  @override
  String labelAssigned(String number) {
    return 'लेबल दिया गया: छत्ता $number';
  }

  @override
  String get hiveLabelsTitle => 'लेबल छापें';

  @override
  String get hiveLabelsMessage =>
      'जिन छत्तों के लिए लेबल चाहिए उन्हें चुनें। एक A4 पेज पर 24 लेबल (70 × 37 मिमी) आते हैं; 100% स्केल पर छापें।';

  @override
  String get hiveLabelsNoHives =>
      'इस फार्म में लेबल छापने के लिए कोई छत्ता नहीं है।';

  @override
  String get hiveLabelsSelectAll => 'सभी चुनें';

  @override
  String get hiveLabelsSelectNone => 'कोई नहीं चुनें';

  @override
  String get hiveLabelsNoneSelected => 'कोई छत्ता नहीं चुना';

  @override
  String hiveLabelsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लेबल',
      one: '1 लेबल',
    );
    return '$_temp0';
  }

  @override
  String hiveLabelsPages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count पेज',
      one: '1 पेज',
    );
    return '$_temp0';
  }

  @override
  String hiveLabelsSummary(String labels, String pages) {
    return '$labels · $pages';
  }

  @override
  String get hiveLabelsPreparing => 'PDF तैयार हो रहा है…';

  @override
  String get hiveLabelsPrint => 'छापें';

  @override
  String get hiveLabelsShare => 'PDF साझा करें';

  @override
  String hiveLabelsDocumentName(String apiary) {
    return 'छत्ता लेबल - $apiary';
  }

  @override
  String get hiveLabelsError => 'PDF तैयार नहीं हो सका। फिर कोशिश करें।';

  @override
  String get quickRecordTitle => 'तेज़ रिकॉर्ड';

  @override
  String get quickRecordInspection => 'निरीक्षण';

  @override
  String get quickRecordFeeding => 'भोजन';

  @override
  String get quickRecordTreatment => 'उपचार';

  @override
  String get quickRecordHarvest => 'शहद निकासी';

  @override
  String get quickRecordNote => 'नोट';

  @override
  String get quickRecordExpense => 'ख़र्च';

  @override
  String get quickRecordComingSoon => 'यह रिकॉर्ड प्रकार जल्द आ रहा है।';

  @override
  String get signInSendCode => 'कोड भेजें';

  @override
  String get signInSending => 'भेजा जा रहा है…';

  @override
  String signInCodeMessage(String email) {
    return 'हमने $email पर 6 अंकों का कोड भेजा है।';
  }

  @override
  String get signInCodeFieldLabel => '6 अंकों का कोड';

  @override
  String get signInVerify => 'साइन इन करें';

  @override
  String get signInVerifying => 'जाँच हो रही है…';

  @override
  String get signInResend => 'कोड फिर भेजें';

  @override
  String signInResendIn(int seconds) {
    return 'कोड फिर भेजें ($seconds से)';
  }

  @override
  String get signInCodeResent => 'नया कोड आ रहा है।';

  @override
  String get authErrorNetwork =>
      'कनेक्ट नहीं हो सका। इंटरनेट जाँचें और फिर कोशिश करें।';

  @override
  String get authErrorInvalidEmail => 'सही ईमेल पता डालें।';

  @override
  String get authErrorInvalidCode =>
      'कोड गलत है या समय खत्म हो गया। फिर कोशिश करें या नया कोड माँगें।';

  @override
  String get authErrorTooManyRequests =>
      'बहुत ज़्यादा कोशिशें। थोड़ा रुकें और फिर कोशिश करें।';

  @override
  String get authErrorUnknown => 'कुछ गड़बड़ हो गई। कृपया फिर कोशिश करें।';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get settingsSystemDefault => 'सिस्टम';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get settingsColorMode => 'थीम';

  @override
  String get settingsColorModeLight => 'हल्की';

  @override
  String get settingsColorModeDark => 'गहरी';

  @override
  String get settingsColorModeSun => 'धूप';

  @override
  String get settingsAccount => 'खाता';

  @override
  String settingsSignedInAs(String email) {
    return '$email से साइन इन';
  }

  @override
  String settingsVersion(String version) {
    return 'संस्करण $version';
  }

  @override
  String get settingsSignOut => 'साइन आउट';

  @override
  String get settingsSignOutConfirmTitle => 'साइन आउट करें?';

  @override
  String get settingsSignOutConfirmMessage =>
      'फिर से साइन इन करने के लिए आपके ईमेल पर नया कोड चाहिए होगा, जिसके लिए इंटरनेट ज़रूरी है।';

  @override
  String get actionCancel => 'रद्द करें';

  @override
  String get actionDelete => 'हटाएँ';

  @override
  String get actionRetry => 'फिर कोशिश करें';

  @override
  String get actionUndo => 'पूर्ववत करें';

  @override
  String onboardingStepCounter(int current, int total) {
    return 'चरण $current / $total';
  }

  @override
  String get onboardingContinue => 'आगे बढ़ें';

  @override
  String get onboardingFinish => 'व्यवसाय सेट करें';

  @override
  String get onboardingFinishing => 'सेट हो रहा है…';

  @override
  String get onboardingCountrySearch => 'देश खोजें';

  @override
  String get onboardingCountrySuggested => 'आपके डिवाइस के लिए सुझाव';

  @override
  String get onboardingCountryAll => 'सभी देश';

  @override
  String get onboardingCountryNoMatch => 'आपकी खोज से कोई देश नहीं मिला।';

  @override
  String get onboardingNameMessage =>
      'यह नाम आपके रिकॉर्ड और रिपोर्ट में दिखेगा।';

  @override
  String get onboardingNameLabel => 'व्यवसाय का नाम';

  @override
  String get onboardingNameHint => 'जैसे सुनहरा छत्ता मधुमक्खी फार्म';

  @override
  String get onboardingHiveCountTitle => 'आपके पास कितने छत्ते हैं?';

  @override
  String get onboardingHiveCountMessage =>
      'अनुमान काफ़ी है; हम सुझाएँगे कि उन्हें कैसे संभालें। छत्ते आप बाद में जोड़ेंगे।';

  @override
  String get hiveCountRangeNone => 'अभी कोई नहीं';

  @override
  String get hiveCountRangeUpTo10 => '1–10';

  @override
  String get hiveCountRangeUpTo50 => '11–50';

  @override
  String get hiveCountRangeUpTo200 => '51–200';

  @override
  String get hiveCountRangeOver200 => '200 से ज़्यादा';

  @override
  String get onboardingApiaryTitle => 'पहला फार्म जोड़ें';

  @override
  String get onboardingApiaryMessage =>
      'फार्म वह जगह है जहाँ आपके छत्ते रखे हैं। सहेजने के लिए इंटरनेट नहीं चाहिए।';

  @override
  String get onboardingApiarySave => 'फार्म सहेजें';

  @override
  String get onboardingApiarySkip => 'अभी छोड़ें';

  @override
  String get onboardingLoading => 'आपका व्यवसाय लोड हो रहा है';

  @override
  String get onboardingLoadErrorTitle => 'आपका व्यवसाय लोड नहीं हो सका';

  @override
  String get onboardingErrorNetwork =>
      'कनेक्ट नहीं हो सका। इंटरनेट जाँचें और फिर कोशिश करें।';

  @override
  String get onboardingErrorUnknown =>
      'कुछ गड़बड़ हो गई। कृपया फिर कोशिश करें।';

  @override
  String get devMenuTitle => 'डेवलपर मेन्यू';

  @override
  String get componentGalleryTitle => 'कंपोनेंट गैलरी';

  @override
  String get componentGalleryDescription =>
      'चार थीम में डिज़ाइन सिस्टम के कंपोनेंट';

  @override
  String get galleryThemeLight => 'हल्की';

  @override
  String get galleryThemeDark => 'गहरी';

  @override
  String get galleryThemeSun => 'धूप';

  @override
  String get galleryThemeGlove => 'दस्ताना';

  @override
  String get galleryBigButton => 'बड़ा बटन';

  @override
  String get galleryChoiceChipGroup => 'चुनाव चिप';

  @override
  String get galleryBigStepper => 'बड़ा काउंटर';

  @override
  String get galleryStatusBadge => 'स्थिति बैज';

  @override
  String get galleryHiveTile => 'छत्ता टाइल';

  @override
  String get galleryEmptyState => 'खाली स्थिति';

  @override
  String get gallerySectionCard => 'सेक्शन कार्ड';

  @override
  String get galleryStrengthDots => 'ताक़त बिंदु';

  @override
  String get galleryTimelineTile => 'इतिहास पंक्ति';

  @override
  String get gallerySampleApiaryHill => 'पहाड़ी वाला';

  @override
  String get gallerySampleApiaryPlain => 'नदी किनारे';

  @override
  String get gallerySampleStartInspection => 'निरीक्षण शुरू करें';

  @override
  String get gallerySampleAddPhoto => 'फ़ोटो जोड़ें';

  @override
  String get gallerySampleSave => 'सहेजें';

  @override
  String get gallerySampleQueen => 'रानी';

  @override
  String get gallerySampleQueenSeen => 'दिखी';

  @override
  String get gallerySampleEggs => 'अंडे हैं';

  @override
  String get gallerySampleNone => 'कोई नहीं';

  @override
  String get gallerySampleActions => 'किए गए काम';

  @override
  String get gallerySampleSuperAdded => 'सुपर लगाया';

  @override
  String get gallerySampleFrameAdded => 'फ़्रेम जोड़ा';

  @override
  String get gallerySampleFed => 'भोजन दिया';

  @override
  String get gallerySampleBeeFrames => 'मधुमक्खियों वाले फ़्रेम';

  @override
  String get gallerySampleBroodFrames => 'ब्रूड फ़्रेम';

  @override
  String get gallerySampleStrong => 'मज़बूत';

  @override
  String get gallerySampleWeak => 'कमज़ोर';

  @override
  String get gallerySampleQueenless => 'रानी रहित';

  @override
  String get gallerySampleTask => 'काम';

  @override
  String get gallerySampleNoApiaries => 'अभी कोई फार्म नहीं';

  @override
  String get gallerySampleNoApiariesMessage =>
      'फार्म आपके छत्तों को उनकी जगह के हिसाब से समूह में रखता है; शुरू करने के लिए पहला जोड़ें।';

  @override
  String get gallerySampleAddApiary => 'पहला फार्म जोड़ें';

  @override
  String get gallerySampleLastInspection => 'पिछला निरीक्षण';

  @override
  String get gallerySampleLastInspectionBody =>
      '3 दिन पहले · 7 फ़्रेम मधुमक्खियाँ · रानी दिखी';

  @override
  String get gallerySampleUntitledCard =>
      'कार्ड बिना शीर्षक का भी हो सकता है; सामग्री सीधे शुरू होती है।';

  @override
  String get gallerySnackBar => 'स्नैकबार';

  @override
  String get galleryCriticalLockCard => 'गंभीर लॉक कार्ड';

  @override
  String get gallerySampleInspectionSaved => 'निरीक्षण सहेजा गया';

  @override
  String get gallerySampleWithdrawalTitle => 'प्रतीक्षा अवधि चल रही है।';

  @override
  String get gallerySampleWithdrawalMessage =>
      'इस छत्ते पर अगले 12 दिन तक शहद सुपर न लगाएँ।';

  @override
  String get syncStatusSynced => 'सिंक हो गया';

  @override
  String syncStatusPending(int count) {
    return '$count बाकी';
  }

  @override
  String get syncStatusError => 'त्रुटि';

  @override
  String syncStatusSemantics(String status) {
    return 'सिंक: $status';
  }

  @override
  String get syncTitle => 'सिंक';

  @override
  String get syncSyncedMessage =>
      'इस फ़ोन का हर रिकॉर्ड सर्वर तक पहुँच गया है।';

  @override
  String syncPendingMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count रिकॉर्ड भेजे जाने की प्रतीक्षा में हैं।',
      one: '1 रिकॉर्ड भेजे जाने की प्रतीक्षा में है।',
    );
    return '$_temp0';
  }

  @override
  String get syncProblemOffline =>
      'सर्वर तक नहीं पहुँच सके। ऑनलाइन होने पर सिंक फिर कोशिश करेगा।';

  @override
  String get syncProblemFailed =>
      'सिंक पूरा नहीं हुआ। थोड़ी देर बाद फिर कोशिश करें।';

  @override
  String get syncProblemUpgrade =>
      'यह संस्करण अब सिंक नहीं कर सकता। ऐप अपडेट करें।';

  @override
  String syncLastSynced(String time) {
    return 'पिछला सिंक $time';
  }

  @override
  String get syncNow => 'अभी सिंक करें';

  @override
  String get syncRunning => 'सिंक हो रहा है…';

  @override
  String syncRejectedTitle(int count) {
    return 'भेजे नहीं जा सके ($count)';
  }

  @override
  String get syncRejectedMessage =>
      'सर्वर ने ये रिकॉर्ड स्वीकार नहीं किए। बाकी सब सिंक होता रहेगा।';

  @override
  String syncRejectedSubtitle(String reason, String date) {
    return '$reason · $date';
  }

  @override
  String get syncRejectionForbidden =>
      'आपको यह रिकॉर्ड बदलने की अनुमति नहीं है';

  @override
  String get syncRejectionConflict =>
      'किसी दूसरे रिकॉर्ड से टकराव (जैसे वही लेबल)';

  @override
  String get syncRejectionMissingReference =>
      'जिस रिकॉर्ड से यह जुड़ा है वह सर्वर पर नहीं है';

  @override
  String get syncRejectionUnsupported => 'यह रिकॉर्ड प्रकार सिंक नहीं होता';

  @override
  String get syncRejectionInvalid => 'रिकॉर्ड में गलत डेटा है';

  @override
  String get syncRejectionUnknown => 'अज्ञात कारण';

  @override
  String get syncTableOrganizations => 'व्यवसाय';

  @override
  String get syncTableMemberships => 'सदस्यता';

  @override
  String get syncTableApiaries => 'फार्म';

  @override
  String get syncTableQueens => 'रानी';

  @override
  String get syncTableHives => 'छत्ता';

  @override
  String get syncTableHiveStatusEvents => 'छत्ते की स्थिति में बदलाव';

  @override
  String get syncTableHiveLocationHistory => 'छत्ते का स्थानांतरण';

  @override
  String get initialSyncTitle => 'आपके रिकॉर्ड डाउनलोड हो रहे हैं';

  @override
  String get initialSyncMessage =>
      'आपके व्यवसाय के रिकॉर्ड इस फ़ोन पर डाउनलोड हो रहे हैं। यह सिर्फ़ एक बार होता है; इसके बाद ऐप बिना इंटरनेट भी चलता है।';

  @override
  String initialSyncRows(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString रिकॉर्ड डाउनलोड हुए',
      one: '1 रिकॉर्ड डाउनलोड हुआ',
    );
    return '$_temp0';
  }

  @override
  String get initialSyncFailedTitle => 'डाउनलोड पूरा नहीं हुआ';

  @override
  String get suggestedValue => 'पिछले रिकॉर्ड से';

  @override
  String get stepperNoValue => 'सेट नहीं';

  @override
  String get hiveStartInspection => 'निरीक्षण शुरू करें';

  @override
  String inspectionTitle(String number) {
    return 'छत्ता $number का निरीक्षण';
  }

  @override
  String inspectionPrevious(String date) {
    return 'पिछला निरीक्षण $date';
  }

  @override
  String get inspectionFirst => 'पहला निरीक्षण';

  @override
  String get inspectionSuggestedLegend =>
      'हल्के मान पिछले निरीक्षण से हैं। जो अलग है उसे बदलें; बाकी वैसे ही सहेजा जाएगा।';

  @override
  String get inspectionDraftSaved => 'इस फ़ोन पर ड्राफ़्ट के रूप में रखा गया';

  @override
  String get inspectionRestart => 'फिर से शुरू करें';

  @override
  String get inspectionQueen => 'रानी';

  @override
  String get queenStateSeen => 'दिखी';

  @override
  String get queenStateEggs => 'अंडे दिखे';

  @override
  String get queenStateNone => 'कोई नहीं';

  @override
  String get inspectionFrames => 'फ़्रेम';

  @override
  String get inspectionBeeFrames => 'मधुमक्खियों वाले';

  @override
  String get inspectionBroodFrames => 'ब्रूड वाले';

  @override
  String get inspectionHoneyFrames => 'शहद वाले';

  @override
  String get inspectionTemperament => 'स्वभाव';

  @override
  String get temperamentCalm => 'शांत';

  @override
  String get temperamentNervous => 'चिड़चिड़ी';

  @override
  String get inspectionSwarmSigns => 'झुंड बनने के संकेत';

  @override
  String get inspectionQueenCells => 'रानी कोष';

  @override
  String get queenCellsNone => 'कोई नहीं';

  @override
  String get queenCellsSwarm => 'झुंड';

  @override
  String get queenCellsSupersedure => 'प्रतिस्थापन';

  @override
  String get queenCellsEmergency => 'आपातकालीन';

  @override
  String get inspectionDisease => 'बीमारी का शक';

  @override
  String get inspectionAnswerNo => 'नहीं';

  @override
  String get inspectionAnswerYes => 'हाँ';

  @override
  String get inspectionActions => 'आज किया';

  @override
  String get inspectionActionSuperAdded => 'सुपर लगाया';

  @override
  String get inspectionActionSuperRemoved => 'सुपर हटाया';

  @override
  String get inspectionActionFramesAdded => 'फ़्रेम जोड़े';

  @override
  String get inspectionActionFoundationAdded => 'मोम शीट दी';

  @override
  String get inspectionActionFed => 'भोजन दिया';

  @override
  String get inspectionActionExcluderFitted => 'रानी अवरोधक लगाया';

  @override
  String get inspectionActionEntranceReduced => 'प्रवेश द्वार छोटा किया';

  @override
  String get inspectionActionPollenTrapFitted => 'पराग जाल लगाया';

  @override
  String get inspectionSave => 'सहेजें';

  @override
  String inspectionSaved(String number) {
    return 'छत्ता $number का निरीक्षण सहेजा गया';
  }

  @override
  String get inspectionRemindPrompt => 'इतने में याद दिलाएँ';

  @override
  String inspectionRemindDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिन',
      one: '1 दिन',
    );
    return '$_temp0';
  }

  @override
  String get inspectionLoadError => 'निरीक्षण नहीं खुल सका';

  @override
  String get syncTableInspections => 'निरीक्षण';

  @override
  String get signInTagline =>
      'आपकी मधुमक्खी डायरी, जेब में। बिना इंटरनेट चलती है।';

  @override
  String get signInEmailLabelLong => 'आपका ईमेल पता';

  @override
  String get signInEmailHelper =>
      'पासवर्ड नहीं चाहिए। हम आपके पते पर 6 अंकों का कोड भेजेंगे।';

  @override
  String get signInEmailHint => 'name@example.com';

  @override
  String get signInCodeHeading => 'ईमेल में आया कोड डालें';

  @override
  String get signInPasteCode => 'कोड चिपकाएँ';

  @override
  String get signInCodeSpamHint =>
      'नहीं आया? स्पैम फ़ोल्डर देखें। एक बार साइन इन करने के बाद ऐप बिना इंटरनेट भी खुलता है।';

  @override
  String get signInChangeEmail => 'ईमेल बदलें';

  @override
  String get onboardingLanguageCountryTitle => 'भाषा और देश';

  @override
  String get onboardingAppLanguage => 'ऐप की भाषा';

  @override
  String get onboardingDeviceLanguage => 'डिवाइस की भाषा';

  @override
  String get onboardingCountryLabel => 'वह देश जहाँ आप मधुमक्खी पालते हैं';

  @override
  String get onboardingCountryChoose => 'देश चुनें';

  @override
  String onboardingRegionFeaturesTitle(String country) {
    return '$country के लिए चालू';
  }

  @override
  String onboardingRegionDefaultsTitle(String country) {
    return '$country की सेटिंग्स';
  }

  @override
  String get onboardingRegionDefaultsMessage =>
      'इकाइयाँ और मुद्रा आपके देश के अनुसार हैं।';

  @override
  String get onboardingBusinessTitle => 'अपने व्यवसाय के बारे में बताएँ';

  @override
  String get regionFeatureAks => 'AKS और व्यवसाय पंजीकरण विवरण';

  @override
  String get regionFeatureSubsidies => 'छत्ता सब्सिडी रिमाइंडर';

  @override
  String get regionFeatureRegulations => 'नियमों का सार';

  @override
  String get regionFeatureTrDrugList => 'लाइसेंसशुदा दवाओं की सूची';

  @override
  String get regionFeatureTrFlora => 'तुर्किये फूल कैलेंडर';

  @override
  String get regionFeatureTrMigrationDocs =>
      'प्रवासी मधुमक्खी पालन के दस्तावेज़';

  @override
  String get unitKilogram => 'किग्रा';

  @override
  String get unitPound => 'पाउंड';

  @override
  String get unitCelsius => '°C';

  @override
  String get unitFahrenheit => '°F';

  @override
  String get hemisphereNorthern => 'उत्तरी गोलार्ध';

  @override
  String get hemisphereSouthern => 'दक्षिणी गोलार्ध';

  @override
  String get relativeToday => 'आज';

  @override
  String get relativeYesterday => 'कल';

  @override
  String relativeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन पहले',
      one: '1 दिन पहले',
    );
    return '$_temp0';
  }

  @override
  String apiariesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फार्म',
      one: '1 फार्म',
    );
    return '$_temp0';
  }

  @override
  String apiariesSummary(String apiaries, String hives) {
    return '$apiaries · $hives';
  }

  @override
  String get apiaryHiveCountUnit => 'छत्ते';

  @override
  String get hiveLayoutGridShort => 'ग्रिड';

  @override
  String get hiveLayoutListShort => 'सूची';

  @override
  String apiaryDetailSubtitle(String hives, String visit) {
    return '$hives · $visit';
  }

  @override
  String apiaryDetailSubtitlePlace(String hives, String visit, String place) {
    return '$hives · $visit · $place';
  }

  @override
  String get apiaryBulkFeed => 'सबको भोजन';

  @override
  String get apiaryBulkTreat => 'सबका उपचार';

  @override
  String get hiveCardKind => 'छत्ता';

  @override
  String get hiveLastInspection => 'पिछला निरीक्षण';

  @override
  String get hiveLastInspectionNone => 'अभी नहीं';

  @override
  String get hiveBulkPreviewTitle => 'पूर्वावलोकन';

  @override
  String hiveBulkSaveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count छत्ते बनाएँ',
      one: '1 छत्ता बनाएँ',
    );
    return '$_temp0';
  }

  @override
  String get listEllipsis => '…';

  @override
  String get scanOfflineHint =>
      'इंटरनेट नहीं चाहिए · पढ़ते ही वाइब्रेट करता है';

  @override
  String get titleSeparator => ' ·';

  @override
  String get settingsGeneral => 'सामान्य';

  @override
  String get settingsGloveMode => 'दस्ताना मोड';

  @override
  String get settingsGloveModeHint => 'हर बटन एक स्तर बड़ा हो जाता है।';

  @override
  String get settingsCountry => 'देश';

  @override
  String settingsCountryValue(String name, String code) {
    return '$name · $code';
  }

  @override
  String get moreSectionApiary => 'फार्म';

  @override
  String get moreSectionBusiness => 'व्यवसाय';

  @override
  String get moreSectionHelp => 'सहायता';

  @override
  String get galleryFormFields => 'फ़ॉर्म फ़ील्ड';

  @override
  String get galleryRadioCardGroup => 'चुनाव कार्ड';

  @override
  String get gallerySegmentedTabs => 'दृश्य बदलें';

  @override
  String get galleryListGroup => 'समूहित सूची';

  @override
  String get galleryNoteCard => 'नोट कार्ड';

  @override
  String get gallerySummaryTile => 'सारांश टाइल';

  @override
  String get galleryActionTile => 'कार्रवाई टाइल';

  @override
  String get galleryAppLogo => 'लोगो और छत्ता';

  @override
  String get gallerySampleApiaryName => 'फार्म का नाम';

  @override
  String get gallerySampleFirstNumber => 'पहला नंबर';

  @override
  String get gallerySampleNoteHint =>
      'पासवर्ड नहीं चाहिए। हम आपके पते पर 6 अंकों का कोड भेजेंगे।';

  @override
  String get gallerySampleGrid => 'ग्रिड';

  @override
  String get gallerySampleList => 'सूची';

  @override
  String get gallerySampleMap => 'नक्शा';

  @override
  String get gallerySampleInspections => 'निरीक्षण';

  @override
  String get gallerySampleNoteTitle => 'तुर्किये के लिए चालू';

  @override
  String get gallerySampleNoteMessage =>
      'AKS और व्यवसाय पंजीकरण विवरण, नियमों का सार और लाइसेंसशुदा दवाओं की सूची।';

  @override
  String get gallerySampleLastInspectionValue => '3 दिन पहले';

  @override
  String get gallerySampleFrames => '8 मधुमक्खी फ़्रेम · 5 ब्रूड';

  @override
  String get gallerySampleActiveTreatment => 'चालू उपचार';

  @override
  String get gallerySampleDaysLeft => '12 दिन बाकी';

  @override
  String get syncTableMedia => 'फ़ोटो या वॉइस नोट';

  @override
  String get mediaTakePhoto => 'फ़ोटो लें';

  @override
  String get mediaRecordVoice => 'वॉइस नोट रिकॉर्ड करें';

  @override
  String get mediaStopRecording => 'रिकॉर्डिंग रोकें';

  @override
  String mediaRecording(String duration) {
    return 'रिकॉर्डिंग · $duration';
  }

  @override
  String mediaPhotoAdded(String number) {
    return 'छत्ता $number में फ़ोटो जोड़ी गई';
  }

  @override
  String mediaVoiceAdded(String number) {
    return 'छत्ता $number में वॉइस नोट जोड़ा गया';
  }

  @override
  String get mediaCameraDenied =>
      'कैमरे की अनुमति नहीं है। फ़ोन की सेटिंग्स में अनुमति दे सकते हैं।';

  @override
  String get mediaMicrophoneDenied =>
      'माइक्रोफ़ोन की अनुमति नहीं है। फ़ोन की सेटिंग्स में अनुमति दे सकते हैं।';

  @override
  String get mediaCaptureFailed => 'सहेजा नहीं जा सका। फिर कोशिश करें।';

  @override
  String mediaPhotoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फ़ोटो',
      one: '1 फ़ोटो',
    );
    return '$_temp0';
  }

  @override
  String mediaVoiceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count वॉइस नोट',
      one: '1 वॉइस नोट',
    );
    return '$_temp0';
  }

  @override
  String inspectionMediaAttached(String items) {
    return 'निरीक्षण के साथ सहेजा गया: $items';
  }

  @override
  String get timelinePhoto => 'फ़ोटो';

  @override
  String get timelineVoiceNote => 'वॉइस नोट';

  @override
  String get mediaOpenPhoto => 'फ़ोटो खोलें';

  @override
  String get mediaDownloadPhoto =>
      'फ़ोटो इस फ़ोन पर नहीं है। डाउनलोड करने के लिए टैप करें।';

  @override
  String mediaPlay(String duration) {
    return 'चलाएँ · $duration';
  }

  @override
  String get mediaStopPlaying => 'रोकें';

  @override
  String get mediaNotUploaded =>
      'अभी अपलोड नहीं हुआ। जिस फ़ोन से लिया गया वह ऑनलाइन होने पर पहुँचेगा।';

  @override
  String get mediaDownloadOffline =>
      'डाउनलोड नहीं हो सका। इंटरनेट कनेक्शन जाँचें।';

  @override
  String get mediaDownloadFailed => 'डाउनलोड नहीं हो सका।';

  @override
  String get mediaNotFound => 'फ़ोटो नहीं मिली';

  @override
  String get settingsData => 'डेटा';

  @override
  String get settingsMediaWifiOnly => 'फ़ोटो सिर्फ़ Wi‑Fi पर अपलोड करें';

  @override
  String get settingsMediaWifiOnlyHint =>
      'फ़ोटो और वॉइस नोट मोबाइल डेटा इस्तेमाल नहीं करेंगे।';

  @override
  String settingsPendingUploads(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फ़ाइलें अपलोड की प्रतीक्षा में',
      one: '1 फ़ाइल अपलोड की प्रतीक्षा में',
    );
    return '$_temp0';
  }

  @override
  String get hiveQueenNone => 'दर्ज नहीं';

  @override
  String get hiveQueenNoneHint => 'रानी जोड़ने के लिए टैप करें';

  @override
  String queenMarkColorName(String color) {
    String _temp0 = intl.Intl.selectLogic(color, {
      'white': 'सफ़ेद',
      'yellow': 'पीला',
      'red': 'लाल',
      'green': 'हरा',
      'blue': 'नीला',
      'other': 'अज्ञात',
    });
    return '$_temp0';
  }

  @override
  String get queenYearUnknown => 'साल अज्ञात';

  @override
  String get queenUnmarked => 'बिना निशान';

  @override
  String queenAge(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: '$age साल',
      one: '1 साल',
      zero: 'एक साल से कम',
    );
    return '$_temp0';
  }

  @override
  String get queenSourceOwnRearing => 'अपना पालन';

  @override
  String get queenSourcePurchased => 'ख़रीदी';

  @override
  String get queenSourceCertifiedBreeder => 'प्रमाणित ब्रीडर';

  @override
  String get queenSource => 'स्रोत';

  @override
  String get queenMother => 'माँ रानी';

  @override
  String get queenMotherUnknown => 'अज्ञात';

  @override
  String get queenBreed => 'नस्ल';

  @override
  String get queenBreedHint => 'जैसे इटालियन';

  @override
  String get queenBreedLine => 'लाइन';

  @override
  String get queenBreedLineHint => 'जैसे बकफ़ास्ट';

  @override
  String get queenWing => 'पंख';

  @override
  String get queenWingClipped => 'कटे हुए';

  @override
  String get queenWingIntact => 'नहीं कटे';

  @override
  String get queenYear => 'साल';

  @override
  String get queenYearHelper => 'जन्म या ख़रीद का साल';

  @override
  String get queenMark => 'निशान का रंग';

  @override
  String queenMarkSuggestion(String year, String color) {
    return '$year का रंग: $color';
  }

  @override
  String get queenUnknown => 'नहीं डाला';

  @override
  String get queenEdit => 'रानी संपादित करें';

  @override
  String get queenReplace => 'रानी बदलें';

  @override
  String get queenGive => 'रानी जोड़ें';

  @override
  String get queenNoneTitle => 'कोई रानी दर्ज नहीं';

  @override
  String get queenNoneMessage =>
      'इस छत्ते को दी गई रानी दर्ज करें; उसका साल, रंग और वंश यहाँ दिखेगा।';

  @override
  String queenFormNewTitle(String number) {
    return 'नई रानी · छत्ता $number';
  }

  @override
  String get queenFormEditTitle => 'रानी संपादित करें';

  @override
  String get queenFormSave => 'सहेजें';

  @override
  String queenGiven(String number) {
    return 'छत्ता $number में नई रानी है';
  }

  @override
  String get oldQueensTitle => 'पुरानी रानियाँ';

  @override
  String oldQueensIntro(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other:
          'सक्रिय छत्तों की वे रानियाँ जो $age साल या उससे ज़्यादा की हैं। उन्हें बदलने की योजना बनाएँ।',
    );
    return '$_temp0';
  }

  @override
  String get oldQueensEmptyTitle => 'कोई पुरानी रानी नहीं';

  @override
  String oldQueensEmptyMessage(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other:
          'सक्रिय छत्तों की रानियाँ $age साल से कम की हैं या उनका साल नहीं डाला गया।',
    );
    return '$_temp0';
  }

  @override
  String get syncTableMiteCounts => 'वरोआ गिनती';

  @override
  String get varroaMethodSugarRoll => 'चीनी पाउडर';

  @override
  String get varroaMethodAlcoholWash => 'अल्कोहल धुलाई';

  @override
  String get varroaMethodStickyBoard => 'चिपचिपा बोर्ड';

  @override
  String varroaFormTitle(String number) {
    return 'वरोआ · छत्ता $number';
  }

  @override
  String get varroaMethod => 'तरीका';

  @override
  String get varroaSampleBees => 'नमूने की मधुमक्खियाँ';

  @override
  String get varroaBoardDays => 'बोर्ड पर दिन';

  @override
  String get varroaMites => 'गिने गए माइट';

  @override
  String get varroaBoardMites => 'गिरे माइट';

  @override
  String get varroaSave => 'सहेजें';

  @override
  String varroaSaved(String number) {
    return 'छत्ता $number की वरोआ गिनती सहेजी गई';
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

    return '$valueString माइट/दिन';
  }

  @override
  String get varroaInfestation => 'संक्रमण';

  @override
  String get varroaDailyDrop => 'रोज़ की गिरावट';

  @override
  String get varroaReached => 'सीमा पर · उपचार की योजना बनाएँ';

  @override
  String get varroaBelow => 'सीमा से नीचे';

  @override
  String varroaThresholdNote(String threshold) {
    return 'सीमा $threshold (सेटिंग्स से)।';
  }

  @override
  String get hiveVarroa => 'वरोआ';

  @override
  String get hiveVarroaNone => 'अभी कोई गिनती नहीं';

  @override
  String get hiveVarroaReached => 'सीमा पहुँची';

  @override
  String get hiveVarroaCount => 'वरोआ गिनें';

  @override
  String varroaChartTitle(String apiary) {
    return '$apiary · हाल की गिनती';
  }

  @override
  String varroaChartThreshold(String threshold) {
    return 'सीमा $threshold';
  }

  @override
  String get varroaChartEmpty =>
      'अभी चीनी या अल्कोहल से कोई गिनती नहीं। किसी छत्ते के कार्ड से जोड़ें।';

  @override
  String varroaChartBar(String day, String value) {
    return '$day: $value';
  }

  @override
  String varroaChartSemantics(String threshold, String bars) {
    return 'प्रति दिन औसत संक्रमण, सीमा $threshold: $bars';
  }

  @override
  String get settingsVarroa => 'वरोआ';

  @override
  String get settingsVarroaPercent => 'संक्रमण सीमा';

  @override
  String get settingsVarroaPerDay => 'चिपचिपा बोर्ड सीमा';

  @override
  String get settingsVarroaHint =>
      'गिनती सीमा तक पहुँचने पर चेतावनी दिखती है। सिर्फ़ इसी फ़ोन पर सहेजा जाता है।';

  @override
  String get syncTableRefDrugs => 'दवा सूची';

  @override
  String get syncTableDrugs => 'दवा';

  @override
  String get syncTableTreatments => 'उपचार';

  @override
  String get syncTableFeedings => 'भोजन';

  @override
  String get drugIngredientAmitraz => 'अमित्राज़';

  @override
  String get drugIngredientOxalicAcid => 'ऑक्सालिक एसिड';

  @override
  String get drugIngredientFormicAcid => 'फ़ॉर्मिक एसिड';

  @override
  String get drugIngredientThymol => 'थाइमोल';

  @override
  String get drugIngredientFlumethrin => 'फ़्लूमेथ्रिन';

  @override
  String get drugIngredientTauFluvalinate => 'टाउ-फ़्लूवालिनेट';

  @override
  String get drugIngredientCoumaphos => 'कूमाफ़ोस';

  @override
  String get drugIngredientLacticAcid => 'लैक्टिक एसिड';

  @override
  String get drugIngredientOther => 'अन्य';

  @override
  String get drugUnitStrip => 'पट्टी';

  @override
  String get drugUnitMl => 'मिली';

  @override
  String get drugUnitG => 'ग्रा';

  @override
  String get drugUnitDose => 'खुराक';

  @override
  String get hiveTreat => 'उपचार करें';

  @override
  String get treatmentFormTitle => 'उपचार';

  @override
  String treatmentScopeHive(String number) {
    return 'छत्ता $number';
  }

  @override
  String treatmentScopeApiary(int count) {
    return 'पूरा फार्म · $count';
  }

  @override
  String get treatmentChooseDrug => 'दवा चुनें';

  @override
  String get treatmentChangeDrug => 'बदलें';

  @override
  String treatmentDrugIngredient(String ingredient) {
    return 'सक्रिय घटक: $ingredient';
  }

  @override
  String treatmentDrugLicense(String number) {
    return 'लाइसेंस $number';
  }

  @override
  String get treatmentDrugCustom => 'आपकी दवा';

  @override
  String get treatmentAddDrug => 'नई दवा जोड़ें';

  @override
  String get drugInfoOpen => 'दवा की जानकारी';

  @override
  String get drugInfoSourceTitle => 'स्रोत: तुर्किये का कृषि और वन मंत्रालय';

  @override
  String get drugInfoSourceMessage =>
      'यह मंत्रालय द्वारा स्वीकृत उत्पाद जानकारी से लिया गया है और प्रकाशित रूप में तुर्की भाषा में दिखाया गया है। इस्तेमाल से पहले लेबल पढ़ें; शक हो तो पशु चिकित्सक से पूछें।';

  @override
  String get drugInfoActiveIngredient => 'सक्रिय घटक';

  @override
  String get drugInfoIndications => 'किसके लिए';

  @override
  String get drugInfoUsage => 'इस्तेमाल और बारंबारता';

  @override
  String get drugInfoUsageMethod => 'लगाने का तरीका';

  @override
  String get drugInfoUsageMethodAndDose => 'तरीका और खुराक';

  @override
  String get drugInfoUsageDiagnosis => 'जाँच के लिए';

  @override
  String get drugInfoUsageDose => 'खुराक';

  @override
  String get drugInfoUsageFrequency => 'बारंबारता';

  @override
  String get drugInfoUsageDuration => 'अवधि';

  @override
  String get drugInfoUsageOther => 'नोट';

  @override
  String get drugInfoSuitablePeriods => 'उपयुक्त समय';

  @override
  String get drugInfoAvoidPeriods => 'इस्तेमाल न करें';

  @override
  String get drugInfoWithdrawal => 'प्रतीक्षा अवधि';

  @override
  String get drugInfoWarnings => 'चेतावनियाँ';

  @override
  String get drugInfoClose => 'बंद करें';

  @override
  String get treatmentBatchNo => 'बैच नंबर';

  @override
  String get treatmentStartedOn => 'शुरुआत';

  @override
  String treatmentDose(String unit) {
    return 'हर छत्ते की खुराक ($unit)';
  }

  @override
  String treatmentDoseTotal(String total, String unit) {
    return 'कुल $total $unit';
  }

  @override
  String get treatmentWithdrawalDays => 'प्रतीक्षा अवधि (दिन)';

  @override
  String get treatmentRemoval => 'हटाना';

  @override
  String get treatmentRemovalNone => 'कोई नहीं';

  @override
  String get treatmentRemovalChange =>
      'उसी सुबह रिमाइंडर; बदलने के लिए टैप करें';

  @override
  String get treatmentRemovalSingle =>
      'एक बार इस्तेमाल; सेट करने के लिए टैप करें';

  @override
  String get treatmentRemovalClear => 'हटाना नहीं (एक बार इस्तेमाल)';

  @override
  String get treatmentNoSuper => 'शहद सुपर नहीं';

  @override
  String treatmentNoSuperUntil(String date) {
    return '$date तक';
  }

  @override
  String treatmentNoSuperAfterRemoval(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'हटाना + $days दिन प्रतीक्षा',
      one: 'हटाना + 1 दिन प्रतीक्षा',
      zero: 'हटाने के बाद प्रतीक्षा नहीं',
    );
    return '$_temp0';
  }

  @override
  String treatmentNoSuperAfterStart(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'शुरुआत + $days दिन प्रतीक्षा',
      one: 'शुरुआत + 1 दिन प्रतीक्षा',
      zero: 'प्रतीक्षा नहीं',
    );
    return '$_temp0';
  }

  @override
  String treatmentSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count छत्तों के लिए सहेजें',
      one: 'सहेजें',
    );
    return '$_temp0';
  }

  @override
  String treatmentSaved(String number) {
    return 'छत्ता $number का उपचार सहेजा गया';
  }

  @override
  String treatmentSavedMany(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count छत्तों का उपचार सहेजा गया',
      one: '1 छत्ते का उपचार सहेजा गया',
    );
    return '$_temp0';
  }

  @override
  String get drugFormTitle => 'नई दवा';

  @override
  String get drugName => 'नाम';

  @override
  String get drugActiveIngredient => 'सक्रिय घटक';

  @override
  String get drugDoseUnit => 'खुराक की इकाई';

  @override
  String get drugWithdrawalDays => 'लेबल पर प्रतीक्षा अवधि (दिन)';

  @override
  String get drugSave => 'दवा जोड़ें';

  @override
  String get withdrawalLockTitle => 'प्रतीक्षा अवधि चल रही है।';

  @override
  String withdrawalLockMessage(String number, String product, String date) {
    return 'छत्ता $number का $product से उपचार चल रहा है। $date से पहले शहद सुपर नहीं लगाना चाहिए; इस अवधि के शहद में दवा के अवशेष हो सकते हैं।';
  }

  @override
  String get withdrawalDaysLeft => 'बाकी';

  @override
  String withdrawalDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिन',
      one: '1 दिन',
    );
    return '$_temp0';
  }

  @override
  String get withdrawalApplied => 'लगाया';

  @override
  String get withdrawalReasonPrompt => 'फिर भी सहेजने के लिए कारण चुनें';

  @override
  String get withdrawalReasonRemovedEarly => 'दवा पहले हटा दी';

  @override
  String get withdrawalReasonNotForSale =>
      'सुपर नहीं बिकेगा (अपने इस्तेमाल/भोजन के लिए)';

  @override
  String get withdrawalCancel => 'रद्द करें, सुपर न लगाएँ';

  @override
  String get withdrawalProceed => 'फिर भी सहेजें';

  @override
  String inspectionWithdrawalOverride(String reason) {
    return 'प्रतीक्षा अवधि में शहद सुपर लगाया: $reason';
  }

  @override
  String timelineTreatment(String product) {
    return 'उपचार · $product';
  }

  @override
  String timelineTreatmentBatch(String batch) {
    return 'बैच $batch';
  }

  @override
  String treatmentDoseValue(String dose, String unit) {
    return '$dose $unit';
  }

  @override
  String timelineTreatmentRemoval(String date) {
    return 'हटाना $date';
  }

  @override
  String timelineTreatmentWithdrawal(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिन प्रतीक्षा',
      one: '1 दिन प्रतीक्षा',
    );
    return '$_temp0';
  }

  @override
  String get hiveActiveTreatment => 'चालू उपचार';

  @override
  String get hiveActiveTreatmentNone => 'कोई नहीं';

  @override
  String hiveActiveTreatmentLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिन बाकी',
      one: '1 दिन बाकी',
    );
    return '$_temp0';
  }

  @override
  String hiveActiveTreatmentDetail(String ingredient) {
    return '$ingredient · शहद सुपर नहीं';
  }

  @override
  String get treatmentRotationTitle => 'वही सक्रिय घटक।';

  @override
  String treatmentRotationMessage(int count, String ingredient) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'इस फार्म के पिछले $count उपचार भी $ingredient से थे। प्रतिरोध कम करने के लिए दूसरा सक्रिय घटक आज़माएँ।',
    );
    return '$_temp0';
  }

  @override
  String get treatmentPrescriptionAdd => 'पर्चे / बिल की फ़ोटो जोड़ें';

  @override
  String get treatmentPrescriptionAdded => 'पर्चे की फ़ोटो जोड़ी गई';

  @override
  String get treatmentPrescriptionRemove => 'हटाएँ';

  @override
  String get reminderChannelName => 'रिमाइंडर';

  @override
  String get treatmentReminderDenied =>
      'सूचनाएँ बंद हैं; हटाने का रिमाइंडर सेट नहीं हुआ।';

  @override
  String get hiveFeed => 'भोजन दें';

  @override
  String get feedingFormTitle => 'भोजन';

  @override
  String feedingScopeHive(String number) {
    return 'छत्ता $number';
  }

  @override
  String feedingScopeApiary(int count) {
    return 'पूरा फार्म · $count';
  }

  @override
  String get feedingKind => 'प्रकार';

  @override
  String get feedingKindSyrup1to1 => 'चाशनी 1:1 · उत्तेजक';

  @override
  String get feedingKindSyrup2to1 => 'चाशनी 2:1 · सर्दी';

  @override
  String get feedingKindBeeCake => 'चीनी केक';

  @override
  String get feedingKindPollenSubstitute => 'पराग विकल्प';

  @override
  String feedingAmount(String unit) {
    return 'हर छत्ते पर ($unit)';
  }

  @override
  String get feedingSuperHiveTitle => 'इस छत्ते पर शहद सुपर है।';

  @override
  String get feedingSuperHiveMessage => 'चाशनी शहद में जा सकती है।';

  @override
  String feedingSuperSkippedTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count छत्तों पर शहद सुपर है',
      one: '1 छत्ते पर शहद सुपर है',
    );
    return '$_temp0';
  }

  @override
  String feedingSuperSkippedMessage(String numbers) {
    return '($numbers)। छोड़ दिए गए ताकि चाशनी शहद में न जाए।';
  }

  @override
  String get feedingPrepare => 'तैयार करना';

  @override
  String feedingPrepareCount(int count, String amount, String unit) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count छत्ते × $amount $unit',
      one: '1 छत्ता × $amount $unit',
    );
    return '$_temp0';
  }

  @override
  String feedingTotalSyrup(String amount, String unit) {
    return '$amount $unit चाशनी';
  }

  @override
  String feedingTotalBeeCake(String amount, String unit) {
    return '$amount $unit चीनी केक';
  }

  @override
  String feedingTotalPollenSubstitute(String amount, String unit) {
    return '$amount $unit पराग विकल्प';
  }

  @override
  String get feedingSugar => 'चीनी';

  @override
  String get feedingWater => 'पानी';

  @override
  String feedingApprox(String amount, String unit) {
    return '≈ $amount $unit';
  }

  @override
  String feedingSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count छत्तों के लिए सहेजें',
      one: 'सहेजें',
      zero: 'भोजन के लिए कोई छत्ता नहीं',
    );
    return '$_temp0';
  }

  @override
  String feedingSaved(String number) {
    return 'छत्ता $number का भोजन सहेजा गया';
  }

  @override
  String feedingSavedMany(int count) {
    return '$count छत्तों का भोजन सहेजा गया';
  }

  @override
  String get unitLiter => 'ली';

  @override
  String get unitGallon => 'गैलन';

  @override
  String get syncTableTasks => 'काम';

  @override
  String get tasksTabToday => 'आज';

  @override
  String get tasksTabWeek => 'इस हफ़्ते';

  @override
  String get tasksTabApiary => 'फार्म के अनुसार';

  @override
  String get tasksAdd => 'काम जोड़ें';

  @override
  String tasksOverdue(int count) {
    return 'देरी से · $count';
  }

  @override
  String tasksDayGroup(String day, int count) {
    return '$day · $count';
  }

  @override
  String get tasksToday => 'आज';

  @override
  String get tasksTomorrow => 'कल';

  @override
  String get tasksNoApiary => 'बिना फार्म';

  @override
  String tasksApiaryGroup(String apiary, int count) {
    return '$apiary · $count';
  }

  @override
  String get tasksEmptyTodayTitle => 'आज कोई काम नहीं';

  @override
  String get tasksEmptyWeekTitle => 'इस हफ़्ते कोई काम नहीं';

  @override
  String get tasksEmptyAddHint => 'ऊपर कोने में + से नया काम जोड़ें।';

  @override
  String get tasksLoadError => 'काम लोड नहीं हो सके।';

  @override
  String tasksWeekDaySemantics(String day, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count काम',
      one: '1 काम',
      zero: 'कोई काम नहीं',
    );
    return '$day, $_temp0';
  }

  @override
  String taskOverdueDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिन देरी',
      one: '1 दिन देरी',
    );
    return '$_temp0';
  }

  @override
  String get taskSourceInspection => 'निरीक्षण से';

  @override
  String get taskSourceTreatment => 'उपचार';

  @override
  String taskInspectionTitle(String number) {
    return 'छत्ता $number · फिर जाँचें';
  }

  @override
  String get taskInspectionTitleNoHive => 'फिर जाँचें';

  @override
  String taskTreatmentTitle(String number) {
    return 'छत्ता $number · पट्टियाँ हटाएँ';
  }

  @override
  String get taskTreatmentTitleApiary => 'पट्टियाँ हटाएँ';

  @override
  String get taskReminderBody => 'आपके काम का समय हो गया है।';

  @override
  String get taskAssigneeMe => 'मैं';

  @override
  String taskAssignedTo(String name) {
    return '$name को सौंपा गया';
  }

  @override
  String taskMemberNumbered(String role, int index) {
    return '$role $index';
  }

  @override
  String get roleOwner => 'मालिक';

  @override
  String get rolePartner => 'साझेदार';

  @override
  String get roleWorker => 'कर्मचारी';

  @override
  String get roleViewer => 'दर्शक';

  @override
  String taskCompleteAction(String title) {
    return 'पूरा करें: $title';
  }

  @override
  String get taskCompleted => 'काम पूरा हुआ';

  @override
  String get taskFormNewTitle => 'नया काम';

  @override
  String get taskFormEditTitle => 'काम संपादित करें';

  @override
  String get taskFormName => 'काम';

  @override
  String get taskFormNameHint => 'जैसे पहाड़ वाले फार्म पर जाना';

  @override
  String get taskFormDue => 'अंतिम तारीख़';

  @override
  String get taskFormPickDate => 'दूसरा दिन';

  @override
  String get taskFormTime => 'समय';

  @override
  String get taskFormApiary => 'फार्म';

  @override
  String get taskFormHive => 'छत्ता';

  @override
  String get taskFormNone => 'कोई नहीं';

  @override
  String get taskFormChooseApiary => 'फार्म चुनें';

  @override
  String get taskFormChooseHive => 'छत्ता चुनें';

  @override
  String get taskFormAssignee => 'किसे सौंपा';

  @override
  String get taskFormUnassigned => 'किसी को नहीं';

  @override
  String get taskFormCompleted => 'पूरा';

  @override
  String get taskFormSave => 'सहेजें';

  @override
  String get taskFormDelete => 'काम हटाएँ';

  @override
  String get taskDeleteTitle => 'यह काम हटाएँ?';

  @override
  String get taskDeleteMessage => 'काम हर फ़ोन से हट जाएगा।';

  @override
  String get taskDeleteConfirm => 'हटाएँ';

  @override
  String get taskSaved => 'काम सहेजा गया';

  @override
  String get taskDeleted => 'काम हटाया गया';

  @override
  String get taskNotFound => 'काम नहीं मिला; शायद हटा दिया गया हो।';

  @override
  String get taskReminderDenied => 'सूचनाएँ बंद हैं; रिमाइंडर नहीं बजेगा।';

  @override
  String get exactAlarmTitle => 'रिमाइंडर ठीक समय पर बजें?';

  @override
  String get exactAlarmMessage =>
      'बैटरी बचाने के लिए Android सूचनाओं को कुछ मिनट देर कर सकता है। खुलने वाली सेटिंग में Mobil Arıcı को अनुमति दें, तो काम के रिमाइंडर ठीक समय पर बजेंगे। इंटरनेट नहीं चाहिए।';

  @override
  String get exactAlarmConfirm => 'सेटिंग खोलें';

  @override
  String get settingsReminders => 'रिमाइंडर';

  @override
  String get settingsExactAlarms => 'ठीक समय पर बजें';

  @override
  String get settingsExactAlarmsOn => 'चालू';

  @override
  String get settingsExactAlarmsOff => 'बंद · कुछ मिनट देर हो सकती है';

  @override
  String weatherTemperature(String value) {
    return '$value°';
  }

  @override
  String weatherForecastAsOf(String time) {
    return '$time का पूर्वानुमान';
  }

  @override
  String get weatherNoLocationTitle => 'लोकेशन नहीं';

  @override
  String get weatherNoLocationAction => 'मौसम के लिए लोकेशन जोड़ें';

  @override
  String get weatherPendingHint => 'ऑनलाइन होने पर आएगा';

  @override
  String weatherWind(String speed) {
    return 'हवा $speed';
  }

  @override
  String weatherSpeed(String value, String unit) {
    return '$value $unit';
  }

  @override
  String get unitKmh => 'किमी/घं';

  @override
  String get unitMph => 'मील/घं';

  @override
  String weatherPercent(String value) {
    return '$value%';
  }

  @override
  String weatherTemperatureRange(String max, String min) {
    return '$max / $min';
  }

  @override
  String get hiveOpeningRain => 'बारिश';

  @override
  String get hiveOpeningWind => 'तेज़ हवा';

  @override
  String get hiveOpeningCold => 'ठंड';

  @override
  String get hiveOpeningDaySuitable => 'खोलें';

  @override
  String get weatherConditionSunny => 'धूप';

  @override
  String get weatherConditionPartlyCloudy => 'आंशिक बादल';

  @override
  String get weatherConditionCloudy => 'बादल';

  @override
  String get weatherConditionRainy => 'बारिश';

  @override
  String get weatherConditionWindy => 'तेज़ हवा';

  @override
  String get weatherConditionOther => 'बर्फ़, कोहरा या तूफ़ान';

  @override
  String get weatherConditionFog => 'कोहरा';

  @override
  String get weatherConditionThunder => 'आँधी-तूफ़ान';

  @override
  String get weatherConditionSleet => 'ओले-बारिश';

  @override
  String get weatherConditionSnow => 'बर्फ़';

  @override
  String weatherFeelsLike(String condition, String value) {
    return '$condition · महसूस $value';
  }

  @override
  String get weatherWindLabel => 'हवा';

  @override
  String get weatherHumidityLabel => 'नमी';

  @override
  String get weatherPrecipitationLabel => 'बारिश';

  @override
  String get weatherScreenTitle => 'फार्म का मौसम';

  @override
  String weatherScreenSubtitle(String place, String days) {
    return '$place · $days दिन का पूर्वानुमान';
  }

  @override
  String weatherScreenSubtitleNoPlace(String days) {
    return '$days दिन का पूर्वानुमान';
  }

  @override
  String weatherUpdatedAt(String time) {
    return 'अपडेट $time';
  }

  @override
  String get weatherNow => 'अभी';

  @override
  String get weatherToday => 'आज';

  @override
  String get weatherColumnDay => 'दिन';

  @override
  String get weatherColumnTemperature => 'तापमान';

  @override
  String get weatherColumnPrecipitation => 'बारिश';

  @override
  String get weatherColumnHive => 'छत्ते';

  @override
  String get weatherTodaySuitable => 'छत्ते खोलने के लिए अच्छा दिन';

  @override
  String get weatherTodayRain => 'आज बारिश है; छत्ते खोलने का दिन नहीं';

  @override
  String get weatherTodayWind => 'आज तेज़ हवा है; छत्ते खोलने का दिन नहीं';

  @override
  String get weatherTodayCold => 'आज ठंड है; छत्ते खोलने का दिन नहीं';

  @override
  String weatherDayRange(String from, String to) {
    return '$from–$to';
  }

  @override
  String weatherPlanRain(String days) {
    return '$days को बारिश।';
  }

  @override
  String weatherPlanWind(String days) {
    return '$days को तेज़ हवा।';
  }

  @override
  String weatherPlanMove(String weekday) {
    String _temp0 = intl.Intl.selectLogic(weekday, {
      'monday': 'निरीक्षण सोमवार को रखें।',
      'tuesday': 'निरीक्षण मंगलवार को रखें।',
      'wednesday': 'निरीक्षण बुधवार को रखें।',
      'thursday': 'निरीक्षण गुरुवार को रखें।',
      'friday': 'निरीक्षण शुक्रवार को रखें।',
      'saturday': 'निरीक्षण शनिवार को रखें।',
      'other': 'निरीक्षण रविवार को रखें।',
    });
    return '$_temp0';
  }

  @override
  String get weatherPlanAction => 'योजना बनाएँ';

  @override
  String weatherPlanTaskTitle(String apiary) {
    return '$apiary का निरीक्षण';
  }

  @override
  String weatherThresholdsHint(
    String temperature,
    String wind,
    String precipitation,
  ) {
    return 'खोलने के लिए ठीक: $temperature से ऊपर, हवा $wind से कम, बारिश की संभावना $precipitation से कम। सीमाएँ सेटिंग्स में बदल सकते हैं।';
  }

  @override
  String get weatherEmptyTitle => 'अभी पूर्वानुमान नहीं';

  @override
  String get weatherEmptyMessage =>
      'इस फार्म का पूर्वानुमान अभी नहीं आया। ऑनलाइन होने पर रीफ़्रेश करें।';

  @override
  String get weatherNoLocationMessage =>
      'इस फार्म की लोकेशन नहीं है। पूर्वानुमान के लिए लोकेशन जोड़ें।';

  @override
  String get weatherRefresh => 'रीफ़्रेश करें';

  @override
  String get weatherRefreshFailed =>
      'पूर्वानुमान नहीं मिल सका। इंटरनेट कनेक्शन जाँचें।';

  @override
  String get weatherApiaryNotFound => 'फार्म नहीं मिला';

  @override
  String get weatherAttributionPrefix => 'Powered by';

  @override
  String get weatherAttributionLink => 'WeatherAPI.com';

  @override
  String get settingsHiveOpening => 'छत्ता खोलने की सीमाएँ';

  @override
  String get settingsHiveOpeningTemperature => 'तापमान';

  @override
  String settingsHiveOpeningTemperatureValue(String value) {
    return '$value से ऊपर';
  }

  @override
  String get settingsHiveOpeningWind => 'हवा';

  @override
  String get settingsHiveOpeningPrecipitation => 'बारिश की संभावना';

  @override
  String settingsHiveOpeningBelow(String value) {
    return '$value से कम';
  }

  @override
  String get settingsHiveOpeningHint =>
      'मौसम स्क्रीन और आज के कार्ड इन सीमाओं से \"खोलें\" बताते हैं। सिर्फ़ इसी फ़ोन पर सहेजा जाता है।';

  @override
  String get hiveOpeningSuitable => 'खोलने के लिए ठीक';

  @override
  String get todayGreetingMorning => 'सुप्रभात';

  @override
  String get todayGreetingAfternoon => 'नमस्ते';

  @override
  String get todayGreetingEvening => 'शुभ संध्या';

  @override
  String get todayAttentionTitle => 'ध्यान चाहिए';

  @override
  String todayAttentionHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count छत्ते',
      one: '1 छत्ता',
    );
    return '$_temp0';
  }

  @override
  String get todayAttentionNone => 'किसी छत्ते पर ध्यान की ज़रूरत नहीं';

  @override
  String get todayTasksTitle => 'आज';

  @override
  String todayTasksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count काम',
      one: '1 काम',
    );
    return '$_temp0';
  }

  @override
  String todayTasksApiaryCount(String apiary, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count काम',
      one: '1 काम',
    );
    return '$apiary · $_temp0';
  }

  @override
  String todaySetupProgress(int done, int total) {
    return 'सेटअप $done/$total';
  }

  @override
  String get setupStepApiary => 'फार्म जोड़ें';

  @override
  String get setupStepHives => 'छत्ते बनाएँ';

  @override
  String get setupStepInspection => 'पहला निरीक्षण करें';

  @override
  String setupStepDone(String step) {
    return '$step: पूरा';
  }

  @override
  String get attentionQueenless => 'रानी रहित';

  @override
  String get attentionWeak => 'कमज़ोर';

  @override
  String get attentionSwarming => 'झुंड के संकेत';

  @override
  String get attentionTreatmentRemoval => 'उपचार हटाना है';

  @override
  String get attentionQueenlessTitle => 'रानी रहित छत्ते';

  @override
  String get attentionWeakTitle => 'कमज़ोर छत्ते';

  @override
  String get attentionSwarmingTitle => 'झुंड के संकेत वाले छत्ते';

  @override
  String get attentionTreatmentRemovalTitle => 'हटाने वाले उपचार';

  @override
  String get attentionQueenlessIntro =>
      'सक्रिय छत्ते जिनके पिछले निरीक्षण में न रानी दिखी न अंडे।';

  @override
  String attentionWeakIntro(int max) {
    return 'सक्रिय छत्ते जिनकी पिछले निरीक्षण में ताक़त $max/5 या कम थी।';
  }

  @override
  String get attentionSwarmingIntro =>
      'सक्रिय छत्ते जिनके पिछले निरीक्षण में झुंड के संकेत या झुंड वाले रानी कोष थे।';

  @override
  String get attentionTreatmentRemovalIntro =>
      'छत्ते जिनकी पट्टियाँ हटाने का समय आ गया है और काम अभी पूरा नहीं हुआ।';

  @override
  String get attentionEmpty => 'इस समूह में कोई छत्ता नहीं।';

  @override
  String attentionLastInspection(String date) {
    return 'पिछला निरीक्षण: $date';
  }

  @override
  String attentionRemovalDue(String date) {
    return 'हटाने की तारीख़: $date';
  }

  @override
  String get syncTableHarvests => 'शहद निकासी';

  @override
  String get syncTableHarvestHives => 'निकासी वाला छत्ता';

  @override
  String withdrawalLockHarvestMessage(
    String number,
    String product,
    String date,
  ) {
    return 'छत्ता $number का $product से उपचार चल रहा है। $date से पहले शहद नहीं निकालना चाहिए; इस अवधि के शहद में दवा के अवशेष हो सकते हैं।';
  }

  @override
  String get withdrawalReasonNotForSaleHarvest =>
      'शहद नहीं बिकेगा (अपने इस्तेमाल/भोजन के लिए)';

  @override
  String get withdrawalHarvestCancel => 'रद्द करें, निकासी न करें';

  @override
  String get withdrawalHarvestProceed => 'फिर भी निकासी करें';

  @override
  String get apiaryHarvest => 'शहद निकासी';

  @override
  String harvestFormTitle(String apiary) {
    return 'शहद निकासी · $apiary';
  }

  @override
  String harvestSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count छत्ते चुने',
      one: '1 छत्ता चुना',
      zero: 'कोई छत्ता नहीं चुना',
    );
    return '$_temp0';
  }

  @override
  String harvestSelectedHint(String numbers) {
    return '$numbers · बदलने के लिए टैप करें या जोड़ने के लिए स्कैन करें';
  }

  @override
  String get harvestSelectedEmptyHint =>
      'छत्ते चुनने के लिए टैप करें या स्कैन करें';

  @override
  String get harvestScan => 'स्कैन';

  @override
  String harvestLockedTitle(String numbers) {
    return '$numbers प्रतीक्षा अवधि में।';
  }

  @override
  String get harvestLockedMessage =>
      'निकासी नहीं हुई। फिर भी निकालने के लिए उसे छत्तों की सूची में चुनें।';

  @override
  String get harvestDate => 'तारीख़';

  @override
  String get harvestToday => 'आज';

  @override
  String get harvestYesterday => 'कल';

  @override
  String get harvestPickDate => 'दूसरा दिन';

  @override
  String get harvestHoneyKind => 'शहद का प्रकार';

  @override
  String get honeyKindPine => 'चीड़';

  @override
  String get honeyKindFlower => 'फूल';

  @override
  String get honeyKindChestnut => 'चेस्टनट';

  @override
  String get honeyKindCitrus => 'नींबू वर्गीय';

  @override
  String get honeyKindOther => 'अन्य';

  @override
  String get harvestUnit => 'किस रूप में निकाला';

  @override
  String get harvestUnitSuper => 'सुपर';

  @override
  String get harvestUnitFrame => 'फ़्रेम';

  @override
  String get harvestTakenSupers => 'निकाले गए सुपर';

  @override
  String get harvestTakenFrames => 'निकाले गए फ़्रेम';

  @override
  String harvestWeight(String unit) {
    return 'निकाला गया शहद ($unit)';
  }

  @override
  String get harvestWeightInvalid => '574 या 574.5 जैसा वज़न डालें';

  @override
  String harvestWeightTooLarge(String max, String unit) {
    return 'अधिकतम $max $unit';
  }

  @override
  String get harvestPerHive => 'हर छत्ते पर';

  @override
  String harvestWeightValue(String value, String unit) {
    return '$value $unit';
  }

  @override
  String harvestSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'निकासी सहेजें',
      zero: 'निकासी के लिए कोई छत्ता नहीं',
    );
    return '$_temp0';
  }

  @override
  String harvestSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count छत्तों की निकासी सहेजी गई',
      one: '1 छत्ते की निकासी सहेजी गई',
    );
    return '$_temp0';
  }

  @override
  String get harvestHivesTitle => 'निकासी वाले छत्ते';

  @override
  String get harvestSelectAll => 'सभी चुनें';

  @override
  String get harvestSelectNone => 'कोई नहीं चुनें';

  @override
  String harvestHiveLocked(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिन',
      one: '1 दिन',
    );
    return 'प्रतीक्षा · $_temp0 बाकी';
  }

  @override
  String harvestHiveOverridden(String reason) {
    return 'फिर भी निकाला: $reason';
  }

  @override
  String get harvestHivesDone => 'हो गया';

  @override
  String get harvestNoActiveHives => 'इस फार्म में कोई सक्रिय छत्ता नहीं है।';

  @override
  String get harvestScanTitle => 'निकासी के लिए स्कैन';

  @override
  String harvestScanAdded(String number) {
    return 'छत्ता $number जोड़ा गया';
  }

  @override
  String harvestScanAlready(String number) {
    return 'छत्ता $number पहले से चुना है';
  }

  @override
  String harvestScanOtherApiary(String number) {
    return 'छत्ता $number इस फार्म में नहीं है';
  }

  @override
  String harvestScanInactive(String number) {
    return 'छत्ता $number सक्रिय नहीं है';
  }

  @override
  String get harvestScanUnknown => 'यह लेबल किसी छत्ते से जुड़ा नहीं है';

  @override
  String harvestScanDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'हो गया · $count छत्ते',
      one: 'हो गया · 1 छत्ता',
      zero: 'हो गया',
    );
    return '$_temp0';
  }

  @override
  String get apiaryTourStart => 'राउंड शुरू करें';

  @override
  String get apiaryTourResume => 'राउंड जारी रखें';

  @override
  String get tourReplaceTitle => 'चल रहा राउंड खत्म करें?';

  @override
  String tourReplaceMessage(String apiary) {
    return '$apiary का राउंड अभी चल रहा है। नया राउंड शुरू करने से उसकी प्रगति मिट जाएगी; निरीक्षण सहेजे रहेंगे।';
  }

  @override
  String get tourReplaceConfirm => 'नया राउंड शुरू करें';

  @override
  String tourTitle(String apiary) {
    return '$apiary राउंड';
  }

  @override
  String get tourFinish => 'राउंड खत्म करें';

  @override
  String tourProgress(int done, int total) {
    return '$done / $total';
  }

  @override
  String tourProgressLabel(int done, int total) {
    return '$total में से $done छत्ते पूरे';
  }

  @override
  String tourMinutes(int minutes) {
    return '$minutes मिनट';
  }

  @override
  String tourHoursMinutes(int hours, int minutes) {
    return '$hours घं $minutes मिनट';
  }

  @override
  String tourElapsedLabel(String duration) {
    return 'बीता समय: $duration';
  }

  @override
  String get tourNext => 'अगला';

  @override
  String tourPreviousVisit(String date) {
    return 'पिछली बार · $date';
  }

  @override
  String get tourQueue => 'क्रम';

  @override
  String tourSkippedCount(int count) {
    return '$count छोड़े';
  }

  @override
  String get tourStateDone => 'पूरा';

  @override
  String get tourStateSkipped => 'छोड़ा';

  @override
  String get tourStatePending => 'प्रतीक्षा में';

  @override
  String get tourStateNext => 'अगला';

  @override
  String tourHiveSemantics(String number, String state) {
    return 'छत्ता $number, $state';
  }

  @override
  String get tourSkip => 'छोड़ें';

  @override
  String tourInspect(String number) {
    return '$number का निरीक्षण';
  }

  @override
  String get tourAllDone => 'हर छत्ते का निरीक्षण हो गया।';

  @override
  String get tourSunSuggestion =>
      'धूप मोड तेज़ रोशनी में स्क्रीन पढ़ना आसान बनाता है।';

  @override
  String get tourSunOn => 'धूप मोड चालू करें';

  @override
  String get tourSunMode => 'धूप मोड';

  @override
  String get tourFinishTitle => 'राउंड खत्म करें?';

  @override
  String tourFinishMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count छत्तों का निरीक्षण नहीं हुआ; सारांश में उन्हें छोड़ा गया गिना जाएगा।',
      one: '1 छत्ते का निरीक्षण नहीं हुआ; सारांश में उसे छोड़ा गया गिना जाएगा।',
    );
    return '$_temp0';
  }

  @override
  String get tourNotFound => 'इस फार्म में कोई राउंड नहीं चल रहा।';

  @override
  String get tourCompleteTitle => 'राउंड पूरा';

  @override
  String tourInspectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count छत्तों का निरीक्षण',
      one: '1 छत्ते का निरीक्षण',
    );
    return '$_temp0';
  }

  @override
  String get tourHealthy => 'मज़बूत / ठीक';

  @override
  String get tourTasksTitle => 'काम';

  @override
  String tourTaskRequeen(String numbers) {
    return 'रानी बदलें: $numbers';
  }

  @override
  String tourTaskFeedWeak(String numbers) {
    return '1:1 चाशनी दें: $numbers';
  }

  @override
  String tourTaskSwarmCheck(String numbers) {
    return 'झुंड जाँच: $numbers';
  }

  @override
  String tourTaskRevisit(String numbers) {
    return 'छोड़े गए छत्ते जाँचें: $numbers';
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
      other: '$days दिन में',
      one: 'कल',
      zero: 'आज',
    );
    return '$_temp0';
  }

  @override
  String tourSaveTasks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'काम सहेजें',
      one: 'काम सहेजें',
      zero: 'बंद करें',
    );
    return '$_temp0';
  }

  @override
  String tourTasksSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count काम सहेजे गए',
      one: '1 काम सहेजा गया',
    );
    return '$_temp0';
  }

  @override
  String get tourNoTasks => 'सुझाने के लिए कोई काम नहीं।';

  @override
  String get reportsTitle => 'रिपोर्ट';

  @override
  String get reportTreatmentRegister => 'उपचार रजिस्टर';

  @override
  String get reportTreatmentRegisterHint => 'निरीक्षण के लिए';

  @override
  String get reportHiveHistory => 'छत्ते का इतिहास';

  @override
  String get reportHiveHistoryHint => 'एक छत्ता या एक फार्म';

  @override
  String get reportFrom => 'से';

  @override
  String get reportTo => 'तक';

  @override
  String get reportApiary => 'फार्म';

  @override
  String get reportAllApiaries => 'सभी फार्म';

  @override
  String get reportHive => 'छत्ता';

  @override
  String get reportAllHives => 'सभी छत्ते';

  @override
  String get reportLanguage => 'PDF की भाषा';

  @override
  String get reportRegistrationNo => 'व्यवसाय पंजीकरण नंबर';

  @override
  String get reportAksNo => 'AKS नंबर';

  @override
  String get reportRecordNo => 'पंजीकरण नंबर';

  @override
  String get reportNumbersHelper =>
      'सिर्फ़ PDF के शीर्षक में छपता है; सहेजा नहीं जाता।';

  @override
  String get reportShare => 'साझा करें';

  @override
  String get reportCreate => 'PDF बनाएँ';

  @override
  String get reportPreparing => 'PDF तैयार हो रहा है…';

  @override
  String get reportError => 'PDF नहीं बन सका। फिर कोशिश करें।';

  @override
  String get reportLoadError => 'रिकॉर्ड पढ़े नहीं जा सके।';

  @override
  String get reportEmpty => 'इस अवधि में कोई रिकॉर्ड नहीं।';

  @override
  String reportTreatmentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count उपचार',
      one: '1 उपचार',
    );
    return '$_temp0';
  }

  @override
  String reportHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count छत्ते',
      one: '1 छत्ता',
    );
    return '$_temp0';
  }

  @override
  String reportRecordCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count रिकॉर्ड',
      one: '1 रिकॉर्ड',
    );
    return '$_temp0';
  }

  @override
  String get reportNoValue => '—';

  @override
  String get pdfTreatmentRegisterTitle => 'उपचार रजिस्टर';

  @override
  String get pdfHiveHistoryTitle => 'छत्ते का इतिहास';

  @override
  String pdfRegistrationNo(String number) {
    return 'व्यवसाय पंजीकरण नंबर $number';
  }

  @override
  String pdfAksNo(String number) {
    return 'AKS नंबर $number';
  }

  @override
  String pdfRecordNo(String number) {
    return 'पंजीकरण नंबर $number';
  }

  @override
  String pdfPeriod(String from, String to) {
    return 'अवधि: $from – $to';
  }

  @override
  String pdfApiary(String name) {
    return 'फार्म: $name';
  }

  @override
  String pdfCreated(String date) {
    return 'बनाया गया $date';
  }

  @override
  String pdfPage(int page, int pages) {
    return 'पेज $page / $pages';
  }

  @override
  String get pdfColumnDate => 'तारीख़';

  @override
  String get pdfColumnApiary => 'फार्म';

  @override
  String get pdfColumnProduct => 'उत्पाद / बैच';

  @override
  String get pdfColumnHives => 'छत्ते';

  @override
  String get pdfColumnDose => 'हर छत्ते की खुराक';

  @override
  String get pdfColumnRemoval => 'हटाना';

  @override
  String get pdfColumnWithdrawalEnd => 'प्रतीक्षा का अंत';

  @override
  String get pdfColumnEvent => 'रिकॉर्ड';

  @override
  String get pdfColumnDetails => 'विवरण';

  @override
  String get pdfEventFeeding => 'भोजन';

  @override
  String get pdfEventVarroa => 'वरोआ गिनती';

  @override
  String get pdfEventHarvest => 'शहद निकासी';

  @override
  String pdfHarvestTotal(String amount) {
    return 'कुल निकासी: $amount';
  }

  @override
  String pdfDocumentName(String title, String from, String to) {
    return '$title $from–$to';
  }

  @override
  String get moreFeedback => 'फ़ीडबैक भेजें';

  @override
  String get feedbackTitle => 'फ़ीडबैक भेजें';

  @override
  String get feedbackIntro =>
      'हम यह ऐप मधुमक्खी पालकों के साथ मिलकर बना रहे हैं। हम हर संदेश पढ़ते हैं।';

  @override
  String get feedbackKindLabel => 'यह किस बारे में है?';

  @override
  String get feedbackKindBug => 'गड़बड़ी';

  @override
  String get feedbackKindSuggestion => 'सुझाव';

  @override
  String get feedbackKindMissingFeature => 'कमी वाली सुविधा';

  @override
  String get feedbackKindThanks => 'धन्यवाद';

  @override
  String get feedbackMessageLabel => 'आपका संदेश';

  @override
  String get feedbackMessageHint => 'क्या हुआ, और आपको क्या उम्मीद थी?';

  @override
  String get feedbackAddScreenshot => 'स्क्रीनशॉट जोड़ें';

  @override
  String get feedbackScreenshotAttached => 'स्क्रीनशॉट जुड़ा';

  @override
  String get feedbackRemoveScreenshot => 'हटाएँ';

  @override
  String get feedbackScreenshotDenied =>
      'फ़ोटो तक पहुँच की अनुमति नहीं मिली। स्क्रीनशॉट जोड़ने के लिए सेटिंग्स में अनुमति दें।';

  @override
  String get feedbackIncludeDeviceInfo => 'डिवाइस और संस्करण की जानकारी जोड़ें';

  @override
  String get feedbackOfflineHint =>
      'इंटरनेट न हो तो संदेश कतार में रहेगा और ऑनलाइन होने पर भेजा जाएगा।';

  @override
  String get feedbackSend => 'भेजें';

  @override
  String get feedbackQueued => 'धन्यवाद! आपका संदेश भेजने की कतार में है।';

  @override
  String get settingsAnalytics => 'इस्तेमाल का डेटा साझा करें';

  @override
  String get settingsAnalyticsHint =>
      'निरीक्षण का समय, स्कैन के नतीजे और सिंक में देरी जैसे आँकड़े; आपका नाम, छत्ते और लोकेशन कभी नहीं भेजे जाते।';

  @override
  String get teamTitle => 'टीम';

  @override
  String get teamRoleOwner => 'मालिक';

  @override
  String get teamRolePartner => 'साझेदार';

  @override
  String get teamRoleWorker => 'कर्मचारी';

  @override
  String get teamRoleViewer => 'सलाहकार';

  @override
  String get teamRoleViewerSubtitle => 'सिर्फ़ पढ़ना';

  @override
  String get teamRoleHintPartner =>
      'साझेदार रिकॉर्ड डालता है और वित्त देखता है।';

  @override
  String get teamRoleHintWorker =>
      'कर्मचारी रिकॉर्ड डालता है पर वित्त नहीं देखता।';

  @override
  String get teamRoleHintViewer =>
      'सलाहकार सिर्फ़ पढ़ सकता है और रिकॉर्ड नहीं डाल सकता।';

  @override
  String teamMemberSelf(String name) {
    return '$name (आप)';
  }

  @override
  String get teamMemberUnknown => 'टीम सदस्य';

  @override
  String get teamMembersEmpty => 'सिंक पूरा होने पर सदस्य दिखेंगे।';

  @override
  String get teamInviteTitle => 'टीम में बुलाएँ';

  @override
  String get teamInviteHint => 'कोड बताएँ या भेजें। यह 48 घंटे मान्य है।';

  @override
  String get teamInviteGenerate => 'कोड बनाएँ';

  @override
  String get teamInviteCopy => 'कॉपी करें';

  @override
  String get teamInviteCopied => 'कोड कॉपी हुआ।';

  @override
  String teamInviteCodeSemantics(String code) {
    return 'आमंत्रण कोड $code';
  }

  @override
  String get teamHaveCode => 'मेरे पास कोड है';

  @override
  String get teamJoinTitle => 'कोड से जुड़ें';

  @override
  String get teamJoinHint => 'आपको भेजा गया 6 अक्षरों का कोड डालें।';

  @override
  String get teamJoinCodeLabel => 'आमंत्रण कोड';

  @override
  String get teamJoinAction => 'जुड़ें';

  @override
  String get teamJoinDone => 'आप टीम से जुड़ गए।';

  @override
  String get teamErrorOffline =>
      'इसके लिए इंटरनेट चाहिए। ऑनलाइन होने पर फिर कोशिश करें।';

  @override
  String get teamErrorInvalidCode =>
      'कोड गलत है, समय खत्म हो गया या पहले इस्तेमाल हो चुका।';

  @override
  String get teamErrorAlreadyMember => 'आप पहले से इस टीम के सदस्य हैं।';

  @override
  String get teamErrorForbidden => 'आपको यह करने की अनुमति नहीं है।';

  @override
  String get teamErrorOwnerLocked =>
      'मालिक की भूमिका नहीं बदली जा सकती और मालिक को हटाया नहीं जा सकता।';

  @override
  String get teamErrorUnknown => 'नहीं हो सका। थोड़ी देर में फिर कोशिश करें।';

  @override
  String get teamRemoveAction => 'टीम से हटाएँ';

  @override
  String get teamRemoveTitle => 'टीम से हटाएँ?';

  @override
  String teamRemoveMessage(String name) {
    return '$name इस व्यवसाय के रिकॉर्ड तक पहुँच खो देंगे।';
  }

  @override
  String get teamRemoveConfirm => 'हटाएँ';

  @override
  String teamRemoved(String name) {
    return '$name को टीम से हटाया गया।';
  }

  @override
  String teamRoleChanged(String name, String role) {
    return '$name अब $role हैं।';
  }

  @override
  String get teamActivityTitle => 'हाल की गतिविधि';

  @override
  String get teamActivityEmpty => 'अभी कोई गतिविधि नहीं।';

  @override
  String get teamActivitySelf => 'आप';

  @override
  String teamActivityInspection(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count निरीक्षण दर्ज किए',
      one: '1 निरीक्षण दर्ज किया',
    );
    return '$_temp0';
  }

  @override
  String teamActivityTreatment(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count छत्तों का उपचार किया',
      one: '1 छत्ते का उपचार किया',
    );
    return '$_temp0';
  }

  @override
  String teamActivityFeeding(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count छत्तों को भोजन दिया',
      one: '1 छत्ते को भोजन दिया',
    );
    return '$_temp0';
  }

  @override
  String teamActivityHarvest(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count निकासी दर्ज कीं',
      one: '1 निकासी दर्ज की',
    );
    return '$_temp0';
  }

  @override
  String teamActivityMiteCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count वरोआ गिनतियाँ दर्ज कीं',
      one: '1 वरोआ गिनती दर्ज की',
    );
    return '$_temp0';
  }

  @override
  String teamActivityTask(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count काम जोड़े',
      one: '1 काम जोड़ा',
    );
    return '$_temp0';
  }

  @override
  String get teamActivityJustNow => 'अभी-अभी';

  @override
  String teamActivityMinutesAgo(int count) {
    return '$count मिनट पहले';
  }

  @override
  String teamActivityHoursAgo(int count) {
    return '$count घं पहले';
  }

  @override
  String get teamActivityYesterday => 'कल';

  @override
  String teamActivityDaysAgo(int count) {
    return '$count दिन पहले';
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
  String get settingsPush => 'काम की सूचनाएँ';

  @override
  String get settingsPushHint =>
      'जब आपको कोई काम सौंपा जाए तो सूचना पाएँ। काम खोलने के लिए उस पर टैप करें।';

  @override
  String get documentsTitle => 'दस्तावेज़ तिजोरी';

  @override
  String get documentsAdd => 'दस्तावेज़ जोड़ें';

  @override
  String documentsSummaryOffline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दस्तावेज़',
      one: '1 दस्तावेज़',
    );
    return '$_temp0 · सब बिना इंटरनेट खुलते हैं';
  }

  @override
  String documentsSummaryMissing(int count, int missing) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दस्तावेज़',
      one: '1 दस्तावेज़',
    );
    String _temp1 = intl.Intl.pluralLogic(
      missing,
      locale: localeName,
      other: '$missing फ़ाइलें',
      one: '1 फ़ाइल',
    );
    return '$_temp0 · $_temp1 अभी इस फ़ोन पर नहीं';
  }

  @override
  String get documentsRegionNoteTr =>
      'दस्तावेज़ के प्रकार देश पर निर्भर हैं। तुर्किये के बाहर आप अपने दस्तावेज़ प्रकार बनाते हैं।';

  @override
  String get documentsRegionNoteOther =>
      'दस्तावेज़ के प्रकार आप तय करते हैं; आपके डाले प्रकार अगली बार सुझाए जाते हैं।';

  @override
  String get documentsRoadCheck => 'सड़क जाँच · दस्तावेज़ दिखाएँ';

  @override
  String get documentsEmptyTitle => 'अभी कोई दस्तावेज़ नहीं';

  @override
  String get documentsEmptyMessage =>
      'अपने परमिट और प्रमाणपत्रों की फ़ोटो या PDF जोड़ें। ये बिना इंटरनेट खुलते हैं और समाप्ति से पहले आपको याद दिलाया जाता है।';

  @override
  String get documentsLoadError => 'दस्तावेज़ नहीं खुल सके।';

  @override
  String get documentFileKindPhoto => 'फ़ोटो';

  @override
  String get documentFileKindPdf => 'PDF';

  @override
  String get documentTypeHealthReport => 'स्वास्थ्य प्रमाणपत्र';

  @override
  String get documentTypeTransportPermit => 'परिवहन परमिट';

  @override
  String get documentTypeMigratoryCertificate =>
      'प्रवासी मधुमक्खी पालक प्रमाणपत्र';

  @override
  String get documentTypeBusinessRegistration => 'व्यवसाय पंजीकरण प्रमाणपत्र';

  @override
  String get documentTypeLandPermit => 'ज़मीन की अनुमति';

  @override
  String get documentTypeAnalysisReport => 'जाँच रिपोर्ट';

  @override
  String get documentExpiryNone => 'कोई समाप्ति नहीं';

  @override
  String get documentExpiryExpired => 'समाप्त';

  @override
  String get documentExpiryToday => 'आज समाप्त';

  @override
  String documentExpiryDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिन',
      one: '1 दिन',
    );
    return '$_temp0';
  }

  @override
  String documentExpiryMonths(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months महीने',
      one: '1 महीना',
    );
    return '$_temp0';
  }

  @override
  String documentExpiresOn(String date) {
    return '$date तक मान्य';
  }

  @override
  String get documentFormNewTitle => 'दस्तावेज़ जोड़ें';

  @override
  String get documentFormEditTitle => 'दस्तावेज़ संपादित करें';

  @override
  String get documentFormType => 'दस्तावेज़ का प्रकार';

  @override
  String get documentFormCustomTypeHint => 'जैसे बीमा पॉलिसी';

  @override
  String get documentFormName => 'नाम';

  @override
  String get documentFormNameHint => 'जैसे स्वास्थ्य प्रमाणपत्र 2026';

  @override
  String get documentFormDescription => 'विवरण';

  @override
  String get documentFormDescriptionHint => 'जैसे ज़िला कार्यालय · 152 छत्ते';

  @override
  String get documentFormExpiry => 'मान्य तक';

  @override
  String get documentFormNoExpiry => 'कोई समाप्ति नहीं';

  @override
  String get documentFormPickDate => 'तारीख़ चुनें';

  @override
  String get documentFormExpiryHelper =>
      'समाप्ति से 30, 7 और 1 दिन पहले याद दिलाया जाएगा।';

  @override
  String get documentFormFile => 'फ़ाइल';

  @override
  String get documentFormTakePhoto => 'फ़ोटो लें';

  @override
  String get documentFormPickImage => 'गैलरी से';

  @override
  String get documentFormPickPdf => 'PDF चुनें';

  @override
  String get documentFormNoFile => 'दस्तावेज़ की फ़ोटो लें या उसका PDF चुनें।';

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
      'फ़ाइल 20 MB से बड़ी है; छोटी फ़ाइल चुनें।';

  @override
  String get documentFileFailed => 'फ़ाइल नहीं मिल सकी, फिर कोशिश करें।';

  @override
  String get documentFilePermissionDenied =>
      'अनुमति नहीं मिली। दस्तावेज़ जोड़ने के लिए सेटिंग्स में इस ऐप को कैमरे या फ़ाइलों की अनुमति दें।';

  @override
  String get documentFormSave => 'सहेजें';

  @override
  String get documentFormDelete => 'दस्तावेज़ हटाएँ';

  @override
  String get documentSaved => 'दस्तावेज़ सहेजा गया';

  @override
  String get documentReminderDenied =>
      'दस्तावेज़ सहेजा गया। सूचना की अनुमति के बिना समाप्ति रिमाइंडर नहीं बजेंगे।';

  @override
  String get documentDeleteTitle => 'यह दस्तावेज़ हटाएँ?';

  @override
  String get documentDeleteMessage =>
      'दस्तावेज़ और उसकी फ़ाइल हर फ़ोन से हट जाएँगे।';

  @override
  String get documentDeleteConfirm => 'हटाएँ';

  @override
  String get documentDeleted => 'दस्तावेज़ हटाया गया';

  @override
  String get documentNotFound => 'दस्तावेज़ नहीं मिला; शायद हटा दिया गया हो।';

  @override
  String get documentEdit => 'संपादित करें';

  @override
  String get documentFileMissing =>
      'फ़ाइल अभी इस फ़ोन पर नहीं है। ऑनलाइन होने पर डाउनलोड होगी।';

  @override
  String get documentPdfFailed => 'PDF नहीं खुल सका।';

  @override
  String documentPdfPage(int page, int count) {
    return 'पेज $page / $count';
  }

  @override
  String get roadCheckTitle => 'सड़क जाँच';

  @override
  String roadCheckPosition(int index, int count) {
    return '$index / $count';
  }

  @override
  String get roadCheckSwipeHint => 'अगले दस्तावेज़ के लिए बगल में स्वाइप करें';

  @override
  String get roadCheckPrevious => 'पिछला दस्तावेज़';

  @override
  String get roadCheckNext => 'अगला दस्तावेज़';

  @override
  String documentReminderBody(int days, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिन',
      one: '1 दिन',
    );
    return '$_temp0 में समाप्त · $date';
  }

  @override
  String get syncTableDocuments => 'दस्तावेज़';

  @override
  String get migrationsTitle => 'प्रवास योजनाएँ';

  @override
  String get migrationsAdd => 'नई योजना';

  @override
  String get migrationsEmptyTitle => 'अभी कोई प्रवास योजना नहीं';

  @override
  String get migrationsEmptyMessage =>
      'साल का रास्ता तय करें: हर पड़ाव की तारीख़ें, छत्तों की संख्या और लक्ष्य फार्म।';

  @override
  String get migrationsLoadError => 'प्रवास योजनाएँ नहीं खुल सकीं';

  @override
  String migrationStopCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count पड़ाव',
      one: '1 पड़ाव',
      zero: 'कोई पड़ाव नहीं',
    );
    return '$_temp0';
  }

  @override
  String migrationTitle(String name, String year) {
    return '$name $year';
  }

  @override
  String get migrationNotFound => 'प्रवास योजना नहीं मिली';

  @override
  String get migrationDocuments => 'दस्तावेज़';

  @override
  String get migrationEdit => 'योजना संपादित करें';

  @override
  String get migrationAddStop => 'पड़ाव जोड़ें';

  @override
  String get migrationNoStopsTitle => 'अभी कोई पड़ाव नहीं';

  @override
  String get migrationNoStopsMessage =>
      'रास्ते के पड़ाव क्रम से जोड़ें: फूलों का स्रोत, जगह, तारीख़ें और छत्तों की संख्या।';

  @override
  String migrationNextMoveIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिन में',
      one: '1 दिन में',
      zero: 'आज',
    );
    return 'अगला प्रवास · $_temp0';
  }

  @override
  String migrationNextMoveLate(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिन देरी',
      one: '1 दिन देरी',
    );
    return 'अगला प्रवास · $_temp0';
  }

  @override
  String migrationRoute(String from, String to) {
    return '$from → $to';
  }

  @override
  String migrationDocReady(String document) {
    return '$document तैयार';
  }

  @override
  String migrationDocDays(String document, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिन',
      one: '1 दिन',
      zero: 'आज समाप्त',
    );
    return '$document $_temp0';
  }

  @override
  String migrationDocBeforeMove(String document) {
    return '$document प्रवास से पहले समाप्त होगा';
  }

  @override
  String migrationDocExpired(String document) {
    return '$document समाप्त';
  }

  @override
  String migrationDocMissing(String document) {
    return '$document नहीं है';
  }

  @override
  String get migrationStopPast => 'बीता';

  @override
  String get migrationStopCurrent => 'अभी यहाँ';

  @override
  String get migrationStopPlanned => 'योजना में';

  @override
  String get migrationStopHere => 'आप यहाँ हैं';

  @override
  String migrationStopDates(String start, String end) {
    return '$start–$end';
  }

  @override
  String migrationYield(String year, String kg) {
    return '$year: $kg किग्रा/छत्ता';
  }

  @override
  String migrationYields(String values) {
    return 'पिछली उपज · $values';
  }

  @override
  String get migrationNoYield => 'इस फार्म पर पहले कोई निकासी नहीं';

  @override
  String get migrationFormNewTitle => 'नई प्रवास योजना';

  @override
  String get migrationFormEditTitle => 'प्रवास योजना संपादित करें';

  @override
  String get migrationFormYear => 'साल';

  @override
  String get migrationFormName => 'नाम';

  @override
  String get migrationFormDefaultName => 'प्रवास योजना';

  @override
  String get migrationFormSave => 'सहेजें';

  @override
  String get migrationFormDelete => 'योजना हटाएँ';

  @override
  String get migrationDeleteTitle => 'प्रवास योजना हटाएँ?';

  @override
  String get migrationDeleteMessage =>
      'योजना और उसके सभी पड़ाव हटा दिए जाएँगे।';

  @override
  String get migrationDeleteConfirm => 'हटाएँ';

  @override
  String get migrationSaved => 'योजना सहेजी गई';

  @override
  String get migrationDeleted => 'योजना हटाई गई';

  @override
  String get stopFormNewTitle => 'नया पड़ाव';

  @override
  String get stopFormEditTitle => 'पड़ाव संपादित करें';

  @override
  String get stopFormName => 'फूलों का स्रोत';

  @override
  String get stopFormNameHint => 'जैसे सरसों, लीची';

  @override
  String get stopFormPlace => 'जगह';

  @override
  String get stopFormPlaceHint => 'जैसे मुज़फ़्फ़रपुर, बिहार';

  @override
  String get stopFormStart => 'योजनाबद्ध शुरुआत';

  @override
  String get stopFormEnd => 'योजनाबद्ध अंत';

  @override
  String get stopFormApiary => 'लक्ष्य फार्म';

  @override
  String get stopFormChooseApiary => 'लक्ष्य फार्म चुनें';

  @override
  String get stopFormNone => 'कोई नहीं';

  @override
  String get stopFormHiveCount => 'छत्ते';

  @override
  String get stopFormPosition => 'रास्ते में क्रम';

  @override
  String get stopFormStatus => 'स्थिति';

  @override
  String get stopFormDelete => 'पड़ाव हटाएँ';

  @override
  String get stopDeleteTitle => 'पड़ाव हटाएँ?';

  @override
  String get stopDeleteMessage => 'पड़ाव योजना से हट जाएगा।';

  @override
  String get stopSaved => 'पड़ाव सहेजा गया';

  @override
  String get stopDeleted => 'पड़ाव हटाया गया';

  @override
  String get syncTableMigrations => 'प्रवास योजना';

  @override
  String get syncTableMigrationStops => 'प्रवास पड़ाव';

  @override
  String get moveStart => 'प्रवास शुरू करें';

  @override
  String moveTitle(String route) {
    return 'प्रवास · $route';
  }

  @override
  String get moveNone => 'कोई आगामी प्रवास नहीं';

  @override
  String get moreMigratory => 'प्रवासी';

  @override
  String get syncTableTransports => 'प्रवास';

  @override
  String get syncTableTransportItems => 'ले जाया गया छत्ता';

  @override
  String get moveStepCheck => 'जाँच';

  @override
  String get moveStepLoad => 'लदाई';

  @override
  String get moveStepUnload => 'उतराई';

  @override
  String moveStepDone(String step) {
    return '$step, पूरा';
  }

  @override
  String get moveNoDestinationTitle => 'पड़ाव का कोई फार्म नहीं';

  @override
  String get moveNoDestinationMessage =>
      'पड़ाव के लिए लक्ष्य फार्म चुनें, ताकि उतराई के बाद छत्तों की लोकेशन अपडेट हो सके।';

  @override
  String get moveEditStop => 'पड़ाव संपादित करें';

  @override
  String get moveFrom => 'से';

  @override
  String get moveTo => 'तक';

  @override
  String moveSourceHives(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सक्रिय छत्ते',
      one: '1 सक्रिय छत्ता',
      zero: 'कोई सक्रिय छत्ता नहीं',
    );
    return '$_temp0';
  }

  @override
  String get moveChecklist => 'लदाई की जाँच सूची';

  @override
  String get moveCheckEntrances => 'प्रवेश द्वार बंद';

  @override
  String get moveCheckVentilation => 'हवादारी खुली';

  @override
  String get moveCheckStraps => 'पट्टे कसे हुए';

  @override
  String get moveCheckWater => 'पानी तैयार';

  @override
  String get moveVehicles => 'वाहन';

  @override
  String moveVehicleDefault(int number) {
    return 'ट्रक $number';
  }

  @override
  String get moveAddVehicle => 'वाहन जोड़ें';

  @override
  String moveRemoveVehicle(String vehicle) {
    return '$vehicle हटाएँ';
  }

  @override
  String get moveVehicleName => 'वाहन का नाम';

  @override
  String get moveVehicleExists => 'इस नाम का वाहन पहले से है';

  @override
  String get moveStartLoading => 'लदाई शुरू करें';

  @override
  String get moveChecklistHint =>
      'लदाई शुरू करने के लिए सूची की हर चीज़ पर टिक करें।';

  @override
  String moveVehicleCount(String vehicle, int count) {
    return '$vehicle · $count';
  }

  @override
  String get moveLoaded => 'लदे';

  @override
  String get moveUnloaded => 'उतरे';

  @override
  String moveCountTotal(int total) {
    return '/ $total';
  }

  @override
  String moveCountLabel(int count, int total) {
    return '$total में से $count छत्ते';
  }

  @override
  String moveLastScanned(String number) {
    return 'पिछला स्कैन: $number';
  }

  @override
  String moveNotScanned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count छत्ते अभी स्कैन नहीं हुए',
      one: '1 छत्ता अभी स्कैन नहीं हुआ',
    );
    return '$_temp0';
  }

  @override
  String get moveAllScanned => 'सब स्कैन हुए';

  @override
  String get moveShowList => 'सूची देखें';

  @override
  String get moveMissingTitle => 'स्कैन न हुए छत्ते';

  @override
  String get moveLoadingHint =>
      'मंज़िल पर उतारते समय आप फिर स्कैन करेंगे; कोई छत्ता कम हुआ तो मैं बताऊँगा। उतराई के बाद छत्तों की लोकेशन अपडेट होगी।';

  @override
  String moveUnloadingHint(String destination) {
    return 'उतारते समय हर छत्ता फिर स्कैन करें। पूरा होने पर उतारे गए छत्ते $destination में चले जाएँगे।';
  }

  @override
  String get moveEnterNumber => 'नंबर डालें';

  @override
  String get moveHiveNumber => 'छत्ता नंबर';

  @override
  String moveNumberNotFound(String number) {
    return '$number नंबर का कोई छत्ता नहीं';
  }

  @override
  String get moveScanStart => 'स्कैन शुरू करें';

  @override
  String get moveScanContinue => 'स्कैन जारी रखें';

  @override
  String get moveToUnloading => 'उतराई पर जाएँ';

  @override
  String moveToUnloadingTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count छत्ते स्कैन नहीं हुए',
      one: '1 छत्ता स्कैन नहीं हुआ',
    );
    return '$_temp0';
  }

  @override
  String get moveToUnloadingMessage =>
      'स्कैन न हुए छत्ते इस प्रवास में शामिल नहीं होंगे और जहाँ हैं वहीं रहेंगे।';

  @override
  String get moveFinish => 'प्रवास खत्म करें';

  @override
  String moveFinishTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count छत्ते नहीं उतरे',
      one: '1 छत्ता नहीं उतरा',
    );
    return '$_temp0';
  }

  @override
  String moveFinishMessage(String source) {
    return 'न उतरे छत्ते $source में अपनी लोकेशन बनाए रखेंगे। कमी की सूची प्रवास पर बनी रहेगी।';
  }

  @override
  String get moveFinishConfirm => 'खत्म करें';

  @override
  String get moveDoneTitle => 'प्रवास पूरा';

  @override
  String moveDoneSummary(int loaded, int unloaded) {
    return 'लदे $loaded · उतरे $unloaded';
  }

  @override
  String moveDoneMoved(int count, String destination) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count छत्ते $destination ले जाए गए।',
      one: '1 छत्ता $destination ले जाया गया।',
      zero: 'कोई छत्ता नहीं ले जाया गया।',
    );
    return '$_temp0';
  }

  @override
  String get moveDoneMissing => 'न उतरे छत्ते';

  @override
  String moveScanLoaded(String number, String vehicle) {
    return '$number लदा · $vehicle';
  }

  @override
  String moveScanLoadedOther(String number) {
    return '$number लदा; यह छत्ता इस फार्म में नहीं था';
  }

  @override
  String moveScanAlreadyLoaded(String number) {
    return '$number पहले से लदा है';
  }

  @override
  String moveScanUnloaded(String number) {
    return '$number उतरा';
  }

  @override
  String moveScanAlreadyUnloaded(String number) {
    return '$number पहले से उतरा है';
  }

  @override
  String moveScanNotLoaded(String number) {
    return '$number इस प्रवास में नहीं लदा था';
  }

  @override
  String get moveScanUnknown => 'अज्ञात लेबल';

  @override
  String get moveScanDone => 'हो गया';

  @override
  String get inventoryTitle => 'सामान और स्टॉक';

  @override
  String get inventoryAdd => 'सामान जोड़ें';

  @override
  String get inventoryEmptyTitle => 'अभी स्टॉक में कुछ नहीं';

  @override
  String get inventoryEmptyMessage =>
      'चीनी, मोम शीट और जार जैसा सामान जोड़ें। न्यूनतम से कम वाले सामान चिह्नित होते हैं।';

  @override
  String get inventoryCategoryEmpty => 'इस श्रेणी में कुछ नहीं';

  @override
  String get inventoryLoadError => 'स्टॉक नहीं खुल सका।';

  @override
  String get inventoryNotFound => 'सामान नहीं मिला';

  @override
  String get inventoryCategoryConsumable => 'खपत का सामान';

  @override
  String get inventoryCategoryEquipment => 'उपकरण';

  @override
  String get inventoryCategoryComb => 'छत्ता शीट';

  @override
  String get inventoryUnitKg => 'किग्रा';

  @override
  String get inventoryUnitLiter => 'ली';

  @override
  String get inventoryUnitPiece => 'नग';

  @override
  String get inventoryUnitRoll => 'रोल';

  @override
  String get inventoryUnitPack => 'पैक';

  @override
  String get inventoryUnitNameKg => 'किलोग्राम';

  @override
  String get inventoryUnitNameLiter => 'लीटर';

  @override
  String get inventoryUnitNamePiece => 'नग';

  @override
  String get inventoryUnitNameRoll => 'रोल';

  @override
  String get inventoryUnitNamePack => 'पैक';

  @override
  String inventoryQuantity(String quantity, String unit) {
    return '$quantity $unit';
  }

  @override
  String inventoryBelowThreshold(String threshold) {
    return 'न्यूनतम से कम · कम से कम $threshold';
  }

  @override
  String get inventoryMoveIn => 'आया';

  @override
  String get inventoryMoveOut => 'गया';

  @override
  String get inventoryMoveCount => 'गिनती';

  @override
  String get inventoryMoveAdjustment => 'सुधार';

  @override
  String inventoryInStock(String quantity) {
    return 'स्टॉक में: $quantity';
  }

  @override
  String inventoryAmountLabel(String unit) {
    return 'मात्रा ($unit)';
  }

  @override
  String inventoryCountedLabel(String unit) {
    return 'गिनी गई मात्रा ($unit)';
  }

  @override
  String get inventoryAmountInvalid => 'सही मात्रा डालें';

  @override
  String get inventoryAmountWhole => 'इस इकाई के लिए पूरी संख्या डालें';

  @override
  String get inventorySaveIn => 'स्टॉक में जोड़ें';

  @override
  String get inventorySaveOut => 'स्टॉक से घटाएँ';

  @override
  String get inventorySaveCount => 'स्टॉक सुधारें';

  @override
  String inventoryMovedIn(String quantity) {
    return '$quantity जोड़ा';
  }

  @override
  String inventoryMovedOut(String quantity) {
    return '$quantity घटाया';
  }

  @override
  String inventoryAdjusted(String quantity) {
    return 'स्टॉक अब $quantity';
  }

  @override
  String inventoryUnchanged(String quantity) {
    return 'स्टॉक पहले से $quantity है';
  }

  @override
  String get inventoryDetails => 'विवरण और इतिहास';

  @override
  String get inventoryHistory => 'इतिहास';

  @override
  String get inventoryHistoryEmpty => 'अभी कोई लेन-देन नहीं';

  @override
  String inventoryThreshold(String threshold) {
    return 'न्यूनतम: कम से कम $threshold';
  }

  @override
  String get inventoryNoThreshold => 'कोई न्यूनतम नहीं';

  @override
  String get inventoryQuickMove => 'जोड़ें / घटाएँ';

  @override
  String get inventoryEdit => 'सामान संपादित करें';

  @override
  String get inventoryFormNewTitle => 'नया सामान';

  @override
  String get inventoryFormEditTitle => 'सामान संपादित करें';

  @override
  String get inventoryFormName => 'नाम';

  @override
  String get inventoryFormCategory => 'श्रेणी';

  @override
  String get inventoryFormUnit => 'इकाई';

  @override
  String get inventoryFormLocation => 'रखने की जगह';

  @override
  String get inventoryFormLocationHint => 'गोदाम, ट्रक, दफ़्तर… वैकल्पिक।';

  @override
  String get inventoryFormThreshold => 'न्यूनतम';

  @override
  String get inventoryFormThresholdHint =>
      'स्टॉक इससे नीचे जाने पर चेतावनी मिलेगी। वैकल्पिक।';

  @override
  String get inventoryFormThresholdInvalid => 'सही न्यूनतम डालें';

  @override
  String get inventoryFormSave => 'सहेजें';

  @override
  String get inventoryFormDelete => 'सामान हटाएँ';

  @override
  String get inventoryDeleteTitle => 'यह सामान हटाएँ?';

  @override
  String get inventoryDeleteMessage => 'सामान और उसका स्टॉक सूची से हट जाएँगे।';

  @override
  String get inventoryDeleteConfirm => 'हटाएँ';

  @override
  String get inventorySaved => 'सामान सहेजा गया';

  @override
  String get inventoryDeleted => 'सामान हटाया गया';

  @override
  String get syncTableInventoryItems => 'स्टॉक का सामान';

  @override
  String get syncTableInventoryMoves => 'स्टॉक लेन-देन';

  @override
  String inventoryIncrease(String quantity) {
    return '+$quantity';
  }

  @override
  String inventoryFormThresholdUnit(String unit) {
    return 'न्यूनतम ($unit)';
  }

  @override
  String get stockUseTitle => 'स्टॉक से घटाएँ';

  @override
  String get stockUseNone => 'न घटाएँ';

  @override
  String stockUseValue(String item, String quantity) {
    return '$item · −$quantity';
  }

  @override
  String get stockUseChoose => 'किस सामान से घटाएँ?';

  @override
  String get taskFormTreatment => 'योजनाबद्ध उपचार';

  @override
  String get taskFormTreatmentUnknown => 'दवा सूची में नहीं';

  @override
  String get taskFormTreatmentNeedsApiary =>
      'योजनाबद्ध उपचार के लिए फार्म चुनें';

  @override
  String taskTreatmentPlanTitle(String drug) {
    return 'उपचार · $drug';
  }

  @override
  String get shoppingTitle => 'ख़रीदारी सूची';

  @override
  String shoppingCardTitle(int count) {
    return 'ख़रीदारी सूची · $count';
  }

  @override
  String get shoppingEmptyTitle => 'कुछ ख़रीदना नहीं';

  @override
  String get shoppingEmptyMessage =>
      'न्यूनतम से कम सामान और योजनाबद्ध उपचारों की ज़रूरत यहाँ दिखेगी।';

  @override
  String get shoppingShare => 'साझा करें';

  @override
  String get shoppingLoadError => 'ख़रीदारी सूची नहीं खुल सकी';

  @override
  String shoppingReasonThreshold(String stock, String threshold) {
    return 'स्टॉक $stock · न्यूनतम $threshold';
  }

  @override
  String shoppingReasonPlanned(String quantity) {
    return 'योजनाबद्ध उपचार $quantity';
  }

  @override
  String get shoppingReasonNoItem => 'योजनाबद्ध उपचार · स्टॉक में सामान नहीं';

  @override
  String shoppingShareLine(String name, String quantity) {
    return '• $name: $quantity';
  }

  @override
  String get moreRearing => 'रानी पालन';

  @override
  String get rearingTitle => 'रानी पालन';

  @override
  String rearingBatchName(int number) {
    return 'बैच $number';
  }

  @override
  String rearingBatchTitle(int number) {
    return 'रानी पालन · बैच $number';
  }

  @override
  String get rearingAdd => 'बैच जोड़ें';

  @override
  String get rearingEmptyTitle => 'अभी कोई बैच नहीं';

  @override
  String get rearingEmptyMessage =>
      'ग्राफ़्टिंग का दिन डालें; स्वीकृति से अंडे देने की जाँच तक का कार्यक्रम और रिमाइंडर अपने आप बनेंगे।';

  @override
  String get rearingLoadError => 'बैच लोड नहीं हो सके';

  @override
  String get rearingNotFound => 'बैच नहीं मिला';

  @override
  String rearingListGrafted(String date) {
    return 'ग्राफ़्टिंग $date';
  }

  @override
  String get rearingEdit => 'बैच संपादित करें';

  @override
  String get rearingGraftedLabel => 'ग्राफ़्ट की गईं';

  @override
  String get rearingAcceptedLabel => 'स्वीकृत';

  @override
  String get rearingNucsLabel => 'न्यूक';

  @override
  String get rearingNotCounted => 'गिनी नहीं';

  @override
  String rearingAcceptedPercent(int percent) {
    return '$percent%';
  }

  @override
  String rearingMotherLine(String mother, String date) {
    return 'माँ: $mother · ग्राफ़्टिंग $date';
  }

  @override
  String rearingMotherUnknownLine(String date) {
    return 'माँ अज्ञात · ग्राफ़्टिंग $date';
  }

  @override
  String rearingDay(int day) {
    return 'दिन $day';
  }

  @override
  String get rearingToday => 'आज';

  @override
  String get rearingStepGraft => 'लार्वा ग्राफ़्टिंग';

  @override
  String get rearingStepAcceptance => 'स्वीकृति जाँच';

  @override
  String get rearingStepCapped => 'कोष बंद';

  @override
  String get rearingStepDistribution => 'कोष बाँटें';

  @override
  String get rearingStepEmergence => 'रानियों का निकलना';

  @override
  String get rearingStepLayingCheck => 'अंडे देने की जाँच';

  @override
  String rearingStepGraftDetail(int count) {
    return '$count लार्वा';
  }

  @override
  String rearingStepAcceptanceDetail(int count) {
    return '$count कोष स्वीकृत';
  }

  @override
  String get rearingStepAcceptanceTodo => 'स्वीकृत कोष गिनें';

  @override
  String get rearingStepCappedDetail => 'छेड़ें नहीं';

  @override
  String rearingStepDistributionDetail(int count) {
    return 'निकलने से पहले, $count न्यूक में';
  }

  @override
  String get rearingStepDistributionTodo => 'निकलने से पहले, न्यूक में';

  @override
  String get rearingStepEmergenceDetail => 'न्यूक जाँचें';

  @override
  String get rearingStepLayingCheckDetail => 'संभोग की सफलता दर्ज करें';

  @override
  String get rearingStepDone => 'पूरा';

  @override
  String get rearingStepCurrent => 'अगला';

  @override
  String get rearingStepUpcoming => 'आने वाला';

  @override
  String get rearingDistribute => 'कोष न्यूक में बाँटें';

  @override
  String get rearingDistributeApiary => 'फार्म';

  @override
  String get rearingDistributeCount => 'न्यूक';

  @override
  String rearingDistributePlan(int reused, int created) {
    return 'खाली न्यूक दोबारा: $reused · नए न्यूक: $created';
  }

  @override
  String get rearingDistributeSave => 'बाँटें';

  @override
  String get rearingDistributeNoApiary => 'पहले फार्म जोड़ें';

  @override
  String rearingDistributed(int count) {
    return '$count न्यूक में बाँटे गए';
  }

  @override
  String get rearingNucsSection => 'संभोग न्यूक';

  @override
  String rearingNucTitle(String number) {
    return 'न्यूक $number';
  }

  @override
  String get matingNucStatusEmpty => 'खाली';

  @override
  String get matingNucStatusCell => 'कोष';

  @override
  String get matingNucStatusVirgin => 'कुंवारी रानी';

  @override
  String get matingNucStatusLaying => 'अंडे दे रही';

  @override
  String get matingNucStatusFailed => 'असफल';

  @override
  String get matingNucStatusGiven => 'छत्ते को दी';

  @override
  String get rearingNucGive => 'छत्ते को दें';

  @override
  String get rearingNucChooseHive => 'कौन सा छत्ता?';

  @override
  String get rearingNucNoHives => 'कोई सक्रिय छत्ता नहीं';

  @override
  String get rearingFormNewTitle => 'नया बैच';

  @override
  String get rearingFormEditTitle => 'बैच संपादित करें';

  @override
  String get rearingFormGraftedOn => 'ग्राफ़्टिंग का दिन';

  @override
  String get rearingFormGraftedCount => 'ग्राफ़्ट किए लार्वा';

  @override
  String get rearingFormAcceptedCount => 'स्वीकृत कोष';

  @override
  String get rearingFormAcceptedClear => 'अभी गिने नहीं';

  @override
  String get rearingFormScheduleHint =>
      'स्वीकृति, कोष बंद होना, बाँटना, निकलना और अंडे देने की जाँच रिमाइंडर वाले काम के रूप में जुड़ते हैं।';

  @override
  String get rearingFormSave => 'सहेजें';

  @override
  String get rearingFormDelete => 'बैच हटाएँ';

  @override
  String get rearingDeleteTitle => 'बैच हटाएँ?';

  @override
  String get rearingDeleteMessage =>
      'इसके काम भी हटेंगे। न्यूक और दी गई रानियाँ बनी रहेंगी।';

  @override
  String get rearingDeleteConfirm => 'हटाएँ';

  @override
  String get rearingDeleted => 'बैच हटाया गया';

  @override
  String get rearingSaved => 'बैच सहेजा गया';

  @override
  String get taskSourceQueenRearing => 'रानी पालन';

  @override
  String get syncTableQueenRearingBatches => 'रानी पालन बैच';

  @override
  String get syncTableMatingNucs => 'संभोग न्यूक';

  @override
  String get lotsTitle => 'निकासी और लॉट';

  @override
  String get lotsEmptyTitle => 'अभी कोई लॉट नहीं';

  @override
  String get lotsEmptyMessage =>
      'निकासी सहेजने के बाद उसे किसी लॉट में जोड़ें; लॉट यहाँ दिखेंगे।';

  @override
  String get lotsLoadError => 'लॉट लोड नहीं हो सके';

  @override
  String get lotsInStock => 'स्टॉक में';

  @override
  String get lotsPerHive => 'हर छत्ते पर';

  @override
  String lotNumber(String number) {
    return 'लॉट $number';
  }

  @override
  String lotHoneyTitle(String kind) {
    return '$kind शहद';
  }

  @override
  String get lotStatusOpen => 'खुला';

  @override
  String get lotStatusClosed => 'बंद';

  @override
  String get lotWithdrawalBadge => 'प्रतीक्षा अवधि में';

  @override
  String lotMoistureValue(String value) {
    return 'नमी $value%';
  }

  @override
  String get lotAnalyzed => 'जाँचा गया ✓';

  @override
  String get lotAnalysisPending => 'जाँच बाकी';

  @override
  String lotStockValue(String weight) {
    return 'स्टॉक $weight';
  }

  @override
  String get lotNotFound => 'लॉट नहीं मिला';

  @override
  String get lotEdit => 'लॉट संपादित करें';

  @override
  String lotWithdrawalTitle(String hives) {
    return '$hives की निकासी प्रतीक्षा अवधि में हुई।';
  }

  @override
  String get lotWithdrawalMessage =>
      'इस लॉट में दवा के अवशेष हो सकते हैं; बेचने से पहले जाँच करवाएँ।';

  @override
  String get lotStock => 'स्टॉक';

  @override
  String get lotHarvested => 'निकाला गया';

  @override
  String get lotSold => 'बेचा गया';

  @override
  String get lotInStock => 'स्टॉक में';

  @override
  String get lotSell => 'बिक्री दर्ज करें';

  @override
  String get lotAnalyses => 'जाँचें';

  @override
  String get lotAnalysesEmpty => 'अभी कोई जाँच नहीं';

  @override
  String get lotAddAnalysis => 'जाँच जोड़ें';

  @override
  String get lotHarvests => 'निकासियाँ';

  @override
  String get lotHarvestsEmpty => 'इस लॉट में कोई निकासी नहीं';

  @override
  String get lotTreatments => 'छत्तों का पिछला उपचार';

  @override
  String get lotTreatmentsEmpty => 'इस लॉट के छत्तों का कोई उपचार दर्ज नहीं';

  @override
  String lotTreatmentTitle(String hive, String product) {
    return 'छत्ता $hive · $product';
  }

  @override
  String lotTreatmentDetail(String date, String end) {
    return '$date · प्रतीक्षा $end को खत्म';
  }

  @override
  String get lotPublicPage => 'सार्वजनिक पेज';

  @override
  String get lotPublish => 'प्रकाशित करें';

  @override
  String get lotPublishHint =>
      'जो भी QR स्कैन करेगा वह लॉट का पेज देखेगा। फ़ोन, पता और लोकेशन कभी नहीं दिखाए जाते।';

  @override
  String get lotPublishOwnerOnly =>
      'सिर्फ़ व्यवसाय का मालिक प्रकाशित कर सकता है।';

  @override
  String get lotPublished => 'प्रकाशित';

  @override
  String get lotNotPublished => 'प्रकाशित नहीं';

  @override
  String get lotPublicFields => 'पेज पर दिखेगा';

  @override
  String get lotPublicProducer => 'व्यवसाय का नाम और छत्तों की संख्या';

  @override
  String get lotPublicOrigin => 'मूल और निकासी का महीना';

  @override
  String get lotPublicLab => 'जाँच के मान';

  @override
  String get lotPublicReport => 'जाँच रिपोर्ट';

  @override
  String get lotJarLabels => 'जार लेबल (QR)';

  @override
  String get lotJarLabelsHint =>
      'हर A4 पेज पर 24 लेबल (70 × 37 मिमी); 100% स्केल पर छापें।';

  @override
  String lotJarLabelsDocumentName(String number) {
    return 'जार लेबल - $number';
  }

  @override
  String get lotSales => 'बिक्री';

  @override
  String get lotSalesEmpty => 'अभी कोई बिक्री दर्ज नहीं';

  @override
  String lotSaleValue(String weight) {
    return '−$weight';
  }

  @override
  String lotSaleAmount(String unit) {
    return 'बेचा गया शहद ($unit)';
  }

  @override
  String lotSaleTooMuch(String weight) {
    return 'स्टॉक में सिर्फ़ $weight है';
  }

  @override
  String get lotSaleSave => 'स्टॉक से घटाएँ';

  @override
  String lotSaleSaved(String weight) {
    return '$weight की बिक्री दर्ज हुई';
  }

  @override
  String get lotOrigin => 'मूल';

  @override
  String get lotOriginHint => 'जैसे पहाड़ी चीड़';

  @override
  String get lotMoisture => 'नमी %';

  @override
  String get lotMoistureHelper => 'रिफ़्रैक्टोमीटर रीडिंग; वैकल्पिक';

  @override
  String get lotMoistureInvalid => '10 से 30 के बीच मान डालें, जैसे 17.2';

  @override
  String lotEditTitle(String lot) {
    return '$lot संपादित करें';
  }

  @override
  String get lotStatus => 'स्थिति';

  @override
  String get lotStatusHelper => 'बंद लॉट में नई निकासी नहीं जुड़ती';

  @override
  String get lotSave => 'सहेजें';

  @override
  String get lotDelete => 'लॉट हटाएँ';

  @override
  String lotDeleteTitle(String lot) {
    return '$lot हटाएँ?';
  }

  @override
  String get lotDeleteMessage =>
      'जाँचें और बिक्री भी हटेंगी; निकासियाँ बनी रहेंगी।';

  @override
  String get lotDeleted => 'लॉट हटाया गया';

  @override
  String labTitle(String lot) {
    return 'जाँच · $lot';
  }

  @override
  String get labDate => 'जाँच की तारीख़';

  @override
  String get labHmf => 'HMF (मिग्रा/किग्रा)';

  @override
  String get labDiastase => 'डायस्टेज़ संख्या';

  @override
  String get labProline => 'प्रोलीन (मिग्रा/किग्रा)';

  @override
  String labHmfValue(String value) {
    return 'HMF $value';
  }

  @override
  String labDiastaseValue(String value) {
    return 'डायस्टेज़ $value';
  }

  @override
  String labProlineValue(String value) {
    return 'प्रोलीन $value';
  }

  @override
  String labValueInvalid(String min, String max) {
    return '$min से $max के बीच मान डालें';
  }

  @override
  String get labResidue => 'अवशेष';

  @override
  String get labResidueNone => 'कोई अवशेष नहीं';

  @override
  String get labResidueDetected => 'अवशेष मिले';

  @override
  String get labReport => 'रिपोर्ट';

  @override
  String get labReportNone => 'कोई रिपोर्ट नहीं';

  @override
  String get labReportEmpty => 'दस्तावेज़ तिजोरी में कोई जाँच रिपोर्ट नहीं';

  @override
  String get labReportAdd => 'रिपोर्ट दस्तावेज़ तिजोरी में जोड़ें';

  @override
  String get labSave => 'जाँच सहेजें';

  @override
  String get labSaved => 'जाँच सहेजी गई';

  @override
  String get harvestLotTitle => 'लॉट में जोड़ें';

  @override
  String harvestLotSaved(String weight, String kind) {
    return 'निकासी सहेजी गई: $weight $kind';
  }

  @override
  String get harvestLotIntro =>
      'जब शहद किसी लॉट में जाता है, तो छत्तों के पिछले उपचार की तारीख़ें उससे जुड़ जाती हैं।';

  @override
  String get harvestLotNew => 'नया लॉट';

  @override
  String harvestLotNewHint(String kind) {
    return '$kind · नंबर अपने आप मिलेगा';
  }

  @override
  String get harvestLotCreate => 'लॉट बनाएँ';

  @override
  String get harvestLotAdd => 'लॉट में जोड़ें';

  @override
  String get harvestLotSkip => 'अभी छोड़ें';

  @override
  String harvestLotCreated(String lot) {
    return '$lot बनाया गया';
  }

  @override
  String harvestLotAdded(String lot) {
    return 'निकासी $lot में जोड़ी गई';
  }

  @override
  String get harvestLotGone => 'निकासी पूर्ववत हुई';

  @override
  String get harvestLotBack => 'फार्म पर वापस';

  @override
  String get syncTableLots => 'लॉट';

  @override
  String get syncTableLotHarvests => 'लॉट निकासी';

  @override
  String get syncTableLotTreatments => 'लॉट उपचार';

  @override
  String get syncTableLabResults => 'जाँच नतीजा';

  @override
  String get syncTableLotSales => 'लॉट बिक्री';

  @override
  String get harvestLotGoneMessage =>
      'निकासी किसी लॉट में नहीं जुड़ी। आप उसे फार्म से फिर दर्ज कर सकते हैं।';

  @override
  String get financeTitle => 'वित्त';

  @override
  String financeYearTitle(String year) {
    return 'वित्त · $year';
  }

  @override
  String get financeSeasonNet => 'सीज़न का शुद्ध';

  @override
  String get financeIncome => 'आय';

  @override
  String get financeExpense => 'ख़र्च';

  @override
  String get financeCostPerHive => 'लागत/छत्ता';

  @override
  String get financeRecent => 'हाल की प्रविष्टियाँ';

  @override
  String get financeEmptyTitle => 'अभी कोई प्रविष्टि नहीं';

  @override
  String get financeEmptyMessage =>
      'नीचे के बटनों से आय और ख़र्च दर्ज करें; सीज़न का शुद्ध यहाँ गिना जाता है।';

  @override
  String get financeLoadError => 'प्रविष्टियाँ लोड नहीं हो सकीं';

  @override
  String get financeAddIncome => '+ आय';

  @override
  String get financeAddExpense => '− ख़र्च';

  @override
  String financePlus(String amount) {
    return '+$amount';
  }

  @override
  String financeMinus(String amount) {
    return '−$amount';
  }

  @override
  String get financeReceiptAttached => 'रसीद जुड़ी';

  @override
  String financeTransportRoute(String from, String to) {
    return '$from → $to';
  }

  @override
  String get financeFormIncomeTitle => 'आय जोड़ें';

  @override
  String get financeFormExpenseTitle => 'ख़र्च जोड़ें';

  @override
  String financeFormAmount(String currency) {
    return 'राशि ($currency)';
  }

  @override
  String get financeFormAmountInvalid =>
      '0 से अधिक राशि डालें, जैसे 17500 या 17.50';

  @override
  String get financeFormCategory => 'श्रेणी';

  @override
  String get financeFormDate => 'तारीख़';

  @override
  String get financeFormDescription => 'विवरण';

  @override
  String get financeFormDescriptionHint => 'जैसे चीनी 500 किग्रा';

  @override
  String get financeFormReceipt => 'रसीद / बिल';

  @override
  String get financeFormNoReceipt => 'कोई रसीद नहीं';

  @override
  String get financeFormReceiptAdded => 'रसीद की फ़ोटो जोड़ी गई';

  @override
  String get financeFormTakePhoto => 'फ़ोटो लें';

  @override
  String get financeFormPickImage => 'गैलरी से';

  @override
  String get financeFormRemoveReceipt => 'रसीद हटाएँ';

  @override
  String get financeFormPhotoDenied =>
      'अनुमति नहीं मिली। रसीद जोड़ने के लिए सेटिंग्स में इस ऐप को कैमरे या फ़ोटो की अनुमति दें।';

  @override
  String get financeFormPhotoFailed => 'फ़ोटो नहीं मिल सकी, फिर कोशिश करें।';

  @override
  String get financeFormLinks => 'जुड़ा रिकॉर्ड';

  @override
  String get financeFormApiary => 'फार्म';

  @override
  String get financeFormLot => 'लॉट';

  @override
  String get financeFormTransport => 'प्रवास';

  @override
  String get financeFormNone => 'कोई नहीं';

  @override
  String get financeFormChooseApiary => 'फार्म चुनें';

  @override
  String get financeFormChooseLot => 'लॉट चुनें';

  @override
  String get financeFormChooseTransport => 'प्रवास चुनें';

  @override
  String get financeFormNoLots => 'अभी कोई लॉट नहीं';

  @override
  String get financeFormNoTransports => 'अभी कोई प्रवास नहीं';

  @override
  String financeFormSaleAmount(String unit) {
    return 'बेचा गया शहद ($unit)';
  }

  @override
  String get financeFormSaleHelper =>
      'लॉट के स्टॉक से घटेगा; स्टॉक न बदलना हो तो खाली छोड़ें';

  @override
  String get financeFormSave => 'सहेजें';

  @override
  String get financeIncomeSaved => 'आय सहेजी गई';

  @override
  String get financeExpenseSaved => 'ख़र्च सहेजा गया';

  @override
  String get financeNotFound => 'प्रविष्टि नहीं मिली';

  @override
  String get financeReceiptPending => 'रसीद अभी इस फ़ोन तक नहीं पहुँची';

  @override
  String get financeDelete => 'प्रविष्टि हटाएँ';

  @override
  String get financeDeleteTitle => 'यह प्रविष्टि हटाएँ?';

  @override
  String get financeDeleteMessage =>
      'अगर यह किसी लॉट बिक्री से जुड़ी है, तो बिक्री भी हटेगी और स्टॉक वापस आएगा।';

  @override
  String get financeDeleteConfirm => 'हटाएँ';

  @override
  String get financeDeleted => 'प्रविष्टि हटाई गई';

  @override
  String get financeCategoryFeeding => 'भोजन';

  @override
  String get financeCategoryTreatment => 'दवा';

  @override
  String get financeCategoryEquipment => 'उपकरण';

  @override
  String get financeCategoryFuelTransport => 'ईंधन / ढुलाई';

  @override
  String get financeCategoryLandRent => 'ज़मीन का किराया';

  @override
  String get financeCategoryLabor => 'मज़दूरी';

  @override
  String get financeCategoryLabAnalysis => 'प्रयोगशाला जाँच';

  @override
  String get financeCategoryHoney => 'शहद';

  @override
  String get financeCategoryPollen => 'पराग';

  @override
  String get financeCategoryPropolis => 'प्रोपोलिस';

  @override
  String get financeCategoryWax => 'मोम';

  @override
  String get financeCategoryNucs => 'न्यूक';

  @override
  String get financeCategoryQueens => 'रानियाँ';

  @override
  String get financeCategoryOther => 'अन्य';

  @override
  String get syncTableTransactions => 'आय/ख़र्च';

  @override
  String get customersTitle => 'ग्राहक बही';

  @override
  String get customersAdd => 'ग्राहक जोड़ें';

  @override
  String get customersEmptyTitle => 'अभी कोई ग्राहक नहीं';

  @override
  String get customersEmptyMessage =>
      'ग्राहकों के ऑर्डर और बकाया पर नज़र रखने के लिए उन्हें जोड़ें।';

  @override
  String customerReceivableValue(String amount) {
    return '$amount बकाया';
  }

  @override
  String get customerNoReceivable => 'कोई बकाया नहीं';

  @override
  String get customerNotFound => 'ग्राहक नहीं मिला';

  @override
  String get customerEdit => 'ग्राहक संपादित करें';

  @override
  String get customerAddSale => 'बिक्री जोड़ें';

  @override
  String get customerOrders => 'ऑर्डर';

  @override
  String get customerNoOrders => 'इस ग्राहक को अभी कोई बिक्री नहीं।';

  @override
  String get customerPaid => 'भुगतान हुआ';

  @override
  String customerRemaining(String amount) {
    return '$amount बाकी';
  }

  @override
  String get customerPaidAmount => 'अब तक भुगतान';

  @override
  String get customerMarkPaid => 'भुगतान हुआ चिह्नित करें';

  @override
  String get customerMarkedPaid => 'भुगतान हुआ चिह्नित';

  @override
  String get customerAddPayment => 'भुगतान दर्ज करें';

  @override
  String get customerSendWhatsApp => 'WhatsApp से भेजें';

  @override
  String get customerWhatsAppNoPhone => 'फ़ोन नहीं; WhatsApp में संपर्क चुनें';

  @override
  String get customerWhatsAppFailed => 'WhatsApp नहीं खुल सका';

  @override
  String get customerOpenTransaction => 'प्रविष्टि खोलें';

  @override
  String customerWhatsAppGreeting(String name) {
    return 'नमस्ते $name,';
  }

  @override
  String get customerWhatsAppIntro => 'आपके ऑर्डर का सारांश:';

  @override
  String customerWhatsAppAmount(String amount) {
    return 'कुल: $amount';
  }

  @override
  String customerWhatsAppPaid(String amount) {
    return 'भुगतान: $amount';
  }

  @override
  String customerWhatsAppRemaining(String amount) {
    return 'बाकी: $amount';
  }

  @override
  String get customerWhatsAppPaidInFull => 'पूरा भुगतान हो गया, धन्यवाद।';

  @override
  String customerWhatsAppAddress(String address) {
    return 'डिलीवरी का पता: $address';
  }

  @override
  String get customerFormNewTitle => 'नया ग्राहक';

  @override
  String get customerFormEditTitle => 'ग्राहक संपादित करें';

  @override
  String get customerFormName => 'नाम';

  @override
  String get customerFormPhone => 'फ़ोन';

  @override
  String get customerFormPhoneHelper => 'WhatsApp के लिए, जैसे +91 98765 43210';

  @override
  String get customerFormAddress => 'डिलीवरी का पता';

  @override
  String get customerFormNotes => 'नोट';

  @override
  String get customerFormSave => 'सहेजें';

  @override
  String get customerSaved => 'ग्राहक सहेजा गया';

  @override
  String get customerDelete => 'ग्राहक हटाएँ';

  @override
  String get customerDeleteTitle => 'ग्राहक हटाएँ?';

  @override
  String get customerDeleteMessage => 'उनकी बिक्री आपकी आय में बनी रहेगी।';

  @override
  String get customerDeleteConfirm => 'हटाएँ';

  @override
  String get customerDeleted => 'ग्राहक हटाया गया';

  @override
  String get customerPaymentSave => 'भुगतान सहेजें';

  @override
  String get customerPaymentSaved => 'भुगतान सहेजा गया';

  @override
  String customerPaymentTooMuch(String amount) {
    return 'सिर्फ़ $amount बाकी है।';
  }

  @override
  String get financeFormCustomer => 'ग्राहक';

  @override
  String get financeFormChooseCustomer => 'ग्राहक चुनें';

  @override
  String get financeFormNoCustomers => 'अभी कोई ग्राहक नहीं';

  @override
  String get financeFormPaidNow => 'अभी भुगतान';

  @override
  String get financeFormPaidNowHelper => 'पूरी राशि बकाया हो तो खाली छोड़ें।';

  @override
  String get financeFormPaidTooMuch => 'राशि से ज़्यादा नहीं हो सकता।';

  @override
  String get financeProfitTitle => 'फार्म के अनुसार मुनाफ़ा';

  @override
  String get financeProfitUnknownApiary => 'हटाया गया फार्म';

  @override
  String financeReceivables(String amount, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ग्राहक',
      one: '1 ग्राहक',
    );
    return '$amount बकाया · $_temp0';
  }

  @override
  String get syncTableCustomers => 'ग्राहक';

  @override
  String get syncTableCustomerPayments => 'भुगतान';

  @override
  String get customerUnpaid => 'भुगतान नहीं';

  @override
  String customerPartiallyPaid(String paid, String remaining) {
    return '$paid भुगतान, $remaining बाकी';
  }

  @override
  String get taskAksUpdateTitle => 'AKS अपडेट करना न भूलें';

  @override
  String get taskSourceAks => 'AKS';

  @override
  String get syncTableRefSupportPeriods => 'सहायता अवधि';

  @override
  String get subsidiesTitle => 'सब्सिडी';

  @override
  String get subsidiesCheckTitle => 'आवेदन से पहले';

  @override
  String get subsidiesActiveHives => 'ऐप में सक्रिय छत्ते';

  @override
  String get subsidiesDeclaredHives => 'AKS में घोषित';

  @override
  String get subsidiesNotDeclared => 'नहीं डाला';

  @override
  String get subsidiesCheckNotDeclared =>
      'AKS में घोषित छत्तों की संख्या डालें; आवेदन से पहले इसकी ऐप से तुलना होगी।';

  @override
  String subsidiesCheckDiffers(String active, String declared) {
    return 'ऐप में $active सक्रिय छत्ते हैं पर AKS में $declared घोषित हैं। आवेदन से पहले अपना AKS रिकॉर्ड अपडेट करें।';
  }

  @override
  String get subsidiesCheckMatches =>
      'संख्याएँ मेल खाती हैं: ऐप और AKS एक जैसे हैं।';

  @override
  String get subsidiesEditDeclared => 'घोषित संख्या डालें';

  @override
  String get subsidiesDeclaredOwnerOnly =>
      'सिर्फ़ मालिक घोषित संख्या डाल सकता है।';

  @override
  String get subsidiesPeriodsTitle => 'आवेदन अवधियाँ';

  @override
  String get subsidiesEmptyTitle => 'अभी कोई सहायता अवधि नहीं';

  @override
  String get subsidiesEmptyMessage =>
      'आवेदन अवधियाँ घोषित होने पर यहाँ दिखेंगी; कोई अवधि खुलने पर आपको सूचना मिलेगी।';

  @override
  String get subsidiesPhaseOpen => 'खुली';

  @override
  String get subsidiesPhaseUpcoming => 'आने वाली';

  @override
  String get subsidiesPhaseClosed => 'बंद';

  @override
  String subsidiesPeriodDates(String start, String end) {
    return '$start – $end';
  }

  @override
  String get subsidiesOpenSource => 'सरकारी सूचना खोलें';

  @override
  String get subsidiesOpenSourceFailed => 'लिंक नहीं खुल सका';

  @override
  String get aksCountTitle => 'AKS छत्ता संख्या';

  @override
  String get aksCountLabel => 'AKS में घोषित छत्ता संख्या';

  @override
  String get aksCountHelper => 'जाँच छोड़ने के लिए खाली छोड़ें।';

  @override
  String get aksCountInvalid => '0 से 100,000 के बीच संख्या डालें';

  @override
  String get aksCountSave => 'सहेजें';

  @override
  String get aksCountSaved => 'AKS छत्ता संख्या सहेजी गई';

  @override
  String get aksCountNoOrganization =>
      'व्यवसाय की जानकारी अभी इस फ़ोन पर सिंक नहीं हुई; सिंक की प्रतीक्षा करें।';

  @override
  String get knowledgeTitle => 'ज्ञान भंडार';

  @override
  String get knowledgeSearchHint => 'सर्दी का भंडार, वरोआ…';

  @override
  String knowledgeMonthLabel(String month, String place) {
    return '$month · $place';
  }

  @override
  String get knowledgePlaceTurkey => 'तुर्किये';

  @override
  String get knowledgePlaceNorthern => 'उत्तरी गोलार्ध';

  @override
  String get knowledgePlaceSouthern => 'दक्षिणी गोलार्ध';

  @override
  String get knowledgeMonthTitle => 'इस महीने करें';

  @override
  String get knowledgeDiagnosisTitle => 'निदान सहायक';

  @override
  String get knowledgeDiagnosisSubtitle =>
      'कोई लक्षण चुनें, संभावित कारण देखें';

  @override
  String get knowledgeAtlasTitle => 'रोग और कीट एटलस';

  @override
  String knowledgeTopicCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count विषय',
      one: '1 विषय',
    );
    return '$_temp0';
  }

  @override
  String get knowledgeGuidesTitle => 'तकनीकी गाइड';

  @override
  String get knowledgeGuidesSubtitle =>
      'विभाजन, रानी देना, मिलाना, सर्दी बिताना';

  @override
  String get knowledgeCalculatorsTitle => 'कैलकुलेटर';

  @override
  String get knowledgeCalculatorsSubtitle =>
      'चाशनी, दवा की खुराक, रानी कैलेंडर, उपज';

  @override
  String get knowledgeRegulationsTitle => 'नियमों का सार';

  @override
  String get knowledgeRegulationsSubtitle =>
      'नियमावली, प्रवासी पालन, शहद अधिसूचना';

  @override
  String get knowledgeTrBadge => 'TR';

  @override
  String get knowledgeFirstYearTitle => 'मेरा पहला साल';

  @override
  String get knowledgeFirstYearSubtitle =>
      'शुरुआत करने वालों के लिए कदम-दर-कदम';

  @override
  String get knowledgeCalendarTitle => 'मौसमी कैलेंडर';

  @override
  String get knowledgeOffline => 'सारी सामग्री बिना इंटरनेट खुलती है';

  @override
  String get knowledgeNoResultsTitle => 'कोई नतीजा नहीं';

  @override
  String get knowledgeNoResultsMessage => 'कोई दूसरा शब्द आज़माएँ।';

  @override
  String get knowledgeCategoryEmptyTitle => 'अभी कोई लेख नहीं';

  @override
  String get knowledgeCategoryEmptyMessage =>
      'इस भाग की सामग्री किसी अपडेट के साथ आएगी।';

  @override
  String get knowledgeArticleNotFound => 'लेख नहीं मिला';

  @override
  String get knowledgeLoadError => 'ज्ञान भंडार नहीं खुल सका';

  @override
  String get knowledgeLinkFailed => 'लिंक नहीं खुल सका';

  @override
  String get diagnosisSymptoms => 'जो लक्षण दिख रहे हैं';

  @override
  String get diagnosisSymptomsHelper => 'एक से ज़्यादा चुन सकते हैं।';

  @override
  String get diagnosisResults => 'संभावित रोग';

  @override
  String get diagnosisPickHint =>
      'संभावित रोग यहाँ देखने के लिए कोई लक्षण चुनें।';

  @override
  String get diagnosisNoMatch => 'चुने गए लक्षणों से कोई रोग मेल नहीं खाता।';

  @override
  String diagnosisMatched(int matched, int total) {
    return 'मिलते लक्षण: $matched/$total';
  }

  @override
  String get diagnosisNotifiable => 'सूचना ज़रूरी';

  @override
  String get diagnosisDisclaimer =>
      'यह शुरुआती आकलन है; अंतिम निदान पशु चिकित्सक या प्रयोगशाला देती है।';

  @override
  String get diagnosisLoadError => 'निदान तालिका नहीं खुल सकी';

  @override
  String get diagnosisNotFound => 'रोग नहीं मिला';

  @override
  String get diagnosisNotifiableTitle => 'सूचना ज़रूरी वाला रोग।';

  @override
  String get diagnosisNotifiableMessage =>
      'शक की सूचना अधिकारी को दें; इस छत्ते के उपकरण, फ़्रेम या शहद दूसरे छत्तों के साथ न बाँटें।';

  @override
  String get diagnosisAdvice => 'क्या करें';

  @override
  String get diagnosisAuthority => 'अधिकारी';

  @override
  String diagnosisCall(String phone) {
    return '$phone पर कॉल करें';
  }

  @override
  String get diagnosisCallFailed => 'कॉल शुरू नहीं हो सकी';

  @override
  String get diagnosisQuarantine => 'छत्ते को क्वारंटीन करें';

  @override
  String get quarantinePickTitle => 'क्वारंटीन के लिए छत्ता';

  @override
  String get quarantineSearchHint => 'छत्ता नंबर';

  @override
  String get quarantineNoHivesTitle => 'कोई छत्ता नहीं';

  @override
  String get quarantineNoHivesMessage =>
      'क्वारंटीन के लिए कोई सक्रिय छत्ता नहीं।';

  @override
  String quarantineDone(String number) {
    return 'छत्ता $number क्वारंटीन में';
  }

  @override
  String get hiveQuarantined => 'क्वारंटीन में';

  @override
  String hiveQuarantineDisease(String disease) {
    return 'शक: $disease';
  }

  @override
  String hiveQuarantineSince(String date) {
    return '$date से';
  }

  @override
  String get hiveQuarantineWarning =>
      'इसके उपकरण, फ़्रेम या शहद दूसरे छत्तों के साथ न बाँटें।';

  @override
  String get hiveQuarantineEnd => 'क्वारंटीन खत्म करें';

  @override
  String hiveQuarantineEnded(String number) {
    return 'छत्ता $number क्वारंटीन से बाहर';
  }

  @override
  String get calculatorSyrup => 'चाशनी';

  @override
  String get calculatorSyrupSubtitle => 'ज़रूरी चीनी और पानी';

  @override
  String get calculatorDose => 'उपचार की खुराक';

  @override
  String get calculatorDoseSubtitle => 'आपके छत्तों की संख्या के लिए कुल';

  @override
  String get calculatorQueen => 'रानी कैलेंडर';

  @override
  String get calculatorQueenSubtitle => 'ग्राफ़्टिंग के दिन से हर चरण का दिन';

  @override
  String get calculatorYield => 'उपज';

  @override
  String get calculatorYieldSubtitle => 'हर छत्ते का शहद';

  @override
  String get calculatorOffline =>
      'गणना बिना इंटरनेट चलती है और कुछ सहेजती नहीं।';

  @override
  String get calculatorNotFound => 'कैलकुलेटर नहीं मिला';

  @override
  String get calculatorHives => 'छत्तों की संख्या';

  @override
  String get calculatorSyrupKind => 'चाशनी का प्रकार';

  @override
  String get calculatorFillHint => 'छत्तों की संख्या और मात्रा डालें।';

  @override
  String get calculatorDosePerHive => 'हर छत्ते की खुराक';

  @override
  String get calculatorDoseUnit => 'इकाई';

  @override
  String get calculatorTotal => 'कुल';

  @override
  String calculatorDoseTotal(String unit, String total) {
    String _temp0 = intl.Intl.selectLogic(unit, {
      'strip': '$total पट्टियाँ',
      'ml': '$total मिली',
      'g': '$total ग्रा',
      'other': '$total खुराक',
    });
    return '$_temp0';
  }

  @override
  String calculatorDoseCount(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count छत्ते × $amount',
      one: '1 छत्ता × $amount',
    );
    return '$_temp0';
  }

  @override
  String calculatorYieldTotal(String unit) {
    return 'कुल शहद ($unit)';
  }

  @override
  String get calculatorYieldPerHive => 'हर छत्ते पर';

  @override
  String calculatorYieldValue(String amount, String unit) {
    return '$amount $unit';
  }

  @override
  String get calculatorQueenSteps => 'चरण';

  @override
  String get hiveLossWintering => 'सर्दी';

  @override
  String get hiveLossQueenless => 'रानी रहित';

  @override
  String get hiveLossVarroa => 'वरोआ';

  @override
  String get hiveLossDisease => 'रोग';

  @override
  String get hiveLossStarvation => 'भूख';

  @override
  String get hiveLossRobbing => 'लूट';

  @override
  String get hiveLossPredator => 'भालू / जानवर';

  @override
  String get hiveLossPoisoning => 'ज़हर';

  @override
  String get hiveLossOther => 'अन्य';

  @override
  String get hiveLossUnspecified => 'नहीं बताया';

  @override
  String hiveLossReasonTitle(String number) {
    return 'छत्ता $number क्यों खोया?';
  }

  @override
  String get hiveLossSkip => 'बिना कारण छोड़ें';

  @override
  String get hiveFormLossReason => 'खोने का कारण';

  @override
  String get hiveFormLossReasonHelper =>
      'सीज़न रिपोर्ट में इस्तेमाल होता है; खाली छोड़ सकते हैं।';

  @override
  String get seasonReportTile => 'सीज़न रिपोर्ट';

  @override
  String seasonTitle(String year) {
    return 'सीज़न $year';
  }

  @override
  String get seasonPdf => 'PDF';

  @override
  String get seasonExportCsv => 'Excel (CSV) में निर्यात';

  @override
  String get seasonExportError => 'फ़ाइल नहीं बन सकी। फिर कोशिश करें।';

  @override
  String get seasonLoadError => 'सीज़न रिपोर्ट लोड नहीं हो सकी।';

  @override
  String get seasonHives => 'छत्ते';

  @override
  String seasonHiveChange(int start, int end) {
    return '$start → $end';
  }

  @override
  String seasonNetGain(int count) {
    return '+$count शुद्ध';
  }

  @override
  String seasonNetLoss(int count) {
    return '−$count शुद्ध';
  }

  @override
  String get seasonNetSame => 'कोई बदलाव नहीं';

  @override
  String get seasonWinterLoss => 'सर्दी का नुकसान';

  @override
  String get seasonWinterNotStarted => 'सर्दी अभी शुरू नहीं हुई';

  @override
  String seasonPreviousWinter(String year) {
    return 'सर्दी का नुकसान $year';
  }

  @override
  String seasonPreviousWinterRate(String year, String rate) {
    return '$year: $rate';
  }

  @override
  String get seasonHoney => 'कुल शहद';

  @override
  String get seasonNewQueens => 'नई रानियाँ';

  @override
  String seasonOwnReared(int count) {
    return 'अपना पालन $count';
  }

  @override
  String get seasonLossesTitle => 'नुकसान और कारण';

  @override
  String get seasonNoLosses => 'इस सीज़न कोई छत्ता नहीं खोया।';

  @override
  String seasonHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count छत्ते',
      one: '1 छत्ता',
    );
    return '$_temp0';
  }

  @override
  String get seasonByTreatment => 'सर्दी का नुकसान · उपचार के तरीके के अनुसार';

  @override
  String get seasonByApiary => 'सर्दी का नुकसान · फार्म के अनुसार';

  @override
  String get seasonByQueenLine => 'सर्दी का नुकसान · रानी लाइन के अनुसार';

  @override
  String get seasonTabTreatment => 'उपचार';

  @override
  String get seasonTabApiary => 'फार्म';

  @override
  String get seasonTabQueenLine => 'रानी लाइन';

  @override
  String get seasonNoWinterData =>
      'आपके रिकॉर्ड में अभी कोई छत्ता सर्दी में नहीं गया।';

  @override
  String get seasonFewData => 'कम डेटा';

  @override
  String get seasonMisleadingNote =>
      'आपके अपने रिकॉर्ड से; कम छत्तों में भ्रामक हो सकता है।';

  @override
  String get seasonUntreated => 'उपचार नहीं';

  @override
  String get seasonMethodSeparator => ' +';

  @override
  String get seasonQueenLineUnknown => 'अज्ञात लाइन';

  @override
  String get seasonFinanceTitle => 'लागत और मुनाफ़ा';

  @override
  String get seasonProfit => 'मुनाफ़ा';

  @override
  String get seasonPdfFigure => 'आँकड़ा';

  @override
  String get seasonPdfValue => 'मान';

  @override
  String seasonPdfHiveChange(int start, int end, String net) {
    return '$start → $end ($net)';
  }

  @override
  String seasonPdfNewQueens(int count, int own) {
    return '$count (अपना पालन $own)';
  }

  @override
  String seasonPdfWinterLoss(String rate, int lost, int hives) {
    return '$rate ($hives में से $lost छत्ते)';
  }

  @override
  String get seasonPdfReason => 'कारण';

  @override
  String get seasonPdfHives => 'छत्ते';

  @override
  String get seasonPdfLost => 'खोए';

  @override
  String get seasonPdfRate => 'नुकसान';

  @override
  String get seasonPdfGroup => 'समूह';

  @override
  String get seasonPdfTotal => 'कुल';

  @override
  String get seasonCsvHive => 'छत्ता';

  @override
  String get seasonCsvApiary => 'फार्म';

  @override
  String get seasonCsvStartStatus => 'सीज़न की शुरुआत में स्थिति';

  @override
  String get seasonCsvEndStatus => 'सीज़न के अंत में स्थिति';

  @override
  String get seasonCsvLossDate => 'खोने की तारीख़';

  @override
  String get seasonCsvLossReason => 'खोने का कारण';

  @override
  String get seasonCsvInWinter => 'सर्दी में गया';

  @override
  String get seasonCsvLostInWinter => 'सर्दी में खोया';

  @override
  String get seasonCsvWinterApiary => 'सर्दी का फार्म';

  @override
  String get seasonCsvTreatment => 'सर्दी से पहले उपचार';

  @override
  String get seasonCsvQueenLine => 'रानी लाइन';

  @override
  String get seasonCsvAddedInSeason => 'इस सीज़न जोड़ा';

  @override
  String get seasonCsvYes => 'हाँ';

  @override
  String get seasonCsvNo => 'नहीं';

  @override
  String get offlineMapsTitle => 'ऑफ़लाइन नक्शे';

  @override
  String get offlineMapsIntro =>
      'अपने फार्मों के आसपास का इलाका डाउनलोड करें; नेटवर्क न हो तब भी नक्शा खुलेगा।';

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
    return 'डाउनलोड हुआ · $size';
  }

  @override
  String offlineMapsDownloadingWifi(String received, String total) {
    return 'Wi‑Fi पर डाउनलोड हो रहा है · $received / $total';
  }

  @override
  String offlineMapsDownloading(String received, String total) {
    return 'डाउनलोड हो रहा है · $received / $total';
  }

  @override
  String offlineMapsDownload(String name) {
    return '$name डाउनलोड करें';
  }

  @override
  String get offlineMapsCancel => 'डाउनलोड रोकें';

  @override
  String offlineMapsDelete(String name) {
    return '$name हटाएँ';
  }

  @override
  String offlineMapsDeleteTitle(String name) {
    return '$name हटाएँ?';
  }

  @override
  String get offlineMapsDeleteMessage =>
      'बिना इंटरनेट इस फार्म के आसपास का नक्शा नहीं खुलेगा। आप इसे कभी भी फिर डाउनलोड कर सकते हैं।';

  @override
  String get offlineMapsDeleteConfirm => 'हटाएँ';

  @override
  String get offlineMapsWifiOnly => 'सिर्फ़ Wi‑Fi पर डाउनलोड करें';

  @override
  String get offlineMapsWifiOnlyHint =>
      'हर फार्म के लिए कुछ MB; मोबाइल डेटा इस्तेमाल नहीं होता।';

  @override
  String offlineMapsStop(String name) {
    return '$name पड़ाव';
  }

  @override
  String offlineMapsDone(String name) {
    return '$name के आसपास का इलाका डाउनलोड हुआ';
  }

  @override
  String offlineMapsFailed(String name) {
    return '$name के आसपास का इलाका डाउनलोड नहीं हो सका। कनेक्शन जाँचें और फिर कोशिश करें।';
  }

  @override
  String get offlineMapsNeedsWifi =>
      'Wi‑Fi से जुड़ें या \"सिर्फ़ Wi‑Fi पर डाउनलोड करें\" बंद करें।';

  @override
  String get offlineMapsAttribution =>
      'नक्शा डेटा © OpenStreetMap contributors · OpenFreeMap';

  @override
  String get settingsOfflineMaps => 'ऑफ़लाइन नक्शे';

  @override
  String settingsOfflineMapsValue(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फार्म · $size',
      one: '1 फार्म · $size',
      zero: 'कोई नहीं',
    );
    return '$_temp0';
  }

  @override
  String get offlineMapsCoverage =>
      'हर फार्म के आसपास 6 किमी विस्तार से और 40 किमी सामान्य दृश्य में मिलता है।';

  @override
  String offlineMapsDownloadedOn(String date) {
    return 'डाउनलोड: $date';
  }

  @override
  String get offlineMapsToDownload => 'डाउनलोड के लिए फार्म';

  @override
  String get offlineMapsMoved => 'फार्म की जगह बदली, फिर डाउनलोड करें';

  @override
  String get offlineMapsNoApiaries =>
      'लोकेशन वाला कोई फार्म नहीं। किसी फार्म में लोकेशन जोड़ें, वह यहाँ दिखेगा।';

  @override
  String get offlineMapsAllDownloaded =>
      'लोकेशन वाले सभी फार्म डाउनलोड हो चुके हैं।';

  @override
  String get syncReminderTitle => 'आपके रिकॉर्ड का अभी बैकअप नहीं हुआ';

  @override
  String syncReminderBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count रिकॉर्ड 3 दिन से सर्वर तक नहीं पहुँचे। ऑनलाइन होने पर ऐप खोलें।',
      one: '1 रिकॉर्ड 3 दिन से सर्वर तक नहीं पहुँचा। ऑनलाइन होने पर ऐप खोलें।',
    );
    return '$_temp0';
  }

  @override
  String get syncOverdueTitle => '3+ दिन से बैकअप नहीं';

  @override
  String syncOverdueMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count रिकॉर्ड सिर्फ़ इस फ़ोन पर हैं। फ़ोन खोया तो ये भी खो जाएँगे। इंटरनेट से जुड़ें और सिंक करें।',
      one: '1 रिकॉर्ड सिर्फ़ इस फ़ोन पर है। फ़ोन खोया तो यह भी खो जाएगा। इंटरनेट से जुड़ें और सिंक करें।',
    );
    return '$_temp0';
  }

  @override
  String syncDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिन पहले',
      one: 'कल',
      zero: 'आज',
    );
    return '$_temp0';
  }

  @override
  String syncLastSyncedAgo(String ago, String when) {
    return 'पिछला सिंक $ago · $when';
  }

  @override
  String syncPendingTitle(int count) {
    return 'भेजे जाने की प्रतीक्षा में · $count';
  }

  @override
  String settingsSignOutPendingMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count रिकॉर्ड अभी सर्वर पर नहीं भेजे गए और सिर्फ़ इस फ़ोन पर हैं। साइन आउट करने पर ये नहीं भेजे जाएँगे। पहले इंटरनेट से जुड़ें और सिंक करें।',
      one: '1 रिकॉर्ड अभी सर्वर पर नहीं भेजा गया और सिर्फ़ इस फ़ोन पर है। साइन आउट करने पर यह नहीं भेजा जाएगा। पहले इंटरनेट से जुड़ें और सिंक करें।',
    );
    return '$_temp0';
  }

  @override
  String get settingsSignOutAnyway => 'फिर भी साइन आउट करें';

  @override
  String get settingsExport => 'डेटा निर्यात';

  @override
  String get settingsExportValue => 'Excel';

  @override
  String get settingsExportHint =>
      'आपके सभी रिकॉर्ड एक Excel फ़ाइल में; कहीं भी साझा करें या सहेजें।';

  @override
  String get exportPreparing => 'तैयार हो रहा है…';

  @override
  String get exportFailed => 'फ़ाइल तैयार नहीं हो सकी। फिर कोशिश करें।';

  @override
  String exportFileName(String date) {
    return 'Mobil Arıcı $date';
  }

  @override
  String get exportYes => 'हाँ';

  @override
  String get exportNo => 'नहीं';

  @override
  String get exportSheetApiaries => 'फार्म';

  @override
  String get exportSheetHives => 'छत्ते';

  @override
  String get exportSheetQueens => 'रानियाँ';

  @override
  String get exportSheetInspections => 'निरीक्षण';

  @override
  String get exportSheetFeedings => 'भोजन';

  @override
  String get exportSheetTreatments => 'उपचार';

  @override
  String get exportSheetMiteCounts => 'वरोआ गिनती';

  @override
  String get exportSheetHarvests => 'निकासियाँ';

  @override
  String get exportSheetTasks => 'काम';

  @override
  String get exportSheetInventory => 'स्टॉक';

  @override
  String get exportSheetFinance => 'आय और ख़र्च';

  @override
  String get exportColName => 'नाम';

  @override
  String get exportColLatitude => 'अक्षांश';

  @override
  String get exportColLongitude => 'देशांतर';

  @override
  String get exportColAltitude => 'ऊँचाई (मी)';

  @override
  String get exportColLandowner => 'ज़मीन मालिक';

  @override
  String get exportColLandownerPhone => 'ज़मीन मालिक का फ़ोन';

  @override
  String get exportColWaterSource => 'पानी का स्रोत';

  @override
  String get exportColVehicleDistance => 'वाहन से दूरी (मी)';

  @override
  String get exportColRoadNotes => 'रास्ते के नोट';

  @override
  String get exportColNotes => 'नोट्स';

  @override
  String get exportColActiveHives => 'सक्रिय छत्ते';

  @override
  String get exportColCreated => 'जोड़ा गया';

  @override
  String get exportColApiary => 'फार्म';

  @override
  String get exportColHive => 'छत्ता';

  @override
  String get exportColType => 'प्रकार';

  @override
  String get exportColStatus => 'स्थिति';

  @override
  String get exportColBoxes => 'बॉक्स';

  @override
  String get exportColFrames => 'फ़्रेम';

  @override
  String get exportColSource => 'स्रोत';

  @override
  String get exportColMarking => 'चिह्न';

  @override
  String get exportColTag => 'लेबल कोड';

  @override
  String get exportColQuarantine => 'क्वारंटीन';

  @override
  String get exportColQueen => 'रानी';

  @override
  String get exportColYear => 'साल';

  @override
  String get exportColColor => 'निशान का रंग';

  @override
  String get exportColBreed => 'नस्ल';

  @override
  String get exportColLine => 'लाइन';

  @override
  String get exportColWingClipped => 'पंख कटे';

  @override
  String get exportColDate => 'तारीख़';

  @override
  String get exportColQueenState => 'रानी';

  @override
  String get exportColBeeFrames => 'मधुमक्खी फ़्रेम';

  @override
  String get exportColBroodFrames => 'ब्रूड फ़्रेम';

  @override
  String get exportColHoneyFrames => 'शहद फ़्रेम';

  @override
  String get exportColTemperament => 'स्वभाव';

  @override
  String get exportColSwarmSigns => 'झुंड के संकेत';

  @override
  String get exportColQueenCells => 'रानी कोष';

  @override
  String get exportColDisease => 'बीमारी का शक';

  @override
  String get exportColActions => 'किया गया';

  @override
  String get exportColAmount => 'मात्रा';

  @override
  String get exportColUnit => 'इकाई';

  @override
  String get exportColProduct => 'उत्पाद';

  @override
  String get exportColActiveIngredient => 'सक्रिय घटक';

  @override
  String get exportColDose => 'खुराक';

  @override
  String get exportColWithdrawal => 'प्रतीक्षा (दिन)';

  @override
  String get exportColBatch => 'बैच नंबर';

  @override
  String get exportColPlannedRemoval => 'योजनाबद्ध हटाना';

  @override
  String get exportColMethod => 'तरीका';

  @override
  String get exportColMites => 'माइट';

  @override
  String get exportColSampleBees => 'नमूने की मधुमक्खियाँ';

  @override
  String get exportColDays => 'दिन';

  @override
  String get exportColResult => 'नतीजा';

  @override
  String get exportColHoneyKind => 'शहद';

  @override
  String get exportColUnitCount => 'संख्या';

  @override
  String get exportColNetKg => 'शुद्ध (किग्रा)';

  @override
  String get exportColHiveCount => 'छत्ते';

  @override
  String get exportColDue => 'अंतिम तारीख़';

  @override
  String get exportColTitle => 'शीर्षक';

  @override
  String get exportColCompleted => 'पूरा';

  @override
  String get exportColCategory => 'श्रेणी';

  @override
  String get exportColPlace => 'जगह';

  @override
  String get exportColStock => 'स्टॉक में';

  @override
  String get exportColThreshold => 'इससे कम पर चेतावनी';

  @override
  String get exportColCurrency => 'मुद्रा';

  @override
  String get exportColDescription => 'विवरण';

  @override
  String get businessTitle => 'व्यवसाय';

  @override
  String get businessEdit => 'संपादित करें';

  @override
  String get businessEditTitle => 'व्यवसाय संपादित करें';

  @override
  String get businessCancel => 'रद्द करें';

  @override
  String get businessSave => 'सहेजें';

  @override
  String get businessSaveError =>
      'सहेजा नहीं जा सका; व्यवसाय अभी इस फ़ोन पर नहीं है।';

  @override
  String get businessMissingTitle => 'व्यवसाय की जानकारी नहीं';

  @override
  String get businessMissingMessage =>
      'व्यवसाय इस फ़ोन तक पहुँचने पर यह यहाँ दिखेगी।';

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
  String get businessRegionTr => 'TR प्रोफ़ाइल';

  @override
  String get businessRegionOther => 'सामान्य प्रोफ़ाइल';

  @override
  String get businessPendingSync => 'अभी सिंक नहीं हुआ';

  @override
  String businessCountHives(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'छत्ते',
      one: 'छत्ता',
    );
    return '$_temp0';
  }

  @override
  String businessCountApiaries(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'फार्म',
      one: 'फार्म',
    );
    return '$_temp0';
  }

  @override
  String businessCountInspections(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'निरीक्षण',
      one: 'निरीक्षण',
    );
    return '$_temp0';
  }

  @override
  String get businessSectionBusiness => 'व्यवसाय';

  @override
  String get businessSectionAccount => 'खाता';

  @override
  String get businessType => 'प्रकार';

  @override
  String get businessTypeMigratory => 'प्रवासी';

  @override
  String get businessTypeStationary => 'स्थिर';

  @override
  String get businessTypeHelp =>
      'स्थिर होने पर प्रवास योजनाएँ और प्रवास छिप जाते हैं; रिकॉर्ड नहीं हटते।';

  @override
  String get businessCurrency => 'मुद्रा';

  @override
  String get businessCurrencySearch => 'कोड या देश खोजें';

  @override
  String get businessCurrencyNoMatch => 'आपकी खोज से कोई मुद्रा नहीं मिली।';

  @override
  String get businessCurrencyNote =>
      'पिछले रिकॉर्ड बदले नहीं जाते; नई मुद्रा सिर्फ़ अब से होने वाले रिकॉर्ड पर लागू होती है।';

  @override
  String businessTeamTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'टीम · $count लोग',
      one: 'टीम · 1 व्यक्ति',
    );
    return '$_temp0';
  }

  @override
  String get businessTeamSolo => 'अभी टीम में कोई सदस्य नहीं';

  @override
  String businessRoleCountOwner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count मालिक',
      one: '1 मालिक',
    );
    return '$_temp0';
  }

  @override
  String businessRoleCountPartner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count साझेदार',
      one: '1 साझेदार',
    );
    return '$_temp0';
  }

  @override
  String businessRoleCountWorker(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count कर्मचारी',
      one: '1 कर्मचारी',
    );
    return '$_temp0';
  }

  @override
  String businessRoleCountViewer(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सलाहकार',
      one: '1 सलाहकार',
    );
    return '$_temp0';
  }

  @override
  String get businessEmail => 'साइन-इन ईमेल';

  @override
  String get businessEmailSoon => 'ईमेल बदलने की सुविधा जल्द आ रही है।';

  @override
  String get businessFirstRecord => 'पहला रिकॉर्ड';

  @override
  String businessFirstRecordValue(String date, int season) {
    return '$date · सीज़न $season';
  }

  @override
  String get businessSettingsShortcut => 'भाषा, इकाइयाँ, थीम और डेटा सेटिंग्स';

  @override
  String get businessNameLabel => 'व्यवसाय का नाम';

  @override
  String get businessFullNameLabel => 'पूरा नाम';

  @override
  String get businessFullNameHelp => 'आपकी टीम आपको इसी नाम से देखती है।';

  @override
  String get businessAvatarLabel => 'अवतार';

  @override
  String get businessAvatarHelp =>
      'लोगो न हो तो आपके नाम के पहले अक्षर आपके चुने रंग में दिखते हैं।';

  @override
  String get businessAvatarPine => 'चीड़';

  @override
  String get businessAvatarHoney => 'शहद';

  @override
  String get businessAvatarSky => 'आसमान';

  @override
  String get businessAvatarSlate => 'स्लेट';

  @override
  String get businessLogoUpload => 'लोगो अपलोड करें';

  @override
  String get businessLogoRemove => 'लोगो हटाएँ';

  @override
  String get businessDiscardTitle => 'बदलाव छोड़ दें?';

  @override
  String get businessDiscardMessage => 'बिना सहेजे बदलाव खो जाएँगे।';

  @override
  String get businessDiscardAction => 'छोड़ दें';

  @override
  String get businessTypeConfirmTitle => 'स्थिर पर बदलें?';

  @override
  String businessTypeConfirmMessage(int plans, int stops) {
    String _temp0 = intl.Intl.pluralLogic(
      plans,
      locale: localeName,
      other: '$plans प्रवास योजनाएँ',
      one: '1 प्रवास योजना',
    );
    String _temp1 = intl.Intl.pluralLogic(
      stops,
      locale: localeName,
      other: '$stops पड़ाव',
      one: '1 पड़ाव',
    );
    return '$_temp0 और $_temp1 छिप जाएँगे। रिकॉर्ड नहीं हटते; आप इसे वापस कर सकते हैं।';
  }

  @override
  String get businessTypeConfirmAction => 'बदलें';

  @override
  String get businessReadOnly =>
      'सिर्फ़ मालिक और साझेदार व्यवसाय की जानकारी बदल सकते हैं।';

  @override
  String get financeOtherCurrencies => 'अन्य मुद्राएँ';

  @override
  String financeOtherCurrencyLine(String currency, String amount) {
    return '$currency · शुद्ध $amount';
  }

  @override
  String get migratoryHiddenTitle => 'प्रवासी मॉड्यूल बंद है';

  @override
  String get migratoryHiddenMessage =>
      'आपका व्यवसाय स्थिर है। प्रवास योजनाएँ और प्रवास हटाए नहीं गए; प्रवासी पर बदलने से वापस आ जाएँगे।';

  @override
  String get onboardingMigratoryTitle =>
      'क्या आप अपने छत्ते एक जगह से दूसरी जगह ले जाते हैं (प्रवासी)?';

  @override
  String get onboardingMigratoryMessage =>
      'अगर नहीं, तो प्रवास योजनाएँ और प्रवास छिपे रहेंगे; व्यवसाय प्रोफ़ाइल में कभी भी बदल सकते हैं।';

  @override
  String get onboardingMigratoryYes => 'हाँ';

  @override
  String get onboardingMigratoryNo => 'नहीं, स्थिर';

  @override
  String get settingsDeleteAccount => 'मेरा खाता हटाएँ';

  @override
  String get settingsDeleteAccountOffline =>
      'खाता हटाने के लिए इंटरनेट चाहिए; ऑनलाइन होने पर फिर कोशिश करें।';

  @override
  String get deletionTitle => 'मेरा खाता हटाएँ';

  @override
  String deletionStepCounter(int current, int total) {
    return 'चरण $current / $total';
  }

  @override
  String get deletionContinue => 'आगे बढ़ें';

  @override
  String get deletionSoloTitle => 'आपका खाता और व्यवसाय हटा दिए जाएँगे';

  @override
  String deletionSoloMessage(String organization) {
    return '$organization में सिर्फ़ आप हैं। खाता हटाने से व्यवसाय और उसके सभी रिकॉर्ड भी हट जाएँगे।';
  }

  @override
  String get deletionCountsLabel => 'हटने वाले रिकॉर्ड';

  @override
  String get deletionCountHives => 'छत्ते';

  @override
  String get deletionCountApiaries => 'फार्म';

  @override
  String get deletionCountInspections => 'निरीक्षण';

  @override
  String get deletionCountHarvests => 'निकासियाँ';

  @override
  String get deletionCountDocuments => 'दस्तावेज़';

  @override
  String get deletionCountPhotos => 'फ़ोटो';

  @override
  String get deletionLotWarningTitle => 'QR कोड काम करना बंद कर देंगे।';

  @override
  String deletionLotWarningMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count सार्वजनिक लॉट पेज हटेंगे, और आपके जारों के QR कोड काम करना बंद कर देंगे।',
      one: '1 सार्वजनिक लॉट पेज हटेगा, और आपके जारों के QR कोड काम करना बंद कर देंगे।',
    );
    return '$_temp0';
  }

  @override
  String get deletionTeamTitle => 'आपकी टीम है: चुनें कि व्यवसाय का क्या हो';

  @override
  String deletionTeamMessage(int count, String organization) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'आप $organization के मालिक हैं, और टीम में $count और लोग हैं।',
      one: 'आप $organization के मालिक हैं, और टीम में 1 और व्यक्ति है।',
    );
    return '$_temp0';
  }

  @override
  String get deletionChoiceTransfer => 'मालिकाना हक़ सौंपें और छोड़ें';

  @override
  String get deletionChoiceTransferHint =>
      'व्यवसाय और उसके रिकॉर्ड बने रहेंगे। आपका चुना साझेदार मालिक बनेगा; सिर्फ़ आपका खाता हटेगा।';

  @override
  String get deletionChoiceDelete => 'व्यवसाय और सभी रिकॉर्ड हटाएँ';

  @override
  String deletionChoiceDeleteHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'टीम के दूसरे $count लोग भी पहुँच खो देंगे।',
      one: 'टीम का दूसरा व्यक्ति भी पहुँच खो देगा।',
    );
    return '$_temp0';
  }

  @override
  String get deletionTransferPick => 'नया मालिक';

  @override
  String get deletionTransferNoPartner =>
      'सौंपने के लिए टीम में किसी का साझेदार होना ज़रूरी है। टीम स्क्रीन पर किसी सदस्य को साझेदार बनाएँ, या व्यवसाय हटाएँ।';

  @override
  String get deletionPartnerFallbackName => 'साझेदार';

  @override
  String get deletionMemberTitle => 'सिर्फ़ आपका खाता हटेगा';

  @override
  String deletionMemberMessage(String organization) {
    return '$organization और उसके रिकॉर्ड नहीं हटेंगे। आपके डाले रिकॉर्ड व्यवसाय में रहेंगे; आपका नाम टीम से हटा दिया जाएगा।';
  }

  @override
  String get deletionUnknownMessage =>
      'आपकी सदस्यता अभी इस फ़ोन तक नहीं पहुँची। सिंक के बाद फिर कोशिश करें।';

  @override
  String get deletionGraceNote =>
      '7 दिन बाद हटाना अंतिम हो जाता है; तब तक आप साइन इन करके मन बदल सकते हैं।';

  @override
  String get deletionBackupTitle => 'पहले अपना डेटा सहेजें';

  @override
  String get deletionBackupMessage =>
      'हटाए गए रिकॉर्ड वापस नहीं आ सकते। हम पहले एक कॉपी सहेजने की सलाह देते हैं।';

  @override
  String get deletionBackupReports => 'PDF रिपोर्ट';

  @override
  String get deletionBackupReportsHint => 'तैयार रिपोर्ट PDF में डाउनलोड करें।';

  @override
  String get deletionBackupJson => 'सभी रिकॉर्ड';

  @override
  String get deletionBackupJsonValue => 'JSON';

  @override
  String get deletionBackupJsonHint =>
      'आपके सभी रिकॉर्ड एक फ़ाइल में; जहाँ चाहें सहेजें।';

  @override
  String get deletionBackupSaved => 'सहेजा गया';

  @override
  String get deletionBackupDownload => 'मेरे रिकॉर्ड डाउनलोड करें';

  @override
  String get deletionBackupSkip => 'छोड़ें';

  @override
  String deletionBackupFileName(String date) {
    return 'mobil-arici-records-$date';
  }

  @override
  String get deletionVerifyTitle => 'पुष्टि करें कि यह आप हैं';

  @override
  String get deletionVerifyButton => 'कोड जाँचें';

  @override
  String get deletionConfirmTitle => 'अंतिम पुष्टि';

  @override
  String get deletionConfirmIntro => 'अगर आप पुष्टि करते हैं:';

  @override
  String deletionConsequenceAccount(String date) {
    return 'आपका खाता $date को स्थायी रूप से हट जाएगा।';
  }

  @override
  String deletionConsequenceOrganization(String organization) {
    return '$organization और उसके सभी रिकॉर्ड भी हटेंगे।';
  }

  @override
  String deletionConsequenceTransfer(String name, String organization) {
    return '$name $organization के नए मालिक बनेंगे।';
  }

  @override
  String get deletionConsequenceRecordsStay => 'व्यवसाय के रिकॉर्ड नहीं हटते।';

  @override
  String deletionConsequenceLots(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लॉट पेज बंद होंगे; उनके QR कोड काम करना बंद करेंगे।',
      one: '1 लॉट पेज बंद होगा; उसके QR कोड काम करना बंद करेंगे।',
    );
    return '$_temp0';
  }

  @override
  String get deletionConsequenceSignOut =>
      'आप साइन आउट होंगे और इस फ़ोन का डेटा हट जाएगा।';

  @override
  String get deletionConsequenceCancel =>
      'उससे पहले साइन इन करने पर आप हटाना रद्द कर सकते हैं।';

  @override
  String deletionConfirmTypeName(String organization) {
    return 'पुष्टि के लिए व्यवसाय का नाम लिखें: $organization';
  }

  @override
  String deletionConfirmTypeKeyword(String keyword) {
    return 'पुष्टि के लिए $keyword लिखें';
  }

  @override
  String get deletionKeyword => 'हटाएँ';

  @override
  String get deletionConfirmButton => 'मेरा खाता हटाएँ';

  @override
  String get deletionConfirmButtonWithOrganization =>
      'मेरा खाता और व्यवसाय हटाएँ';

  @override
  String get deletionSubmitting => 'भेजा जा रहा है…';

  @override
  String get deletionFailureNetwork =>
      'सर्वर तक नहीं पहुँच सके। कनेक्शन जाँचें और फिर कोशिश करें।';

  @override
  String get deletionFailureOwnerMustTransfer =>
      'आप टीम वाले एक और व्यवसाय के मालिक भी हैं। पहले वहाँ मालिकाना हक़ सौंपें।';

  @override
  String get deletionFailureInvalidTransfer =>
      'आपका चुना व्यक्ति अब साझेदार नहीं है। कोई दूसरा साझेदार चुनें।';

  @override
  String get deletionFailureRateLimited =>
      'कम समय में बहुत ज़्यादा कोशिशें। कल फिर कोशिश करें।';

  @override
  String get deletionFailureForbidden =>
      'आपका सत्र खत्म हो गया। फिर साइन इन करें और दोबारा कोशिश करें।';

  @override
  String get deletionFailureCodeRequired =>
      'आपकी पुष्टि का समय खत्म हो गया। नया कोड लें और फिर पुष्टि करें।';

  @override
  String get deletionFailureUnknown =>
      'अनुरोध नहीं भेजा जा सका। थोड़ी देर में फिर कोशिश करें।';

  @override
  String get deletionDoneTitle => 'हमें आपका अनुरोध मिल गया';

  @override
  String deletionDoneDate(String date) {
    return 'आपका खाता $date को स्थायी रूप से हट जाएगा।';
  }

  @override
  String get deletionDoneCancelHint =>
      'मन बदले तो उससे पहले साइन इन करें, हटाना रद्द हो जाएगा।';

  @override
  String get deletionDoneEmail => 'हमने विवरण आपके ईमेल पर भी भेज दिया है।';

  @override
  String get deletionDoneClearing => 'इस फ़ोन का डेटा हटाया जा रहा है…';

  @override
  String get deletionDoneSignedOut =>
      'आप साइन आउट हो गए और इस फ़ोन का डेटा हटा दिया गया।';

  @override
  String get deletionDoneAction => 'हो गया';

  @override
  String get deletionPendingTitle => 'आपका खाता हटने वाला है';

  @override
  String deletionPendingMessage(String date) {
    return 'आपका खाता $date को हटेगा। आगे बढ़ने पर हटाना रद्द हो जाएगा।';
  }

  @override
  String get deletionPendingContinue => 'आगे बढ़ें और खाता रखें';

  @override
  String get deletionPendingSignOut => 'साइन आउट करें और हटाना जारी रखें';

  @override
  String get deletionPendingCancelled => 'हटाना रद्द हुआ। फिर से स्वागत है!';

  @override
  String get deletionPendingCancelFailed =>
      'हटाना रद्द नहीं हो सका। कनेक्शन जाँचें और फिर कोशिश करें।';

  @override
  String teamMemberLeaving(String date) {
    return 'खाता हटा रहे हैं · $date';
  }

  @override
  String get teamErrorMemberLeaving =>
      'यह व्यक्ति अपना खाता हटा रहा है; प्रतीक्षा अवधि में उनकी भूमिका नहीं बदल सकती और उन्हें हटाया नहीं जा सकता।';
}
