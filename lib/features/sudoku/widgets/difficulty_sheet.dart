import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

enum Difficulty { easy, medium, hard }

class DifficultySheet extends StatelessWidget {
  const DifficultySheet({super.key});

  static Future<Difficulty?> show(BuildContext context) {
    return showModalBottomSheet<Difficulty>(
      context: context,
      backgroundColor: AppColors.backgroundCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const DifficultySheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.gridBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Gap(24),
          Text('Select Difficulty', style: AppTextStyles.heading2),
          const Gap(8),
          Text('How hard do you want it?', style: AppTextStyles.body),
          const Gap(24),
          _DifficultyOption(
            label: 'Easy',
            description: '45 clues — great for beginners',
            color: AppColors.success,
            icon: Icons.sentiment_satisfied_outlined,
            onTap: () => Navigator.pop(context, Difficulty.easy),
          ),
          const Gap(12),
          _DifficultyOption(
            label: 'Medium',
            description: '32 clues — a decent challenge',
            color: AppColors.warning,
            icon: Icons.sentiment_neutral_outlined,
            onTap: () => Navigator.pop(context, Difficulty.medium),
          ),
          const Gap(12),
          _DifficultyOption(
            label: 'Hard',
            description: '25 clues — for the brave',
            color: AppColors.danger,
            icon: Icons.sentiment_very_dissatisfied_outlined,
            onTap: () => Navigator.pop(context, Difficulty.hard),
          ),
          const Gap(24),
        ],
      ),
    );
  }
}

class _DifficultyOption extends StatelessWidget {
  final String label;
  final String description;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _DifficultyOption({
    required this.label,
    required this.description,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gridBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.heading2.copyWith(fontSize: 15),
                  ),
                  const Gap(2),
                  Text(description, style: AppTextStyles.body),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textDisabled,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
