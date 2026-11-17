import 'package:flutter/material.dart';
import 'package:service_mate/core/constants/app_colors.dart';
import 'package:service_mate/core/constants/app_typography.dart';
import 'package:service_mate/features/bookings/models/booking_model.dart';
import 'package:service_mate/shared/widgets/app_button.dart';

class BookingCancelDialog extends StatefulWidget {
  final BookingModel booking;
  final Future<void> Function(String reason) onConfirmCancel;

  const BookingCancelDialog({
    super.key,
    required this.booking,
    required this.onConfirmCancel,
  });

  static Future<bool?> show(
    BuildContext context, {
    required BookingModel booking,
    required Future<void> Function(String reason) onConfirmCancel,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => BookingCancelDialog(
        booking: booking,
        onConfirmCancel: onConfirmCancel,
      ),
    );
  }

  @override
  State<BookingCancelDialog> createState() => _BookingCancelDialogState();
}

class _BookingCancelDialogState extends State<BookingCancelDialog> {
  final List<String> _reasons = const [
    'Change of schedule / plans',
    'Found another convenient time',
    'Booked by accident',
    'Service no longer required',
    'Other reason',
  ];

  late String _selectedReason;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedReason = _reasons.first;
  }

  Future<void> _handleConfirm() async {
    setState(() => _isLoading = true);
    try {
      await widget.onConfirmCancel(_selectedReason);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to cancel booking: $e'),
            backgroundColor: AppColors.statusError,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.statusErrorBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.statusError,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Cancel Booking?',
              style: AppTypography.title,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to cancel your appointment for "${widget.booking.serviceName}" on ${widget.booking.timeSlot}?',
              style: AppTypography.body,
            ),
            const SizedBox(height: 16),
            Text(
              'Reason for cancellation',
              style: AppTypography.label.copyWith(color: AppColors.midnightNavy),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedReason,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  items: _reasons.map((r) {
                    return DropdownMenuItem<String>(
                      value: r,
                      child: Text(r, style: AppTypography.body),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedReason = val);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
                child: const Text('Keep Booking'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton(
                label: 'Yes, Cancel',
                variant: AppButtonVariant.danger,
                isLoading: _isLoading,
                onPressed: _handleConfirm,
                height: 44,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
