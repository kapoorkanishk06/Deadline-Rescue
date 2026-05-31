import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_1/ui/components/soft_loader.dart';
import 'package:project_1/ui/components/back_button_bar.dart';
import 'package:project_1/nav.dart';

class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({super.key});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1600), () {
      if (!mounted) return;
      context.go('/results');
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            BackButtonBar(
              alwaysVisible: true,
              onPressed: () {
                try {
                  _timer?.cancel();
                } catch (_) {}
                if (mounted) context.go(AppRoutes.dump);
              },
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  // Updated calming micro-copy per request
                  Text('Rescuing your day…', style: text.titleLarge),
                  const SizedBox(height: 8),
                  Text('This takes a few seconds.', style: text.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8))),
                  const SizedBox(height: 24),
                  const SoftLoader(),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
