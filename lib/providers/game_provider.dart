import 'package:flutter_riverpod/flutter_riverpod.dart';


/// Holds information about selected cell, grid size, and highlight states
class GameState {
  final int? selectedRow;
  final int? selectedColumn;
  final int gridSize;
  final Map<String, bool> highlightedCells;

  const GameState({
    this.selectedRow,
    this.selectedColumn,
    this.gridSize = 3,
    this.highlightedCells = const {},
  });

  /// Copy method to create new state with updated values
  GameState copyWith({
    int? selectedRow,
    int? selectedColumn,
    int? gridSize,
    Map<String, bool>? highlightedCells,
    bool clearSelection = false,
  }) {
    return GameState(
      selectedRow: clearSelection ? null : (selectedRow ?? this.selectedRow),
      selectedColumn: clearSelection ? null : (selectedColumn ?? this.selectedColumn),
      gridSize: gridSize ?? this.gridSize,
      highlightedCells: clearSelection ? {} : (highlightedCells ?? this.highlightedCells),
    );
  }

  /// Check if a cell is the selected cell (red indicator)
  bool isSelectedCell(int row, int col) {
    return selectedRow == row && selectedColumn == col;
  }

  /// Check if a cell should have green indicator (same row)
  bool isRowHighlighted(int row, int col) {
    return selectedRow != null && selectedRow == row && !isSelectedCell(row, col);
  }

  /// Check if a cell should have yellow indicator (same column)
  bool isColumnHighlighted(int row, int col) {
    return selectedColumn != null && selectedColumn == col && !isSelectedCell(row, col);
  }
}

/// StateNotifier for managing game state changes
class GameNotifier extends StateNotifier<GameState> {
  GameNotifier() : super(const GameState());

  /// Set the grid size when user enters a number
  void setGridSize(int size) {
    state = state.copyWith(
      gridSize: size,
      clearSelection: true,
    );
  }

  /// Handle cell tap - update selected cell and highlighting
  void selectCell(int row, int col) {
    state = state.copyWith(
      selectedRow: row,
      selectedColumn: col,
    );
  }

  /// Clear all selections and highlighting
  void clearSelection() {
    state = state.copyWith(clearSelection: true);
  }
}

/// Provider instance for game state management
final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier();
});