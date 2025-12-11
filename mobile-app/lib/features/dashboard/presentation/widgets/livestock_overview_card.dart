import 'package:flutter/material.dart';

class LivestockOverviewCard extends StatelessWidget {
  const LivestockOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    // يمكن ربطها بـ LivestockBloc لعرض بيانات حقيقية لكل حقل
    return _tile(
      title: 'الثروة الحيوانية',
      subtitle: 'إجمالي 45 رأس (أبقار / أغنام / ماعز)',
      icon: Icons.pets,
      color: Colors.brown.shade100,
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
