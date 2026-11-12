import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:todoapp/product/service/connectivity_service.dart';

final class ConnectivityServiceImpl implements IConnectivityService {
  ConnectivityServiceImpl({Connectivity? connectivity}) : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  @override
  Future<bool> get isOnline async {
    final results = await _connectivity.checkConnectivity();
    return _isConnected(results);
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(_isConnected).distinct();
  }

  bool _isConnected(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }
}
