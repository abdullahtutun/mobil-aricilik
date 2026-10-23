import 'package:flutter/material.dart';
import 'package:mobil_arici/features/hives/domain/hive_label_code.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/unknown_label_view.dart';

/// Kovan etiketi linki (`mobilarici://h/<kimlik>`) bir kovan açmadığında
/// görünür; kovan varsa router doğrudan kartına yönlendirir. Etiketi bir
/// kovana atamayı sunar.
class HiveLinkScreen extends StatelessWidget {
  const new({required this.hiveId, super.key});

  final String hiveId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: UnknownLabelView(code: hiveLabelCode(hiveId)),
    );
  }
}
