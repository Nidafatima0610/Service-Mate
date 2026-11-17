import 'package:flutter/material.dart';
import 'package:service_mate/core/constants/app_colors.dart';
import 'package:service_mate/core/constants/app_typography.dart';
import 'package:service_mate/features/bookings/models/time_slot_model.dart';

class TimeSlotSelector extends StatelessWidget {
  final List<TimeSlot> slots;
  final String? selectedSlot;
  final ValueChanged<String> onSlotSelected;

  const TimeSlotSelector({
    super.key,
    required this.slots,
    required this.selectedSlot,
    required this.onSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    final morningSlots = slots.where((s) => s.period == SlotPeriod.morning).toList();
    final afternoonSlots = slots.where((s) => s.period == SlotPeriod.afternoon).toList();
    final eveningSlots = slots.where((s) => s.period == SlotPeriod.evening).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (morningSlots.isNotEmpty) ...[
          _buildPeriodSection('Morning', Icons.wb_sunny_outlined, morningSlots),
          const SizedBox(height: 16),
        ],
        if (afternoonSlots.isNotEmpty) ...[
          _buildPeriodSection('Afternoon', Icons.wb_twilight_rounded, afternoonSlots),
          const SizedBox(height: 16),
        ],
        if (eveningSlots.isNotEmpty) ...[
          _buildPeriodSection('Evening', Icons.nightlight_round, eveningSlots),
        ],
      ],
    );
  }

  Widget _buildPeriodSection(String title, IconData icon, List<TimeSlot> periodSlots) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 15, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              title,
              style: AppTypography.label.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: periodSlots.map((slot) {
            final isSelected = selectedSlot == slot.label;
            final isAvailable = slot.isAvailable;

            return InkWell(
              onTap: isAvailable ? () => onSlotSelected(slot.label) : null,
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: !isAvailable
                      ? AppColors.surfaceMuted
                      : isSelected
                          ? AppColors.tealAccent
                          : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: !isAvailable
                        ? AppColors.borderLight
                        : isSelected
                            ? AppColors.tealAccent
                            : AppColors.borderLight,
                    width: 1.2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      slot.label,
                      style: AppTypography.subtitle.copyWith(
                        color: !isAvailable
                            ? AppColors.textMuted
                            : isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 13,
                        decoration: !isAvailable ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if (!isAvailable) ...[
                      const SizedBox(width: 4),
                      Text(
                        'Booked',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 10,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
