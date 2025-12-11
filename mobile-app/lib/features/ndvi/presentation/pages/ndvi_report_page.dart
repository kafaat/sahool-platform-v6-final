import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../presentation/theme/app_colors.dart';
import '../bloc/ndvi_bloc.dart';

/// صفحة تقرير NDVI تعرض:
/// - تطور NDVI عبر الزمن (خطّي)
/// - نسبة الغيوم لكل مشهد (أعمدة)
class NdviReportPage extends StatelessWidget {
  const NdviReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NdviBloc()..add(NdviLoadRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تقرير NDVI'),
        ),
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<NdviBloc, NdviState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.scenes.isEmpty) {
                  return const Center(
                    child: Text('لا توجد بيانات NDVI لعرض التقرير.'),
                  );
                }

                final scenes = state.scenes.reversed.toList(); // الأقدم أولاً
                return ListView(
                  children: [
                    const Text(
                      'تطور مؤشر NDVI عبر الزمن',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 220,
                      child: _NdviLineChart(scenes: scenes),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'نسبة الغيوم لكل مشهد',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 220,
                      child: _CloudsBarChart(scenes: scenes),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _NdviLineChart extends StatelessWidget {
  final List<dynamic> scenes;
  const _NdviLineChart({required this.scenes});

  @override
  Widget build(BuildContext context) {
    final spots = <FlSpot>[];
    for (var i = 0; i < scenes.length; i++) {
      final s = scenes[i];
      spots.add(FlSpot(i.toDouble(), s.avgNdvi));
    }

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 1,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: 0.2,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= scenes.length) {
                  return const SizedBox();
                }
                final date = scenes[idx].date as DateTime;
                return Text(
                  '${date.day}/${date.month}',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            spots: spots,
            dotData: const FlDotData(show: true),
            barWidth: 3,
          ),
        ],
        gridData: const FlGridData(show: true),
      ),
    );
  }
}

class _CloudsBarChart extends StatelessWidget {
  final List<dynamic> scenes;
  const _CloudsBarChart({required this.scenes});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        maxY: 100,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: 20,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= scenes.length) {
                  return const SizedBox();
                }
                final date = scenes[idx].date as DateTime;
                return Text(
                  '${date.day}/${date.month}',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
        ),
        barGroups: List.generate(scenes.length, (i) {
          final s = scenes[i];
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: s.cloudCoverage,
                width: 14,
              ),
            ],
          );
        }),
        gridData: const FlGridData(show: true),
      ),
    );
  }
}
