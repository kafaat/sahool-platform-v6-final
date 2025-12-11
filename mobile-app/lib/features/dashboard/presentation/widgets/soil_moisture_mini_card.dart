import 'package:flutter/material.dart';

class SoilMoistureMiniCard extends StatelessWidget {
  const SoilMoistureMiniCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _tile(
      title: 'رطوبة التربة',
      subtitle: '68٪ ضمن النطاق الآمن',
      icon: Icons.water_drop_outlined,
      color: Colors.lightBlueAccent.shade100,
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
