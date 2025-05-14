import 'package:mcid_connect/data/auth/microsoft/device_code_response.dart';
import 'package:mcid_connect/data/auth/microsoft/microsoft_account.dart';
import 'package:mcid_connect/interfaces/base_auth_interface.dart';

abstract interface class MicrosoftAuthServiceInterface implements BaseAuthInterface<MicrosoftAccount>{
  Future<DeviceCodeResponse> getDeviceCode();
  Future<String> getAccessToken(String deviceCode);
  Future<String> getAccessTokenWithLocalServer();
  Future<MicrosoftAccount> getMicrosoftAccount();
  Future<String?> refreshAccessToken(String refreshToken);
  Future<MicrosoftAccount?> refreshAccessTokenWithProfile(String refreshToken);
  void closeLocalServer();
}
