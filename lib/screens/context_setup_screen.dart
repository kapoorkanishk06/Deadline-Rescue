import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:project_1/state/rescue_state.dart';
import 'package:project_1/ui/components/minimal_card.dart';
import 'package:project_1/ui/components/pill_selector.dart';
import 'package:project_1/ui/components/primary_button.dart';

class ContextSetupScreen extends StatelessWidget {
  const ContextSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final state = context.watch<RescueState>();
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 960; // desktop breakpoint for layout refinements
    const maxContentWidth = 1000.0; // keep content between 960 and 1040px

    final timeOptions = [
      PillOption('1h', 1),
      PillOption('2h', 2),
      PillOption('3h', 3),
      PillOption('4h', 4),
      PillOption('5h+', 5),
    ];
    final energyOptions = [
      PillOption('Low', EnergyLevel.low),
      PillOption('Medium', EnergyLevel.medium),
      PillOption('High', EnergyLevel.high),
    ];

    final canContinue = state.timeHours != null && state.energy != null;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: maxContentWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Let's get real about today.",
                    style: text.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      height: (text.headlineLarge?.height ?? 1.0) + 0.06,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FractionallySizedBox(
                    widthFactor: 0.84,
                    alignment: Alignment.centerLeft,
                    child: Text('No perfect plans. Just what you can actually finish.', style: text.bodyLarge),
                  ),
                  const SizedBox(height: 24),
                  MinimalCard(
                    padding: const EdgeInsets.fromLTRB(16, 28, 16, 28),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('How much time do you really have today?', style: text.titleLarge),
                      const SizedBox(height: 12),
                      PillSelector(options: timeOptions, selected: state.timeHours, onChanged: (v) => context.read<RescueState>().setTimeHours(v)),
                      const SizedBox(height: 16),
                      Text(
                        'Energy',
                        style: text.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface),
                      ),
                      const SizedBox(height: 12),
                      PillSelector(options: energyOptions, selected: state.energy, onChanged: (v) => context.read<RescueState>().setEnergy(v)),
                    ]),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'You can change this later.',
                      style: text.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55)),
                    ),
                  ),
                  if (isDesktop) const SizedBox(height: 16) else const Spacer(),
                  // CTA: match card width via container width; desktop spacing close to card
                  PrimaryButton(
                    label: 'Continue',
                    onPressed: canContinue ? () => context.go('/dump') : null,
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.center,
                    child: Text('Built by Prime Path', style: text.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
