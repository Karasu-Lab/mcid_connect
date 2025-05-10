import 'package:json_annotation/json_annotation.dart';

part 'microsoft_token_response.g.dart';

@JsonSerializable()
class MicrosoftTokenResponse {
  @JsonKey(name: 'token_type')
  final String tokenType;

  @JsonKey(name: 'expires_in')
  final int expiresIn;

  final String scope;

  @JsonKey(name: 'access_token')
  final String accessToken;

  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  @JsonKey(name: 'user_id')
  final String? userId;

  const MicrosoftTokenResponse({
    required this.tokenType,
    required this.expiresIn,
    required this.scope,
    required this.accessToken,
    required this.refreshToken,
    this.userId,
  });

  MicrosoftTokenResponse copyWith({
    String? tokenType,
    int? expiresIn,
    String? scope,
    String? accessToken,
    String? refreshToken,
    String? userId,
  }) {
    return MicrosoftTokenResponse(
      tokenType: tokenType ?? this.tokenType,
      expiresIn: expiresIn ?? this.expiresIn,
      scope: scope ?? this.scope,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      userId: userId ?? this.userId,
    );
  }

  /// Converts a JSON map to a [MicrosoftTokenResponse].
  factory MicrosoftTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$MicrosoftTokenResponseFromJson(json);

  /// Converts this [MicrosoftTokenResponse] to a JSON map.
  Map<String, dynamic> toJson() => _$MicrosoftTokenResponseToJson(this);
}
