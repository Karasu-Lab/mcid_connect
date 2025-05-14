import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mcid_connect/data/auth/microsoft/device_code_response.dart';
import 'package:mcid_connect/data/auth/microsoft/microsoft_account.dart';
import 'package:mcid_connect/data/profile/minecraft_account_profile.dart';
import 'package:mcid_connect/mcid_connect.dart';
import 'package:mcid_connect/env/env.dart';

Future<void> printDeviceCodeInstructions(DeviceCodeResponse response) async {
  debugPrint('\n==================================================');
  debugPrint('Using real Microsoft authentication. Please follow these steps:');
  debugPrint('1. Open this URL: ${response.verificationUri}');
  debugPrint('2. Enter the code "${response.userCode}"');
  debugPrint('3. Sign in with your Microsoft account');
  debugPrint('4. Please wait for the authentication to complete...');
  debugPrint('==================================================\n');
}

Future<void> verifyMinecraftProfile(MinecraftAccountProfile profile) async {
  debugPrint('\n==================================================');
  debugPrint('Minecraft Profile Verification:');
  debugPrint('Username: ${profile.name}');
  debugPrint('UUID: ${profile.id}');
  debugPrint('==================================================\n');

  expect(profile.name, isNotEmpty, reason: 'Username should not be empty');
  expect(profile.id, isNotEmpty, reason: 'UUID should not be empty');
}

void main() {
  group('Minecraft Token Refresh and Profile Tests', () {
    late AuthService authService;
    late String cachedRefreshToken;
    late MinecraftAccountProfile originalProfile;
    late String xstsUhs;
    late String xstsToken;
    late String minecraftToken;

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
    });

    test(
      'Full Authentication Flow with Token Refresh and Profile Verification',
      () async {
        debugPrint('\n==================================================');
        debugPrint('STAGE 1: Initial Authentication');
        debugPrint('==================================================\n');

        bool authResult = await authService.startAuthenticationFlow(
          useDeviceCode: true,
        );
        expect(
          authResult,
          isTrue,
          reason: 'Initial authentication flow should succeed',
        );

        bool hasProfile = await authService.hasMinecraftProfile();
        expect(
          hasProfile,
          isTrue,
          reason: 'Should have a Minecraft profile after authentication',
        );

        cachedRefreshToken = authService.microsoftRefreshToken!;
        originalProfile = authService.minecraftProfile!;
        xstsUhs = authService.xstsUhs!;
        xstsToken = authService.xstsToken!;

        debugPrint('\n==================================================');
        debugPrint(
          'Original Refresh Token (truncated): ${cachedRefreshToken.substring(0, 20)}...',
        );
        debugPrint('Original XSTS UHS: $xstsUhs');
        debugPrint(
          'Original XSTS Token (truncated): ${xstsToken.substring(0, 20)}...',
        );
        debugPrint('==================================================\n');

        await verifyMinecraftProfile(originalProfile);

        debugPrint('\n==================================================');
        debugPrint('STAGE 2: Testing Token Refresh');
        debugPrint('==================================================\n');

        authService.clearAuthentication();

        MicrosoftAccount? microsoftAccount = await authService
            .refreshAuthenticationWithToken(cachedRefreshToken);

        expect(
          microsoftAccount,
          isNotNull,
          reason: 'Microsoft account should be retrieved with refresh token',
        );
        expect(
          microsoftAccount?.refreshToken,
          isNotEmpty,
          reason: 'New refresh token should be available',
        );

        debugPrint('\n==================================================');
        debugPrint('Refreshed Microsoft Account:');
        debugPrint(
          'New Refresh Token (truncated): ${microsoftAccount?.refreshToken.substring(0, 20)}...',
        );
        debugPrint('==================================================\n');

        bool isAuth = await authService.isAuthenticated();
        expect(isAuth, isTrue, reason: 'Should be authenticated after refresh');

        debugPrint('\n==================================================');
        debugPrint('Authentication Status after Refresh: $isAuth');
        debugPrint('New XSTS UHS: ${authService.xstsUhs}');
        debugPrint(
          'New XSTS Token (truncated): ${authService.xstsToken!.substring(0, 20)}...',
        );
        debugPrint('==================================================\n');

        debugPrint('\n==================================================');
        debugPrint('STAGE 3: Getting Minecraft Token with XSTS');
        debugPrint('==================================================\n');

        minecraftToken =
            await authService.getMinecraftTokenWithXstsToken(
              xstsUhs,
              xstsToken,
            ) ??
            '';

        expect(
          minecraftToken,
          isNotEmpty,
          reason: 'Should get a valid Minecraft token with XSTS',
        );

        debugPrint('\n==================================================');
        debugPrint('STAGE 4: Getting Minecraft Profile with Token');
        debugPrint('==================================================\n');

        MinecraftAccountProfile? profileWithToken = await authService
            .getMinecraftProfileWithToken(minecraftToken);

        expect(
          profileWithToken,
          isNotNull,
          reason: 'Should get a profile with the Minecraft token',
        );

        if (profileWithToken != null) {
          await verifyMinecraftProfile(profileWithToken);

          expect(
            profileWithToken.id,
            equals(originalProfile.id),
            reason: 'Profile UUID should match the original',
          );
          expect(
            profileWithToken.name,
            equals(originalProfile.name),
            reason: 'Profile name should match the original',
          );
        }

        debugPrint('\n==================================================');
        debugPrint('All tests completed successfully!');
        debugPrint('==================================================\n');
      },
    );
  });
}
