import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../presentation/router/routes.dart';
import '../../../../presentation/theme/app_colors.dart';
import '../../data/analytics_repository.dart';
import '../bloc/analytics_overview_bloc.dart';
import '../bloc/analytics_overview_event.dart';
import '../bloc/analytics_overview_state.dart';

class AnalyticsOverviewPage extends StatelessWidget {
  const AnalyticsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AnalyticsOverviewBloc(getIt<AnalyticsRepository>())
        ..add(const LoadAnalyticsOverview()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('لوحة تحليلات المزرعة'),
        ),
        body: BlocBuilder<AnalyticsOverviewBloc, AnalyticsOverviewState>(
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

            final data = state.data ?? {};
            final fieldsCount = data['fields_count'] ?? 0;
            final avgNdvi = (data['avg_ndvi'] ?? 0.0) as num;
            final totalWater = (data['total_water_m3'] ?? 0.0) as num;
            final livestockHealth =
                (data['livestock_health_index'] ?? 0.0) as num;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _OverviewStatsRow(
                  fieldsCount: fieldsCount,
                  avgNdvi: avgNdvi.toDouble(),
                  totalWater: totalWater.toDouble(),
                  livestockHealth: livestockHealth.toDouble(),
                ),
                const SizedBox(height: 24),
                _SectionHeader(
                  title: 'لوحات تحليلات تفصيلية',
                  subtitle: 'اختر نوع التحليلات التي تريد استكشافها بشكل أعمق',
                ),
                const SizedBox(height: 12),
                _AnalyticsNavCard(
                  icon: Icons.landscape,
                  title: 'تحليلات NDVI',
                  description: 'متابعة صحة الغطاء النباتي وتغيّرها زمنياً',
                  onTap: () => context.push(Routes.analyticsNdvi),
                ),
                const SizedBox(height: 12),
                _AnalyticsNavCard(
                  icon: Icons.water_drop,
                  title: 'تحليلات الري',
                  description: 'مراقبة استهلاك المياه وتحسين جداول الري',
                  onTap: () => context.push(Routes.analyticsIrrigation),
                ),
                const SizedBox(height: 12),
                _AnalyticsNavCard(
                  icon: Icons.analytics,
                  title: 'تحليلات المواشي',
                  description: 'توزيع الأنواع ومؤشر الصحة لكل نوع',
                  onTap: () => context.push(Routes.analyticsLivestock),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OverviewStatsRow extends StatelessWidget {
  final int fieldsCount;
  final double avgNdvi;
  final double totalWater;
  final double livestockHealth;

  const _OverviewStatsRow({
    required this.fieldsCount,
    required this.avgNdvi,
    required this.totalWater,
    required this.livestockHealth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _statCard('عدد الحقول', '$fieldsCount'),
            const SizedBox(width: 8),
            _statCard('متوسط NDVI', avgNdvi.toStringAsFixed(2)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _statCard('استهلاك المياه (م³)', totalWater.toStringAsFixed(1)),
            const SizedBox(width: 8),
            _statCard('مؤشر صحة المواشي', livestockHealth.toStringAsFixed(2)),
          ],
        ),
      ],
    );
  }

  Widget _statCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _SectionHeader({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ]
      ],
    );
  }
}

class _AnalyticsNavCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _AnalyticsNavCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 28, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
