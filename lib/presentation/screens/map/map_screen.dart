import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../providers/app_providers.dart';
import '../../widgets/common_widgets.dart';

/// Mock map view with route markers (no Google Maps API key required for MVP).
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final itinerary = ref.watch(itineraryProvider).valueOrNull;

    if (itinerary == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Trip Map')),
        body: const Center(child: Text('No itinerary')),
      );
    }

    final days = itinerary.days;
    final selected = _selected.clamp(0, days.length - 1);
    final day = days[selected];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Map'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Stack(
        children: [
          // Stylized mock map background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE8F5E9),
                  Color(0xFFE3F2FD),
                  Color(0xFFF1F8E9),
                ],
              ),
            ),
            child: CustomPaint(
              painter: _MapGridPainter(),
              child: Stack(
                children: [
                  // Route line
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _RoutePainter(
                        count: days.length,
                        selected: selected,
                      ),
                    ),
                  ),
                  ...List.generate(days.length, (i) {
                    final pos = _markerPos(i, days.length);
                    final isSelected = i == selected;
                    return Positioned(
                      left: pos.$1,
                      top: pos.$2,
                      child: GestureDetector(
                        onTap: () => setState(() => _selected = i),
                        child: Column(
                          children: [
                            Container(
                              width: isSelected ? 36 : 30,
                              height: isSelected ? 36 : 30,
                              decoration: BoxDecoration(
                                color: i == 0
                                    ? AppColors.success
                                    : i == days.length - 1
                                        ? AppColors.danger
                                        : AppColors.mustVisit,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${i + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Day ${i + 1}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          Positioned(
            right: 16,
            top: 16,
            child: Column(
              children: [
                _MapFab(icon: Icons.my_location, onTap: () {}),
                const SizedBox(height: 8),
                _MapFab(icon: Icons.add, onTap: () {}),
                const SizedBox(height: 8),
                _MapFab(icon: Icons.remove, onTap: () {}),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: SoftShadowCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Day ${day.dayNumber}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          day.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        if (day.distanceFromPreviousKm > 0)
                          Text(
                            'Distance from previous day: ${day.distanceFromPreviousKm.toStringAsFixed(0)} km',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  AppNetworkImage(
                    url: itinerary.imageUrl,
                    width: 64,
                    height: 64,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  (double, double) _markerPos(int i, int total) {
    final t = total <= 1 ? 0.0 : i / (total - 1);
    final left = 40.0 + t * 240;
    final top = 80.0 + (i.isEven ? 40.0 : 140.0) + (i * 12);
    return (left, top);
  }
}

class _MapFab extends StatelessWidget {
  const _MapFab({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 20, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 1;
    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RoutePainter extends CustomPainter {
  _RoutePainter({required this.count, required this.selected});

  final int count;
  final int selected;

  @override
  void paint(Canvas canvas, Size size) {
    if (count < 2) return;
    final path = Path();
    for (var i = 0; i < count; i++) {
      final t = i / (count - 1);
      final x = 55.0 + t * 240;
      final y = 95.0 + (i.isEven ? 40.0 : 140.0) + (i * 12);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final paint = Paint()
      ..color = const Color(0xFF3B82F6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _RoutePainter oldDelegate) =>
      oldDelegate.selected != selected || oldDelegate.count != count;
}
