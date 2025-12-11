import 'package:flutter/material.dart';
import 'field_astral_engine.dart';

class AstralTipToday extends StatelessWidget {
  const AstralTipToday({super.key});

  @override
  Widget build(BuildContext context) {
    final house = FieldAstralEngine.currentHouse();
    final recommendation = FieldAstralEngine.analyzeField(
      cropType: null,
      fieldAreaHa: null,
      regionTag: 'yemen',
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.auto_awesome, color: Colors.deepPurple.shade400),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'التقويم الزراعي الفلكي اليوم – منزلة: ${house.name}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  recommendation.summary,
                  style: const TextStyle(fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
