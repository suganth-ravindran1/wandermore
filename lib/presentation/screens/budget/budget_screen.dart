import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../providers/app_providers.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/budget_widgets.dart';
import '../../widgets/common_widgets.dart';

class BudgetScreen extends ConsumerStatefulWidget {
  const BudgetScreen({super.key});

  @override
  ConsumerState<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends ConsumerState<BudgetScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final itinerary = ref.watch(itineraryProvider).valueOrNull;

    if (itinerary == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Budget')),
        body: Center(
          child: PrimaryButton(
            label: 'Create a Trip First',
            expand: false,
            onPressed: () => context.go('/explore'),
          ),
        ),
        bottomNavigationBar: const TripBottomNav(currentIndex: 2),
      );
    }

    final budget = itinerary.budget;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          BudgetTotalCard(total: budget.total, days: budget.days),
          const SizedBox(height: 20),
          Row(
            children: [
              _BudgetTab(
                label: 'Breakdown',
                selected: _tab == 0,
                onTap: () => setState(() => _tab = 0),
              ),
              const SizedBox(width: 20),
              _BudgetTab(
                label: 'Daily Wise',
                selected: _tab == 1,
                onTap: () => setState(() => _tab = 1),
              ),
            ],
          ),
          const Divider(height: 1),
          const SizedBox(height: 8),
          if (_tab == 0) ...[
            ...budget.categories.map(
              (c) => BudgetCategoryRow(
                category: c,
                percent: budget.percentOf(c),
              ),
            ),
            const SizedBox(height: 12),
            DailyBudgetBanner(amount: budget.dailyAverage),
            const SizedBox(height: 20),
            SoftShadowCard(
              padding: const EdgeInsets.all(16),
              color: AppColors.softTealAlt,
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Optimize & Save',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'AI tips to reduce flexible costs.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'View Options',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            ...List.generate(itinerary.days.length, (i) {
              final day = itinerary.days[i];
              final dayBudget = (budget.total / budget.days).round();
              return SoftShadowCard(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Day ${day.dayNumber}',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            day.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      MoneyText.format(dayBudget),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
      bottomNavigationBar: const TripBottomNav(currentIndex: 2),
    );
  }
}

class _BudgetTab extends StatelessWidget {
  const _BudgetTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 3,
            width: 72,
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
