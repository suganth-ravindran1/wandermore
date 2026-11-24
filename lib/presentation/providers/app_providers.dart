import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/destination.dart';
import '../../data/models/itinerary.dart';
import '../../data/models/trip_preferences.dart';
import '../../data/repositories/destination_repository.dart';
import '../../data/services/mock_ai_service.dart';

final destinationRepositoryProvider = Provider<DestinationRepository>((ref) {
  return DestinationRepository();
});

final mockAiServiceProvider = Provider<MockAiService>((ref) {
  return MockAiService();
});

class ExploreState {
  const ExploreState({
    this.isInternational = false,
    this.selectedCategory = 'Adventure',
    this.searchQuery = '',
  });

  final bool isInternational;
  final String selectedCategory;
  final String searchQuery;

  ExploreState copyWith({
    bool? isInternational,
    String? selectedCategory,
    String? searchQuery,
  }) {
    return ExploreState(
      isInternational: isInternational ?? this.isInternational,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ExploreNotifier extends StateNotifier<ExploreState> {
  ExploreNotifier() : super(const ExploreState());

  void setInternational(bool value) {
    state = state.copyWith(isInternational: value);
  }

  void setCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
}

final exploreProvider =
    StateNotifierProvider<ExploreNotifier, ExploreState>((ref) {
  return ExploreNotifier();
});

final suggestedDestinationsProvider = Provider<List<Destination>>((ref) {
  final explore = ref.watch(exploreProvider);
  final repo = ref.watch(destinationRepositoryProvider);
  return repo.byCategory(
    explore.selectedCategory,
    international: explore.isInternational,
  );
});

final trendingDestinationsProvider = Provider<List<Destination>>((ref) {
  final explore = ref.watch(exploreProvider);
  final repo = ref.watch(destinationRepositoryProvider);
  return repo.trending(international: explore.isInternational);
});

class TripFormNotifier extends StateNotifier<TripPreferences> {
  TripFormNotifier()
      : super(
          TripPreferences(
            destination: '',
            startDate: DateTime.now().add(const Duration(days: 14)),
            endDate: DateTime.now().add(const Duration(days: 19)),
            travelers: 2,
            travelStyle: 'Adventure',
            budgetRange: BudgetRange.medium,
          ),
        );

  void initFromDestination(Destination destination) {
    final start = DateTime.now().add(const Duration(days: 14));
    final end = start.add(Duration(days: destination.days - 1));
    state = TripPreferences(
      destination: destination.name,
      startDate: start,
      endDate: end,
      travelers: 2,
      travelStyle: destination.category,
      budgetRange: BudgetRange.medium,
      isInternational: destination.isInternational,
      mustVisitPlaces: [],
    );
  }

  void setDestination(String value) {
    state = state.copyWith(destination: value);
  }

  void setDates(DateTime start, DateTime end) {
    state = state.copyWith(startDate: start, endDate: end);
  }

  void setTravelers(int count) {
    state = state.copyWith(travelers: count.clamp(1, 12));
  }

  void setTravelStyle(String style) {
    state = state.copyWith(travelStyle: style);
  }

  void setBudgetRange(BudgetRange range) {
    state = state.copyWith(budgetRange: range);
  }

  void addMustVisit(String place) {
    final cleaned = place.trim();
    if (cleaned.isEmpty) return;
    if (state.mustVisitPlaces
        .any((p) => p.toLowerCase() == cleaned.toLowerCase())) {
      return;
    }
    state = state.copyWith(
      mustVisitPlaces: [...state.mustVisitPlaces, cleaned],
    );
  }

  void removeMustVisit(String place) {
    state = state.copyWith(
      mustVisitPlaces:
          state.mustVisitPlaces.where((p) => p != place).toList(),
    );
  }

  void setMustVisitPlaces(List<String> places) {
    state = state.copyWith(mustVisitPlaces: places);
  }
}

final tripFormProvider =
    StateNotifierProvider<TripFormNotifier, TripPreferences>((ref) {
  return TripFormNotifier();
});

class ItineraryNotifier extends StateNotifier<AsyncValue<Itinerary?>> {
  ItineraryNotifier(this._ai) : super(const AsyncValue.data(null));

  final MockAiService _ai;

  Future<void> generate(TripPreferences prefs) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _ai.generateItinerary(prefs));
  }

  void save() {
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncValue.data(current.copyWith(saved: true));
    }
  }

  void updateTitle(String title) {
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncValue.data(current.copyWith(title: title));
    }
  }

  void clear() {
    state = const AsyncValue.data(null);
  }
}

final itineraryProvider =
    StateNotifierProvider<ItineraryNotifier, AsyncValue<Itinerary?>>((ref) {
  return ItineraryNotifier(ref.watch(mockAiServiceProvider));
});

final selectedDayProvider = StateProvider<int>((ref) => 0);

final favoriteIdsProvider =
    StateNotifierProvider<_FavoritesNotifier, Set<String>>((ref) {
  return _FavoritesNotifier();
});

class _FavoritesNotifier extends StateNotifier<Set<String>> {
  _FavoritesNotifier() : super({});

  void toggle(String id) {
    if (state.contains(id)) {
      state = {...state}..remove(id);
    } else {
      state = {...state, id};
    }
  }

  bool isFavorite(String id) => state.contains(id);
}
