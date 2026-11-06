import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/utils/digits.dart';
import 'package:mobil_arici/features/auth/domain/sign_in_rules.dart';

/// Tek tek kutularda görünen [otpLength] haneli kod alanı.
///
/// Altta görünmez tek bir metin alanı var: klavye, yapıştırma (basılı
/// tutunca), sistemin kod önerisi ve ekran okuyucu onunla çalışır; kutular
/// yalnızca çizimdir. Kod tamamlanınca [onCompleted] çağrılır.
class OtpCodeField extends StatefulWidget {
  const new({
    required this.controller,
    required this.focusNode,
    required this.semanticLabel,
    required this.onCompleted,
    super.key,
    this.enabled = true,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String semanticLabel;
  final ValueChanged<String> onCompleted;
  final bool enabled;

  @override
  State<OtpCodeField> createState() => _OtpCodeFieldState();
}

class _OtpCodeFieldState extends State<OtpCodeField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
    widget.focusNode.addListener(_onChanged);
  }

  @override
  void didUpdateWidget(OtpCodeField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onChanged);
      widget.controller.addListener(_onChanged);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode.removeListener(_onChanged);
      widget.focusNode.addListener(_onChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    widget.focusNode.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final code = widget.controller.text;
    final spacing = context.spacing;

    return Stack(
      children: [
        ExcludeSemantics(
          child: Row(
            children: [
              for (var i = 0; i < otpLength; i++) ...[
                if (i > 0) SizedBox(width: spacing.sm),
                Expanded(
                  child: _DigitBox(
                    digit: i < code.length ? code[i] : null,
                    active:
                        widget.enabled &&
                        widget.focusNode.hasFocus &&
                        i == code.length.clamp(0, otpLength - 1),
                  ),
                ),
              ],
            ],
          ),
        ),
        Positioned.fill(
          child: Opacity(
            opacity: 0,
            alwaysIncludeSemantics: true,
            child: Semantics(
              label: widget.semanticLabel,
              child: TextField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                // Pasifken de odak ve klavye kalır; yanlış kodda alan
                // hemen yeniden yazılabilir.
                readOnly: !widget.enabled,
                showCursor: false,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.oneTimeCode],
                autocorrect: false,
                enableSuggestions: false,
                inputFormatters: [
                  const AsciiDigitsFormatter(),
                  _OtpCodeFormatter(),
                ],
                decoration: const InputDecoration.collapsed(hintText: null),
                onChanged: (value) {
                  if (value.length == otpLength) widget.onCompleted(value);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DigitBox extends StatelessWidget {
  const new({required this.digit, required this.active});

  final String? digit;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final strokes = context.strokes;
    final digit = this.digit;

    return SizedBox(
      height: context.touchTargets.fieldLarge + context.spacing.sm,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.tile,
          borderRadius: BorderRadius.circular(context.radii.button),
          border: Border.all(
            color: active ? colors.primary : colors.divider,
            width: strokes.focus,
          ),
        ),
        child: Center(
          child: digit == null
              ? null
              : Text(digit, style: context.typography.number),
        ),
      ),
    );
  }
}

class _OtpCodeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final code = otpInput(previous: oldValue.text, next: newValue.text);
    // İmleç hep sonda: kutular soldan sağa dolar.
    return TextEditingValue(
      text: code,
      selection: TextSelection.collapsed(offset: code.length),
    );
  }
}
