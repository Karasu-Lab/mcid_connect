import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mcid_connect/data/auth/minecraft/minecraft_token_response.dart';
import 'package:mcid_connect/data/profile/minecraft_account_profile.dart';
import 'package:mcid_connect/interfaces/auth_interfaces.dart';
import 'dart:async';

import 'package:mcid_connect/interfaces/minecraft_auth_service_interface.dart';

class MinecraftAuthService implements MinecraftAuthServiceInterface {
  final http.Client _httpClient;
  final String _clientId;
  static MinecraftAuthService? _instance;

  MinecraftAccountProfile? _minecraftProfile;
  String? _minecraftToken;
  DateTime? _tokenExpiration;

  factory MinecraftAuthService({
    required String clientId,
    http.Client? httpClient,
  }) {
    _instance ??= MinecraftAuthService._internal(
      clientId,
      httpClient ?? http.Client(),
    );
    return _instance!;
  }

  MinecraftAuthService._internal(this._clientId, this._httpClient);
  @override
  Future<MinecraftTokenResponse> getMinecraftAccessToken(
    String uhs,
    String xstsToken,
  ) async {
    try {
      final response = await _httpClient.post(
        Uri.parse(
          'https://api.minecraftservices.com/authentication/login_with_xbox',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"identityToken": "XBL3.0 x=$uhs;$xstsToken"}),
      );

      if (response.statusCode == 200) {
        final tokenResponse = MinecraftTokenResponse.fromJson(
          jsonDecode(response.body),
        );
        _minecraftToken = tokenResponse.accessToken;
        _tokenExpiration = DateTime.now().add(Duration(seconds: tokenResponse.expiresIn));
        return tokenResponse;
      } else {
        throw Exception('Minecraft token retrieval failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to retrieve Minecraft access token: $e');
    }
  }

  @override
  Future<MinecraftTokenResponse> getMinecraftAccessTokenWithDeviceCode(
    String deviceCode,
  ) async {
    try {
      final response = await _httpClient.post(
        Uri.parse(
          'https://login.microsoftonline.com/consumers/oauth2/v2.0/token',
        ),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'client_id': _clientId,
          'device_code': deviceCode,
          'grant_type': 'urn:ietf:params:oauth:grant-type:device_code',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return MinecraftTokenResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Device code authentication failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to retrieve token with device code: $e');
    }
  }
  @override
  Future<MinecraftAccountProfile> getAccountprofile() async {
    if (_minecraftProfile != null) {
      return _minecraftProfile!;
    }

    if (_minecraftToken == null) {
      throw Exception('No Minecraft token available');
    }

    final response = await _httpClient.get(
      Uri.parse('https://api.minecraftservices.com/minecraft/profile'),
      headers: {'Authorization': 'Bearer $_minecraftToken'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      _minecraftProfile = MinecraftAccountProfile.fromJson(jsonResponse);
      return _minecraftProfile!;
    } else if (response.statusCode == 404) {
      throw Exception(
        'No Minecraft profile found. You may need to purchase the game.',
      );
    } else {
      throw Exception('Failed to get Minecraft profile: ${response.body}');
    }
  }

  @override
  Future<bool> checkGameOwnership() async {
    if (_minecraftToken == null) {
      throw Exception('No Minecraft token available');
    }

    final response = await _httpClient.get(
      Uri.parse('https://api.minecraftservices.com/entitlements/mcstore'),
      headers: {'Authorization': 'Bearer $_minecraftToken'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['items'] != null) {
        final items = jsonResponse['items'] as List;
        return items.isNotEmpty;
      }
      return false;
    } else {
      throw Exception('Failed to check game ownership: ${response.body}');
    }
  }

  @override
  Future<String> getMinecraftToken(String xstsToken) async {
    if (_minecraftToken != null &&
        _tokenExpiration != null &&
        _tokenExpiration!.isAfter(DateTime.now())) {
      return _minecraftToken!;
    }

    final tokenResponse = await getMinecraftAccessToken(xstsToken, xstsToken);
    return tokenResponse.accessToken;
  }

  @override
  void clearCache() {
    _minecraftProfile = null;
    _minecraftToken = null;
    _tokenExpiration = null;
  }
}
