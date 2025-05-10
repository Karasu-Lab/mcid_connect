import 'package:mcid_connect/data/auth/minecraft/minecraft_token_response.dart';
import 'package:mcid_connect/data/profile/minecraft_account_profile.dart';
import 'package:mcid_connect/interfaces/base_auth_interface.dart';

abstract interface class MinecraftAuthServiceInterface
    implements BaseAuthInterface<MinecraftAccountProfile> {
  Future<MinecraftTokenResponse> getMinecraftAccessToken(
    String uhs,
    String xstsToken,
  );
  Future<MinecraftTokenResponse> getMinecraftAccessTokenWithDeviceCode(
    String deviceCode,
  );
  Future<bool> checkGameOwnership();
  Future<String> getMinecraftToken(String xstsToken);
  void clearCache();
}
