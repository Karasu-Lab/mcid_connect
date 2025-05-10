// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'minecraft_token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MinecraftTokenResponse _$MinecraftTokenResponseFromJson(
  Map<String, dynamic> json,
) => MinecraftTokenResponse(
  username: json['username'] as String,
  roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
  accessToken: json['access_token'] as String,
  tokenType: json['token_type'] as String,
  expiresIn: (json['expires_in'] as num).toInt(),
);

Map<String, dynamic> _$MinecraftTokenResponseToJson(
  MinecraftTokenResponse instance,
) => <String, dynamic>{
  'username': instance.username,
  'roles': instance.roles,
  'access_token': instance.accessToken,
  'token_type': instance.tokenType,
  'expires_in': instance.expiresIn,
};
