import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/dummy_images.dart';
import '../models/budget.dart';
import '../models/itinerary.dart';
import '../models/trip_preferences.dart';

/// Mock AI service — generates itinerary JSON for ANY destination.
class MockAiService {
  MockAiService();

  final _uuid = const Uuid();
  final _dateFmt = DateFormat('d MMM');
  final _dayFmt = DateFormat('EEE, d MMM');

  Future<Itinerary> generateItinerary(TripPreferences input) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final daysCount = input.durationDays.clamp(2, 10);
    final must = input.mustVisitPlaces;
    final dest = input.destination;
    final basePerDay = input.isInternational ? 7500 : 3200;
    final totalBase =
        (basePerDay * daysCount * input.travelers * input.budgetRange.multiplier)
            .round();

    final days = <DayPlan>[];
    for (var i = 0; i < daysCount; i++) {
      final date = input.startDate.add(Duration(days: i));
      final mustForDay = i < must.length ? must[i] : null;
      final isMustDay = mustForDay != null;

      days.add(
        DayPlan(
          dayNumber: i + 1,
          dateLabel: _dayFmt.format(date),
          title: _dayTitle(dest, i, daysCount, mustForDay),
          summary: _daySummary(dest, i, daysCount, mustForDay),
          isMustVisitDay: isMustDay,
          stayName: '$dest View Homestay',
          lat: 27.3 + (i * 0.08),
          lng: 88.6 + (i * 0.05),
          distanceFromPreviousKm: i == 0 ? 0 : 30.0 + (i * 10),
          activities: _activitiesForDay(
            dest: dest,
            dayIndex: i,
            daysCount: daysCount,
            mustPlace: mustForDay,
            date: date,
          ),
        ),
      );
    }

    final categories = _budgetCategories(totalBase);
    final budget = BudgetBreakdown(
      total: categories.fold(0, (s, c) => s + c.amount),
      days: daysCount,
      categories: categories,
    );

    final json = <String, dynamic>{
      'id': _uuid.v4(),
      'title': '$dest ${input.travelStyle} Trip',
      'destination': dest,
      'imageUrl': DummyImages.forDestination(dest),
      'startDate': input.startDate.toIso8601String(),
      'endDate': input.endDate.toIso8601String(),
      'travelers': input.travelers,
      'travelStyle': input.travelStyle,
      'budgetLabel': input.budgetRange.label,
      'days': days.map((d) => d.toJson()).toList(),
      'budget': budget.toJson(),
      'saved': false,
    };

    return Itinerary.fromJson(json);
  }

  String _dayTitle(String dest, int i, int total, String? must) {
    if (i == 0) return '$dest Arrival & Local Sightseeing';
    if (i == total - 1) return 'Leisure Morning & Departure';
    if (must != null) return must;
    final titles = [
      'Nature Trails & Viewpoints',
      'Culture & Local Flavors',
      'Adventure Day Out',
      'Hidden Gems Exploration',
      'Scenic Drive & Lakes',
    ];
    return titles[i % titles.length];
  }

  String _daySummary(String dest, int i, int total, String? must) {
    if (must != null) return 'Prioritized: $must plus nearby highlights.';
    if (i == 0) return 'Arrival in $dest, check-in & easy local sightseeing.';
    if (i == total - 1) return 'Free time, souvenirs, and departure.';
    return 'Curated ${['adventure', 'nature', 'culture', 'food'][i % 4]} experiences around $dest.';
  }

  List<ActivityItem> _activitiesForDay({
    required String dest,
    required int dayIndex,
    required int daysCount,
    required String? mustPlace,
    required DateTime date,
  }) {
    final items = <ActivityItem>[
      ActivityItem(
        time: '07:30 AM',
        title: 'Breakfast',
        description: 'Local breakfast at your stay.',
      ),
    ];

    if (dayIndex == 0) {
      items.addAll([
        ActivityItem(
          time: '10:00 AM',
          title: 'Arrival & Check-in',
          description: 'Settle into your stay and freshen up.',
          imageUrl: DummyImages.forPlace(dest, 0),
        ),
        ActivityItem(
          time: '02:00 PM',
          title: '$dest City Walk',
          description: 'Explore markets and local streets.',
          imageUrl: DummyImages.forPlace(dest, 1),
          travelTimeMinutes: 20,
        ),
        ActivityItem(
          time: '06:30 PM',
          title: 'Sunset Viewpoint',
          description: 'Catch golden-hour views.',
          imageUrl: DummyImages.forPlace(dest, 2),
          travelTimeMinutes: 25,
        ),
      ]);
    } else if (dayIndex == daysCount - 1) {
      items.addAll([
        ActivityItem(
          time: '09:00 AM',
          title: 'Souvenir Shopping',
          description: 'Pick up local crafts and snacks.',
        ),
        ActivityItem(
          time: '12:00 PM',
          title: 'Checkout & Departure',
          description: 'Head to airport / station.',
          travelTimeMinutes: 45,
        ),
      ]);
    } else {
      final highlight = mustPlace ?? '$dest Highlight ${dayIndex + 1}';
      items.addAll([
        ActivityItem(
          time: '09:00 AM',
          title: highlight,
          description: mustPlace != null
              ? 'AI prioritized must-visit experience.'
              : 'Top-rated attraction for the day.',
          isMustVisit: mustPlace != null,
          imageUrl: DummyImages.forPlace(highlight, dayIndex),
          travelTimeMinutes: 35,
        ),
        ActivityItem(
          time: '01:00 PM',
          title: 'Local Lunch',
          description: 'Regional specialties nearby.',
        ),
        ActivityItem(
          time: '03:30 PM',
          title: 'Secondary Spot',
          description: 'Nearby viewpoint or cultural stop.',
          imageUrl: DummyImages.forPlace(dest, dayIndex + 3),
          travelTimeMinutes: 20,
        ),
        ActivityItem(
          time: '07:00 PM',
          title: 'Dinner & Rest',
          description: 'Evening meal and downtime.',
        ),
      ]);
    }

    return items;
  }

  List<BudgetCategory> _budgetCategories(int total) {
    final weights = <String, double>{
      'Accommodation': 0.33,
      'Food': 0.22,
      'Transport': 0.18,
      'Permits & Tickets': 0.08,
      'Activities': 0.10,
      'Shopping': 0.05,
      'Emergency Buffer': 0.04,
    };
    final icons = {
      'Accommodation': 'bed',
      'Food': 'restaurant',
      'Transport': 'directions_car',
      'Permits & Tickets': 'confirmation_number',
      'Activities': 'hiking',
      'Shopping': 'shopping_bag',
      'Emergency Buffer': 'health_and_safety',
    };

    var allocated = 0;
    final list = <BudgetCategory>[];
    final entries = weights.entries.toList();
    for (var i = 0; i < entries.length; i++) {
      final e = entries[i];
      final amount = i == entries.length - 1
          ? total - allocated
          : (total * e.value).round();
      allocated += amount;
      list.add(
        BudgetCategory(
          name: e.key,
          amount: amount,
          iconName: icons[e.key]!,
        ),
      );
    }
    return list;
  }

  String formatRange(DateTime start, DateTime end) =>
      '${_dateFmt.format(start)} - ${_dateFmt.format(end)} ${end.year}';
}
