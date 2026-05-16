import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/sudoku_board.dart';

class SudokuGrid extends StatelessWidget {
  final SudokuBoard board;
  final Function(int row, int col) onCellTap;
  final bool showDomains;

  const SudokuGrid({
    super.key,
    required this.board,
    required this.onCellTap,
    this.showDomains = false,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.gridBorderBold, width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: List.generate(9, (row) {
            return Expanded(
              child: Row(
                children: List.generate(9, (col) {
                  return Expanded(
                    child: _SudokuCell(
                      cell: board.getCell(row, col),
                      onTap: () => onCellTap(row, col),
                      borderRight: _rightBorderWidth(col),
                      borderBottom: _bottomBorderWidth(row),
                      showDomains: showDomains,
                    ),
                  );
                }),
              ),
            );
          }),
        ),
      ),
    );
  }

  double _rightBorderWidth(int col) {
    if (col == 8) return 0;
    if ((col + 1) % 3 == 0) return 2;
    return 0.5;
  }

  double _bottomBorderWidth(int row) {
    if (row == 8) return 0;
    if ((row + 1) % 3 == 0) return 2;
    return 0.5;
  }
}

class _SudokuCell extends StatelessWidget {
  final SudokuCell cell;
  final VoidCallback onTap;
  final double borderRight;
  final double borderBottom;
  final bool showDomains;

  const _SudokuCell({
    required this.cell,
    required this.onTap,
    required this.borderRight,
    required this.borderBottom,
    required this.showDomains,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _backgroundColor(),
          border: Border(
            right: BorderSide(
              color: borderRight > 1
                  ? AppColors.gridBorderBold
                  : AppColors.gridBorder,
              width: borderRight,
            ),
            bottom: BorderSide(
              color: borderBottom > 1
                  ? AppColors.gridBorderBold
                  : AppColors.gridBorder,
              width: borderBottom,
            ),
          ),
        ),
        child: Center(
          child: cell.value != null
              ? Text('${cell.value}', style: _textStyle())
              : showDomains && cell.domain.length > 1
              ? _DomainHints(domain: cell.domain)
              : null,
        ),
      ),
    );
  }

  Color _backgroundColor() {
    if (cell.isSelected) return AppColors.cellSelected;
    if (cell.isHighlighted) return AppColors.cellHighlighted;
    if (cell.isGiven) return AppColors.cellPrefilled;
    return AppColors.cellDefault;
  }

  TextStyle _textStyle() {
    if (cell.hasError) return AppTextStyles.numberError;
    switch (cell.type) {
      case CellType.given:
        return AppTextStyles.numberGiven;
      case CellType.solved:
        return AppTextStyles.numberSolved;
      case CellType.user:
        return AppTextStyles.numberUser;
      case CellType.empty:
        return AppTextStyles.numberGiven;
      default:
        return AppTextStyles.numberGiven;
    }
  }
}

class _DomainHints extends StatelessWidget {
  final Set<int> domain;

  const _DomainHints({required this.domain});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: 9,
        itemBuilder: (context, index) {
          final number = index + 1;
          final inDomain = domain.contains(number);
          return Center(
            child: Text(
              inDomain ? '$number' : '',
              style: AppTextStyles.domainHint,
            ),
          );
        },
      ),
    );
  }
}
