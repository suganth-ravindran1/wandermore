import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../providers/app_providers.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/timeline_widgets.dart';

class ItineraryDetailsScreen extends ConsumerWidget {
  const ItineraryDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itinerary = ref.watch(itineraryProvider).valueOrNull;
    final selected = ref.watch(selectedDayProvider);

    if (itinerary == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Day Plan')),
        body: const Center(child: Text('No itinerary')),
      );
    }

    final dayIndex = selected.clamp(0, itinerary.days.length - 1);
    final day = itinerary.days[dayIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Day ${day.dayNumber}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          DayChipSelector(
            days: itinerary.days,
            selectedIndex: dayIndex,
            onSelected: (i) =>
                ref.read(selectedDayProvider.notifier).state = i,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Day ${day.dayNumber} - ${day.dateLabel}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (day.isMustVisitDay) const MustVisitBadge(),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                ...List.generate(day.activities.length, (i) {
                  return TimelineActivityItem(
                    activity: day.activities[i],
                    isLast: i == day.activities.length - 1,
                  );
                }),
                if (day.stayName != null) ...[
                  const SizedBox(height: 16),
                  SoftShadowCard(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.softTeal,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.home_outlined,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Stay',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                day.stayName!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                OutlineAppButton(
                  label: 'View Map',
                  icon: Icons.map_outlined,
                  onPressed: () => context.push('/map'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
