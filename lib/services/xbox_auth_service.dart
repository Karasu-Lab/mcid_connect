import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mcid_connect/interfaces/auth_interfaces.dart';

class XboxAuthService implements XboxAuthServiceInterface {
  final http.Client _httpClient;

  static XboxAuthService? _instance;

  factory XboxAuthService({http.Client? httpClient}) {
    _instance ??= XboxAuthService._internal(httpClient ?? http.Client());
    return _instance!;
  }

  XboxAuthService._internal(this._httpClient);
  /// MicrosoftアクセストークンからXboxトークンを取得し、XSTSトークンを生成する
  @override
  Future<Map<String, String>> getXstsToken(String accessToken) async {
    // 1. XBL (Xbox Live) 認証トークンを取得
    final xblToken = await _getXboxLiveToken(accessToken);

    // 2. XSTSトークンを取得
    return await _getXstsTokenFromXbl(xblToken);
  }

  /// Microsoft アクセストークンを Xbox Live トークンに変換する
  Future<String> _getXboxLiveToken(String accessToken) async {
    final response = await _httpClient.post(
      Uri.parse('https://user.auth.xboxlive.com/user/authenticate'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'Properties': {
          'AuthMethod': 'RPS',
          'SiteName': 'user.auth.xboxlive.com',
          'RpsTicket': 'd=${accessToken}',
        },
        'RelyingParty': 'http://auth.xboxlive.com',
        'TokenType': 'JWT',
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['Token'];
    } else {
      throw Exception('Failed to get Xbox Live token: ${response.body}');
    }
  }
  /// XBLトークンからXSTSトークンを取得する
  Future<Map<String, String>> _getXstsTokenFromXbl(String xblToken) async {
    final response = await _httpClient.post(
      Uri.parse('https://xsts.auth.xboxlive.com/xsts/authorize'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'Properties': {
          'SandboxId': 'RETAIL',
          'UserTokens': [xblToken],
        },
        'RelyingParty': 'rp://api.minecraftservices.com/',
        'TokenType': 'JWT',
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final token = jsonResponse['Token'];
      String uhs = "";
      if (jsonResponse['DisplayClaims'] != null && 
          jsonResponse['DisplayClaims']['xui'] != null && 
          jsonResponse['DisplayClaims']['xui'].isNotEmpty) {
        uhs = jsonResponse['DisplayClaims']['xui'][0]['uhs'];
      }
      return {'token': token, 'uhs': uhs};
    } else {
      throw Exception('Failed to get XSTS token: ${response.body}');
    }
  }
}
