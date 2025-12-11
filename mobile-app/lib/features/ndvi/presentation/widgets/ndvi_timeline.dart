import 'package:flutter/material.dart';
import '../../../../presentation/theme/app_colors.dart';
import '../../domain/entities/ndvi_data.dart';

class NdviTimeline extends StatelessWidget {
  final NdviHistory history;
  final DateTime selectedDate;
  final void Function(DateTime) onDateSelected;

  const NdviTimeline({
    super.key,
    required this.history,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.neutral300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'التاريخ الزمني',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      history.isImproving ? Icons.trending_up : Icons.trending_down,
                      color: history.isImproving ? AppColors.success : AppColors.error,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${(history.trend * 100).abs().toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: history.isImproving ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Timeline
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: history.history.length,
              itemBuilder: (context, index) {
                final data = history.history[index];
                final isSelected = _isSameDay(data.capturedAt, selectedDate);
                
                return GestureDetector(
                  onTap: () => onDateSelected(data.capturedAt),
                  child: Container(
                    width: 50,
                    margin: const EdgeInsets.only(left: 8),
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          width: 8,
                          decoration: BoxDecoration(
                            color: AppColors.getNdviColor(data.value),
                            borderRadius: BorderRadius.circular(4),
                            border: isSelected
                                ? Border.all(color: AppColors.primary, width: 2)
                                : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data.value.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? AppColors.primary : AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '${data.capturedAt.day}/${data.capturedAt.month}',
                          style: TextStyle(
                            fontSize: 8,
                            color: isSelected ? AppColors.primary : AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
