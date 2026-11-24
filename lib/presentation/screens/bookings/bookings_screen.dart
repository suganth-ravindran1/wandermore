import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../providers/app_providers.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/common_widgets.dart';

class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itinerary = ref.watch(itineraryProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          SoftShadowCard(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.softTeal,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.flight_takeoff,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        itinerary == null
                            ? 'Flight booking'
                            : 'Arrival → ${itinerary.destination}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    _ConfirmedBadge(),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '12 May • 10:30 AM',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          SoftShadowCard(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.softTeal,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.verified_user_outlined,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Local Permits',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    _ConfirmedBadge(),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  itinerary == null
                      ? '2 People'
                      : '${itinerary.travelers} People • Confirmed',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          SoftShadowCard(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                _BookingDetail(label: 'Check-out', value: '16 May, 11:00 AM'),
                _BookingDetail(label: 'Nights', value: '4 Nights'),
                _BookingDetail(label: 'Guests', value: '1 Room, 1 Guest'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Total Paid',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                      Text(
                        MoneyText.format(
                          itinerary?.budget.categories.first.amount ?? 3500,
                        ),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'View Invoice',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlineAppButton(
                        label: 'Contact Hotel',
                        icon: Icons.phone_outlined,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: PrimaryButton(
                        label: 'View Location',
                        icon: Icons.location_on_outlined,
                        onPressed: () => context.push('/map'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          PrimaryButton(
            label: '+ New Booking',
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: const TripBottomNav(currentIndex: 3),
    );
  }
}

class _ConfirmedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.softTeal,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Confirmed',
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _BookingDetail extends StatelessWidget {
  const _BookingDetail({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
