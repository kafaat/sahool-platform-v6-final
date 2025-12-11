import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../presentation/theme/app_colors.dart';
import '../../../../presentation/router/routes.dart';
import '../../../../presentation/widgets/cards/field_card.dart';
import '../../../../domain/entities/field_entity.dart';
import '../../astral/field_astral_engine.dart';
import '../../astral/field_astral_recommendation.dart';
import '../bloc/field_list_bloc.dart';
import '../../sync/field_sync_service.dart';
import 'field_create_wizard_page.dart';

class FieldsPage extends StatefulWidget {
  const FieldsPage({super.key});

  @override
  State<FieldsPage> createState() => _FieldsPageState();
}

class _FieldsPageState extends State<FieldsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _viewMode = 'grid';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FieldListBloc>(
      create: (_) => FieldListBloc(
        repository: FieldRepository(dio: getIt<Dio>()),
      )..add(FieldListRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('حقولي'),
          actions: [
            IconButton(
              icon: Icon(
                _viewMode == 'grid' ? Icons.view_list : Icons.grid_view,
              ),
              onPressed: () {
                setState(() {
                  _viewMode = _viewMode == 'grid' ? 'list' : 'grid';
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.sync),
              tooltip: 'مزامنة الحقول',
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                messenger.showSnackBar(
                  const SnackBar(content: Text('جاري مزامنة الحقول غير المتصلة...')),
                );
                final service = FieldSyncService(dio: getIt<Dio>());
                final synced = await service.syncOfflineCreations();
                if (!context.mounted) return;
                context.read<FieldListBloc>().add(FieldListRefreshed());
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      synced == 0
                          ? 'لا توجد حقول بحاجة لمزامنة.'
                          : 'تمت مزامنة $synced حقل/حقول بنجاح.',
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              tooltip: 'إضافة حقل',
              onPressed: () {
                context.go(Routes.addField);
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'جميع الحقول'),
              Tab(text: 'حسب الحالة'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _FieldsTabAll(viewMode: _viewMode),
            _FieldsTabStatus(viewMode: _viewMode),
          ],
        ),
      ),
    );
  }
}

class _FieldsTabAll extends StatelessWidget {
  final String viewMode;

  const _FieldsTabAll({required this.viewMode});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldListBloc, FieldListState>(
      builder: (context, state) {
        if (state is FieldListLoading || state is FieldListInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is FieldListFailure) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'تعذر تحميل الحقول:\n${state.message}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        if (state is FieldListLoaded) {
          if (state.fields.isEmpty) {
            return const Center(
              child: Text('لا توجد حقول مسجلة حتى الآن.'),
            );
          }

          final fields = state.fields;
          if (viewMode == 'grid') {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                itemCount: fields.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  final field = fields[index];
                  return FieldCard(
                    field: field,
                    onTap: () {
                      _openFieldHub(context, field);
                    },
                  );
                },
              ),
            );
          } else {
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: fields.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final field = fields[index];
                return FieldCard(
                  field: field,
                  onTap: () {
                    _openFieldHub(context, field);
                  },
                );
              },
            );
          }
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _openFieldHub(BuildContext context, FieldEntity field) {
    final ndvi = field.ndviValue ?? 0.0;
    context.go(
      Routes.fieldHub,
      queryParameters: {
        'fieldId': field.id,
        'fieldName': field.name,
        'crop': field.cropType,
        'areaHa': field.area.toString(),
        'ndvi': ndvi.toStringAsFixed(2),
      },
    );
  }
}

class _FieldsTabStatus extends StatelessWidget {
  final String viewMode;

  const _FieldsTabStatus({required this.viewMode});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldListBloc, FieldListState>(
      builder: (context, state) {
        if (state is FieldListLoaded) {
          final active = state.fields
              .where((f) => f.status == 'active')
              .toList();
          final monitoring = state.fields
              .where((f) => f.status != 'active')
              .toList();

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              if (active.isNotEmpty) ...[
                Text(
                  'حقول نشطة',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...active.map(
                  (f) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: FieldCard(
                      field: f,
                      onTap: () => _openFieldHub(context, f),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (monitoring.isNotEmpty) ...[
                Text(
                  'تحتاج متابعة',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...monitoring.map(
                  (f) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: FieldCard(
                      field: f,
                      onTap: () => _openFieldHub(context, f),
                    ),
                  ),
                ),
              ],
              if (active.isEmpty && monitoring.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('لا توجد بيانات حالة متاحة للحقول.'),
                  ),
                ),
            ],
          );
        }

        if (state is FieldListFailure) {
          return Center(
            child: Text(
              'خطأ في تحميل الحقول حسب الحالة.',
              textAlign: TextAlign.center,
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void _openFieldHub(BuildContext context, FieldEntity field) {
    final ndvi = field.ndviValue ?? 0.0;
    context.go(
      Routes.fieldHub,
      queryParameters: {
        'fieldId': field.id,
        'fieldName': field.name,
        'crop': field.cropType,
        'areaHa': field.area.toString(),
        'ndvi': ndvi.toStringAsFixed(2),
      },
    );
  }
}