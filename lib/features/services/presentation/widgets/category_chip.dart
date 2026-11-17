import 'package:flutter/material.dart';
import 'package:service_mate/core/constants/app_colors.dart';
import 'package:service_mate/core/constants/app_typography.dart';
import 'package:service_mate/features/services/models/category_model.dart';

class CategoryFilterChipWidget extends StatelessWidget {
  final ServiceCategory? category;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isAll;

  const CategoryFilterChipWidget({
    super.key,
    this.category,
    required this.isSelected,
    required this.onTap,
    this.isAll = false,
  });

  @override
  Widget build(BuildContext context) {
    final title = isAll ? 'All Services' : (category?.name ?? '');
    final icon = isAll ? Icons.grid_view_rounded : (category?.icon ?? Icons.category_rounded);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.midnightNavy : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected ? AppColors.midnightNavy : AppColors.borderLight,
              width: 1.2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.midnightNavy.withValues(alpha: 0.12),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    )
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? AppColors.tealLight : AppColors.midnightNavy,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTypography.subtitle.copyWith(
                  color: isSelected ? Colors.white : AppColors.midnightNavy,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
