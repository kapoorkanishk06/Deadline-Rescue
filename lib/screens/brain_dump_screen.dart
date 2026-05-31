import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:project_1/state/rescue_state.dart';
import 'package:project_1/ui/components/minimal_card.dart';
import 'package:project_1/ui/components/primary_button.dart';
import 'package:project_1/ui/components/back_button_bar.dart';
import 'package:project_1/nav.dart';

class BrainDumpScreen extends StatefulWidget {
  const BrainDumpScreen({super.key});

  @override
  State<BrainDumpScreen> createState() => _BrainDumpScreenState();
}

class _BrainDumpScreenState extends State<BrainDumpScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final existing = context.read<RescueState>().brainDump;
    _controller = TextEditingController(text: existing);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final isMobile = MediaQuery.of(context).size.width <= 600;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const BackButtonBar(alwaysVisible: true, fallbackRoute: AppRoutes.home),
            const SizedBox(height: 4),
            Text('Dump everything on your mind.', style: text.headlineLarge),
            const SizedBox(height: 8),
            Text('Messy is okay.', style: text.bodyLarge),
            const SizedBox(height: 24),
            Expanded(
              child: MinimalCard(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: 'Assignment, revise unit 3, gym, call mom, project meeting…',
                        border: InputBorder.none,
                        // Slight extra inner padding on mobile to avoid a cramped top-left cursor
                        contentPadding: EdgeInsets.only(
                          top: isMobile ? 8 : 4,
                          left: isMobile ? 2 : 0,
                          right: isMobile ? 2 : 0,
                        ),
                      ),
                      style: text.bodyLarge,
                    ),
                  ),
                  SizedBox(height: isMobile ? 10 : 8),
                  Text("Don't prioritize. Just list.", style: text.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
                ]),
              ),
            ),
            SizedBox(height: isMobile ? 20 : 16),
            PrimaryButton(
              label: 'Save My Day',
              onPressed: () {
                try {
                  context.read<RescueState>().setBrainDump(_controller.text);
                } catch (e) {
                  debugPrint('Failed to save brain dump: $e');
                }
                context.go('/processing');
              },
            ),
            SizedBox(height: isMobile ? 20 : 16),
            Align(
              alignment: Alignment.center,
              child: Text('Built by Prime Path', style: text.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
            ),
          ]),
        ),
      ),
    );
  }
}
