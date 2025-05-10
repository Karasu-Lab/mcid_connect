// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'microsoft_token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MicrosoftTokenResponse _$MicrosoftTokenResponseFromJson(
  Map<String, dynamic> json,
) => MicrosoftTokenResponse(
  tokenType: json['token_type'] as String,
  expiresIn: (json['expires_in'] as num).toInt(),
  scope: json['scope'] as String,
  accessToken: json['access_token'] as String,
  refreshToken: json['refresh_token'] as String,
  userId: json['user_id'] as String?,
);

Map<String, dynamic> _$MicrosoftTokenResponseToJson(
  MicrosoftTokenResponse instance,
) => <String, dynamic>{
  'token_type': instance.tokenType,
  'expires_in': instance.expiresIn,
  'scope': instance.scope,
  'access_token': instance.accessToken,
  'refresh_token': instance.refreshToken,
  'user_id': instance.userId,
};
