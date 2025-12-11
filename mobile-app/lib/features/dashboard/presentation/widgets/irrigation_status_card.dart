import 'package:flutter/material.dart';

class IrrigationStatusCard extends StatelessWidget {
  const IrrigationStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    // لاحقاً يمكن ربطها بـ IrrigationBloc لعرض بيانات حقيقية
    return _tile(
      title: 'الري',
      subtitle: 'جدولة 2 دورة ري اليوم',
      icon: Icons.grass,
      color: Colors.tealAccent.shade100,
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
