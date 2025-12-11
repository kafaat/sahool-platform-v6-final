import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/dashboard_bloc.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/recent_activities_widget.dart';
import '../widgets/quick_stats_section.dart';
import '../widgets/ndvi_summary_card.dart';
import '../widgets/irrigation_status_card.dart';
import '../widgets/livestock_overview_card.dart';
import '../widgets/weather_mini_card.dart';
import '../widgets/soil_moisture_mini_card.dart';
import '../widgets/heat_stress_card.dart';
import '../widgets/tasks_today_mini_card.dart';

import '../../../ai_assistant/presentation/widgets/ai_insights_mini.dart';
import '../../../fields/astral/astral_tip_today.dart';

import '../../../../presentation/router/routes.dart';
import '../../../../presentation/theme/app_colors.dart';
import '../../../ndvi/presentation/bloc/ndvi_bloc.dart';

class DashboardPageV2 extends StatelessWidget {
  const DashboardPageV2({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DashboardBloc>(
          create: (_) => DashboardBloc()..add(DashboardLoaded()),
        ),
        BlocProvider<NdviBloc>(
          create: (_) => NdviBloc()..add(NdviLoadRequested()),
        ),
      ],
      child: const _DashboardViewV2(),
    );
  }
}

class _DashboardViewV2 extends StatelessWidget {
  const _DashboardViewV2();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('لوحة التحكم الذكية 2.0'),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: 'العودة للوحة القديمة',
            onPressed: () => context.go(Routes.dashboard),
            icon: const Icon(Icons.dashboard_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // رأس اللوحة
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: DashboardHeader(),
              ),
            ),

            // إحصائيات سريعة
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: QuickStatsSection(),
              ),
            ),

            // مساعد الذكاء الصناعي المختصر
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: AiInsightsMini(),
              ),
            ),

            // ملخص NDVI
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BlocBuilder<NdviBloc, NdviState>(
                  builder: (context, state) {
                    return NdviSummaryCard(
                      scene: state.selected,
                      onTap: (ctx) => ctx.go(Routes.ndviMap),
                    );
                  },
                ),
              ),
            ),

            // نصيحة التقويم الزراعي الفلكي
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: AstralTipToday(),
              ),
            ),

            // شبكة الودجات التفاعلية
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.25,
                children: const [
                  IrrigationStatusCard(),
                  LivestockOverviewCard(),
                  WeatherMiniCard(),
                  SoilMoistureMiniCard(),
                  HeatStressCard(),
                  TasksTodayMiniCard(),
                ],
              ),
            ),

            // الأنشطة الأخيرة
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: RecentActivitiesWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
