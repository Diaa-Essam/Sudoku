import '../models/sudoku_board.dart';

class Validator {
  /// Returns true if placing [value] at [row],[col] violates no constraints.
  static bool isValid(SudokuBoard board, int row, int col, int value) {
    // Check row
    for (var c = 0; c < 9; c++) {
      if (c == col) continue;
      if (board.cells[row][c].value == value) return false;
    }

    // Check column
    for (var r = 0; r < 9; r++) {
      if (r == row) continue;
      if (board.cells[r][col].value == value) return false;
    }

    // Check 3x3 box
    final startRow = (row ~/ 3) * 3;
    final startCol = (col ~/ 3) * 3;
    for (var r = startRow; r < startRow + 3; r++) {
      for (var c = startCol; c < startCol + 3; c++) {
        if (r == row && c == col) continue;
        if (board.cells[r][c].value == value) return false;
      }
    }

    return true;
  }

  /// Marks all conflicting cells on the board with hasError = true.
  static void validateBoard(SudokuBoard board) {
    // Clear all errors first
    for (var r = 0; r < 9; r++) {
      for (var c = 0; c < 9; c++) {
        board.cells[r][c].hasError = false;
      }
    }

    // Check every filled cell
    for (var r = 0; r < 9; r++) {
      for (var c = 0; c < 9; c++) {
        final cell = board.cells[r][c];
        if (cell.value == null) continue;
        if (!isValid(board, r, c, cell.value!)) {
          cell.hasError = true;
        }
      }
    }
  }
}
