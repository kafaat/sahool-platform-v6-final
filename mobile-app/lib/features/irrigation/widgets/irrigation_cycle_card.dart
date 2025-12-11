import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IrrigationCycleCard extends StatelessWidget {
  final Map<String, dynamic> cycle;
  final VoidCallback? onDelete;

  const IrrigationCycleCard({
    super.key,
    required this.cycle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final zone = cycle['zone'] ?? '-';
    final duration = cycle['duration_minutes'] ?? 0;
    final startStr = cycle['start'] as String?;
    DateTime? start;
    if (startStr != null) {
      start = DateTime.tryParse(startStr);
    }
    final df = DateFormat('yyyy-MM-dd HH:mm');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            child: Text('$zone'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المنطقة: $zone',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'المدة: $duration دقيقة',
                  style: const TextStyle(color: Colors.grey),
                ),
                if (start != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'البدء: ${df.format(start.toLocal())}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ],
            ),
          ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }
}
