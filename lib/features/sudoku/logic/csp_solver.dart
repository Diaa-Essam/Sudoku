import 'package:flutter/material.dart';
import '../models/sudoku_board.dart';
import '../widgets/solver_log.dart';

class CspSolver {
  final SudokuBoard board;
  final VoidCallback onBoardChanged;
  final void Function(LogEntry entry) onLogEntry;

  int _totalRevisions = 0;
  int _totalPruned = 0;

  CspSolver({
    required this.board,
    required this.onBoardChanged,
    required this.onLogEntry,
  });

  Future<bool> solve() async {
    final ac3Result = await runAC3();
    if (!ac3Result) {
      logSummary('AC-3 detected no solution.');
      return false;
    }

    if (board.isSolved) {
      logSummary(
        'Solved by AC-3 alone! Revisions: $_totalRevisions, Pruned: $_totalPruned',
      );
      return true;
    }

    logSummary('AC-3 done. Starting backtracking...');
    final btResult = runBacktracking();

    logSummary(
      'Total revisions: $_totalRevisions, Total pruned: $_totalPruned',
    );
    return btResult;
  }

  Future<bool> runAC3() async {
    // Build initial queue of all arcs
    final queue = <List<int>>[];

    for (var r = 0; r < 9; r++) {
      for (var c = 0; c < 9; c++) {
        for (final neighbor in board.getNeighbors(r, c)) {
          queue.add([r, c, neighbor.row, neighbor.col]);
        }
      }
    }

    while (queue.isNotEmpty) {
      final arc = queue.removeAt(0);
      final xi = board.cells[arc[0]][arc[1]];
      final xj = board.cells[arc[2]][arc[3]];

      _totalRevisions++;
      logArc('Revising arc (X${arc[0]}${arc[1]}, X${arc[2]}${arc[3]})');

      if (await _revise(xi, xj, arc)) {
        if (xi.domain.isEmpty) {
          logSummary('Domain of X${arc[0]}${arc[1]} is empty — no solution.');
          return false;
        }

        // Enqueue all neighbors of xi
        for (final neighbor in board.getNeighbors(arc[0], arc[1])) {
          if (neighbor.row != arc[2] || neighbor.col != arc[3]) {
            queue.add([neighbor.row, neighbor.col, arc[0], arc[1]]);
          }
        }
      }
    }

    return true;
  }

  Future<bool> _revise(SudokuCell xi, SudokuCell xj, List<int> arc) async {
    bool revised = false;
    final toRemove = <int>[];

    for (final valueX in xi.domain) {
      // Constraint: xi != xj — check if xj has any value != valueX
      final hasSupport = xj.domain.any((valueY) => valueY != valueX);

      if (!hasSupport) {
        toRemove.add(valueX);
      }
    }

    for (final value in toRemove) {
      logArc(
        'Current domain of X${arc[0]}${arc[1]}: ${xi.domain.toList()..sort()}',
      );
      logArc('Domain of X${arc[2]}${arc[3]}: ${xj.domain.toList()..sort()}');
      logRemoved(
        'Removed $value from X${arc[0]}${arc[1]} — no support in X${arc[2]}${arc[3]}',
      );

      xi.domain.remove(value);
      _totalPruned++;
      revised = true;

      logArc(
        'Updated domain of X${arc[0]}${arc[1]}: ${xi.domain.toList()..sort()}',
      );

      // If singleton — assign the value
      if (xi.domain.length == 1) {
        final assignedValue = xi.domain.first;
        xi.value = assignedValue;
        xi.type = CellType.solved;
        logSingleton(
          'X${arc[0]}${arc[1]} is singleton → assigned $assignedValue',
        );
        onBoardChanged();
        await Future.delayed(const Duration(milliseconds: 80));
      }
    }

    return revised;
  }

  bool runBacktracking() {
    // Find first empty cell
    SudokuCell? empty;
    outer:
    for (var r = 0; r < 9; r++) {
      for (var c = 0; c < 9; c++) {
        if (board.cells[r][c].value == null) {
          empty = board.cells[r][c];
          break outer;
        }
      }
    }

    if (empty == null) return true; // All filled

    for (var value = 1; value <= 9; value++) {
      if (_isSafe(empty.row, empty.col, value)) {
        empty.value = value;
        empty.type = CellType.solved;
        onBoardChanged();

        if (runBacktracking()) return true;

        // Backtrack
        empty.value = null;
        empty.type = CellType.empty;
        onBoardChanged();
      }
    }

    return false;
  }

  bool _isSafe(int row, int col, int value) {
    for (final cell in board.getNeighbors(row, col)) {
      if (cell.value == value) return false;
    }
    return true;
  }

  void logArc(String message) =>
      onLogEntry(LogEntry(message: message, type: LogType.arc));

  void logRemoved(String message) =>
      onLogEntry(LogEntry(message: message, type: LogType.removed));

  void logSingleton(String message) =>
      onLogEntry(LogEntry(message: message, type: LogType.singleton));

  void logSummary(String message) =>
      onLogEntry(LogEntry(message: message, type: LogType.summary));
}
