import 'package:flutter/material.dart';
import '../../../../presentation/theme/app_colors.dart';

/// مقارنة NDVI بين تاريخين - مثل Climate FieldView
class NdviComparisonWidget extends StatefulWidget {
  final String beforeImageUrl;
  final String afterImageUrl;
  final String beforeDate;
  final String afterDate;
  final double beforeNdvi;
  final double afterNdvi;

  const NdviComparisonWidget({
    super.key,
    required this.beforeImageUrl,
    required this.afterImageUrl,
    required this.beforeDate,
    required this.afterDate,
    required this.beforeNdvi,
    required this.afterNdvi,
  });

  @override
  State<NdviComparisonWidget> createState() => _NdviComparisonWidgetState();
}

class _NdviComparisonWidgetState extends State<NdviComparisonWidget> {
  double _sliderPosition = 0.5;

  @override
  Widget build(BuildContext context) {
    final change = widget.afterNdvi - widget.beforeNdvi;
    final changePercent = (change / widget.beforeNdvi * 100).abs();
    final isImproved = change > 0;

    return Column(
      children: [
        // Header with dates and values
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            children: [
              // Before
              Expanded(
                child: _buildDateCard(
                  date: widget.beforeDate,
                  ndvi: widget.beforeNdvi,
                  label: 'قبل',
                  color: AppColors.warning,
                ),
              ),
              
              // Change indicator
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isImproved ? AppColors.successLight : AppColors.errorLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isImproved ? Icons.trending_up : Icons.trending_down,
                      color: isImproved ? AppColors.success : AppColors.error,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${changePercent.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isImproved ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
              
              // After
              Expanded(
                child: _buildDateCard(
                  date: widget.afterDate,
                  ndvi: widget.afterNdvi,
                  label: 'بعد',
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ),
        
        // Comparison View
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    _sliderPosition = (details.localPosition.dx / constraints.maxWidth)
                        .clamp(0.0, 1.0);
                  });
                },
                child: Stack(
                  children: [
                    // After Image (Full)
                    Positioned.fill(
                      child: _buildMapPlaceholder(
                        widget.afterNdvi,
                        'بعد: ${widget.afterDate}',
                        false,
                      ),
                    ),
                    
                    // Before Image (Clipped)
                    ClipRect(
                      clipper: _ComparisonClipper(_sliderPosition),
                      child: _buildMapPlaceholder(
                        widget.beforeNdvi,
                        'قبل: ${widget.beforeDate}',
                        true,
                      ),
                    ),
                    
                    // Slider Line
                    Positioned(
                      left: constraints.maxWidth * _sliderPosition - 2,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 4,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Slider Handle
                    Positioned(
                      left: constraints.maxWidth * _sliderPosition - 24,
                      top: constraints.maxHeight / 2 - 24,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.swap_horiz,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                    ),
                    
                    // Labels
                    Positioned(
                      left: 16,
                      bottom: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'قبل',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 16,
                      bottom: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'بعد',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateCard({
    required String date,
    required double ndvi,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.getNdviColor(ndvi),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                ndvi.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getNdviColor(ndvi),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder(double ndvi, String label, bool isBefore) {
    // In production, this would be actual map tiles
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isBefore
              ? [Colors.brown.shade300, Colors.brown.shade500]
              : [Colors.green.shade300, Colors.green.shade600],
        ),
      ),
      child: CustomPaint(
        painter: _NdviPatternPainter(ndvi, isBefore),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _ComparisonClipper extends CustomClipper<Rect> {
  final double position;
  
  _ComparisonClipper(this.position);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * position, size.height);
  }

  @override
  bool shouldReclip(_ComparisonClipper oldClipper) => position != oldClipper.position;
}

class _NdviPatternPainter extends CustomPainter {
  final double ndvi;
  final bool isBefore;

  _NdviPatternPainter(this.ndvi, this.isBefore);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw NDVI color zones pattern
    final paint = Paint()..style = PaintingStyle.fill;
    final random = isBefore ? 42 : 17; // Seed for consistent pattern
    
    for (var i = 0; i < 20; i++) {
      for (var j = 0; j < 20; j++) {
        final variation = ((i * random + j) % 10) / 100;
        final localNdvi = (ndvi + variation - 0.05).clamp(0.0, 1.0);
        paint.color = AppColors.getNdviColor(localNdvi).withOpacity(0.7);
        
        canvas.drawRect(
          Rect.fromLTWH(
            i * size.width / 20,
            j * size.height / 20,
            size.width / 20,
            size.height / 20,
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
