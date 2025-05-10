import 'package:json_annotation/json_annotation.dart';

part 'minecraft_token_response.g.dart';

@JsonSerializable()
class MinecraftTokenResponse {
  final String username;
  final List<String> roles;
  
  @JsonKey(name: 'access_token')
  final String accessToken;
  
  @JsonKey(name: 'token_type')
  final String tokenType;
  
  @JsonKey(name: 'expires_in')
  final int expiresIn;

  const MinecraftTokenResponse({
    required this.username,
    required this.roles,
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
  });

  MinecraftTokenResponse copyWith({
    String? username,
    List<String>? roles,
    String? accessToken,
    String? tokenType,
    int? expiresIn,
  }) {
    return MinecraftTokenResponse(
      username: username ?? this.username,
      roles: roles ?? this.roles,
      accessToken: accessToken ?? this.accessToken,
      tokenType: tokenType ?? this.tokenType,
      expiresIn: expiresIn ?? this.expiresIn,
    );
  }

  /// Converts a JSON map to a [MinecraftTokenResponse].
  factory MinecraftTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$MinecraftTokenResponseFromJson(json);

  /// Converts this [MinecraftTokenResponse] to a JSON map.
  Map<String, dynamic> toJson() => _$MinecraftTokenResponseToJson(this);
}
