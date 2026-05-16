import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ActionBar extends StatelessWidget {
  final Future<void> Function() onSolve;
  final VoidCallback onClear;
  final bool isManualMode;

  const ActionBar({
    super.key,
    required this.onSolve,
    required this.onClear,
    required this.isManualMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            label: 'Clear',
            icon: Icons.refresh,
            color: AppColors.textSecondary,
            onTap: onClear,
          ),
        ),
        const Gap(12),
        Expanded(
          flex: 2,
          child: _ActionButton(
            label: isManualMode ? 'Solve My Puzzle' : 'Solve',
            icon: Icons.auto_awesome,
            color: AppColors.primary,
            filled: true,
            onTap: onSolve,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool filled;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: filled ? color : AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: filled ? color : AppColors.gridBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: filled ? AppColors.background : color, size: 18),
            const Gap(8),
            Text(
              label,
              style: AppTextStyles.button.copyWith(
                color: filled ? AppColors.background : color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
