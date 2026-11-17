import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:service_mate/core/constants/app_colors.dart';
import 'package:service_mate/core/constants/app_typography.dart';
import 'package:service_mate/core/utils/currency_formatter.dart';
import 'package:service_mate/features/services/models/service_model.dart';
import 'package:service_mate/features/services/presentation/providers/service_providers.dart';
import 'package:service_mate/features/services/presentation/widgets/service_rating_badge.dart';
import 'package:service_mate/shared/widgets/app_button.dart';
import 'package:service_mate/shared/widgets/error_state_view.dart';

class ServiceDetailsScreen extends ConsumerWidget {
  final String serviceId;

  const ServiceDetailsScreen({super.key, required this.serviceId});

  IconData _getCategoryIcon(String iconType) {
    switch (iconType) {
      case 'cleaning':
        return Icons.cleaning_services_rounded;
      case 'beauty':
        return Icons.spa_rounded;
      case 'repair':
        return Icons.home_repair_service_rounded;
      case 'fitness':
        return Icons.fitness_center_rounded;
      case 'photography':
        return Icons.camera_alt_rounded;
      case 'tutoring':
        return Icons.school_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceAsync = ref.watch(serviceDetailProvider(serviceId));

    return Scaffold(
      body: serviceAsync.when(
        data: (ServiceModel service) => Stack(
          children: [
            CustomScrollView(
              slivers: [
                // Custom App Bar with Hero Visual
                SliverAppBar(
                  expandedHeight: 220,
                  pinned: true,
                  backgroundColor: AppColors.midnightNavy,
                  foregroundColor: Colors.white,
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withValues(alpha: 0.35),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                        onPressed: () => context.pop(),
                      ),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.midnightNavy, Color(0xFF1E293B)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            right: -20,
                            bottom: -20,
                            child: Icon(
                              _getCategoryIcon(service.iconType),
                              size: 180,
                              color: Colors.white.withValues(alpha: 0.06),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: AppColors.tealAccent.withValues(alpha: 0.18),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.tealAccent, width: 2),
                                ),
                                child: Icon(
                                  _getCategoryIcon(service.iconType),
                                  size: 34,
                                  color: AppColors.tealLight,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  service.categoryName,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Service Details Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title & Rating
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                service.name,
                                style: AppTypography.displayMedium.copyWith(fontSize: 22),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ServiceRatingBadge(
                              rating: service.providerRating,
                              reviewCount: service.reviewCount,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Provider Info Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: AppColors.midnightNavy,
                                child: Text(
                                  service.providerName.substring(0, 1),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            service.providerName,
                                            style: AppTypography.title.copyWith(fontSize: 15),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(
                                          Icons.verified_rounded,
                                          size: 16,
                                          color: AppColors.tealAccent,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Verified Professional Partner',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Duration & Pricing highlight
                        Row(
                          children: [
                            Expanded(
                              child: _buildFeaturePill(
                                Icons.schedule_rounded,
                                'Duration',
                                service.durationString,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildFeaturePill(
                                Icons.payments_outlined,
                                'Price',
                                CurrencyFormatter.format(service.price),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Description
                        Text(
                          'About this service',
                          style: AppTypography.title.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          service.description,
                          style: AppTypography.body.copyWith(
                            height: 1.6,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // What's Included
                        if (service.includes.isNotEmpty) ...[
                          Text(
                            "What's Included",
                            style: AppTypography.title.copyWith(fontSize: 16),
                          ),
                          const SizedBox(height: 12),
                          ...service.includes.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      size: 18,
                                      color: AppColors.tealAccent,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: AppTypography.body.copyWith(
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          const SizedBox(height: 20),
                        ],

                        // Trust & Policy Notice
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceMuted,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.security_rounded,
                                size: 20,
                                color: AppColors.tealAccent,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ServiceMate Guarantee',
                                      style: AppTypography.label.copyWith(
                                        color: AppColors.midnightNavy,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Free cancellation up to 24 hours prior. Guaranteed professional quality or re-clean/re-service.',
                                      style: AppTypography.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Sticky Bottom CTA Bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: const Border(top: BorderSide(color: AppColors.borderLight)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Total Price',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                          ),
                          Text(
                            CurrencyFormatter.format(service.price),
                            style: AppTypography.headline.copyWith(
                              color: AppColors.midnightNavy,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: AppButton(
                          label: 'Book Appointment',
                          variant: AppButtonVariant.primary,
                          icon: Icons.calendar_today_rounded,
                          onPressed: () {
                            context.push('/book-wizard', extra: service);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: AppColors.midnightNavy),
          ),
        ),
        error: (err, _) => Scaffold(
          appBar: AppBar(title: const Text('Service Details')),
          body: ErrorStateView(
            message: 'Failed to load service details: $err',
            onRetry: () => ref.refresh(serviceDetailProvider(serviceId)),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturePill(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.tealAccent),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textMuted),
              ),
              Text(
                value,
                style: AppTypography.title.copyWith(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
