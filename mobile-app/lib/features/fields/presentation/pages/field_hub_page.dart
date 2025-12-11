import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../presentation/theme/app_colors.dart';
import '../../../../presentation/router/routes.dart';
import '../../../ndvi/presentation/widgets/ndvi_legend.dart';
import '../../astral/field_astral_engine.dart';
import '../../astral/field_astral_recommendation.dart';
import '../../../../core/di/injection.dart';
import '../../data/field_repository.dart';
import '../bloc/field_hub_cubit.dart';

class FieldHubPage extends StatelessWidget {
  const FieldHubPage({
    super.key,
    required this.fieldId,
    this.initialFieldName,
    this.initialCrop,
    this.initialAreaHa,
    this.initialNdvi,
  });

  final String fieldId;
  final String? initialFieldName;
  final String? initialCrop;
  final double? initialAreaHa;
  final double? initialNdvi;

  factory FieldHubPage.fromQuery(Map<String, String> query) {
    final fieldId = query['fieldId'] ?? 'unknown';
    final fieldName = query['fieldName'];
    final crop = query['crop'];
    final areaHa = double.tryParse(query['areaHa'] ?? '');
    final ndvi = double.tryParse(query['ndvi'] ?? '');
    return FieldHubPage(
      fieldId: fieldId,
      initialFieldName: fieldName,
      initialCrop: crop,
      initialAreaHa: areaHa,
      initialNdvi: ndvi,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FieldHubCubit>(
      create: (_) => FieldHubCubit(repository: FieldRepository(dio: getIt()))..load(fieldId),
      child: BlocBuilder<FieldHubCubit, FieldHubState>(
        builder: (context, state) {
          final field = state.field;
          final ndviValue = field?.ndviValue ?? initialNdvi ?? 0.65;
          final fieldName = field?.name ?? initialFieldName ?? 'حقل بدون اسم';
          final crop = field?.cropType ?? initialCrop ?? 'محصول غير محدد';
          final areaHa = field?.area ?? initialAreaHa ?? 0.0;

          final FieldAstralRecommendation astralRec =
              FieldAstralEngine.analyzeField(cropType: crop, ndvi: ndviValue);

          final temp = state.weatherSnapshot?['temperature']?.toString();
          final rainProb =
              state.weatherSnapshot?['rain_probability']?.toString();
          final soilMoisture =
              (state.soilSnapshot?['moisture_percent'] as num?)?.toDouble();

          return Scaffold(
            appBar: AppBar(
              title: const Text('لوحة الحقل المتكاملة'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.map_outlined),
                  tooltip: 'خريطة NDVI',
                  onPressed: () {
                    context.go(Routes.ndviMap);
                  },
                ),
              ],
            ),
            body: state.isLoading && field == null
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () async {
                      await context.read<FieldHubCubit>().load(fieldId);
                    },
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        _buildHeader(
                          context,
                          fieldId: fieldId,
                          fieldName: fieldName,
                          crop: crop,
                          areaHa: areaHa,
                          ndvi: ndviValue,
                          tasksCount: state.openTasksCount,
                        ),
                        const SizedBox(height: 16),
                        _buildAstralCard(context, astralRec),
                        const SizedBox(height: 16),
                        _buildNdviCard(context, ndviValue),
                        const SizedBox(height: 16),
                        _buildWeatherSoilRow(
                          context,
                          temp: temp,
                          rainProb: rainProb,
                          soilMoisture: soilMoisture,
                        ),
                        const SizedBox(height: 16),
                        _buildOperationsRow(context, fieldId: fieldId),
                        const SizedBox(height: 16),
                        _buildAiCard(
                          context,
                          fieldId: fieldId,
                          fieldName: fieldName,
                          crop: crop,
                          areaHa: areaHa,
                          ndvi: ndviValue,
                          astralRec: astralRec,
                          weatherSnapshot: state.weatherSnapshot,
                          soilSnapshot: state.soilSnapshot,
                          tasksCount: state.openTasksCount,
                        ),
                        if (state.error != null) ...<Widget>[
                          const SizedBox(height: 16),
                          Text(
                            state.error!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.red),
                          ),
                        ],
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context, {
    required String fieldId,
    required String fieldName,
    required String crop,
    required double areaHa,
    required double ndvi,
    required int tasksCount,
  }) {
    final ndviPercent = (ndvi * 100).toStringAsFixed(0);
    final isHealthy = ndvi >= 0.7;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fieldName,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text('المحصول: $crop'),
                  backgroundColor: AppColors.chipBackground,
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text('المساحة: ${areaHa.toStringAsFixed(1)} هـ'),
                  backgroundColor: AppColors.chipBackground,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isHealthy ? AppColors.success : AppColors.warning,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.spa, size: 16, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        'NDVI $ndviPercent%',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  isHealthy ? 'حيوية عالية' : 'تحتاج متابعة',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isHealthy ? AppColors.success : AppColors.warning,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                Text(
                  '#$fieldId',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.task_alt, size: 18),
                const SizedBox(width: 6),
                Text('مهام مفتوحة: $tasksCount'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAstralCard(
    BuildContext context,
    FieldAstralRecommendation rec,
  ) {
    return Card(
      color: AppColors.surfaceHighlight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.bedtime, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'التقويم الزراعي الفلكي',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              rec.currentMansionName,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(rec.astralAdvice),
            const SizedBox(height: 8),
            Text(
              rec.ndviAdvice,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: 8),
            Text(
              rec.cropAdvice,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNdviCard(BuildContext context, double ndvi) {
    final ndviPercent = (ndvi * 100).toStringAsFixed(0);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.terrain_outlined),
                const SizedBox(width: 8),
                Text(
                  'حالة الغطاء النباتي (NDVI)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Text(
                  '$ndviPercent%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const NdviLegend(),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  context.go(Routes.ndviMap);
                },
                icon: const Icon(Icons.fullscreen),
                label: const Text('فتح خريطة NDVI التفصيلية'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherSoilRow(
    BuildContext context, {
    String? temp,
    String? rainProb,
    double? soilMoisture,
  }) {
    return Row(
      children: [
        Expanded(
          child: _QuickStatCard(
            title: 'الطقس',
            value: temp != null ? '$temp°C' : '--',
            subtitle: rainProb != null ? 'إحتمال المطر: $rainProb%' : '',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickStatCard(
            title: 'رطوبة التربة',
            value: soilMoisture != null
                ? '${soilMoisture.toStringAsFixed(0)}%'
                : '--',
            subtitle: 'لقطة من soil-core',
          ),
        ),
      ],
    );
  }

  Widget _buildOperationsRow(
    BuildContext context, {
    required String fieldId,
  }) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            icon: Icons.task_alt,
            title: 'مهام الحقل',
            subtitle: 'إدارة مهام الري والتسميد والمكافحة',
            onTap: () {
              context.go(Routes.tasks, extra: {'fieldId': fieldId});
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionCard(
            icon: Icons.water_drop,
            title: 'الري',
            subtitle: 'برمجة جداول الري (قريباً)',
            onTap: () {
              // TODO: ربط شاشة إدارة الري الخاصة بالحقل
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAiCard(
    BuildContext context, {
    required String fieldId,
    required String fieldName,
    required String crop,
    required double areaHa,
    required double ndvi,
    required FieldAstralRecommendation astralRec,
    Map<String, dynamic>? weatherSnapshot,
    Map<String, dynamic>? soilSnapshot,
    required int tasksCount,
  }) {
    final contextPayload = {
      'fieldId': fieldId,
      'fieldName': fieldName,
      'crop': crop,
      'areaHa': areaHa,
      'ndvi': ndvi,
      'tasksCount': tasksCount,
      'astral': {
        'mansion': astralRec.currentMansionName,
        'astralAdvice': astralRec.astralAdvice,
        'ndviAdvice': astralRec.ndviAdvice,
        'cropAdvice': astralRec.cropAdvice,
      },
      'weather': weatherSnapshot,
      'soil': soilSnapshot,
    };

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.surface,
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.smart_toy_outlined),
        ),
        title: const Text('اسأل مساعد سهول عن هذا الحقل'),
        subtitle: const Text(
          'المساعد الذكي سيستخدم NDVI + التربة + الطقس + التقويم الفلكي لإجابتك.',
        ),
        onTap: () {
          context.go(
            Routes.aiChat,
            extra: contextPayload,
          );
        },
      ),
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  const _QuickStatCard({
    required this.title,
    required this.value,
    this.subtitle,
  });

  final String title;
  final String value;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (subtitle != null) ...<Widget>[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textMuted,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: AppColors.surfaceHighlight,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Icon(icon, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}