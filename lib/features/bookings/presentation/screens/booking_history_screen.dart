import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:service_mate/core/constants/app_colors.dart';
import 'package:service_mate/core/constants/app_typography.dart';
import 'package:service_mate/features/bookings/models/booking_model.dart';
import 'package:service_mate/features/bookings/presentation/providers/booking_providers.dart';
import 'package:service_mate/features/bookings/presentation/screens/booking_cancel_dialog.dart';
import 'package:service_mate/features/bookings/presentation/screens/booking_details_dialog.dart';
import 'package:service_mate/features/bookings/presentation/widgets/booking_card.dart';
import 'package:service_mate/shared/widgets/empty_state_view.dart';
import 'package:service_mate/shared/widgets/error_state_view.dart';

class BookingHistoryScreen extends ConsumerStatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  ConsumerState<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends ConsumerState<BookingHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showBookingDetails(BookingModel booking) {
    BookingDetailsDialog.show(
      context,
      booking: booking,
      onCancelBooking: booking.isUpcoming ? () => _promptCancel(booking) : null,
    );
  }

  void _promptCancel(BookingModel booking) {
    BookingCancelDialog.show(
      context,
      booking: booking,
      onConfirmCancel: (reason) async {
        await ref.read(bookingsNotifierProvider.notifier).cancelBooking(
              booking.id,
              reason: reason,
            );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Booking #${booking.referenceCode} cancelled successfully.'),
              backgroundColor: AppColors.midnightNavy,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(bookingsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.midnightNavy,
          unselectedLabelColor: AppColors.textMuted,
          indicatorColor: AppColors.tealAccent,
          indicatorWeight: 3,
          labelStyle: AppTypography.subtitle.copyWith(fontWeight: FontWeight.w700),
          unselectedLabelStyle: AppTypography.subtitle,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: bookingsAsync.when(
        data: (bookings) {
          final upcoming = bookings.where((b) => b.isUpcoming).toList();
          final completed = bookings.where((b) => b.isCompleted).toList();
          final cancelled = bookings.where((b) => b.isCancelled).toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildBookingsList(upcoming, 'No Upcoming Bookings', 'You have no scheduled appointments at the moment.'),
              _buildBookingsList(completed, 'No Completed Bookings', 'Completed service history will appear here.'),
              _buildBookingsList(cancelled, 'No Cancelled Bookings', 'No cancelled bookings found.'),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.midnightNavy),
        ),
        error: (err, _) => ErrorStateView(
          message: 'Unable to load bookings: $err',
          onRetry: () => ref.read(bookingsNotifierProvider.notifier).refresh(),
        ),
      ),
    );
  }

  Widget _buildBookingsList(
    List<BookingModel> list,
    String emptyTitle,
    String emptyMessage,
  ) {
    if (list.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => ref.read(bookingsNotifierProvider.notifier).refresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: EmptyStateView(
              icon: Icons.calendar_month_outlined,
              title: emptyTitle,
              message: emptyMessage,
              actionLabel: 'Explore Services',
              onAction: () => context.go('/services'),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(bookingsNotifierProvider.notifier).refresh(),
      color: AppColors.midnightNavy,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final booking = list[index];
          return BookingCard(
            booking: booking,
            onTap: () => _showBookingDetails(booking),
            onCancel: booking.isUpcoming ? () => _promptCancel(booking) : null,
          );
        },
      ),
    );
  }
}
