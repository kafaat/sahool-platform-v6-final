import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../presentation/router/routes.dart';
import '../../../../presentation/theme/app_colors.dart';

class AiInsightsMini extends StatelessWidget {
  const AiInsightsMini({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go(Routes.aiChat),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: const [
            Icon(Icons.psychology, color: Colors.white, size: 32),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'مساعد سهول الذكي جاهز لتحليل بيانات الحقول (NDVI، الطقس، الري، التربة) '
                'وإعطاء توصيات فورية.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
