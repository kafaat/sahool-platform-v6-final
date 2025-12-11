import 'package:flutter_bloc/flutter_bloc.dart';
import '../logging/app_logger.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    AppLogger.d('onCreate: ${bloc.runtimeType}', tag: 'Bloc');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    AppLogger.d('onChange: ${bloc.runtimeType}', tag: 'Bloc');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    AppLogger.e('onError: ${bloc.runtimeType}', tag: 'Bloc', error: error, stackTrace: stackTrace);
  }
}
