import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mcid_connect/data/auth/microsoft/device_code_response.dart';
import 'package:mcid_connect/data/profile/minecraft_account_profile.dart';
import 'package:mcid_connect/interfaces/auth_service_interface.dart';
import 'package:mcid_connect/mcid_connect.dart';

class AuthService implements AuthServiceInterface {
  AuthService({
    required this.clientId,
    required this.redirectUri,
    required this.scopes,
    http.Client? httpClient,
    this.onGetDeviceCode,
  }) {
    _microsoftAuthService = MicrosoftAuthService(
      clientId: clientId,
      redirectUri: redirectUri,
      httpClient: httpClient,
    );
    _xboxAuthService = XboxAuthService(httpClient: httpClient);
    _minecraftAuthService = MinecraftAuthService(
      clientId: clientId,
      httpClient: httpClient,
    );
  }
  final String clientId;
  final String redirectUri;
  final List<String> scopes;

  final void Function(DeviceCodeResponse)? onGetDeviceCode;

  late final MicrosoftAuthService _microsoftAuthService;
  late final XboxAuthService _xboxAuthService;
  late final MinecraftAuthService _minecraftAuthService;

  String? _accessToken;
  String? _microsoftRefreshToken;
  String? _xstsToken;
  String? _xstsUhs;
  String? _minecraftToken;
  MinecraftAccountProfile? _minecraftProfile;
  String get accessToken => _accessToken!;
  String? get microsoftRefreshToken => _microsoftRefreshToken;
  String get xstsToken => _xstsToken!;
  String get xstsUhs => _xstsUhs!;
  String get minecraftToken => _minecraftToken!;
  MinecraftAccountProfile get minecraftProfile => _minecraftProfile!;

  @override
  Future<bool> startAuthenticationFlow({
    String? deviceCode,
    bool useDeviceCode = true,
  }) async {
    try {
      if (useDeviceCode) {
        if (deviceCode == null) {
          final response = await _microsoftAuthService.getDeviceCode();
          if (onGetDeviceCode != null) {
            onGetDeviceCode!(response);
          }
          deviceCode = response.deviceCode;
        }
        _accessToken = await _microsoftAuthService.getAccessToken(deviceCode);
        _microsoftRefreshToken = _microsoftAuthService.getRefreshToken();
      } else {
        _accessToken =
            await _microsoftAuthService.getAccessTokenWithLocalServer();
        _microsoftRefreshToken = _microsoftAuthService.getRefreshToken();
      }

      final xstsResponse = await _xboxAuthService.getXstsToken(_accessToken!);
      final xstsToken = xstsResponse['token']!;
      final uhs = xstsResponse['uhs']!;
      _xstsToken = xstsToken;
      _xstsUhs = uhs;
      final tokenResponse = await _minecraftAuthService.getMinecraftAccessToken(
        uhs,
        xstsToken,
      );
      _minecraftToken = tokenResponse.accessToken;

      try {
        _minecraftProfile = await _minecraftAuthService.getAccountprofile();
      } catch (e) {
        debugPrint('Failed to get Minecraft profile: $e');
      }

      return true;
    } catch (e) {
      debugPrint('Authentication flow failed: $e');
      return false;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    if (_minecraftToken != null) {
      return true;
    }

    if (_microsoftRefreshToken != null) {
      try {
        return await refreshAuthentication();
      } catch (e) {
        debugPrint('Re-authentication failed with stored token: $e');
        return false;
      }
    }

    final refreshToken = _microsoftAuthService.getRefreshToken();
    if (refreshToken != null) {
      _microsoftRefreshToken = refreshToken;
      try {
        return await refreshAuthentication();
      } catch (e) {
        debugPrint('Re-authentication failed: $e');
        return false;
      }
    }

    return false;
  }

  @override
  Future<bool> hasMinecraftProfile() async {
    if (_minecraftProfile != null) {
      return true;
    }

    if (_minecraftToken != null) {
      try {
        _minecraftProfile = await _minecraftAuthService.getAccountprofile();
        return true;
      } catch (e) {
        if (e.toString().contains('404')) {
          return false;
        }
        rethrow;
      }
    }

    return false;
  }

  Future<MinecraftAccountProfile?> getMinecraftProfile() async {
    if (await hasMinecraftProfile()) {
      return _minecraftProfile ??
          await _minecraftAuthService.getAccountprofile();
    }
    return null;
  }

  String getAuthenticationUrl() {
    return Uri.parse(
      'https://login.microsoftonline.com/consumers/oauth2/v2.0/authorize'
      '?client_id=$clientId'
      '&response_type=code'
      '&redirect_uri=$redirectUri'
      '&scope=${scopes.join('%20')}',
    ).toString();
  }

  void clearAuthentication() {
    _accessToken = null;
    _microsoftRefreshToken = null;
    _xstsToken = null;
    _xstsUhs = null;
    _minecraftToken = null;
    _minecraftProfile = null;
    _microsoftAuthService.clearCache();
    _minecraftAuthService.clearCache();
  }

  Future<bool> refreshAuthentication() async {
    if (_microsoftRefreshToken == null) {
      return false;
    }

    try {
      _accessToken = await _microsoftAuthService.refreshAccessToken(
        _microsoftRefreshToken!,
      );
      if (_accessToken == null) {
        return false;
      }

      final xstsResponse = await _xboxAuthService.getXstsToken(_accessToken!);
      final xstsToken = xstsResponse['token']!;
      final uhs = xstsResponse['uhs']!;
      _xstsToken = xstsToken;
      _xstsUhs = uhs;

      final tokenResponse = await _minecraftAuthService.getMinecraftAccessToken(
        uhs,
        xstsToken,
      );
      _minecraftToken = tokenResponse.accessToken;

      try {
        _minecraftProfile = await _minecraftAuthService.getAccountprofile();
      } catch (e) {
        debugPrint('Failed to get Minecraft profile during refresh: $e');
      }

      return true;
    } catch (e) {
      debugPrint('Failed to refresh authentication: $e');
      return false;
    }
  }
}
