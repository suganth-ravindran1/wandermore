import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/dummy_images.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/destination.dart';
import '../../providers/app_providers.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/destination_cards.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  List<Destination> _results = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    final explore = ref.read(exploreProvider);
    final repo = ref.read(destinationRepositoryProvider);
    setState(() {
      _results = repo.search(
        value,
        international: explore.isInternational,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: TextField(
              controller: _controller,
              autofocus: true,
              onChanged: _onChanged,
              onSubmitted: _onChanged,
              decoration: InputDecoration(
                hintText: 'Search country, city or place...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _controller.clear();
                          setState(() => _results = []);
                        },
                      ),
              ),
            ),
          ),
          Expanded(
            child: _controller.text.trim().isEmpty
                ? const Center(
                    child: Text(
                      'Search any place — known or unknown.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      if (_results.isNotEmpty) ...[
                        SoftShadowCard(
                          padding: const EdgeInsets.all(14),
                          margin: const EdgeInsets.only(bottom: 20),
                          onTap: () => _select(_results.first),
                          child: Row(
                            children: [
                              AppNetworkImage(
                                url: _results.first.imageUrl,
                                width: 64,
                                height: 64,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${_results.first.name}, ${_results.first.region}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.softTeal,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        _results.first.id.startsWith('custom_')
                                            ? 'New Place'
                                            : 'Popular',
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                        ),
                        Text(
                          'Popular in ${_results.first.name}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ..._placeHints(_results.first.name).map(
                          (p) => PlaceListTile(
                            title: p.$1,
                            subtitle: p.$2,
                            imageUrl: DummyImages.forPlace(p.$1),
                            onTap: () => _select(
                              Destination.unknown(
                                _results.first.name,
                                international: _results.first.isInternational,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  List<(String, String)> _placeHints(String dest) {
    final repo = ref.read(destinationRepositoryProvider);
    return repo
        .placeSuggestions(dest, '')
        .take(4)
        .map((p) => (p, 'Top attraction near $dest'))
        .toList();
  }

  void _select(Destination d) {
    ref.read(tripFormProvider.notifier).initFromDestination(d);
    context.push('/create');
  }
}
