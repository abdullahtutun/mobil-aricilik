import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';

/// Firebase projesi `mobilarici-94b97`; dev ve prod aynı projeyi kullanır.
/// google-services eklentisi yok: ayarlar Dart'tan verilir, böylece dev'in
/// `.dev` uygulama kimliği derlemeyi bozmaz. İstemci anahtarları gizli
/// değildir.
FirebaseOptions get firebaseOptions => Platform.isIOS ? _ios : _android;

const _android = FirebaseOptions(
  apiKey: 'AIzaSyCfHQ9pCnqvn5q1G2wrmrUkTTPzo06iosE',
  appId: '1:134091678985:android:628f61cd40a9c5bfad9fd8',
  messagingSenderId: '134091678985',
  projectId: 'mobilarici-94b97',
  storageBucket: 'mobilarici-94b97.firebasestorage.app',
);

const _ios = FirebaseOptions(
  apiKey: 'AIzaSyDg3iLQf07NRB0199_AonlOHowaBEO6DH4',
  appId: '1:134091678985:ios:9d4cb53ec09211ccad9fd8',
  messagingSenderId: '134091678985',
  projectId: 'mobilarici-94b97',
  storageBucket: 'mobilarici-94b97.firebasestorage.app',
  iosBundleId: 'com.abdullahtutun.mobilarici',
);
