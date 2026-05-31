import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({super.key, required this.label, this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 17), // +~6px total height
          elevation: 1, // subtle lift
          shadowColor: scheme.shadow.withValues(alpha: 0.05), // 3–5% opacity shadow
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? Opacity(
                opacity: 0.9,
                child: const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: scheme.onPrimary)),
      ),
    );
  }
}
