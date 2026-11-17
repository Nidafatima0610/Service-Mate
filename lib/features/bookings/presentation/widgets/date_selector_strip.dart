import 'package:flutter/material.dart';
import 'package:service_mate/core/constants/app_colors.dart';
import 'package:service_mate/core/constants/app_typography.dart';
import 'package:service_mate/core/utils/date_formatter.dart';

class DateSelectorStrip extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final int daysAhead;

  const DateSelectorStrip({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.daysAhead = 14,
  });

  @override
  Widget build(BuildContext context) {
    final dates = DateFormatter.getUpcomingDates(daysAhead);

    return SizedBox(
      height: 84,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: dates.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = date.year == selectedDate.year &&
              date.month == selectedDate.month &&
              date.day == selectedDate.day;

          final isToday = index == 0;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onDateSelected(date),
              borderRadius: BorderRadius.circular(14),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 64,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.midnightNavy : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? AppColors.midnightNavy : AppColors.borderLight,
                    width: 1.3,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.midnightNavy.withValues(alpha: 0.18),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isToday ? 'Today' : DateFormatter.formatDayOfWeek(date),
                      style: AppTypography.bodySmall.copyWith(
                        color: isSelected
                            ? AppColors.tealLight
                            : (isToday ? AppColors.tealAccent : AppColors.textMuted),
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormatter.formatDayNumber(date),
                      style: AppTypography.headline.copyWith(
                        color: isSelected ? Colors.white : AppColors.midnightNavy,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormatter.formatMonth(date),
                      style: AppTypography.bodySmall.copyWith(
                        color: isSelected ? Colors.white70 : AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
