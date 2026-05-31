import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_1/state/rescue_state.dart';
import 'package:project_1/ui/components/minimal_card.dart';
import 'package:project_1/ui/components/back_button_bar.dart';
import 'package:project_1/nav.dart';
import 'package:go_router/go_router.dart';

class RescueResultsScreen extends StatelessWidget {
  const RescueResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RescueState>();
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    final tasks = state.tasks;

    final energy = state.energy ?? EnergyLevel.medium;
    final timeHrs = state.timeHours ?? 2;

    final maxNowTasks = (energy == EnergyLevel.low || timeHrs < 2) ? 1 : 2;
    final nowTasks = tasks.take(maxNowTasks).toList();
    final remaining = tasks.skip(nowTasks.length).toList();
    final canWait = remaining.take(3).toList();
    final drop = remaining.skip(canWait.length).toList();

    // Time estimate helper for Do This Now
    List<int> estimatesMinutes(int count) {
      final totalFocus = (timeHrs * 60 * 0.6).clamp(30, 90).toInt();
      if (count <= 1) {
        final base = switch (energy) {
          EnergyLevel.low => (totalFocus * 0.6).toInt(),
          EnergyLevel.medium => (totalFocus * 0.8).toInt(),
          EnergyLevel.high => totalFocus,
        };
        return [base.clamp(20, 60)];
      } else {
        final each = (totalFocus / 2).clamp(20, 45).toInt();
        return [each, each];
      }
    }

    final estimates = estimatesMinutes(nowTasks.length);

    Widget taskRow(String t, {String? trailing}) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.check_circle_outline, size: 18, color: Colors.blue),
            const SizedBox(width: 8),
            Expanded(child: Text(t, style: text.bodyLarge)),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              Text(trailing, style: text.labelLarge?.copyWith(color: scheme.onSurface.withValues(alpha: 0.7))),
            ]
          ],
        );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            BackButtonBar(
              alwaysVisible: true,
              onPressed: () {
                // Per request: from Screen 3 (Results), go back to Screen 2 (BrainDump)
                // Use go() to ensure navigation works even when there's no back stack.
                context.go(AppRoutes.dump);
              },
            ),
            const SizedBox(height: 4),
            Expanded(
              child: ListView(
                children: [
                  // Card 1: Do This Now
                  MinimalCard(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Do This Now', style: text.titleLarge),
                      const SizedBox(height: 8),
                      if (nowTasks.isEmpty)
                        Text('Start with the smallest task to gain momentum.', style: text.bodyLarge)
                      else
                        ...List.generate(nowTasks.length, (i) => Padding(
                              padding: EdgeInsets.only(bottom: i == nowTasks.length - 1 ? 0 : 8),
                              child: taskRow(nowTasks[i], trailing: '${estimates[i]} min'),
                            )),
                      const SizedBox(height: 8),
                      Text('Finishing these gives the highest relief.', style: text.labelMedium?.copyWith(color: scheme.onSurface.withValues(alpha: 0.7))),
                    ]),
                  ),
                  const SizedBox(height: 16),

                  // Card 2: Can Wait
                  MinimalCard(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Can Wait', style: text.titleLarge),
                      const SizedBox(height: 8),
                      if (canWait.isEmpty)
                        Text('Nothing urgent here. You can safely postpone.', style: text.bodyLarge)
                      else
                        ...List.generate(canWait.length, (i) => Padding(
                              padding: EdgeInsets.only(bottom: i == canWait.length - 1 ? 0 : 8),
                              child: taskRow(canWait[i]),
                            )),
                      const SizedBox(height: 8),
                      Text('Safe to postpone today.', style: text.labelMedium?.copyWith(color: scheme.onSurface.withValues(alpha: 0.7))),
                    ]),
                  ),
                  const SizedBox(height: 16),

                  // Card 3: Drop Without Guilt
                  Container(
                    decoration: BoxDecoration(color: const Color(0xFFFDEAEA), borderRadius: BorderRadius.circular(12), border: Border.all(color: scheme.outline.withValues(alpha: 0.2))),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Drop Without Guilt', style: text.titleLarge?.copyWith(color: scheme.onSurface)),
                        const SizedBox(height: 8),
                        if (drop.isEmpty)
                          Text('If you need to, drop something. That is okay.', style: text.bodyLarge)
                        else
                          ...List.generate(drop.length, (i) => Padding(
                                padding: EdgeInsets.only(bottom: i == drop.length - 1 ? 0 : 8),
                                child: taskRow(drop[i]),
                              )),
                        const SizedBox(height: 8),
                        Text('Dropping these today reduces overload — not failure.', style: text.labelMedium?.copyWith(color: scheme.onSurface.withValues(alpha: 0.8))),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Card 4: 90-Minute Survival Plan
                  MinimalCard(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('90-Minute Survival Plan', style: text.titleLarge),
                      const SizedBox(height: 12),
                      _PlanBlock(minutes: 30, label: nowTasks.isNotEmpty ? nowTasks[0] : (tasks.isNotEmpty ? tasks.first : 'Focus on one small task')),
                      const SizedBox(height: 8),
                      _PlanBlock(minutes: 10, label: 'Break'),
                      const SizedBox(height: 8),
                      _PlanBlock(minutes: 30, label: nowTasks.length >= 2 ? nowTasks[1] : (tasks.length > 1 ? tasks[1] : 'Light admin')),
                      const SizedBox(height: 8),
                      _PlanBlock(minutes: 20, label: 'Buffer'),
                      const SizedBox(height: 12),
                      const _WhyChoices(),
                    ]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: Text('Built by Prime Path', style: text.labelMedium?.copyWith(color: scheme.onSurface.withValues(alpha: 0.6))),
            ),
          ]),
        ),
      ),
    );
  }
}

class _PlanBlock extends StatelessWidget {
  final int minutes;
  final String label;
  const _PlanBlock({required this.minutes, required this.label});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(color: scheme.surface, border: Border.all(color: scheme.outline.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: BorderRadius.circular(8)),
          child: Text('$minutes min', style: text.labelLarge?.copyWith(color: scheme.onPrimaryContainer)),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: text.bodyLarge)),
      ]),
    );
  }
}

class _WhyChoices extends StatefulWidget {
  const _WhyChoices();
  @override
  State<_WhyChoices> createState() => _WhyChoicesState();
}

class _WhyChoicesState extends State<_WhyChoices> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      GestureDetector(
        onTap: () => setState(() => _expanded = !_expanded),
        behavior: HitTestBehavior.opaque,
        child: Row(children: [
          Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: scheme.onSurface.withValues(alpha: 0.7)),
          const SizedBox(width: 4),
          Text('Why these choices?', style: text.labelLarge?.copyWith(color: scheme.onSurface)),
        ]),
      ),
      AnimatedCrossFade(
        firstChild: const SizedBox.shrink(),
        secondChild: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text('Based on the time you have, your energy, and the real cost of each task.', style: text.bodyMedium?.copyWith(color: scheme.onSurface.withValues(alpha: 0.85))),
        ),
        crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 200),
      ),
    ]);
  }
}
