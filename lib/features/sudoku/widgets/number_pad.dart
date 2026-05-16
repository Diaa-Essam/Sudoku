import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class NumberPad extends StatelessWidget {
  final Function(int) onNumberTap;
  final VoidCallback onErase;

  const NumberPad({
    super.key,
    required this.onNumberTap,
    required this.onErase,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(9, (index) {
          final number = index + 1;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: _PadButton(
                child: Text('$number', style: AppTextStyles.numberGiven),
                onTap: () => onNumberTap(number),
              ),
            ),
          );
        }),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: _PadButton(
              child: const Icon(
                Icons.backspace_outlined,
                color: AppColors.danger,
                size: 18,
              ),
              onTap: onErase,
            ),
          ),
        ),
      ],
    );
  }
}

class _PadButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const _PadButton({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 0.75,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.gridBorder),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
