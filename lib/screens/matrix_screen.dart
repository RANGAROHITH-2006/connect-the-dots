import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game1/providers/game_provider.dart';
import 'package:game1/widgets/diagonal_painter.dart';
import 'package:game1/widgets/grid_box.dart';

class MatrixScreen extends ConsumerWidget {
  const MatrixScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final gameNotifier = ref.read(gameProvider.notifier);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Level 1',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF2D1B69),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            gameNotifier.clearSelection();
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2D1B69), 
              Color(0xFF1A0E3F), 
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    gameState.selectedRow == null 
                        ? 'Press any box'
                        : 'Make Cross Connections',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final maxSize = constraints.maxWidth < constraints.maxHeight 
                            ? constraints.maxWidth 
                            : constraints.maxHeight;
                        final gridSize = (maxSize - 40).clamp(200.0, 400.0);
                        
                        return SizedBox(
                          width: gridSize,
                          height: gridSize,
                          child: Stack(
                            children: [

                              _buildGrid(gameState, gameNotifier, gridSize),
                              
                              if (gameState.selectedRow != null && gameState.selectedColumn != null)
                                Positioned.fill(
                                  child: CustomPaint(
                                    painter: DiagonalLinesPainter(
                                      selectedRow: gameState.selectedRow!,
                                      selectedColumn: gameState.selectedColumn!,
                                      gridSize: gameState.gridSize,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              
              // Reset button
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
            
                      gameNotifier.clearSelection();
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Game Reset!'),
                          duration: const Duration(milliseconds: 1000),
                          backgroundColor: const Color(0xFF4A90E2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the grid of tappable boxes
  Widget _buildGrid(GameState gameState, GameNotifier gameNotifier, double gridSize) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gameState.gridSize,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: gameState.gridSize * gameState.gridSize,
      itemBuilder: (context, index) {
        final row = index ~/ gameState.gridSize;
        final col = index % gameState.gridSize;
        
        return GridBox(
          row: row,
          column: col,
          gameState: gameState,
          onTap: () => gameNotifier.selectCell(row, col),
        );
      },
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D1B69),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'How to Play',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Tap any box to see the connection pattern:\n\n'
          '• Red circle: Selected box\n'
          '• Green circles: Same row\n'
          '• Yellow circles: Same column\n'
          '• White lines: Diagonal connections\n\n'
          'Try different boxes to see various patterns!',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Got it!',
              style: TextStyle(
                color: Color(0xFF4A90E2),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}