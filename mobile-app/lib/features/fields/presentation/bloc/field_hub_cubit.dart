import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/offline/offline_helper.dart';
import '../../../../domain/entities/field_entity.dart';
import '../../data/field_repository.dart';

class FieldHubState extends Equatable {
  const FieldHubState({
    this.isLoading = false,
    this.field,
    this.ndviSnapshot,
    this.weatherSnapshot,
    this.soilSnapshot,
    this.openTasksCount = 0,
    this.error,
  });

  final bool isLoading;
  final FieldEntity? field;
  final Map<String, dynamic>? ndviSnapshot;
  final Map<String, dynamic>? weatherSnapshot;
  final Map<String, dynamic>? soilSnapshot;
  final int openTasksCount;
  final String? error;

  FieldHubState copyWith({
    bool? isLoading,
    FieldEntity? field,
    Map<String, dynamic>? ndviSnapshot,
    Map<String, dynamic>? weatherSnapshot,
    Map<String, dynamic>? soilSnapshot,
    int? openTasksCount,
    String? error,
  }) {
    return FieldHubState(
      isLoading: isLoading ?? this.isLoading,
      field: field ?? this.field,
      ndviSnapshot: ndviSnapshot ?? this.ndviSnapshot,
      weatherSnapshot: weatherSnapshot ?? this.weatherSnapshot,
      soilSnapshot: soilSnapshot ?? this.soilSnapshot,
      openTasksCount: openTasksCount ?? this.openTasksCount,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        field,
        ndviSnapshot,
        weatherSnapshot,
        soilSnapshot,
        openTasksCount,
        error,
      ];
}

class FieldHubCubit extends Cubit<FieldHubState> {
  FieldHubCubit({FieldRepository? repository})
      : _repository = repository ?? FieldRepository(dio: getIt()),
        super(const FieldHubState());

  final FieldRepository _repository;

  Future<void> load(String fieldId) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final field = await _repository.getFieldById(fieldId);
      final ndvi = await _repository.getFieldNdviSnapshot(fieldId);
      final weather = await _repository.getFieldWeatherSnapshot(fieldId);
      final soil = await _repository.getFieldSoilSnapshot(fieldId);
      final tasksCount = await _repository.getFieldOpenTasksCount(fieldId);

      // حفظ لقطة كاملة للوحة الحقل للاستخدام في وضع عدم الاتصال
      await OfflineHelper.saveFieldHubSnapshot(fieldId, {
        'fieldName': field.name,
        'crop': field.cropType,
        'areaHa': field.area,
        'ndvi': ndvi,
        'weather': weather,
        'soil': soil,
        'openTasksCount': tasksCount,
      });

      emit(
        state.copyWith(
          isLoading: false,
          field: field,
          ndviSnapshot: ndvi,
          weatherSnapshot: weather,
          soilSnapshot: soil,
          openTasksCount: tasksCount,
        ),
      );
    } catch (e) {
      // في حال فشل الاتصال، نحاول قراءة آخر لقطة محفوظة للحقل
      final cached = OfflineHelper.loadFieldHubSnapshot(fieldId);
      if (cached != null) {
        emit(
          state.copyWith(
            isLoading: false,
            ndviSnapshot: cached['ndvi'] as Map<String, dynamic>?,
            weatherSnapshot: cached['weather'] as Map<String, dynamic>?,
            soilSnapshot: cached['soil'] as Map<String, dynamic>?,
            openTasksCount:
                (cached['openTasksCount'] as num?)?.toInt() ?? 0,
            error:
                'تم عرض آخر بيانات محفوظة لهذا الحقل (بدون اتصال مباشر بالخادم).',
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            error: 'فشل في تحميل بيانات الحقل. تأكد من الاتصال بالخادم.',
          ),
        );
      }
    }
  }
}