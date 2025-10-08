import 'package:flutter/material.dart';

/// Custom painter for drawing diagonal lines from selected cell to grid corners
class DiagonalLinesPainter extends CustomPainter {
  final int selectedRow;
  final int selectedColumn;
  final int gridSize;

  DiagonalLinesPainter({
    required this.selectedRow,
    required this.selectedColumn,
    required this.gridSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = (size.width - (gridSize - 1) * 8) / gridSize;
    final spacing = 8.0;
    final selectedCenterX = (selectedColumn * (cellSize + spacing)) + (cellSize / 2);
    final selectedCenterY = (selectedRow * (cellSize + spacing)) + (cellSize / 2);
    final selectedCenter = Offset(selectedCenterX, selectedCenterY);

    _drawDiagonalLines(canvas, selectedCenter, size);
 
    _drawCrossLines(canvas, selectedCenter, size);
  }

  void _drawDiagonalLines(Canvas canvas, Offset selectedCenter, Size size) {
    final diagonalPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    // Calculate the actual grid bounds
    final cellSize = (size.width - (gridSize - 1) * 8) / gridSize;

    // Four corners of the entire grid
    final topLeft = Offset(cellSize / 2, cellSize / 2);
    final topRight = Offset(size.width - cellSize / 2, cellSize / 2);
    final bottomLeft = Offset(cellSize / 2, size.height - cellSize / 2);
    final bottomRight = Offset(size.width - cellSize / 2, size.height - cellSize / 2);

    final corners = [topLeft, topRight, bottomLeft, bottomRight];

    for (final corner in corners) {
     
      final glowPaint = Paint()
        ..color = Colors.white.withOpacity(0.4)
        ..strokeWidth = 5.0
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      canvas.drawLine(selectedCenter, corner, glowPaint);
      
      // Draw main diagonal line
      canvas.drawLine(selectedCenter, corner, diagonalPaint);
    }
  }

  /// Draw horizontal and vertical lines through the selected cell
  void _drawCrossLines(Canvas canvas, Offset selectedCenter, Size size) {
    final crossPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    //this is Horizontal line drawing
    canvas.drawLine(
      Offset(0, selectedCenter.dy),
      Offset(size.width, selectedCenter.dy),
      crossPaint,
    );

    // Vertical line
    canvas.drawLine(
      Offset(selectedCenter.dx, 0),
      Offset(selectedCenter.dx, size.height),
      crossPaint,
    );
  }

  @override
  bool shouldRepaint(DiagonalLinesPainter oldDelegate) {
    return oldDelegate.selectedRow != selectedRow ||
           oldDelegate.selectedColumn != selectedColumn ||
           oldDelegate.gridSize != gridSize;
  }
}

/// this is Custom painter for animated line drawing effect
class AnimatedDiagonalLinesPainter extends CustomPainter {
  final int selectedRow;
  final int selectedColumn;
  final int gridSize;
  final double animationValue;

  AnimatedDiagonalLinesPainter({
    required this.selectedRow,
    required this.selectedColumn,
    required this.gridSize,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha((255 * animationValue).round())
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final cellSize = (size.width - (gridSize - 1) * 8) / gridSize;
    final spacing = 8.0;

   
    final selectedCenterX = (selectedColumn * (cellSize + spacing)) + (cellSize / 2);
    final selectedCenterY = (selectedRow * (cellSize + spacing)) + (cellSize / 2);

    final corners = [
      Offset(cellSize / 2, cellSize / 2),
      Offset(
        (gridSize - 1) * (cellSize + spacing) + (cellSize / 2),
        cellSize / 2,
      ),
      Offset(
        cellSize / 2,
        (gridSize - 1) * (cellSize + spacing) + (cellSize / 2),
      ),
      Offset(
        (gridSize - 1) * (cellSize + spacing) + (cellSize / 2),
        (gridSize - 1) * (cellSize + spacing) + (cellSize / 2),
      ),
    ];

    final selectedCenter = Offset(selectedCenterX, selectedCenterY);

    //it will Draw animated lines from selected cell to each corner
    for (final corner in corners) {
      if ((corner - selectedCenter).distance < cellSize / 2) {
        continue;
      }

      //it will Calculate animated end point
      final animatedEndPoint = Offset(
        selectedCenter.dx + (corner.dx - selectedCenter.dx) * animationValue,
        selectedCenter.dy + (corner.dy - selectedCenter.dy) * animationValue,
      );

      canvas.drawLine(selectedCenter, animatedEndPoint, paint);
    }
  }

  @override
  bool shouldRepaint(AnimatedDiagonalLinesPainter oldDelegate) {
    return oldDelegate.selectedRow != selectedRow ||
           oldDelegate.selectedColumn != selectedColumn ||
           oldDelegate.gridSize != gridSize ||
           oldDelegate.animationValue != animationValue;
  }
}