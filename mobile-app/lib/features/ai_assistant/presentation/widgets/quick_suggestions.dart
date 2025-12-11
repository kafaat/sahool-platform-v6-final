import 'package:flutter/material.dart';

import '../../../../presentation/theme/app_colors.dart';

typedef SuggestionTapCallback = void Function(String text);

class QuickSuggestions extends StatelessWidget {
  final SuggestionTapCallback onTap;

  const QuickSuggestions({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final suggestions = <String>[
      'حلل لي حالة الحقل بناءً على NDVI والطقس',
      'اقترح برنامج ري للأيام القادمة',
      'ما هي مخاطر الإجهاد الحراري هذا الأسبوع؟',
      'كيف أوزع السماد العضوي على أكثر من موسم؟',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: suggestions
            .map(
              (s) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActionChip(
                  label: Text(
                    s,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: AppColors.primarySurface,
                  onPressed: () => onTap(s),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
