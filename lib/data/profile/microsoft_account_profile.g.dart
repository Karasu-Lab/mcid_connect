// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'microsoft_account_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MicrosoftAccountProfile _$MicrosoftAccountProfileFromJson(
  Map<String, dynamic> json,
) => MicrosoftAccountProfile(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  expiresAt: MicrosoftAccountProfile._dateTimeFromJson(
    json['expiresAt'] as String,
  ),
  email: json['email'] as String,
  username: json['username'] as String,
  id: json['id'] as String,
);

Map<String, dynamic> _$MicrosoftAccountProfileToJson(
  MicrosoftAccountProfile instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'expiresAt': MicrosoftAccountProfile._dateTimeToJson(instance.expiresAt),
  'email': instance.email,
  'username': instance.username,
  'id': instance.id,
};
