import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

class BackButtonBar extends StatelessWidget {
  final bool alwaysVisible;
  final VoidCallback? onPressed;
  final String? fallbackRoute;

  const BackButtonBar({super.key, this.alwaysVisible = false, this.onPressed, this.fallbackRoute});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final canGoBack = alwaysVisible || context.canPop();

    if (!canGoBack) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: () {
          try {
            if (onPressed != null) {
              onPressed!();
              return;
            }
            if (context.canPop()) {
              context.pop();
              return;
            }
            if (fallbackRoute != null) {
              context.go(fallbackRoute!);
              return;
            }
          } catch (e) {
            debugPrint('BackButtonBar onPressed error: $e');
          }
        },
        icon: const Icon(Icons.arrow_back),
        color: scheme.onSurface,
        tooltip: 'Back',
        style: IconButton.styleFrom(
          padding: const EdgeInsets.all(8),
          shape: const CircleBorder(),
          foregroundColor: scheme.onSurface,
        ),
      ),
    );
  }
}
