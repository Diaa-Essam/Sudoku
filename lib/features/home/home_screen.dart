import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../sudoku/sudoku_screen.dart';
import '../sudoku/widgets/difficulty_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(48),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryDim,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: AppColors.primary,
                      size: 14,
                    ),
                    const Gap(6),
                    Text(
                      'CSP · AC-3 · Backtracking',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2),
              const Gap(20),
              Text(
                'Sudoku',
                style: AppTextStyles.heading1,
              ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1),
              Text(
                'AI Solver',
                style: AppTextStyles.heading1.copyWith(
                  color: AppColors.primary,
                ),
              ).animate().fadeIn(delay: 150.ms).slideX(begin: -0.1),
              const Gap(8),
              Text(
                'Solving Sudoku using Constraint\nSatisfaction Problem techniques',
                style: AppTextStyles.body,
              ).animate().fadeIn(delay: 200.ms),
              const Spacer(),
              _ModeCard(
                icon: Icons.smart_toy_outlined,
                title: 'AI Solve Mode',
                subtitle: 'Watch the AI solve a generated puzzle step by step',
                color: AppColors.primary,
                onTap: () async {
                  final difficulty = await DifficultySheet.show(context);
                  if (difficulty == null) return;
                  if (!context.mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SudokuScreen(difficulty: difficulty),
                    ),
                  );
                },
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
              const Gap(16),
              _ModeCard(
                icon: Icons.edit_outlined,
                title: 'Manual Input Mode',
                subtitle: 'Enter your own puzzle and let the AI solve it',
                color: AppColors.success,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SudokuScreen(isManualMode: true),
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
              const Gap(48),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gridBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.heading2.copyWith(fontSize: 16),
                    ),
                    const Gap(4),
                    Text(subtitle, style: AppTextStyles.body),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textDisabled,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
