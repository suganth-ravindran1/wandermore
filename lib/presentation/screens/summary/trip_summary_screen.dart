import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../providers/app_providers.dart';
import '../../widgets/common_widgets.dart';

class TripSummaryScreen extends ConsumerWidget {
  const TripSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itinerary = ref.watch(itineraryProvider).valueOrNull;
    final dateFmt = DateFormat('d MMM yyyy');

    if (itinerary == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Trip Summary')),
        body: const Center(child: Text('No trip')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Summary'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 200,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AppNetworkImage(url: itinerary.imageUrl),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.65),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 16,
                    right: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          itinerary.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          itinerary.metaLine,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withValues(alpha: 0.9),
                      child: const Icon(Icons.edit, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _DetailRow(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Total Budget',
            value: MoneyText.format(itinerary.budget.total),
            bold: true,
          ),
          _DetailRow(
            icon: Icons.schedule_outlined,
            label: 'Trip Duration',
            value: '${itinerary.durationDays} Days',
          ),
          _DetailRow(
            icon: Icons.calendar_month_outlined,
            label: 'Travel Dates',
            value:
                '${dateFmt.format(itinerary.startDate)} - ${dateFmt.format(itinerary.endDate)}',
          ),
          _DetailRow(
            icon: Icons.verified_user_outlined,
            label: 'Travel Style',
            value: itinerary.travelStyle,
          ),
          _DetailRow(
            icon: Icons.groups_outlined,
            label: 'Group',
            value: itinerary.travelers == 1
                ? '1 Person'
                : '${itinerary.travelers} People',
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            label: 'Book All & Save',
            onPressed: () => context.push('/bookings'),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () => context.push('/bookings'),
              child: const Text(
                'or Book Separately',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.bold = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textMuted, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
