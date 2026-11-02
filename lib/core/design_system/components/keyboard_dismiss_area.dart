import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// Klavye açıkken metin alanı dışındaki bir yere dokunulunca alanın odağını
/// bırakır, klavye kapanır. Dokunuş altındaki butona da gider. Kaydırma
/// (parmak kayarsa) klavyeyi kapatmaz; başka bir metin alanına ya da
/// kopyala/yapıştır menüsüne dokunmak odağı oraya taşır. Uygulamanın
/// kökünde bir kez sarılır; her `TextField`'ın varsayılan "dışarı dokunma"
/// davranışını değiştirir.
class KeyboardDismissArea extends StatefulWidget {
  const new({required this.child, super.key});

  final Widget child;

  @override
  State<KeyboardDismissArea> createState() => _KeyboardDismissAreaState();
}

class _KeyboardDismissAreaState extends State<KeyboardDismissArea> {
  /// Alan dışındaki son dokunuşun başladığı yer.
  Offset? _downPosition;

  @override
  Widget build(BuildContext context) => Actions(
    actions: {
      EditableTextTapOutsideIntent:
          CallbackAction<EditableTextTapOutsideIntent>(
            onInvoke: (intent) {
              _downPosition = intent.pointerDownEvent.position;
              return null;
            },
          ),
      EditableTextTapUpOutsideIntent:
          CallbackAction<EditableTextTapUpOutsideIntent>(
            onInvoke: (intent) {
              final down = _downPosition;
              _downPosition = null;
              final event = intent.pointerUpEvent;
              final slop = computeHitSlop(event.kind, null);
              if (down != null && (event.position - down).distance <= slop) {
                intent.focusNode.unfocus();
              }
              return null;
            },
          ),
    },
    child: widget.child,
  );
}
