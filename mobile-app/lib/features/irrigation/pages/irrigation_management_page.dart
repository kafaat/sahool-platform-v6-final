import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/di/injection.dart';
import '../data/irrigation_repository.dart';
import '../bloc/irrigation_bloc.dart';
import '../bloc/irrigation_event.dart';
import '../bloc/irrigation_state.dart';
import '../widgets/irrigation_cycle_card.dart';
import 'irrigation_add_page.dart';

class IrrigationManagementPage extends StatelessWidget {
  final String fieldId;

  const IrrigationManagementPage({super.key, required this.fieldId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => IrrigationBloc(getIt<IrrigationRepository>())
        ..add(LoadIrrigation(fieldId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إدارة الري'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => IrrigationAddPage(fieldId: fieldId),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: BlocBuilder<IrrigationBloc, IrrigationState>(
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
                child: Text('لا توجد دورات ري مسجلة'),
              );
            }

            // إحصائيات بسيطة
            final totalMinutes = state.items
                .map((e) => (e['duration_minutes'] ?? 0) as int)
                .fold<int>(0, (a, b) => a + b);
            final zones = state.items
                .map((e) => e['zone'])
                .where((z) => z != null)
                .toSet()
                .length;
            final df = DateFormat('yyyy-MM-dd HH:mm');
            DateTime? lastStart;
            for (final c in state.items) {
              final s = c['start'] as String?;
              if (s == null) continue;
              final dt = DateTime.tryParse(s);
              if (dt == null) continue;
              if (lastStart == null || dt.isAfter(lastStart)) {
                lastStart = dt;
              }
            }

            return Column(
              children: [
                _IrrigationStatsHeader(
                  totalMinutes: totalMinutes,
                  zonesCount: zones,
                  lastStart: lastStart != null
                      ? df.format(lastStart.toLocal())
                      : '—',
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final cycle = state.items[index];
                      return IrrigationCycleCard(
                        cycle: cycle,
                        onDelete: () {
                          context.read<IrrigationBloc>().add(
                                DeleteCycle(
                                  fieldId: fieldId,
                                  id: cycle['id'].toString(),
                                ),
                              );
                        },
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemCount: state.items.length,
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

class _IrrigationStatsHeader extends StatelessWidget {
  final int totalMinutes;
  final int zonesCount;
  final String lastStart;

  const _IrrigationStatsHeader({
    required this.totalMinutes,
    required this.zonesCount,
    required this.lastStart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _stat('إجمالي الدقائق', '$totalMinutes'),
            const SizedBox(width: 12),
            _stat('عدد المناطق', '$zonesCount'),
            const SizedBox(width: 12),
            Expanded(
              child: _stat('آخر ري', lastStart),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
