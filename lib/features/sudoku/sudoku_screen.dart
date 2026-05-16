import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'models/sudoku_board.dart';
import 'widgets/sudoku_grid.dart';
import 'widgets/number_pad.dart';
import 'widgets/action_bar.dart';
import 'widgets/difficulty_sheet.dart';
import 'widgets/solver_log.dart';
import 'logic/validator.dart';
import 'logic/csp_solver.dart';

class SudokuScreen extends StatefulWidget {
  final bool isManualMode;
  final Difficulty difficulty;

  const SudokuScreen({
    super.key,
    this.isManualMode = false,
    this.difficulty = Difficulty.medium,
  });

  @override
  State<SudokuScreen> createState() => _SudokuScreenState();
}

class _SudokuScreenState extends State<SudokuScreen> {
  late SudokuBoard board;
  int? selectedRow;
  int? selectedCol;
  final List<LogEntry> _logEntries = [];
  bool _showDomains = false;

  final List<List<int>> samplePuzzle = [
    [7, 9, 0, 0, 1, 3, 6, 0, 0],
    [4, 0, 0, 0, 7, 0, 3, 0, 0],
    [1, 0, 0, 2, 4, 0, 9, 7, 5],
    [5, 0, 0, 6, 0, 0, 2, 0, 7],
    [0, 7, 0, 0, 0, 1, 8, 0, 0],
    [8, 0, 6, 9, 2, 0, 5, 0, 0],
    [6, 0, 1, 0, 0, 2, 0, 5, 3],
    [3, 0, 0, 0, 0, 0, 4, 0, 9],
    [0, 2, 4, 0, 3, 5, 0, 0, 0],
  ];

  @override
  void initState() {
    super.initState();
    board = SudokuBoard();
    if (!widget.isManualMode) {
      board.loadPuzzle(samplePuzzle);
    }
  }

  void _onCellTap(int row, int col) {
    setState(() {
      if (selectedRow == row && selectedCol == col) {
        selectedRow = null;
        selectedCol = null;
        _clearHighlights();
        return;
      }
      selectedRow = row;
      selectedCol = col;
      _updateHighlights(row, col);
    });
  }

  void _clearHighlights() {
    for (var r = 0; r < 9; r++) {
      for (var c = 0; c < 9; c++) {
        board.cells[r][c].isSelected = false;
        board.cells[r][c].isHighlighted = false;
      }
    }
  }

  void _updateHighlights(int row, int col) {
    _clearHighlights();
    board.cells[row][col].isSelected = true;
    for (final cell in board.getNeighbors(row, col)) {
      cell.isHighlighted = true;
    }
  }

  void _onNumberTap(int number) {
    if (selectedRow == null || selectedCol == null) return;
    final cell = board.getCell(selectedRow!, selectedCol!);
    if (cell.isGiven) return;

    setState(() {
      cell.value = number;
      cell.type = CellType.user;
      Validator.validateBoard(board);
    });
  }

  void _onErase() {
    if (selectedRow == null || selectedCol == null) return;
    final cell = board.getCell(selectedRow!, selectedCol!);
    if (cell.isGiven) return;

    setState(() {
      cell.value = null;
      cell.type = CellType.empty;
      cell.hasError = false;
      Validator.validateBoard(board);
    });
  }

  Future<void> _onSolve() async {
    setState(() => _logEntries.clear());

    final solver = CspSolver(
      board: board,
      onBoardChanged: () => setState(() {}),
      onLogEntry: (entry) => setState(() => _logEntries.add(entry)),
    );

    final solved = await solver.solve();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(solved ? '✓ Solved!' : '✗ No solution found'),
        backgroundColor: solved ? AppColors.success : AppColors.danger,
      ),
    );
  }

  void _onClear() {
    setState(() {
      for (var r = 0; r < 9; r++) {
        for (var c = 0; c < 9; c++) {
          final cell = board.cells[r][c];
          if (!cell.isGiven) {
            cell.value = null;
            cell.type = CellType.empty;
            cell.hasError = false;
          }
        }
      }
      selectedRow = null;
      selectedCol = null;
      _clearHighlights();
      _logEntries.clear();
    });
  }

  String get _difficultyLabel {
    switch (widget.difficulty) {
      case Difficulty.easy:
        return 'Easy';
      case Difficulty.medium:
        return 'Medium';
      case Difficulty.hard:
        return 'Hard';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.isManualMode ? 'Manual Input' : _difficultyLabel,
          style: AppTextStyles.heading2,
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showDomains ? Icons.grid_on : Icons.grid_off,
              color: _showDomains ? AppColors.primary : AppColors.textDisabled,
              size: 20,
            ),
            onPressed: () => setState(() => _showDomains = !_showDomains),
            tooltip: 'Toggle domain hints',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const Gap(16),
              SudokuGrid(
                board: board,
                onCellTap: _onCellTap,
                showDomains: _showDomains,
              ),
              const Gap(24),
              NumberPad(onNumberTap: _onNumberTap, onErase: _onErase),
              const Gap(16),
              ActionBar(
                onSolve: _onSolve,
                onClear: _onClear,
                isManualMode: widget.isManualMode,
              ),
              const Gap(16),
              SolverLog(entries: _logEntries),
              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }
}
