import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/budget.dart';
import 'common_widgets.dart';

IconData budgetIcon(String name) {
  switch (name) {
    case 'bed':
      return Icons.bed_outlined;
    case 'restaurant':
      return Icons.restaurant_outlined;
    case 'directions_car':
      return Icons.directions_car_outlined;
    case 'confirmation_number':
      return Icons.confirmation_number_outlined;
    case 'hiking':
      return Icons.hiking;
    case 'shopping_bag':
      return Icons.shopping_bag_outlined;
    case 'health_and_safety':
      return Icons.health_and_safety_outlined;
    default:
      return Icons.category_outlined;
  }
}

class BudgetTotalCard extends StatelessWidget {
  const BudgetTotalCard({
    super.key,
    required this.total,
    required this.days,
  });

  final int total;
  final int days;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.budgetCardGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Estimated Budget',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  MoneyText.format(total),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'For $days Days Trip',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: Colors.white,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }
}

class BudgetCategoryRow extends StatelessWidget {
  const BudgetCategoryRow({
    super.key,
    required this.category,
    required this.percent,
  });

  final BudgetCategory category;
  final int percent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.softTeal,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              budgetIcon(category.iconName),
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            MoneyText.format(category.amount),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 36,
            child: Text(
              '$percent%',
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DailyBudgetBanner extends StatelessWidget {
  const DailyBudgetBanner({super.key, required this.amount});

  final int amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.dailyBudgetBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Daily Budget',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            '${MoneyText.format(amount)} / day',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.show_chart, color: AppColors.primary, size: 20),
        ],
      ),
    );
  }
}
