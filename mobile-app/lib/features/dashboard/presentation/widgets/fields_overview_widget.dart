import 'package:flutter/material.dart';
import '../../../../presentation/theme/app_colors.dart';

class FieldsOverviewWidget extends StatelessWidget {
  const FieldsOverviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'حقولي',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('عرض الكل'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildFieldCard(
                name: 'حقل القمح الشمالي',
                crop: 'قمح',
                area: '25 هكتار',
                ndvi: 0.78,
                status: 'نمو',
                statusColor: AppColors.success,
              ),
              _buildFieldCard(
                name: 'حقل البرسيم',
                crop: 'برسيم',
                area: '15 هكتار',
                ndvi: 0.65,
                status: 'ري مطلوب',
                statusColor: AppColors.warning,
              ),
              _buildFieldCard(
                name: 'حقل الشعير',
                crop: 'شعير',
                area: '20 هكتار',
                ndvi: 0.82,
                status: 'جاهز للحصاد',
                statusColor: AppColors.info,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFieldCard({
    required String name,
    required String crop,
    required String area,
    required double ndvi,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(left: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.landscape, color: AppColors.primary, size: 22),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '$crop • $area',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              const Text(
                'NDVI: ',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              Text(
                ndvi.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getNdviColor(ndvi),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: ndvi,
                    backgroundColor: AppColors.neutral200,
                    valueColor: AlwaysStoppedAnimation(AppColors.getNdviColor(ndvi)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
