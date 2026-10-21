import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flavor.g.dart';

enum Flavor { dev, prod }

/// Çalışan flavor. `bootstrap` gerçek değerle override eder; override
/// edilmezse (ör. testlerde) geliştirici araçları kapalı kalsın diye prod.
@Riverpod(keepAlive: true)
Flavor flavor(Ref ref) => Flavor.prod;
