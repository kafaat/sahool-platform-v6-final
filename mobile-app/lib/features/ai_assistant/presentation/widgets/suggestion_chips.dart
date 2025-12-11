import 'package:flutter/material.dart';
import '../../../../presentation/theme/app_colors.dart';
import '../../domain/entities/ai_message.dart';

class SuggestionChips extends StatelessWidget {
  final List<AiSuggestion> suggestions;
  final void Function(AiSuggestion) onTap;

  const SuggestionChips({
    super.key,
    required this.suggestions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: suggestions.map((suggestion) {
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: ActionChip(
                avatar: suggestion.icon != null
                    ? Icon(_getIcon(suggestion.icon!), size: 18, color: AppColors.primary)
                    : null,
                label: Text(
                  suggestion.text,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                  ),
                ),
                onPressed: () => onTap(suggestion),
                backgroundColor: AppColors.primarySurface,
                side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'landscape': return Icons.landscape;
      case 'cloud': return Icons.cloud;
      case 'assignment': return Icons.assignment;
      case 'satellite': return Icons.satellite_alt;
      case 'info': return Icons.info_outline;
      case 'schedule': return Icons.schedule;
      case 'calendar': return Icons.calendar_today;
      case 'warning': return Icons.warning_amber;
      case 'add': return Icons.add;
      case 'list': return Icons.list;
      case 'map': return Icons.map;
      case 'history': return Icons.history;
      default: return Icons.chat_bubble_outline;
    }
  }
}
