import 'package:flutter/material.dart';

import '../../../../presentation/theme/app_colors.dart';
import '../../../../domain/entities/ndvi_scene_entity.dart';

class NdviSummaryCard extends StatelessWidget {
  final NdviSceneEntity? scene;
  final void Function(BuildContext context)? onTap;

  const NdviSummaryCard({
    super.key,
    this.scene,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (scene == null) {
      return _buildEmpty(context);
    }

    final percent = (scene!.avgNdvi * 100).clamp(0, 100).toStringAsFixed(0);
    final clouds = scene!.cloudCoverage.toStringAsFixed(0);

    return InkWell(
      onTap: onTap != null ? () => onTap!(context) : null,
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
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.terrain,
              size: 36,
              color: AppColors.primaryDark,
            ),
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
                    'متوسط: $percent٪ • الغيوم: $clouds٪',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: scene!.avgNdvi.clamp(0.0, 1.0),
                      minHeight: 6,
                      backgroundColor: Colors.white,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.terrain, size: 28, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'لا توجد بعد بيانات NDVI متاحة. افتح شاشة الحقل أو خريطة NDVI لبدء التحميل.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
