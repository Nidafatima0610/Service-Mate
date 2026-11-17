import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:service_mate/core/constants/app_colors.dart';
import 'package:service_mate/core/constants/app_typography.dart';
import 'package:service_mate/features/bookings/presentation/providers/booking_providers.dart';
import 'package:service_mate/features/bookings/presentation/screens/booking_details_dialog.dart';
import 'package:service_mate/features/home/presentation/widgets/home_header.dart';
import 'package:service_mate/features/home/presentation/widgets/upcoming_booking_banner.dart';
import 'package:service_mate/features/services/models/service_model.dart';
import 'package:service_mate/features/services/presentation/providers/service_providers.dart';
import 'package:service_mate/features/services/presentation/widgets/service_card.dart';
import 'package:service_mate/shared/widgets/demo_banner.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final featuredAsync = ref.watch(featuredServicesProvider);
    final popularAsync = ref.watch(popularServicesProvider);
    final nextUpcoming = ref.watch(nextUpcomingBookingProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(categoriesProvider);
            ref.invalidate(featuredServicesProvider);
            ref.invalidate(popularServicesProvider);
            await ref.read(bookingsNotifierProvider.notifier).refresh();
          },
          color: AppColors.midnightNavy,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DemoBanner(),

                HomeHeader(
                  onProfileTap: () => context.go('/profile'),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: InkWell(
                    onTap: () => context.go('/services'),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.borderLight),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded, color: AppColors.midnightNavy, size: 22),
                          const SizedBox(width: 12),
                          Text(
                            'Search cleaning, repairs, tutoring...',
                            style: AppTypography.body.copyWith(color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                if (nextUpcoming != null) ...[
                  UpcomingBookingBanner(
                    booking: nextUpcoming,
                    onTap: () {
                      BookingDetailsDialog.show(
                        context,
                        booking: nextUpcoming,
                        onCancelBooking: () async {
                          await ref.read(bookingsNotifierProvider.notifier).cancelBooking(
                                nextUpcoming.id,
                                reason: 'Cancelled from home screen',
                              );
                        },
                      );
                    },
                  ),
                ],

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Categories',
                        style: AppTypography.headline.copyWith(fontSize: 18),
                      ),
                      TextButton(
                        onPressed: () => context.go('/services'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.tealAccent,
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('View All', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),

                categoriesAsync.when(
                  data: (categories) => SizedBox(
                    height: 92,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: categories.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        return _buildCategoryItem(context, ref, cat.id, cat.name, cat.icon);
                      },
                    ),
                  ),
                  loading: () => const SizedBox(height: 92),
                  error: (_, _) => const SizedBox.shrink(),
                ),

                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Featured Services',
                        style: AppTypography.headline.copyWith(fontSize: 18),
                      ),
                      TextButton(
                        onPressed: () => context.go('/services'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.tealAccent,
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('See All', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                featuredAsync.when(
                  data: (featured) => SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: featured.length,
                      itemBuilder: (context, index) {
                        final service = featured[index];
                        return ServiceCard(
                          service: service,
                          isHorizontal: true,
                          onTap: () => context.push('/service/${service.id}'),
                          onBookNow: () => context.push('/book-wizard', extra: service),
                        );
                      },
                    ),
                  ),
                  loading: () => const SizedBox(
                    height: 180,
                    child: Center(child: CircularProgressIndicator(color: AppColors.midnightNavy)),
                  ),
                  error: (err, _) => Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text('Failed to load featured services: $err'),
                  ),
                ),

                const SizedBox(height: 28),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Popular Near You',
                        style: AppTypography.headline.copyWith(fontSize: 18),
                      ),
                      TextButton(
                        onPressed: () => context.go('/services'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.tealAccent,
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('View All', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                popularAsync.when(
                  data: (List<ServiceModel> popular) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: popular.take(4).map((service) {
                        return ServiceCard(
                          service: service,
                          onTap: () => context.push('/service/${service.id}'),
                          onBookNow: () => context.push('/book-wizard', extra: service),
                        );
                      }).toList(),
                    ),
                  ),
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Center(child: CircularProgressIndicator(color: AppColors.midnightNavy)),
                  ),
                  error: (err, _) => Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text('Failed to load popular services: $err'),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(
    BuildContext context,
    WidgetRef ref,
    String id,
    String title,
    IconData icon,
  ) {
    return InkWell(
      onTap: () {
        ref.read(selectedCategoryFilterProvider.notifier).setCategory(id);
        context.go('/services');
      },
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderLight),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 26,
              color: AppColors.midnightNavy,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 72,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
