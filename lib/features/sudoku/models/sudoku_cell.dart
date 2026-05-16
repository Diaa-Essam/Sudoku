enum CellType { given, user, solved, empty }

class SudokuCell {
  final int row;
  final int col;
  int? value;
  CellType type;
  Set<int> domain;
  bool isSelected;
  bool isHighlighted;
  bool hasError;

  SudokuCell({
    required this.row,
    required this.col,
    this.value,
    this.type = CellType.empty,
    Set<int>? domain,
    this.isSelected = false,
    this.isHighlighted = false,
    this.hasError = false,
  }) : domain = domain ?? {1, 2, 3, 4, 5, 6, 7, 8, 9};

  bool get isEmpty => value == null;
  bool get isGiven => type == CellType.given;

  SudokuCell copyWith({
    int? value,
    CellType? type,
    Set<int>? domain,
    bool? isSelected,
    bool? isHighlighted,
    bool? hasError,
  }) {
    return SudokuCell(
      row: row,
      col: col,
      value: value ?? this.value,
      type: type ?? this.type,
      domain: domain ?? Set.from(this.domain),
      isSelected: isSelected ?? this.isSelected,
      isHighlighted: isHighlighted ?? this.isHighlighted,
      hasError: hasError ?? this.hasError,
    );
  }
}
