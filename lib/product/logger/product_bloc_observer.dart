import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/product/logger/app_logger.dart';

final class ProductBlocObserver extends BlocObserver {
  const ProductBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    AppLogger.info('${bloc.runtimeType} $change');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    AppLogger.error(bloc.runtimeType.toString(), error, stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}
