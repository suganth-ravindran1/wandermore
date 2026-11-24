import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/trip_preferences.dart';
import '../../providers/app_providers.dart';
import '../../widgets/chips.dart';
import '../../widgets/common_widgets.dart';

class CreateItineraryScreen extends ConsumerStatefulWidget {
  const CreateItineraryScreen({super.key});

  @override
  ConsumerState<CreateItineraryScreen> createState() =>
      _CreateItineraryScreenState();
}

class _CreateItineraryScreenState extends ConsumerState<CreateItineraryScreen> {
  final _mustVisitController = TextEditingController();
  final _dateFmt = DateFormat('d MMM yyyy');

  static const _styles = [
    'Adventure',
    'Nature',
    'Culture',
    'Food',
    'Relaxation',
    'Beach',
  ];

  @override
  void dispose() {
    _mustVisitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(tripFormProvider);
    final repo = ref.watch(destinationRepositoryProvider);
    final suggestions = repo.placeSuggestions(
      form.destination.isEmpty ? 'Destination' : form.destination,
      '',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Itinerary'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                const Text(
                  'Tell us your preferences.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 20),
                _FieldCard(
                  icon: Icons.location_on_outlined,
                  label: 'Destination',
                  value: form.destination.isEmpty
                      ? 'Enter destination'
                      : '${form.destination}${form.isInternational ? '' : ', India'}',
                  trailing: Icons.edit_outlined,
                  onTap: () => context.push('/search'),
                ),
                const SizedBox(height: 12),
                _FieldCard(
                  icon: Icons.calendar_month_outlined,
                  label: 'Travel Dates',
                  value:
                      '${_dateFmt.format(form.startDate)} - ${_dateFmt.format(form.endDate)}',
                  onTap: () => _pickDates(form),
                ),
                const SizedBox(height: 12),
                _FieldCard(
                  icon: Icons.people_outline,
                  label: 'Travelers',
                  value:
                      '${form.travelers} Adult${form.travelers == 1 ? '' : 's'}',
                  onTap: () => _pickTravelers(form.travelers),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Travel Style',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _styles
                      .map(
                        (s) => TravelStyleChip(
                          label: s,
                          selected: form.travelStyle == s,
                          onTap: () => ref
                              .read(tripFormProvider.notifier)
                              .setTravelStyle(s),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Budget Range',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<BudgetRange>(
                      value: form.budgetRange,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: BudgetRange.values
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.currency_rupee,
                                    size: 18,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(e.label),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          ref
                              .read(tripFormProvider.notifier)
                              .setBudgetRange(v);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Must-Visit Places',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push('/must-visit'),
                      child: const Text(
                        'Manage',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _mustVisitController,
                  decoration: InputDecoration(
                    hintText: 'Type any place & add',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add_circle,
                          color: AppColors.primary),
                      onPressed: () {
                        ref
                            .read(tripFormProvider.notifier)
                            .addMustVisit(_mustVisitController.text);
                        _mustVisitController.clear();
                      },
                    ),
                  ),
                  onSubmitted: (v) {
                    ref.read(tripFormProvider.notifier).addMustVisit(v);
                    _mustVisitController.clear();
                  },
                ),
                if (form.mustVisitPlaces.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: form.mustVisitPlaces
                        .map(
                          (p) => Chip(
                            label: Text(p),
                            deleteIcon: const Icon(Icons.close, size: 16),
                            onDeleted: () => ref
                                .read(tripFormProvider.notifier)
                                .removeMustVisit(p),
                            backgroundColor: AppColors.softTeal,
                            side: BorderSide.none,
                          ),
                        )
                        .toList(),
                  ),
                ],
                const SizedBox(height: 16),
                const Text(
                  'Suggestions',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                ...suggestions.take(5).map(
                      (s) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text(s, style: const TextStyle(fontSize: 14)),
                        trailing: IconButton(
                          icon: const Icon(Icons.add, color: AppColors.primary),
                          onPressed: () => ref
                              .read(tripFormProvider.notifier)
                              .addMustVisit(s),
                        ),
                      ),
                    ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: PrimaryButton(
                label: 'Generate Itinerary ✨',
                onPressed: form.destination.isEmpty
                    ? null
                    : () async {
                        await ref
                            .read(itineraryProvider.notifier)
                            .generate(form);
                        if (context.mounted) {
                          context.push('/preview');
                        }
                      },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDates(TripPreferences form) async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(
        start: form.startDate,
        end: form.endDate,
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                ),
          ),
          child: child!,
        );
      },
    );
    if (range != null) {
      ref.read(tripFormProvider.notifier).setDates(range.start, range.end);
    }
  }

  Future<void> _pickTravelers(int current) async {
    var value = current;
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModal) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Travelers',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filled(
                        onPressed: () => setModal(() {
                          value = (value - 1).clamp(1, 12);
                        }),
                        icon: const Icon(Icons.remove),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.softTeal,
                          foregroundColor: AppColors.primary,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          '$value',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton.filled(
                        onPressed: () => setModal(() {
                          value = (value + 1).clamp(1, 12);
                        }),
                        icon: const Icon(Icons.add),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    label: 'Done',
                    onPressed: () {
                      ref.read(tripFormProvider.notifier).setTravelers(value);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _FieldCard extends StatelessWidget {
  const _FieldCard({
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final IconData? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SoftShadowCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.softTeal,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null)
            Icon(trailing, color: AppColors.textMuted, size: 20),
        ],
      ),
    );
  }
}
