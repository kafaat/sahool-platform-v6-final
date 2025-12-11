import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../presentation/theme/app_colors.dart';
import '../bloc/dashboard_bloc.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/quick_stats_section.dart';
import '../widgets/weather_widget.dart';
import '../widgets/recent_activities_widget.dart';
import '../widgets/fields_overview_widget.dart';
import '../widgets/tasks_summary_widget.dart';
import '../widgets/irrigation_status_card.dart';
import '../widgets/livestock_overview_card.dart';
import '../widgets/weather_mini_card.dart';
import '../widgets/soil_moisture_mini_card.dart';
import '../widgets/heat_stress_card.dart';
import '../widgets/tasks_today_mini_card.dart';
import '../widgets/ndvi_summary_card.dart';

import '../../../ai_assistant/presentation/widgets/ai_insights_mini.dart';
import '../../../fields/astral/astral_tip_today.dart';
import '../../../ndvi/presentation/bloc/ndvi_bloc.dart';
import '../../../ndvi/presentation/bloc/ndvi_bloc.dart' as ndvi;
import '../../../ndvi/presentation/bloc/ndvi_bloc.dart' show NdviState;
import '../../../ndvi/presentation/bloc/ndvi_bloc.dart' show NdviEvent;

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => DashboardBloc()..add(LoadDashboard()),
        ),
        BlocProvider(
          create: (_) => NdviBloc()..add(const NdviLoadRequested()),
        ),
      ],
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: DashboardHeader(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: const QuickStatsSection(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: const AiInsightsMiniCard(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: const AstralTipToday(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: BlocBuilder<NdviBloc, NdviState>(
                  builder: (context, state) {
                    return NdviSummaryCard(
                      scene: state.selected,
                      onTap: (ctx) {
                        // الانتقال يتم من خلال MainScaffold/router
                        // يمكن استدعاء goRouter هنا إذا لزم
                      },
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: const [
                    Expanded(child: WeatherMiniCard()),
                    SizedBox(width: 8),
                    Expanded(child: SoilMoistureMiniCard()),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: const [
                    Expanded(child: IrrigationStatusCard()),
                    SizedBox(width: 8),
                    Expanded(child: LivestockOverviewCard()),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: const HeatStressCard(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: const TasksTodayMiniCard(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: const WeatherWidget(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: const FieldsOverviewWidget(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: const TasksSummaryWidget(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: const RecentActivitiesWidget(),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 80),
            ),
          ],
        ),
      ),
    );
  }
}
