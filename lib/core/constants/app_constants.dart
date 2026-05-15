abstract class AppConstants {
  // Grid
  static const int gridSize = 9;
  static const int boxSize = 3;
  static const int totalCells = 81;

  // Difficulty — how many cells are revealed
  static const int easyClues = 45;
  static const int mediumClues = 32;
  static const int hardClues = 25;

  // Animation durations
  static const Duration fastAnim = Duration(milliseconds: 150);
  static const Duration normalAnim = Duration(milliseconds: 300);
  static const Duration slowAnim = Duration(milliseconds: 500);

  // Arc consistency step delay (for visualization)
  static const Duration arcStepDelay = Duration(milliseconds: 80);
}
