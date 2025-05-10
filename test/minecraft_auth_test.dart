import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mcid_connect/env/env.dart';
import 'package:mcid_connect/data/auth/microsoft/device_code_response.dart';
import 'package:mcid_connect/mcid_connect.dart';

Future<void> printDeviceCodeInstructions(DeviceCodeResponse response) async {
  debugPrint('\n==================================================');
  debugPrint('Using real Microsoft authentication. Please follow these steps:');
  debugPrint('1. Open this URL: ${response.verificationUri}');
  debugPrint('2. Enter the code "${response.userCode}"');
  debugPrint('3. Sign in with your Microsoft account');
  debugPrint('4. Please wait for the authentication to complete...');
  debugPrint('==================================================\n');
}

Future<void> printRedirectUriInstructions(String authUrl) async {
  debugPrint('\n==================================================');
  debugPrint('Using redirect URI authentication. Please follow these steps:');
  debugPrint('1. Open this URL in your browser:');
  debugPrint(authUrl);
  debugPrint('2. Sign in with your Microsoft account');
  debugPrint(
    '3. You will be redirected to the local server after authentication',
  );
  debugPrint('4. Please wait for the authentication to complete...');
  debugPrint(
    'NOTE: You must set "http://localhost:3000" as the redirect URL in your application settings to use redirect authentication.',
  );
  debugPrint('==================================================\n');
}

Future<void> verifyMinecraftProfile(AuthService authService) async {
  final isAuth = await authService.isAuthenticated();
  expect(
    isAuth,
    isTrue,
    reason: 'Should be authenticated after flow completes',
  );

  final hasProfile = await authService.hasMinecraftProfile();
  expect(
    hasProfile,
    isTrue,
    reason: 'Should have a Minecraft profile after authentication',
  );

  final profile = await authService.getMinecraftProfile();
  expect(profile, isNotNull, reason: 'Minecraft profile should not be null');

  if (profile != null) {
    debugPrint('\n==================================================');
    debugPrint('Authentication successful!');
    debugPrint('Username: ${profile.name}');
    debugPrint('UUID: ${profile.id}');
    debugPrint('==================================================\n');

    expect(profile.name, isNotEmpty, reason: 'Username should not be empty');
    expect(profile.id, isNotEmpty, reason: 'UUID should not be empty');
  }
}

void main() {
  group('Microsoft Authentication Tests', () {
    late AuthService authService;
    late MicrosoftAuthService microsoftAuthService;

    String realClientId = Env.azureAppClientId;
    const String redirectUri = 'http://localhost:3000';
    const List<String> scopes = ['XboxLive.signin', 'offline_access'];
    setUp(() {
      final httpClient = http.Client();
      authService = AuthService(
        clientId: realClientId,
        redirectUri: redirectUri,
        scopes: scopes,
        httpClient: httpClient,
        onGetDeviceCode: printDeviceCodeInstructions,
      );

      microsoftAuthService = MicrosoftAuthService(
        clientId: realClientId,
        redirectUri: redirectUri,
        httpClient: httpClient,
      );
    });

    test('Device Code Authentication Flow Test', () async {
      debugPrint('\n==================================================');
      debugPrint('Running Device Code authentication test');
      debugPrint('==================================================\n');
      try {
        bool authResult = await authService.startAuthenticationFlow(
          useDeviceCode: true,
        );

        expect(
          authResult,
          isTrue,
          reason: 'Authentication flow should succeed',
        );

        await verifyMinecraftProfile(authService);

        authService.clearAuthentication();

        final isAuthAfterClear = await authService.isAuthenticated();
        expect(
          isAuthAfterClear,
          isFalse,
          reason: 'Should not be authenticated after clearing',
        );
      } catch (e) {
        debugPrint('\n==================================================');
        debugPrint('Error occurred during device code authentication: $e');
        debugPrint('==================================================\n');
        rethrow;
      }
    });

    test('Redirect URI Authentication Flow Test', () async {
      debugPrint('\n==================================================');
      debugPrint('Running Redirect URI authentication test');
      debugPrint('==================================================\n');
      try {
        await printRedirectUriInstructions(authService.getAuthenticationUrl());

        bool authResult = await authService.startAuthenticationFlow(
          useDeviceCode: false,
        );

        expect(
          authResult,
          isTrue,
          reason: 'Authentication flow should succeed',
        );

        await verifyMinecraftProfile(authService);

        authService.clearAuthentication();

        final isAuthAfterClear = await authService.isAuthenticated();
        expect(
          isAuthAfterClear,
          isFalse,
          reason: 'Should not be authenticated after clearing',
        );
      } catch (e) {
        debugPrint('\n==================================================');
        debugPrint('Error occurred during redirect URI authentication: $e');
        debugPrint('==================================================\n');
        rethrow;
      } finally {
        microsoftAuthService.closeLocalServer();
        debugPrint('Cleaned up local server resources');
      }
    });
  });
}
