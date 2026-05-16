export 'sudoku_cell.dart';
import 'sudoku_cell.dart';

class SudokuBoard {
  final List<List<SudokuCell>> cells;

  SudokuBoard()
    : cells = List.generate(
        9,
        (row) => List.generate(9, (col) => SudokuCell(row: row, col: col)),
      );

  SudokuCell getCell(int row, int col) => cells[row][col];

  void setCell(int row, int col, int? value, CellType type) {
    cells[row][col].value = value;
    cells[row][col].type = type;
    if (value != null) {
      cells[row][col].domain = {value};
    } else {
      cells[row][col].domain = {1, 2, 3, 4, 5, 6, 7, 8, 9};
    }
  }

  List<SudokuCell> getRow(int row) => cells[row];

  List<SudokuCell> getColumn(int col) =>
      List.generate(9, (row) => cells[row][col]);

  List<SudokuCell> getBox(int row, int col) {
    final startRow = (row ~/ 3) * 3;
    final startCol = (col ~/ 3) * 3;
    final box = <SudokuCell>[];
    for (var r = startRow; r < startRow + 3; r++) {
      for (var c = startCol; c < startCol + 3; c++) {
        box.add(cells[r][c]);
      }
    }
    return box;
  }

  List<SudokuCell> getNeighbors(int row, int col) {
    final neighbors = <SudokuCell>{};
    neighbors.addAll(getRow(row));
    neighbors.addAll(getColumn(col));
    neighbors.addAll(getBox(row, col));
    neighbors.remove(cells[row][col]);
    return neighbors.toList();
  }

  bool get isSolved =>
      cells.every((row) => row.every((cell) => cell.value != null));

  void loadPuzzle(List<List<int>> puzzle) {
    for (var row = 0; row < 9; row++) {
      for (var col = 0; col < 9; col++) {
        final val = puzzle[row][col];
        if (val != 0) {
          setCell(row, col, val, CellType.given);
        } else {
          setCell(row, col, null, CellType.empty);
        }
      }
    }
  }

  List<List<int>> toGrid() => List.generate(
    9,
    (row) => List.generate(9, (col) => cells[row][col].value ?? 0),
  );
}
