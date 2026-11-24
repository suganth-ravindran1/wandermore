import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../providers/app_providers.dart';
import '../../widgets/common_widgets.dart';

class MustVisitScreen extends ConsumerStatefulWidget {
  const MustVisitScreen({super.key});

  @override
  ConsumerState<MustVisitScreen> createState() => _MustVisitScreenState();
}

class _MustVisitScreenState extends ConsumerState<MustVisitScreen> {
  final _controller = TextEditingController();
  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dest = ref.read(tripFormProvider).destination;
      setState(() {
        _suggestions = ref
            .read(destinationRepositoryProvider)
            .placeSuggestions(dest, '');
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search(String q) {
    final dest = ref.read(tripFormProvider).destination;
    setState(() {
      _suggestions = ref
          .read(destinationRepositoryProvider)
          .placeSuggestions(dest, q);
    });
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(tripFormProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Must-Visit Places'),
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
              onChanged: _search,
              decoration: const InputDecoration(
                hintText: 'Search attractions, places...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                if (_suggestions.isNotEmpty) ...[
                  const Text(
                    'Suggestions',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._suggestions.map(
                    (s) {
                      final added = form.mustVisitPlaces
                          .any((p) => p.toLowerCase() == s.toLowerCase());
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(s),
                        subtitle: Text(
                          form.destination,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            added ? Icons.check_circle : Icons.add_circle_outline,
                            color: AppColors.primary,
                          ),
                          onPressed: added
                              ? null
                              : () => ref
                                  .read(tripFormProvider.notifier)
                                  .addMustVisit(s),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                const Text(
                  'Your Must-Visit List',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                if (form.mustVisitPlaces.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      'No places added yet. Type any place name — even unknown ones.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                else
                  ...form.mustVisitPlaces.map(
                    (p) => SoftShadowCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.place, color: AppColors.mustVisit),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              p,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => ref
                                .read(tripFormProvider.notifier)
                                .removeMustVisit(p),
                            icon: const Icon(Icons.close, color: AppColors.danger),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceBlue,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: AppColors.primary),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'AI will prioritize these places in your itinerary.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: PrimaryButton(
                label: 'Add to Itinerary',
                onPressed: () => context.pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
