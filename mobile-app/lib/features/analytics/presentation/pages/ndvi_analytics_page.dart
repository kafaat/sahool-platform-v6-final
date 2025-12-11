import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/di/injection.dart';
import '../../data/analytics_repository.dart';

class NdviAnalyticsPage extends StatefulWidget {
  const NdviAnalyticsPage({super.key});

  @override
  State<NdviAnalyticsPage> createState() => _NdviAnalyticsPageState();
}

class _NdviAnalyticsPageState extends State<NdviAnalyticsPage> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _points = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final repo = getIt<AnalyticsRepository>();
      // لاحقاً يمكنك تمرير fieldId حقيقي من صفحة الحقل
      final data = await repo.fetchNdviTrend('global');
      setState(() {
        _points = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'فشل في تحميل بيانات NDVI';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        appBar: AppBar(title: Text('تحليلات NDVI')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('تحليلات NDVI')),
        body: Center(child: Text(_error!)),
      );
    }
    if (_points.isEmpty) {
      return const Scaffold(
        appBar: AppBar(title: Text('تحليلات NDVI')),
        body: Center(child: Text('لا توجد بيانات كافية')),
      );
    }

    final spots = <FlSpot>[];
    for (var i = 0; i < _points.length; i++) {
      final p = _points[i];
      final v = (p['value'] ?? 0.0) as num;
      spots.add(FlSpot(i.toDouble(), v.toDouble()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('تحليلات NDVI')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: 1,
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                barWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
