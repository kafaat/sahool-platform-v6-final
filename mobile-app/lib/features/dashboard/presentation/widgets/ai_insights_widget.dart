import 'package:go_router/go_router.dart';
import '../../../../presentation/router/routes.dart';
import 'package:flutter/material.dart';
import '../../../../presentation/theme/app_colors.dart';

class AiInsightsWidget extends StatelessWidget {
  const AiInsightsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.primaryLight.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.auto_awesome, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'توصيات الذكاء الاصطناعي',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'بناءً على تحليل بياناتك',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInsightItem(
            icon: Icons.water_drop,
            iconColor: Colors.blue,
            title: 'الري مطلوب',
            subtitle: 'حقل القمح الشمالي يحتاج ري خلال 24 ساعة',
            priority: 'عاجل',
            priorityColor: AppColors.error,
          ),
          const SizedBox(height: 12),
          _buildInsightItem(
            icon: Icons.pest_control,
            iconColor: Colors.orange,
            title: 'مراقبة الآفات',
            subtitle: 'تم رصد نشاط حشري في حقل البرسيم',
            priority: 'متوسط',
            priorityColor: AppColors.warning,
          ),
          const SizedBox(height: 12),
          _buildInsightItem(
            icon: Icons.trending_up,
            iconColor: AppColors.success,
            title: 'فرصة حصاد',
            subtitle: 'حقل الشعير جاهز للحصاد خلال أسبوع',
            priority: 'تنبيه',
            priorityColor: AppColors.info,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String priority,
    required Color priorityColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: priorityColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              priority,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: priorityColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => navigatorKey.currentContext?.go(Routes.aiChat),
              icon: const Icon(Icons.chat_bubble_outline, size: 16),
              label: const Text(
                'فتح المساعد الذكي',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),

