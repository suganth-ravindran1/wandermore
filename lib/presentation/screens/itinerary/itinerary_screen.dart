import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../providers/app_providers.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/timeline_widgets.dart';

class ItineraryScreen extends ConsumerWidget {
  const ItineraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itinerary = ref.watch(itineraryProvider).valueOrNull;

    if (itinerary == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Itinerary')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.map_outlined,
                  size: 64, color: AppColors.textMuted),
              const SizedBox(height: 12),
              const Text(
                'No itinerary yet',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'Create a trip from Explore',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: 'Explore Destinations',
                expand: false,
                onPressed: () => context.go('/explore'),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const TripBottomNav(currentIndex: 1),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Itinerary'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/explore'),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.ios_share)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _Pill(label: 'Overview', selected: true),
                const SizedBox(width: 8),
                _Pill(
                  label: 'Day Plan',
                  selected: false,
                  onTap: () => context.push('/itinerary/details'),
                ),
                const SizedBox(width: 8),
                _Pill(
                  label: 'Map',
                  selected: false,
                  onTap: () => context.push('/map'),
                ),
                const SizedBox(width: 8),
                _Pill(label: 'Tips', selected: false),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SoftShadowCard(
            color: AppColors.surfaceBlue,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              itinerary.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.edit_outlined,
                              size: 16, color: AppColors.textMuted),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        itinerary.metaLine,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${MoneyText.format(itinerary.budget.total)} Total Budget',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () => context.push('/budget'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('View Budget'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(itinerary.days.length, (index) {
            final day = itinerary.days[index];
            return OverviewDayTile(
              day: day,
              onTap: () {
                ref.read(selectedDayProvider.notifier).state = index;
                context.push('/itinerary/details');
              },
            );
          }),
          const SizedBox(height: 8),
          PrimaryButton(
            label: '+ Swap / Replace Place',
            onPressed: () => context.push('/must-visit'),
          ),
          const SizedBox(height: 12),
          OutlineAppButton(
            label: 'Trip Summary',
            onPressed: () => context.push('/summary'),
          ),
        ],
      ),
      bottomNavigationBar: const TripBottomNav(currentIndex: 1),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.selected,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.chipBg,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
