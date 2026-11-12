abstract interface class IConnectivityService {
  Future<bool> get isOnline;

  Stream<bool> get onConnectivityChanged;
}
