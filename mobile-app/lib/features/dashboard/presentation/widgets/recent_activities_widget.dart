import 'package:flutter/material.dart';
import '../../../../presentation/theme/app_colors.dart';

class RecentActivitiesWidget extends StatelessWidget {
  const RecentActivitiesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'النشاط الأخير',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _buildActivityItem(
          icon: Icons.check_circle,
          iconColor: AppColors.success,
          title: 'تم إكمال مهمة الري',
          subtitle: 'حقل القمح الجنوبي',
          time: 'منذ 2 ساعة',
        ),
        _buildActivityItem(
          icon: Icons.satellite_alt,
          iconColor: AppColors.info,
          title: 'تحديث صور الأقمار الصناعية',
          subtitle: 'جميع الحقول',
          time: 'منذ 4 ساعات',
        ),
        _buildActivityItem(
          icon: Icons.warning_amber,
          iconColor: AppColors.warning,
          title: 'تنبيه: انخفاض رطوبة التربة',
          subtitle: 'حقل البرسيم',
          time: 'منذ 6 ساعات',
        ),
        _buildActivityItem(
          icon: Icons.eco,
          iconColor: AppColors.primary,
          title: 'تحليل NDVI جديد',
          subtitle: 'حقل الشعير - NDVI: 0.82',
          time: 'أمس',
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
