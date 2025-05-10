# Mcid Connect

A Dart package for Minecraft authentication that simplifies the process of logging into Minecraft services using Microsoft accounts.

## Features

- Microsoft account authentication
- Xbox Live authentication
- Minecraft account validation
- Profile information retrieval
- Token management

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  mcid_connect: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Authentication Flow

The authentication process involves several steps through Microsoft, Xbox Live, and Minecraft services. The `AuthService` class handles this flow for you:

```dart
import 'package:mcid_connect/mcid_connect.dart';

// Initialize the auth service
final authService = AuthService(
  clientId: 'your-microsoft-client-id',
  redirectUri: 'http://localhost:8080',
  scopes: ['XboxLive.signin', 'XboxLive.offline_access'],
  onGetDeviceCode: (deviceCode) {
    // Show verification URL and user code to the user
    print('Please visit: ${deviceCode.verificationUri}');
    print('And enter this code: ${deviceCode.userCode}');
  },
);

// Start the authentication process
void login() async {
  try {
    // Will trigger the onGetDeviceCode callback with instructions for the user
    final profile = await authService.authenticate();
    
    if (profile != null) {
      print('Successfully logged in as: ${profile.name}');
      print('UUID: ${profile.id}');
    }
  } catch (e) {
    print('Authentication failed: $e');
  }
}
```

### Saving and Restoring Sessions

You can save and restore authentication sessions to avoid requiring users to log in repeatedly:

```dart
// Save session after successful login
Future<void> saveSession() async {
  final session = await authService.getAuthenticationData();
  // Store session data securely (e.g., using flutter_secure_storage)
}

// Restore session on app startup
Future<void> restoreSession(Map<String, dynamic> sessionData) async {
  final success = await authService.restoreAuthentication(sessionData);
  if (success) {
    final profile = authService.minecraftProfile;
    print('Session restored for: ${profile?.name}');
  } else {
    print('Session expired or invalid, new login required');
  }
}
```

### Advanced Usage: Direct Service Access

You can also use the individual services directly for more control:

```dart
// Microsoft authentication
final microsoftAuthService = MicrosoftAuthService(
  clientId: 'your-microsoft-client-id',
  redirectUri: 'http://localhost:8080',
);

// Xbox authentication
final xboxAuthService = XboxAuthService();

// Minecraft authentication
final minecraftAuthService = MinecraftAuthService(
  clientId: 'your-client-id',
);

// Manual authentication flow
Future<void> manualAuthentication() async {
  // 1. Get Microsoft token
  final microsoftAccount = await microsoftAuthService.authenticateWithDeviceCode(
    (deviceCode) => print('Visit ${deviceCode.verificationUri} and enter ${deviceCode.userCode}'),
  );
  
  // 2. Get Xbox token using Microsoft token
  final xboxAccount = await xboxAuthService.authenticate(microsoftAccount.accessToken);
  
  // 3. Get Minecraft token using Xbox token
  final minecraftProfile = await minecraftAuthService.authenticate(xboxAccount.xstsToken);
  
  print('Logged in as: ${minecraftProfile.name}');
}
```

## Environment Variables

For security, you can use environment variables for sensitive information:

```dart
// Create a .env file in your project root:
// MICROSOFT_CLIENT_ID=your-client-id
// REDIRECT_URI=http://localhost:8080

// Then load it in your code:
import 'package:dotenv/dotenv.dart';

void main() {
  final env = DotEnv()..load();
  
  final authService = AuthService(
    clientId: env['MICROSOFT_CLIENT_ID'] ?? '',
    redirectUri: env['REDIRECT_URI'] ?? '',
    scopes: ['XboxLive.signin', 'XboxLive.offline_access'],
    // ...
  );
}
```

## License

This package is available under the MIT License.
