import '../../core/constants/dummy_images.dart';

class Destination {
  const Destination({
    required this.id,
    required this.name,
    required this.region,
    required this.category,
    required this.days,
    required this.price,
    required this.imageUrl,
    this.isInternational = false,
    this.description = '',
  });

  final String id;
  final String name;
  final String region;
  final String category;
  final int days;
  final int price;
  final String imageUrl;
  final bool isInternational;
  final String description;

  String get priceLabel => '₹${_format(price)}';
  String get metaLabel => '$days Days • $priceLabel';

  static String _format(int n) {
    final s = n.toString();
    if (s.length <= 3) return s;
    final buf = StringBuffer();
    final rem = s.length % 3;
    if (rem > 0) buf.write(s.substring(0, rem));
    for (var i = rem; i < s.length; i += 3) {
      if (buf.isNotEmpty) buf.write(',');
      buf.write(s.substring(i, i + 3));
    }
    return buf.toString();
  }

  factory Destination.unknown(String query, {bool international = false}) {
    final cleaned = query.trim();
    return Destination(
      id: 'custom_${cleaned.toLowerCase().replaceAll(' ', '_')}',
      name: cleaned,
      region: international ? 'International' : 'India',
      category: 'Adventure',
      days: 5,
      price: international ? 45000 : 18500,
      imageUrl: DummyImages.forDestination(cleaned),
      isInternational: international,
      description: 'Discover $cleaned with AI-crafted plans.',
    );
  }
}
