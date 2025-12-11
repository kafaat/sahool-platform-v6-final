import 'package:flutter/material.dart';
import '../../../../presentation/theme/app_colors.dart';

class NdviLegend extends StatelessWidget {
  const NdviLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        _LegendItem(color: Colors.brown, label: 'ضعيف'),
        SizedBox(width: 8),
        _LegendItem(color: Colors.yellow, label: 'متوسط'),
        SizedBox(width: 8),
        _LegendItem(color: AppColors.primary, label: 'جيد'),
        SizedBox(width: 8),
        _LegendItem(color: AppColors.primaryDark, label: 'عالي'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11),
        ),
      ],
    );
  }
}
