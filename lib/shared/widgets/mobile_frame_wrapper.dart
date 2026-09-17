import 'package:flutter/material.dart';

/// Reusable Mobile Frame Wrapper (Constrained to 390-420px max width with background canvas)
class MobileFrameWrapper extends StatelessWidget {
  final Widget child;
  final Alignment alignment;

  const MobileFrameWrapper({
    super.key,
    required this.child,
    this.alignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 420,
        ),
        child: child,
      ),
    );
  }
}
