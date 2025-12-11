import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/di/injection.dart';
import '../data/livestock_repository.dart';
import '../bloc/livestock_bloc.dart';
import '../bloc/livestock_event.dart';
import '../bloc/livestock_state.dart';

class LivestockAnalyticsPage extends StatelessWidget {
  final String fieldId;

  const LivestockAnalyticsPage({super.key, required this.fieldId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LivestockBloc(getIt<LivestockRepository>())
        ..add(LoadLivestock(fieldId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تحليلات المواشي'),
        ),
        body: BlocBuilder<LivestockBloc, LivestockState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null) {
              return Center(
                child: Text(
                  state.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            if (state.items.isEmpty) {
              return const Center(
                child: Text('لا توجد بيانات مواشي لهذا الحقل'),
              );
            }

            final totalCount = state.items
                .map((e) => (e['count'] ?? 0) as int)
                .fold<int>(0, (a, b) => a + b);

            final Map<String, int> countByType = {};
            final Map<String, double> healthByType = {};
            final Map<String, int> healthCountByType = {};

            for (final item in state.items) {
              final type = (item['type'] ?? 'غير محدد').toString();
              final count = (item['count'] ?? 0) as int;
              final health = (item['health_index'] ?? 0.0) as double;

              countByType[type] = (countByType[type] ?? 0) + count;
              healthByType[type] = (healthByType[type] ?? 0) + health;
              healthCountByType[type] =
                  (healthCountByType[type] ?? 0) + 1;
            }

            final avgHealthByType = <String, double>{};
            for (final entry in healthByType.entries) {
              final type = entry.key;
              final sum = entry.value;
              final c = healthCountByType[type] ?? 1;
              avgHealthByType[type] = sum / c;
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _SummaryCard(
                  totalCount: totalCount,
                  typesCount: countByType.length,
                ),
                const SizedBox(height: 16),
                const _SectionTitle('توزيع المواشي حسب النوع'),
                SizedBox(
                  height: 220,
                  child: _LivestockPieChart(countByType: countByType),
                ),
                const SizedBox(height: 16),
                const _SectionTitle('متوسط مؤشر الصحة لكل نوع'),
                SizedBox(
                  height: 220,
                  child: _HealthBarChart(
                    avgHealthByType: avgHealthByType,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final int totalCount;
  final int typesCount;

  const _SummaryCard({
    required this.totalCount,
    required this.typesCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            _item('إجمالي المواشي', '$totalCount'),
            const SizedBox(width: 12),
            _item('عدد الأنواع', '$typesCount'),
          ],
        ),
      ),
    );
  }

  Widget _item(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style:
          Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16),
    );
  }
}

class _LivestockPieChart extends StatelessWidget {
  final Map<String, int> countByType;

  const _LivestockPieChart({
    required this.countByType,
  });

  @override
  Widget build(BuildContext context) {
    final total = countByType.values
        .fold<int>(0, (previousValue, element) => previousValue + element);
    if (total == 0) {
      return const Center(child: Text('لا توجد بيانات كافية'));
    }

    final sections = <PieChartSectionData>[];
    for (final entry in countByType.entries) {
      final value = entry.value.toDouble();
      final percent = (value / total * 100).toStringAsFixed(0);
      sections.add(
        PieChartSectionData(
          value: value,
          title: '$percent%',
          radius: 70,
          titleStyle: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return PieChart(
      PieChartData(
        sections: sections,
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }
}

class _HealthBarChart extends StatelessWidget {
  final Map<String, double> avgHealthByType;

  const _HealthBarChart({
    required this.avgHealthByType,
  });

  @override
  Widget build(BuildContext context) {
    if (avgHealthByType.isEmpty) {
      return const Center(child: Text('لا توجد بيانات كافية'));
    }

    final types = avgHealthByType.keys.toList();
    return BarChart(
      BarChartData(
        barGroups: List.generate(types.length, (i) {
          final type = types[i];
          final value = avgHealthByType[type] ?? 0;
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: value.clamp(0, 1),
                width: 18,
              ),
            ],
          );
        }),
        maxY: 1.0,
      ),
    );
  }
}
