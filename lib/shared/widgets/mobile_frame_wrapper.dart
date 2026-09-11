import 'package:flutter/material.dart';

/// Reusable Mobile Frame Wrapper (Constrained to 390-420px max width with background canvas)
class MobileFrameWrapper extends StatelessWidget {
  final Widget child;

  const MobileFrameWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 420,
        ),
        child: child,
      ),
    );
  }
}
