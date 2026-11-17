import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:service_mate/core/constants/app_colors.dart';
import 'package:service_mate/core/constants/app_typography.dart';
import 'package:service_mate/core/utils/currency_formatter.dart';
import 'package:service_mate/core/utils/date_formatter.dart';
import 'package:service_mate/features/bookings/models/booking_model.dart';
import 'package:service_mate/shared/widgets/app_button.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final BookingModel booking;

  const BookingConfirmationScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          context.go('/bookings');
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Success Badge Circle
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.tealAccent.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.tealAccent,
                      size: 54,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  'Booking Confirmed!',
                  textAlign: TextAlign.center,
                  style: AppTypography.displayMedium.copyWith(
                    color: AppColors.midnightNavy,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your appointment has been successfully scheduled and saved.',
                  textAlign: TextAlign.center,
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),

                // Booking Reference Pill
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: booking.referenceCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Copied reference code: ${booking.referenceCode}'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMuted,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'REF CODE: ',
                          style: AppTypography.label.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          booking.referenceCode,
                          style: AppTypography.headline.copyWith(
                            color: AppColors.midnightNavy,
                            fontSize: 16,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.copy_rounded,
                          size: 16,
                          color: AppColors.tealAccent,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Booking Details Summary Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Column(
                    children: [
                      _buildRow(
                        'Service',
                        booking.serviceName,
                        isBold: true,
                      ),
                      const Divider(height: 20),
                      _buildRow('Provider', booking.providerName),
                      const SizedBox(height: 10),
                      _buildRow(
                        'Scheduled Date',
                        DateFormatter.formatFullDate(booking.date),
                      ),
                      const SizedBox(height: 10),
                      _buildRow('Time Slot', booking.timeSlot),
                      const SizedBox(height: 10),
                      _buildRow('Address', booking.customerAddress),
                      const Divider(height: 20),
                      _buildRow(
                        'Total Price',
                        CurrencyFormatter.formatWithDecimals(booking.totalPrice),
                        isBold: true,
                        valueColor: AppColors.midnightNavy,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Action buttons
                AppButton(
                  label: 'View My Bookings',
                  variant: AppButtonVariant.primary,
                  onPressed: () => context.go('/bookings'),
                  icon: Icons.list_alt_rounded,
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => context.go('/'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Return to Home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTypography.body.copyWith(
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
