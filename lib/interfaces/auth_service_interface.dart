abstract interface class AuthServiceInterface {
  Future<bool> startAuthenticationFlow({String? deviceCode, bool useDeviceCode});
  Future<bool> isAuthenticated();
  Future<bool> hasMinecraftProfile();
}
