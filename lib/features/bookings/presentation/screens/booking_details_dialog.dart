import 'package:flutter/material.dart';
import 'package:service_mate/core/constants/app_colors.dart';
import 'package:service_mate/core/constants/app_typography.dart';
import 'package:service_mate/core/utils/currency_formatter.dart';
import 'package:service_mate/core/utils/date_formatter.dart';
import 'package:service_mate/features/bookings/models/booking_model.dart';
import 'package:service_mate/features/bookings/presentation/widgets/booking_status_badge.dart';

class BookingDetailsDialog extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback? onCancelBooking;

  const BookingDetailsDialog({
    super.key,
    required this.booking,
    this.onCancelBooking,
  });

  static Future<void> show(
    BuildContext context, {
    required BookingModel booking,
    VoidCallback? onCancelBooking,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BookingDetailsDialog(
        booking: booking,
        onCancelBooking: onCancelBooking,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking Details',
                      style: AppTypography.headline.copyWith(
                        color: AppColors.midnightNavy,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      booking.referenceCode,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                BookingStatusBadge(status: booking.status),
              ],
            ),
          ),
          const Divider(height: 1),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Info Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMuted,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.serviceCategory,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.tealAccent,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          booking.serviceName,
                          style: AppTypography.title.copyWith(fontSize: 15),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.storefront_rounded, size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              booking.providerName,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Schedule
                  Text(
                    'Appointment Schedule',
                    style: AppTypography.label.copyWith(color: AppColors.midnightNavy),
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    Icons.calendar_month_rounded,
                    'Date',
                    DateFormatter.formatFullDate(booking.date),
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    Icons.schedule_rounded,
                    'Time Slot',
                    booking.timeSlot,
                  ),
                  const SizedBox(height: 20),

                  // Customer & Location
                  Text(
                    'Service Location & Contact',
                    style: AppTypography.label.copyWith(color: AppColors.midnightNavy),
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(Icons.person_outline_rounded, 'Customer', booking.customerName),
                  const SizedBox(height: 8),
                  _buildDetailRow(Icons.phone_outlined, 'Phone', booking.customerPhone),
                  const SizedBox(height: 8),
                  _buildDetailRow(Icons.email_outlined, 'Email', booking.customerEmail),
                  const SizedBox(height: 8),
                  _buildDetailRow(Icons.location_on_outlined, 'Address', booking.customerAddress),
                  if (booking.specialInstructions != null && booking.specialInstructions!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      Icons.note_alt_outlined,
                      'Instructions',
                      booking.specialInstructions!,
                    ),
                  ],
                  const SizedBox(height: 20),

                  // Payment Breakdown
                  Text(
                    'Payment Breakdown',
                    style: AppTypography.label.copyWith(color: AppColors.midnightNavy),
                  ),
                  const SizedBox(height: 10),
                  _buildPriceRow('Base Service Price', booking.basePrice),
                  const SizedBox(height: 6),
                  _buildPriceRow('Platform Service Fee (5%)', booking.serviceFee),
                  const SizedBox(height: 6),
                  _buildPriceRow('Taxes (8%)', booking.tax),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(height: 1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Price',
                        style: AppTypography.title.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        CurrencyFormatter.formatWithDecimals(booking.totalPrice),
                        style: AppTypography.headline.copyWith(
                          color: AppColors.midnightNavy,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (booking.isCancelled) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.statusErrorBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: AppColors.statusError, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Cancelled: ${booking.cancellationReason ?? "Customer request"}',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.statusError,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ),

          // Bottom action
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  if (booking.isUpcoming && onCancelBooking != null) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onCancelBooking!();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.statusError,
                          side: const BorderSide(color: AppColors.statusError),
                        ),
                        child: const Text('Cancel Booking'),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textMuted),
        const SizedBox(width: 8),
        SizedBox(
          width: 85,
          child: Text(
            label,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
        Text(
          CurrencyFormatter.formatWithDecimals(amount),
          style: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
