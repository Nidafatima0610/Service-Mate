import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:service_mate/core/constants/app_colors.dart';
import 'package:service_mate/features/services/presentation/providers/service_providers.dart';
import 'package:service_mate/features/services/presentation/widgets/category_chip.dart';
import 'package:service_mate/features/services/presentation/widgets/service_card.dart';
import 'package:service_mate/shared/widgets/empty_state_view.dart';
import 'package:service_mate/shared/widgets/error_state_view.dart';

class ServiceCatalogScreen extends ConsumerStatefulWidget {
  final String? initialCategory;

  const ServiceCatalogScreen({super.key, this.initialCategory});

  @override
  ConsumerState<ServiceCatalogScreen> createState() => _ServiceCatalogScreenState();
}

class _ServiceCatalogScreenState extends ConsumerState<ServiceCatalogScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null && widget.initialCategory!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(selectedCategoryFilterProvider.notifier).setCategory(widget.initialCategory!);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryFilterProvider);
    final servicesAsync = ref.watch(catalogServicesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Services Catalog'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                ref.read(searchQueryFilterProvider.notifier).setQuery(query);
              },
              decoration: InputDecoration(
                hintText: 'Search by service name, provider...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.midnightNavy),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchQueryFilterProvider.notifier).setQuery('');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          // Categories Horizontal Filter Bar
          categoriesAsync.when(
            data: (categories) => SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length + 1,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return CategoryFilterChipWidget(
                      isAll: true,
                      isSelected: selectedCategory == 'all',
                      onTap: () {
                        ref.read(selectedCategoryFilterProvider.notifier).setCategory('all');
                      },
                    );
                  }
                  final category = categories[index - 1];
                  return CategoryFilterChipWidget(
                    category: category,
                    isSelected: selectedCategory == category.id,
                    onTap: () {
                      ref.read(selectedCategoryFilterProvider.notifier).setCategory(category.id);
                    },
                  );
                },
              ),
            ),
            loading: () => const SizedBox(height: 44),
            error: (_, _) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 12),

          // Services Listing
          Expanded(
            child: servicesAsync.when(
              data: (services) {
                if (services.isEmpty) {
                  return EmptyStateView(
                    icon: Icons.search_off_rounded,
                    title: 'No Services Found',
                    message: 'We couldn’t find any services matching your criteria. Try adjusting your filters or search keywords.',
                    actionLabel: 'Reset Filters',
                    onAction: () {
                      _searchController.clear();
                      ref.read(searchQueryFilterProvider.notifier).setQuery('');
                      ref.read(selectedCategoryFilterProvider.notifier).setCategory('all');
                    },
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return ServiceCard(
                      service: service,
                      onTap: () => context.push('/service/${service.id}'),
                      onBookNow: () => context.push('/book-wizard', extra: service),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.midnightNavy),
              ),
              error: (err, _) => ErrorStateView(
                message: 'Failed to load services: $err',
                onRetry: () => ref.refresh(catalogServicesProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
