import 'package:mcid_connect/data/auth/microsoft/microsoft_account.dart';

abstract interface class AuthServiceInterface {
  Future<bool> startAuthenticationFlow({String? deviceCode, bool useDeviceCode});
  Future<bool> isAuthenticated();
  Future<bool> hasMinecraftProfile();
  Future<MicrosoftAccount?> refreshAuthenticationWithToken(String refreshToken);
}
