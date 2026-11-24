/// Reusable Unsplash / Picsum destination images for the MVP.
class DummyImages {
  DummyImages._();

  static const String heroHiker =
      'https://images.unsplash.com/photo-1551632811-561732d1e306?w=800&q=80';
  static const String landingHero =
      'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=900&q=80';
  static const String suitcase =
      'https://images.unsplash.com/photo-1565026057447-bc90a3dceb87?w=400&q=80';

  static const List<String> destinations = [
    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=600&q=80', // mountains
    'https://images.unsplash.com/photo-1544735716-392fe2489ffa?w=600&q=80', // ladakh-ish
    'https://images.unsplash.com/photo-1596422846543-75c6fc764821?w=600&q=80', // singapore
    'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?w=600&q=80', // meghalaya
    'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=600&q=80', // lake
    'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=600&q=80', // travel
    'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=600&q=80', // suitcase road
    'https://images.unsplash.com/photo-1530789253388-582c481c54b0?w=600&q=80', // beach
    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600&q=80', // tropical
    'https://images.unsplash.com/photo-1516483638261-f4dbaf036963?w=600&q=80', // italy hills
    'https://images.unsplash.com/photo-1528127269322-539801943592?w=600&q=80', // vietnam
    'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=600&q=80', // japan
  ];

  static const List<String> places = [
    'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?w=400&q=80',
    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&q=80',
    'https://images.unsplash.com/photo-1544735716-392fe2489ffa?w=400&q=80',
    'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=400&q=80',
    'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=400&q=80',
    'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=400&q=80',
  ];

  static String forDestination(String name) {
    final hash = name.toLowerCase().codeUnits.fold(0, (a, b) => a + b);
    return destinations[hash % destinations.length];
  }

  static String forPlace(String name, [int index = 0]) {
    final hash = name.toLowerCase().codeUnits.fold(index, (a, b) => a + b);
    return places[hash % places.length];
  }
}
