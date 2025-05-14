import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:mcid_connect/data/auth/microsoft/device_code_response.dart';
import 'package:mcid_connect/data/auth/microsoft/microsoft_account.dart';
import 'package:mcid_connect/data/auth/microsoft/microsoft_token_response.dart';
import 'package:mcid_connect/interfaces/auth_interfaces.dart';

class MicrosoftAuthService implements MicrosoftAuthServiceInterface {
  final String _clientId;
  final String _redirectUri;
  final http.Client _httpClient;

  static MicrosoftAuthService? _instance;
  HttpServer? _localServer;

  factory MicrosoftAuthService({
    required String clientId,
    String? redirectUri,
    http.Client? httpClient,
  }) {
    _instance ??= MicrosoftAuthService._internal(
      clientId,
      redirectUri ?? 'http://localhost:3000',
      httpClient ?? http.Client(),
    );
    return _instance!;
  }

  MicrosoftAuthService._internal(
    this._clientId,
    this._redirectUri,
    this._httpClient,
  );

  String? _msRefreshToken;
  MicrosoftAccount? _microsoftAccount;

  @override
  Future<DeviceCodeResponse> getDeviceCode() async {
    final deviceCodeResponse = await _getMicrosoftDeviceCode();
    return deviceCodeResponse;
  }

  Future<DeviceCodeResponse> _getMicrosoftDeviceCode() async {
    final response = await _httpClient.post(
      Uri.parse(
        'https://login.microsoftonline.com/consumers/oauth2/v2.0/devicecode',
      ),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'client_id': _clientId, 'scope': 'XboxLive.signin offline_access'},
    );

    if (response.statusCode == 200) {
      return DeviceCodeResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get device code: ${response.body}');
    }
  }

  @override
  Future<String> getAccessToken(String deviceCode) async {
    final tokenResponse = await _pollForMicrosoftToken(deviceCode);
    _msRefreshToken = tokenResponse.refreshToken;
    return tokenResponse.accessToken;
  }

  @override
  Future<String> getAccessTokenWithLocalServer() async {
    final tokenResponse = await _getTokenWithLocalServer();
    _msRefreshToken = tokenResponse.refreshToken;
    return tokenResponse.accessToken;
  }

  Future<MicrosoftTokenResponse> _getTokenWithLocalServer() async {
    final redirectUriParsed = Uri.parse(_redirectUri);
    final port = redirectUriParsed.port;
    final completer = Completer<MicrosoftTokenResponse>();

    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
    _localServer = server;
    debugPrint('Local server started. Port: $port');

    final authUrl = Uri.parse(
      'https://login.microsoftonline.com/consumers/oauth2/v2.0/authorize'
      '?client_id=$_clientId'
      '&response_type=code'
      '&redirect_uri=$_redirectUri'
      '&scope=XboxLive.signin%20offline_access',
    );

    debugPrint(
      'Please open the following URL in your browser to login with Microsoft account:',
    );
    debugPrint(authUrl.toString());

    server.listen((HttpRequest request) async {
      final requestParams = request.uri.queryParameters;
      final code = requestParams['code'];

      request.response.headers.contentType = ContentType.html;
      request.response.write('''
      <!DOCTYPE html>
      <html>
      <head>
        <title>Authentication Complete</title>
        <style>
          body { font-family: Arial, sans-serif; text-align: center; padding: 50px; }
          h2 { color: #4CAF50; }
        </style>
      </head>
      <body>
        <h2>Authentication Complete</h2>
        <p>This window will close automatically. If it does not, please close it manually.</p>
        <script>
          setTimeout(function() { window.close(); }, 3000);
        </script>
      </body>
      </html>
      ''');
      await request.response.close();

      if (code != null) {
        try {
          final tokenResponse = await _getTokenFromAuthCode(code);
          completer.complete(tokenResponse);
        } catch (e) {
          completer.completeError(e);
        } finally {
          await server.close();
        }
      } else if (requestParams.containsKey('error')) {
        completer.completeError(
          Exception(
            'Authentication error: ${requestParams['error_description'] ?? requestParams['error']}',
          ),
        );
        await server.close();
      }
    });

    return completer.future;
  }

  Future<MicrosoftTokenResponse> _getTokenFromAuthCode(String code) async {
    final response = await _httpClient.post(
      Uri.parse(
        'https://login.microsoftonline.com/consumers/oauth2/v2.0/token',
      ),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'client_id': _clientId,
        'code': code,
        'redirect_uri': _redirectUri,
        'grant_type': 'authorization_code',
        'scope': 'XboxLive.signin offline_access',
      },
    );

    if (response.statusCode == 200) {
      return MicrosoftTokenResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get token from auth code: ${response.body}');
    }
  }

  Future<MicrosoftTokenResponse> _pollForMicrosoftToken(
    String deviceCode, {
    Duration pollingInterval = const Duration(seconds: 5),
  }) async {
    bool authorized = false;
    MicrosoftTokenResponse? tokenResponse;
    while (!authorized) {
      final response = await _httpClient.post(
        Uri.parse(
          'https://login.microsoftonline.com/consumers/oauth2/v2.0/token',
        ),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'urn:ietf:params:oauth:grant-type:device_code',
          'client_id': _clientId,
          'device_code': deviceCode,
        },
      );

      if (response.statusCode == 200) {
        tokenResponse = MicrosoftTokenResponse.fromJson(
          jsonDecode(response.body),
        );
        authorized = true;
      } else {
        final error = jsonDecode(response.body);
        if (error['error'] == 'authorization_pending') {
          await Future.delayed(pollingInterval);
        } else if (error['error'] == 'expired_token') {
          throw Exception(
            'Device code expired. Please restart the authentication process.',
          );
        } else {
          throw Exception('Token polling failed: ${response.body}');
        }
      }
    }

    return tokenResponse!;
  }

  Future<MicrosoftTokenResponse> _refreshMicrosoftToken(
    String refreshToken,
  ) async {
    final response = await _httpClient.post(
      Uri.parse(
        'https://login.microsoftonline.com/consumers/oauth2/v2.0/token',
      ),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'client_id': _clientId,
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
        'scope': 'XboxLive.signin offline_access',
      },
    );

    if (response.statusCode == 200) {
      return MicrosoftTokenResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to refresh token: ${response.body}');
    }
  }

  @override
  Future<MicrosoftAccount> getMicrosoftAccount() async {
    if (_microsoftAccount != null) {
      return _microsoftAccount!;
    }

    if (_msRefreshToken != null) {
      final tokenResponse = await _refreshMicrosoftToken(_msRefreshToken!);
      _microsoftAccount = MicrosoftAccount(
        refreshToken: tokenResponse.refreshToken,
      );
      return _microsoftAccount!;
    }

    throw Exception('No Microsoft account information available');
  }

  @override
  Future<MicrosoftAccount> getAccountprofile() async {
    return getMicrosoftAccount();
  }

  String? getRefreshToken() {
    return _msRefreshToken;
  }

  void cacheMicrosoftRefreshToken(String refreshToken) {
    _msRefreshToken = refreshToken;
  }

  @override
  Future<String?> refreshAccessToken(String refreshToken) async {
    try {
      final tokenResponse = await _refreshMicrosoftToken(refreshToken);
      _msRefreshToken = tokenResponse.refreshToken;
      return tokenResponse.accessToken;
    } catch (e) {
      debugPrint('Failed to refresh access token: $e');
      return null;
    }
  }

  /// Refreshes the access token using the provided refresh token and returns the Microsoft account profile.
  ///
  /// This method combines token refresh and profile retrieval in a single operation.
  ///
  /// @param refreshToken The Microsoft refresh token to use for refresh operation
  /// @return A Future that resolves to a MicrosoftAccount containing the refreshed token information,
  ///         or null if the refresh operation failed
  @override
  Future<MicrosoftAccount?> refreshAccessTokenWithProfile(
    String refreshToken,
  ) async {
    try {
      final tokenResponse = await _refreshMicrosoftToken(refreshToken);
      _msRefreshToken = tokenResponse.refreshToken;
      _microsoftAccount = MicrosoftAccount(
        refreshToken: tokenResponse.refreshToken,
      );
      return _microsoftAccount;
    } catch (e) {
      debugPrint('Failed to refresh access token with profile: $e');
      return null;
    }
  }

  void clearCache() {
    _msRefreshToken = null;
    _microsoftAccount = null;
  }

  @override
  void closeLocalServer() async {
    if (_localServer != null) {
      await _localServer!.close(force: true);
      debugPrint('Local server closed.');
      _localServer = null;
    }
  }
}
