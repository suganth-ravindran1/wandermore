import '../../core/constants/dummy_images.dart';
import 'budget.dart';

class ActivityItem {
  const ActivityItem({
    required this.time,
    required this.title,
    required this.description,
    this.isMustVisit = false,
    this.imageUrl,
    this.travelTimeMinutes,
  });

  final String time;
  final String title;
  final String description;
  final bool isMustVisit;
  final String? imageUrl;
  final int? travelTimeMinutes;

  factory ActivityItem.fromJson(Map<String, dynamic> json) {
    return ActivityItem(
      time: json['time'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      isMustVisit: json['isMustVisit'] as bool? ?? false,
      imageUrl: json['imageUrl'] as String?,
      travelTimeMinutes: json['travelTimeMinutes'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'time': time,
        'title': title,
        'description': description,
        'isMustVisit': isMustVisit,
        'imageUrl': imageUrl,
        'travelTimeMinutes': travelTimeMinutes,
      };
}

class DayPlan {
  const DayPlan({
    required this.dayNumber,
    required this.dateLabel,
    required this.title,
    required this.summary,
    required this.activities,
    this.isMustVisitDay = false,
    this.stayName,
    this.lat = 0,
    this.lng = 0,
    this.distanceFromPreviousKm = 0,
  });

  final int dayNumber;
  final String dateLabel;
  final String title;
  final String summary;
  final List<ActivityItem> activities;
  final bool isMustVisitDay;
  final String? stayName;
  final double lat;
  final double lng;
  final double distanceFromPreviousKm;

  factory DayPlan.fromJson(Map<String, dynamic> json) {
    return DayPlan(
      dayNumber: json['dayNumber'] as int,
      dateLabel: json['dateLabel'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String? ?? '',
      isMustVisitDay: json['isMustVisitDay'] as bool? ?? false,
      stayName: json['stayName'] as String?,
      lat: (json['lat'] as num?)?.toDouble() ?? 0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0,
      distanceFromPreviousKm:
          (json['distanceFromPreviousKm'] as num?)?.toDouble() ?? 0,
      activities: (json['activities'] as List)
          .map((e) => ActivityItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'dayNumber': dayNumber,
        'dateLabel': dateLabel,
        'title': title,
        'summary': summary,
        'isMustVisitDay': isMustVisitDay,
        'stayName': stayName,
        'lat': lat,
        'lng': lng,
        'distanceFromPreviousKm': distanceFromPreviousKm,
        'activities': activities.map((e) => e.toJson()).toList(),
      };
}

class Itinerary {
  const Itinerary({
    required this.id,
    required this.title,
    required this.destination,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.travelers,
    required this.travelStyle,
    required this.budgetLabel,
    required this.days,
    required this.budget,
    this.saved = false,
  });

  final String id;
  final String title;
  final String destination;
  final String imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final int travelers;
  final String travelStyle;
  final String budgetLabel;
  final List<DayPlan> days;
  final BudgetBreakdown budget;
  final bool saved;

  int get durationDays => days.length;

  String get travelersLabel =>
      travelers == 1 ? 'Solo' : '$travelers Adults';

  String get metaLine =>
      '$durationDays Days • $travelersLabel • $travelStyle';

  Itinerary copyWith({bool? saved, String? title}) {
    return Itinerary(
      id: id,
      title: title ?? this.title,
      destination: destination,
      imageUrl: imageUrl,
      startDate: startDate,
      endDate: endDate,
      travelers: travelers,
      travelStyle: travelStyle,
      budgetLabel: budgetLabel,
      days: days,
      budget: budget,
      saved: saved ?? this.saved,
    );
  }

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      id: json['id'] as String,
      title: json['title'] as String,
      destination: json['destination'] as String,
      imageUrl: json['imageUrl'] as String? ??
          DummyImages.forDestination(json['destination'] as String),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      travelers: json['travelers'] as int,
      travelStyle: json['travelStyle'] as String,
      budgetLabel: json['budgetLabel'] as String,
      days: (json['days'] as List)
          .map((e) => DayPlan.fromJson(e as Map<String, dynamic>))
          .toList(),
      budget: BudgetBreakdown.fromJson(
        json['budget'] as Map<String, dynamic>,
      ),
      saved: json['saved'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'destination': destination,
        'imageUrl': imageUrl,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'travelers': travelers,
        'travelStyle': travelStyle,
        'budgetLabel': budgetLabel,
        'days': days.map((e) => e.toJson()).toList(),
        'budget': budget.toJson(),
        'saved': saved,
      };
}
