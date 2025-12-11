import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../presentation/router/routes.dart';
import '../../../../domain/entities/field_entity.dart';
import '../../data/field_repository.dart';
import '../bloc/create_field_bloc.dart';
import 'field_boundary_picker_page.dart';
import '../../astral/field_astral_engine.dart';
import '../../astral/field_astral_recommendation.dart';

class FieldCreateWizardPage extends StatefulWidget {
  const FieldCreateWizardPage({super.key});

  @override
  State<FieldCreateWizardPage> createState() => _FieldCreateWizardPageState();
}

class _FieldCreateWizardPageState extends State<FieldCreateWizardPage> {
  int _currentStep = 0;

  final _nameCtrl = TextEditingController();
  final _cropCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();

  Map<String, dynamic>? _boundaryGeoJson;
  String? _astralSummary;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _cropCtrl.dispose();
    _areaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateFieldBloc>(
      create: (_) => CreateFieldBloc(
        repository: FieldRepository(dio: getIt<Dio>()),
      ),
      child: BlocListener<CreateFieldBloc, CreateFieldState>(
        listener: (context, state) {
          if (state is CreateFieldSuccess) {
            _onCreateSuccess(context, state.field);
          } else if (state is CreateFieldFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('إضافة حقل جديد'),
          ),
          body: BlocBuilder<CreateFieldBloc, CreateFieldState>(
            builder: (context, state) {
              final isLoading = state is CreateFieldInProgress;
              return AbsorbPointer(
                absorbing: isLoading,
                child: Stepper(
                  currentStep: _currentStep,
                  type: StepperType.horizontal,
                  onStepContinue: () => _onStepContinue(context),
                  onStepCancel: _onStepCancel,
                  controlsBuilder: (ctx, details) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: details.onStepContinue,
                            child: Text(
                              _currentStep == 2 ? 'إنشاء الحقل' : 'التالي',
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (_currentStep > 0)
                            TextButton(
                              onPressed: details.onStepCancel,
                              child: const Text('رجوع'),
                            ),
                        ],
                      ),
                    );
                  },
                  steps: [
                    Step(
                      title: const Text('البيانات'),
                      isActive: _currentStep >= 0,
                      state: _stepState(0),
                      content: _buildStepBasicInfo(),
                    ),
                    Step(
                      title: const Text('الحدود'),
                      isActive: _currentStep >= 1,
                      state: _stepState(1),
                      content: _buildStepBoundary(context),
                    ),
                    Step(
                      title: const Text('مراجعة'),
                      isActive: _currentStep >= 2,
                      state: _stepState(2),
                      content: _buildStepReview(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  StepState _stepState(int index) {
    if (_currentStep > index) return StepState.complete;
    if (_currentStep == index) return StepState.editing;
    return StepState.indexed;
  }

  Widget _buildStepBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _nameCtrl,
          decoration: const InputDecoration(
            labelText: 'اسم الحقل',
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _cropCtrl,
          decoration: const InputDecoration(
            labelText: 'المحصول (اختياري)',
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _areaCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'المساحة (هكتار)',
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'يمكن تعديل المساحة لاحقاً أو حسابها من حدود الحقل.',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildStepBoundary(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'قم بتحديد حدود الحقل على الخريطة. يمكنك إضافة نقاط متعددة لتشكيل المضلع.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () async {
            final result = await Navigator.of(context)
                .push<Map<String, dynamic>>(
              MaterialPageRoute(
                builder: (_) => const FieldBoundaryPickerPage(),
              ),
            );
            if (result != null) {
              setState(() {
                _boundaryGeoJson =
                    result['polygon'] as Map<String, dynamic>?;
                final areaFromMap =
                    (result['areaHa'] as num?)?.toDouble();
                if (areaFromMap != null &&
                    _areaCtrl.text.trim().isEmpty) {
                  _areaCtrl.text = areaFromMap.toStringAsFixed(2);
                }
              });
            }
          },
          icon: const Icon(Icons.map_outlined),
          label: Text(
            _boundaryGeoJson == null
                ? 'تحديد الحدود على الخريطة'
                : 'تم تحديد الحدود (تعديل)',
          ),
        ),
        const SizedBox(height: 12),
        if (_boundaryGeoJson != null)
          Text(
            'تم اختيار مضلع بحدود GeoJSON.',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.green[700]),
          ),
        const SizedBox(height: 12),
        Text(
          'ملاحظة: في الإصدارات القادمة سيتم استخدام FieldSuite للرسم المتقدم والتقسيم.',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildStepReview() {
    final name = _nameCtrl.text.trim();
    final crop = _cropCtrl.text.trim();
    final area = _areaCtrl.text.trim();
    final hasBoundary = _boundaryGeoJson != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'راجع بيانات الحقل قبل الإنشاء:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        _reviewRow('الاسم', name.isEmpty ? 'غير محدد' : name),
        _reviewRow('المحصول', crop.isEmpty ? 'غير محدد' : crop),
        _reviewRow('المساحة (هكتار)', area.isEmpty ? 'غير محدد' : area),
        _reviewRow('الحدود',
            hasBoundary ? 'تم تحديد حدود الحقل' : 'لم يتم تحديد الحدود بعد'),
        const SizedBox(height: 16),
        if (_astralSummary != null)
          Card(
            color: Colors.amber[50],
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.stars_outlined, color: Colors.amber),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _astralSummary!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          const Text(
            'سيتم إظهار ملخص فلكي زراعي عند الإنشاء.',
            style: TextStyle(fontSize: 12),
          ),
      ],
    );
  }

  Widget _reviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _onStepContinue(BuildContext context) async {
    if (_currentStep == 0) {
      final name = _nameCtrl.text.trim();
      final area = double.tryParse(_areaCtrl.text.trim());

      if (name.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يرجى إدخال اسم الحقل')),
        );
        return;
      }
      if (area == null || area <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('يرجى إدخال مساحة صحيحة بالحساب (هكتار).')),
        );
        return;
      }

      setState(() {
        _currentStep = 1;
      });
      return;
    }

    if (_currentStep == 1) {
      if (_boundaryGeoJson == null) {
        final proceed = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('بدون حدود؟'),
                content: const Text(
                    'لم تقم بتحديد حدود الحقل. يفضّل تحديدها للحصول على تحليلات NDVI دقيقة.\nهل تريد الاستمرار بدون حدود؟'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: const Text('رجوع'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: const Text('نعم، استمر'),
                  ),
                ],
              ),
            ) ??
            false;

        if (!proceed) return;
      }

      setState(() {
        _currentStep = 2;
      });

      _prepareAstralSummary();
      return;
    }

    if (_currentStep == 2) {
      await _submitCreateField(context);
    }
  }

  void _onStepCancel() {
    if (_currentStep == 0) return;
    setState(() {
      _currentStep -= 1;
    });
  }

  void _prepareAstralSummary() {
    final crop = _cropCtrl.text.trim().isEmpty
        ? 'محصول عام'
        : _cropCtrl.text.trim();
    final ndviAssumed = 0.6; // قيمة تقديرية كبداية
    final FieldAstralRecommendation rec =
        FieldAstralEngine.analyzeField(cropType: crop, ndvi: ndviAssumed);

    _astralSummary =
        'المنزلة اليوم: ${rec.house.name}\n${rec.astralAdvice}\n\n${rec.ndviAdvice}\n\n${rec.cropAdvice}';
    setState(() {});
  }

  Future<void> _submitCreateField(BuildContext context) async {
    final name = _nameCtrl.text.trim();
    final crop =
        _cropCtrl.text.trim().isEmpty ? null : _cropCtrl.text.trim();
    final area = double.tryParse(_areaCtrl.text.trim());

    if (name.isEmpty || area == null || area <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('البيانات الأساسية غير مكتملة.')),
      );
      setState(() {
        _currentStep = 0;
      });
      return;
    }

    final rec = FieldAstralEngine.analyzeField(
      cropType: crop ?? 'محصول عام',
      ndvi: 0.6,
    );
    final warn = StringBuffer();
    warn.writeln('اليوم في منزلة: ${rec.house.name}');
    warn.writeln(rec.astralAdvice);
    warn.writeln('');
    warn.writeln('هل تريد الاستمرار في إنشاء الحقل الآن؟');

    final proceed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('تنبيه فلكي زراعي'),
            content: Text(warn.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('متابعة'),
              ),
            ],
          ),
        ) ??
        false;

    if (!proceed) return;

    context.read<CreateFieldBloc>().add(
          CreateFieldSubmitted(
            name: name,
            crop: crop,
            areaHa: area,
            boundary: _boundaryGeoJson,
          ),
        );
  }

  void _onCreateSuccess(BuildContext context, FieldEntity field) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم إنشاء الحقل: ${field.name}')),
    );

    context.go(
      Routes.fieldHub,
      queryParameters: {
        'fieldId': field.id,
        'fieldName': field.name,
        'crop': field.cropType,
        'areaHa': field.area.toString(),
        'ndvi': (field.ndviValue ?? 0.0).toStringAsFixed(2),
      },
    );
  }
}