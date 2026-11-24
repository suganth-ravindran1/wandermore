import '../../core/constants/dummy_images.dart';
import '../models/destination.dart';

class DestinationRepository {
  static final List<Destination> _seed = [
    Destination(
      id: 'sikkim',
      name: 'Sikkim',
      region: 'Northeast India',
      category: 'Adventure',
      days: 6,
      price: 18300,
      imageUrl: DummyImages.destinations[0],
      description: 'Mountains, monasteries & alpine lakes.',
    ),
    Destination(
      id: 'ladakh',
      name: 'Ladakh',
      region: 'Jammu & Kashmir',
      category: 'Adventure',
      days: 6,
      price: 18500,
      imageUrl: DummyImages.destinations[1],
      description: 'High-altitude deserts and epic road trips.',
    ),
    Destination(
      id: 'meghalaya',
      name: 'Meghalaya',
      region: 'Northeast India',
      category: 'Nature',
      days: 5,
      price: 16800,
      imageUrl: DummyImages.destinations[3],
      description: 'Living root bridges and cascading waterfalls.',
    ),
    Destination(
      id: 'goa',
      name: 'Goa',
      region: 'West India',
      category: 'Beach',
      days: 4,
      price: 12500,
      imageUrl: DummyImages.destinations[7],
      description: 'Sun, sand, and coastal vibes.',
    ),
    Destination(
      id: 'kerala',
      name: 'Kerala',
      region: 'South India',
      category: 'Nature',
      days: 5,
      price: 15500,
      imageUrl: DummyImages.destinations[4],
      description: 'Backwaters, tea hills, and Ayurveda.',
    ),
    Destination(
      id: 'rajasthan',
      name: 'Rajasthan',
      region: 'North India',
      category: 'Culture',
      days: 7,
      price: 22000,
      imageUrl: DummyImages.destinations[5],
      description: 'Palaces, deserts, and royal heritage.',
    ),
    Destination(
      id: 'singapore',
      name: 'Singapore',
      region: 'Southeast Asia',
      category: 'Culture',
      days: 4,
      price: 29500,
      imageUrl: DummyImages.destinations[2],
      isInternational: true,
      description: 'Gardens, food streets, and futuristic skyline.',
    ),
    Destination(
      id: 'bali',
      name: 'Bali',
      region: 'Indonesia',
      category: 'Beach',
      days: 5,
      price: 32000,
      imageUrl: DummyImages.destinations[8],
      isInternational: true,
      description: 'Temples, beaches, and rice terraces.',
    ),
    Destination(
      id: 'tokyo',
      name: 'Tokyo',
      region: 'Japan',
      category: 'Culture',
      days: 6,
      price: 55000,
      imageUrl: DummyImages.destinations[11],
      isInternational: true,
      description: 'Neon nights and timeless traditions.',
    ),
    Destination(
      id: 'dubai',
      name: 'Dubai',
      region: 'UAE',
      category: 'Luxury',
      days: 4,
      price: 42000,
      imageUrl: DummyImages.destinations[9],
      isInternational: true,
      description: 'Desert luxury and iconic architecture.',
    ),
  ];

  List<Destination> all({bool? international}) {
    if (international == null) return List.unmodifiable(_seed);
    return _seed.where((d) => d.isInternational == international).toList();
  }

  List<Destination> trending({bool international = false}) {
    final list = all(international: international);
    return list.take(4).toList();
  }

  List<Destination> byCategory(String category, {bool international = false}) {
    final list = all(international: international);
    if (category == 'All') return list;
    return list
        .where((d) => d.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  /// Supports ANY place — known destinations + free-text unknown places.
  List<Destination> search(String query, {bool? international}) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];

    final pool = international == null
        ? _seed
        : _seed.where((d) => d.isInternational == international).toList();

    final matches = pool
        .where(
          (d) =>
              d.name.toLowerCase().contains(q) ||
              d.region.toLowerCase().contains(q) ||
              d.category.toLowerCase().contains(q),
        )
        .toList();

    if (matches.isEmpty) {
      return [
        Destination.unknown(query, international: international ?? false),
      ];
    }
    return matches;
  }

  Destination? byId(String id) {
    try {
      return _seed.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  List<String> placeSuggestions(String destination, String query) {
    final base = _popularPlacesFor(destination);
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return base;
    final filtered = base.where((p) => p.toLowerCase().contains(q)).toList();
    if (filtered.isEmpty) return [query.trim()];
    if (!filtered.any((p) => p.toLowerCase() == q)) {
      return [query.trim(), ...filtered];
    }
    return filtered;
  }

  List<String> _popularPlacesFor(String destination) {
    final key = destination.toLowerCase();
    if (key.contains('meghalaya')) {
      return [
        'Living Root Bridge',
        'Shillong Peak',
        'Cherrapunji',
        'Dawki River',
        'Umiam Lake',
        'Double Decker Bridge',
      ];
    }
    if (key.contains('sikkim')) {
      return [
        'Tsomgo Lake',
        'Nathula Pass',
        'Yumthang Valley',
        'Rumtek Monastery',
        'Gangtok MG Marg',
        'Baba Mandir',
      ];
    }
    if (key.contains('ladakh')) {
      return [
        'Pangong Lake',
        'Nubra Valley',
        'Magnetic Hill',
        'Leh Palace',
        'Khardung La',
      ];
    }
    if (key.contains('singapore')) {
      return [
        'Universal Studios Singapore',
        'Gardens by the Bay',
        'Marina Bay Sands',
        'Sentosa Island',
        'Wings of Time',
      ];
    }
    // Generic suggestions for unknown destinations
    return [
      '$destination City Center',
      '$destination Old Town',
      '$destination Viewpoint',
      '$destination Local Market',
      '$destination Nature Trail',
      '$destination Cultural Museum',
    ];
  }
}
