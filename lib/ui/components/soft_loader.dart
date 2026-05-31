import 'package:flutter/material.dart';

/// Soft, minimal loading indicator (no spinner): three gentle pulsing dots.
class SoftLoader extends StatefulWidget {
  const SoftLoader({super.key});

  @override
  State<SoftLoader> createState() => _SoftLoaderState();
}

class _SoftLoaderState extends State<SoftLoader> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 24,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          double v(int i) => (0.5 + 0.5 * (i == 0 ?
                  (1 + (1 - (2 * (_c.value - 0.0)).abs())) / 2 :
                  i == 1 ? (1 + (1 - (2 * (_c.value - 0.33)).abs())) / 2 :
                  (1 + (1 - (2 * (_c.value - 0.66)).abs())) / 2))
              .clamp(0.3, 1.0);
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Opacity(
                  opacity: v(i),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: scheme.primary, borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
