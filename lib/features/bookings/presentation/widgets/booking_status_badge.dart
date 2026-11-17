import 'package:flutter/material.dart';
import 'package:service_mate/core/constants/app_colors.dart';
import 'package:service_mate/core/constants/app_typography.dart';
import 'package:service_mate/features/bookings/models/booking_model.dart';

class BookingStatusBadge extends StatelessWidget {
  final BookingStatus status;

  const BookingStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case BookingStatus.confirmed:
        bgColor = AppColors.statusSuccessBg;
        textColor = AppColors.statusSuccess;
        icon = Icons.check_circle_rounded;
        break;
      case BookingStatus.inProgress:
        bgColor = const Color(0xFFE0F2FE);
        textColor = const Color(0xFF0284C7);
        icon = Icons.pending_rounded;
        break;
      case BookingStatus.completed:
        bgColor = AppColors.surfaceMuted;
        textColor = AppColors.textSecondary;
        icon = Icons.task_alt_rounded;
        break;
      case BookingStatus.cancelled:
        bgColor = AppColors.statusErrorBg;
        textColor = AppColors.statusError;
        icon = Icons.cancel_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: textColor),
          const SizedBox(width: 5),
          Text(
            status.displayName,
            style: AppTypography.bodySmall.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
