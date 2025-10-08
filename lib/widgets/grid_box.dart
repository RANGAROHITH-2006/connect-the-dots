import 'package:flutter/material.dart';
import 'package:game1/providers/game_provider.dart';


/// Individual grid box widget with indicator logic
class GridBox extends StatefulWidget {
  final int row;
  final int column;
  final GameState gameState;
  final VoidCallback onTap;

  const GridBox({
    super.key,
    required this.row,
    required this.column,
    required this.gameState,
    required this.onTap,
  });

  @override
  State<GridBox> createState() => _GridBoxState();
}

class _GridBoxState extends State<GridBox> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _indicatorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _indicatorAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(GridBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Animate when this box becomes highlighted or selected
    if (_shouldShowIndicator() && !_wasShowingIndicator(oldWidget.gameState)) {
      _animationController.forward();
    } else if (!_shouldShowIndicator() && _wasShowingIndicator(oldWidget.gameState)) {
      _animationController.reverse();
    }
  }

  /// Check if this box should show an indicator
  bool _shouldShowIndicator() {
    return widget.gameState.isSelectedCell(widget.row, widget.column) ||
           widget.gameState.isRowHighlighted(widget.row, widget.column) ||
           widget.gameState.isColumnHighlighted(widget.row, widget.column);
  }

  /// Check if this box was showing indicator in the previous state
  bool _wasShowingIndicator(GameState oldState) {
    return oldState.isSelectedCell(widget.row, widget.column) ||
           oldState.isRowHighlighted(widget.row, widget.column) ||
           oldState.isColumnHighlighted(widget.row, widget.column);
  }

  /// Get the indicator color based on the highlight type 
  Color _getIndicatorColor() {
    if (widget.gameState.isSelectedCell(widget.row, widget.column)) {
      return Colors.red; 
    } else if (widget.gameState.isRowHighlighted(widget.row, widget.column)) {
      return Colors.green; 
    } else if (widget.gameState.isColumnHighlighted(widget.row, widget.column)) {
      return Colors.yellow; 
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
        // Brief tap animation
        _animationController.forward().then((_) {
          if (mounted) {
            _animationController.reverse();
          }
        });
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF4A3A7A), 
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF5A4A8A).withOpacity(0.8),
                          const Color(0xFF4A3A7A).withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
             
                  if (_shouldShowIndicator())
                    Center(
                      child: AnimatedBuilder(
                        animation: _indicatorAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _indicatorAnimation.value,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: _getIndicatorColor(),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: _getIndicatorColor().withOpacity(0.5),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                 
                  Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: widget.onTap,
                      splashColor: Colors.white.withOpacity(0.2),
                      highlightColor: Colors.white.withOpacity(0.1),
                      child: Container(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}