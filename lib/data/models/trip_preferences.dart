enum BudgetRange { budget, medium, luxury }

extension BudgetRangeX on BudgetRange {
  String get label {
    switch (this) {
      case BudgetRange.budget:
        return 'Budget Friendly';
      case BudgetRange.medium:
        return 'Medium Range';
      case BudgetRange.luxury:
        return 'Luxury';
    }
  }

  double get multiplier {
    switch (this) {
      case BudgetRange.budget:
        return 0.75;
      case BudgetRange.medium:
        return 1.0;
      case BudgetRange.luxury:
        return 1.6;
    }
  }
}

class TripPreferences {
  TripPreferences({
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.travelers,
    required this.travelStyle,
    required this.budgetRange,
    List<String>? mustVisitPlaces,
    this.isInternational = false,
  }) : mustVisitPlaces = mustVisitPlaces ?? [];

  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final int travelers;
  final String travelStyle;
  final BudgetRange budgetRange;
  final List<String> mustVisitPlaces;
  final bool isInternational;

  int get durationDays => endDate.difference(startDate).inDays + 1;

  TripPreferences copyWith({
    String? destination,
    DateTime? startDate,
    DateTime? endDate,
    int? travelers,
    String? travelStyle,
    BudgetRange? budgetRange,
    List<String>? mustVisitPlaces,
    bool? isInternational,
  }) {
    return TripPreferences(
      destination: destination ?? this.destination,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      travelers: travelers ?? this.travelers,
      travelStyle: travelStyle ?? this.travelStyle,
      budgetRange: budgetRange ?? this.budgetRange,
      mustVisitPlaces: mustVisitPlaces ?? this.mustVisitPlaces,
      isInternational: isInternational ?? this.isInternational,
    );
  }
}
