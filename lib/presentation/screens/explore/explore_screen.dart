import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/dummy_images.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/destination.dart';
import '../../providers/app_providers.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/chips.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/destination_cards.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  static const _categories = [
    ('Adventure', Icons.terrain),
    ('Beach', Icons.beach_access_outlined),
    ('Nature', Icons.forest_outlined),
    ('Culture', Icons.temple_buddhist_outlined),
    ('Food', Icons.restaurant_outlined),
    ('Nightlife', Icons.nightlife),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final explore = ref.watch(exploreProvider);
    final suggested = ref.watch(suggestedDestinationsProvider);
    final trending = ref.watch(trendingDestinationsProvider);
    final favorites = ref.watch(favoriteIdsProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _Header()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: IntlDomesticToggle(
                  isInternational: explore.isInternational,
                  onChanged: (v) =>
                      ref.read(exploreProvider.notifier).setInternational(v),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: _SearchBar(
                  onTap: () => context.push('/search'),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: SectionHeader(
                  title: 'Quick Picks',
                  subtitle: 'What excites you?',
                  actionLabel: 'See All',
                  onAction: () {},
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, i) {
                    final (label, icon) = _categories[i];
                    return CategoryChip(
                      label: label,
                      icon: icon,
                      selected: explore.selectedCategory == label,
                      onTap: () => ref
                          .read(exploreProvider.notifier)
                          .setCategory(label),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: SectionHeader(
                  title: 'Suggested for You',
                  actionLabel: 'See All',
                  onAction: () {},
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 280,
                child: suggested.isEmpty
                    ? const Center(
                        child: Text(
                          'No destinations in this category',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: suggested.length,
                        itemBuilder: (context, i) {
                          final d = suggested[i];
                          return DestinationCard(
                            destination: d,
                            isFavorite: favorites.contains(d.id),
                            onFavorite: () => ref
                                .read(favoriteIdsProvider.notifier)
                                .toggle(d.id),
                            onTap: () => _openCreate(context, ref, d),
                          );
                        },
                      ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: SectionHeader(
                  title: 'Trending Now',
                  actionLabel: 'See All',
                  onAction: () {},
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 84,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: trending.length,
                  itemBuilder: (context, i) {
                    final d = trending[i];
                    return TrendingCard(
                      destination: d,
                      onTap: () => _openCreate(context, ref, d),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                child: _SurpriseBanner(
                  onTap: () {
                    final pool = explore.isInternational
                        ? suggested.isNotEmpty
                            ? suggested
                            : trending
                        : trending;
                    if (pool.isEmpty) return;
                    final pick = pool[
                        DateTime.now().millisecond % pool.length];
                    _openCreate(context, ref, pick);
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }

  void _openCreate(BuildContext context, WidgetRef ref, Destination d) {
    ref.read(tripFormProvider.notifier).initFromDestination(d);
    context.push('/create');
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 12, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Where will your next\nadventure be?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Plan smarter. Travel better.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none_rounded),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.danger,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Row(
          children: [
            Icon(Icons.search, color: AppColors.textMuted),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Search country, city or place...',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                ),
              ),
            ),
            Icon(Icons.tune, color: AppColors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}

class _SurpriseBanner extends StatelessWidget {
  const _SurpriseBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.softTeal,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Not sure where to go? Let Trailblazer AI suggest the perfect trip for you.',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 42,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Surprise Me ✨'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AppNetworkImage(
              url: DummyImages.suitcase,
              width: 72,
              height: 72,
            ),
          ),
        ],
      ),
    );
  }
}
