import 'package:flutter/material.dart';

class PillOption<T> {
  final String label;
  final T value;
  PillOption(this.label, this.value);
}

class PillSelector<T> extends StatelessWidget {
  final String? ariaLabel;
  final List<PillOption<T>> options;
  final T? selected;
  final ValueChanged<T> onChanged;

  const PillSelector({super.key, required this.options, required this.selected, required this.onChanged, this.ariaLabel});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((o) {
        final isSel = o.value == selected;
        return ChoiceChip(
          label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6), // slightly more horizontal padding
            child: Text(o.label, style: textTheme.labelLarge?.copyWith(color: isSel ? scheme.onPrimaryContainer : scheme.onSurface)),
          ),
          selected: isSel,
          onSelected: (_) => onChanged(o.value),
          side: BorderSide(color: isSel ? scheme.primary : scheme.outline.withValues(alpha: 0.6)), // lighter unselected border
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: scheme.surface,
          selectedColor: scheme.primaryContainer,
          showCheckmark: false,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: const VisualDensity(horizontal: -1, vertical: -0.5), // slightly taller touch target
        );
      }).toList(),
    );
  }
}
