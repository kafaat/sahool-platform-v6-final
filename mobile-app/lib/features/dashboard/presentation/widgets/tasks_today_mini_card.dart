import 'package:flutter/material.dart';

class TasksTodayMiniCard extends StatelessWidget {
  const TasksTodayMiniCard({super.key});

  @override
  Widget build(BuildContext context) {
    // يمكن لاحقاً ربطها بـ TasksBloc لعرض بيانات حقيقية
    return _tile(
      title: 'مهام اليوم',
      subtitle: '3 مهام مستحقة في الحقول',
      icon: Icons.check_circle_outline,
      color: Colors.greenAccent.shade100,
    );
  }

  Widget _tile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
