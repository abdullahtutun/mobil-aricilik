import 'package:flutter/material.dart';
import 'package:mobil_arici/core/services/code_scanner.dart';

/// Kamerasız okutma: ekrandaki görünüm kodu [scan] ile elle alır.
class FakeCodeScanner {
  ValueChanged<String>? _onCode;

  /// Kamera ekranda mı (tanınmayan kodda kapanır).
  bool get isOpen => _onCode != null;

  /// Kameranın [code]'u okuduğunu taklit eder.
  void scan(String code) {
    final onCode = _onCode;
    if (onCode == null) throw StateError('Kamera ekranda değil');
    onCode(code);
  }

  CodeScannerBuilder get builder =>
      (onCode) => _FakeCamera(scanner: this, onCode: onCode);
}

class _FakeCamera extends StatefulWidget {
  const new({required this.scanner, required this.onCode});

  final FakeCodeScanner scanner;
  final ValueChanged<String> onCode;

  @override
  State<_FakeCamera> createState() => _FakeCameraState();
}

class _FakeCameraState extends State<_FakeCamera> {
  @override
  void initState() {
    super.initState();
    widget.scanner._onCode = widget.onCode;
  }

  @override
  void didUpdateWidget(_FakeCamera oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.scanner._onCode = widget.onCode;
  }

  @override
  void dispose() {
    if (widget.scanner._onCode == widget.onCode) widget.scanner._onCode = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.expand();
}
