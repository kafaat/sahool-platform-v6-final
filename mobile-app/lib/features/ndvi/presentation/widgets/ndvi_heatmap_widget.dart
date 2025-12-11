import 'package:flutter/material.dart';
import '../../../../presentation/theme/app_colors.dart';

/// خريطة حرارية للمؤشرات الحيوية
class NdviHeatmapWidget extends StatelessWidget {
  final List<HeatmapPoint> points;
  final double minValue;
  final double maxValue;
  final String title;

  const NdviHeatmapWidget({
    super.key,
    required this.points,
    this.minValue = 0.0,
    this.maxValue = 1.0,
    this.title = 'خريطة NDVI الحرارية',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF5722), Color(0xFFFFEB3B), Color(0xFF4CAF50)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.whatshot, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${points.length} نقطة قياس',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Heatmap Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AspectRatio(
              aspectRatio: 1.5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CustomPaint(
                  painter: _HeatmapPainter(
                    points: points,
                    minValue: minValue,
                    maxValue: maxValue,
                  ),
                  child: Container(),
                ),
              ),
            ),
          ),
          
          // Color Scale
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'مقياس الألوان',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFF44336), // Red - Low
                        Color(0xFFFF9800), // Orange
                        Color(0xFFFFEB3B), // Yellow
                        Color(0xFF8BC34A), // Light Green
                        Color(0xFF4CAF50), // Green
                        Color(0xFF1B5E20), // Dark Green - High
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      minValue.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                    const Text(
                      'منخفض',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                    const Text(
                      'متوسط',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                    const Text(
                      'مرتفع',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                    Text(
                      maxValue.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Statistics
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    label: 'الحد الأدنى',
                    value: _calculateMin().toStringAsFixed(2),
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    label: 'المتوسط',
                    value: _calculateAverage().toStringAsFixed(2),
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    label: 'الحد الأقصى',
                    value: _calculateMax().toStringAsFixed(2),
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateMin() {
    if (points.isEmpty) return 0;
    return points.map((p) => p.value).reduce((a, b) => a < b ? a : b);
  }

  double _calculateMax() {
    if (points.isEmpty) return 0;
    return points.map((p) => p.value).reduce((a, b) => a > b ? a : b);
  }

  double _calculateAverage() {
    if (points.isEmpty) return 0;
    return points.map((p) => p.value).reduce((a, b) => a + b) / points.length;
  }
}

class _HeatmapPainter extends CustomPainter {
  final List<HeatmapPoint> points;
  final double minValue;
  final double maxValue;

  _HeatmapPainter({
    required this.points,
    required this.minValue,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / 20;
    final cellHeight = size.height / 15;
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw grid with interpolated values
    for (var row = 0; row < 15; row++) {
      for (var col = 0; col < 20; col++) {
        // Calculate interpolated NDVI value for this cell
        final x = col / 20;
        final y = row / 15;
        final value = _interpolateValue(x, y);
        
        paint.color = _getColorForValue(value);
        
        canvas.drawRect(
          Rect.fromLTWH(
            col * cellWidth,
            row * cellHeight,
            cellWidth,
            cellHeight,
          ),
          paint,
        );
      }
    }
    
    // Draw actual data points
    final pointPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.white.withOpacity(0.5);
    
    for (final point in points) {
      final px = point.x * size.width;
      final py = point.y * size.height;
      canvas.drawCircle(Offset(px, py), 4, pointPaint);
    }
  }

  double _interpolateValue(double x, double y) {
    if (points.isEmpty) return 0.5;
    
    // Simple inverse distance weighting
    double totalWeight = 0;
    double weightedSum = 0;
    
    for (final point in points) {
      final dx = x - point.x;
      final dy = y - point.y;
      final distance = (dx * dx + dy * dy).clamp(0.001, double.infinity);
      final weight = 1 / distance;
      
      totalWeight += weight;
      weightedSum += point.value * weight;
    }
    
    return weightedSum / totalWeight;
  }

  Color _getColorForValue(double value) {
    final normalized = ((value - minValue) / (maxValue - minValue)).clamp(0.0, 1.0);
    
    // Color gradient from red to green
    if (normalized < 0.2) {
      return Color.lerp(const Color(0xFFF44336), const Color(0xFFFF9800), normalized / 0.2)!;
    } else if (normalized < 0.4) {
      return Color.lerp(const Color(0xFFFF9800), const Color(0xFFFFEB3B), (normalized - 0.2) / 0.2)!;
    } else if (normalized < 0.6) {
      return Color.lerp(const Color(0xFFFFEB3B), const Color(0xFF8BC34A), (normalized - 0.4) / 0.2)!;
    } else if (normalized < 0.8) {
      return Color.lerp(const Color(0xFF8BC34A), const Color(0xFF4CAF50), (normalized - 0.6) / 0.2)!;
    } else {
      return Color.lerp(const Color(0xFF4CAF50), const Color(0xFF1B5E20), (normalized - 0.8) / 0.2)!;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HeatmapPoint {
  final double x; // 0 to 1
  final double y; // 0 to 1
  final double value;

  const HeatmapPoint({
    required this.x,
    required this.y,
    required this.value,
  });
}
