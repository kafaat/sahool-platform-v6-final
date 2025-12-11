import 'package:flutter/material.dart';
import '../../../../presentation/theme/app_colors.dart';
import '../../../../domain/entities/ndvi_scene_entity.dart';

class NdviSummaryCard extends StatelessWidget {
  final NdviSceneEntity? scene;
  final VoidCallback? onTap;

  const NdviSummaryCard({
    super.key,
    required this.scene,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (scene == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE8F5E9),
              Color(0xFFC8E6C9),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.terrain, size: 32, color: AppColors.primaryDark),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'مؤشر حيوية الحقل (NDVI)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'متوسط: \${(scene!.avgNdvi * 100).toStringAsFixed(0)}٪ • غيوم: \${scene!.cloudCoverage.toStringAsFixed(0)}٪',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: scene!.avgNdvi.clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
