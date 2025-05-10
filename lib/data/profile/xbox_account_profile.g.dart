// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xbox_account_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

XboxAccountProfile _$XboxAccountProfileFromJson(Map<String, dynamic> json) =>
    XboxAccountProfile(
      token: json['token'] as String,
      userHash: json['userHash'] as String,
      xuid: json['xuid'] as String,
      expiresAt: XboxAccountProfile._dateTimeFromJson(
        json['expiresAt'] as String,
      ),
    );

Map<String, dynamic> _$XboxAccountProfileToJson(XboxAccountProfile instance) =>
    <String, dynamic>{
      'token': instance.token,
      'userHash': instance.userHash,
      'xuid': instance.xuid,
      'expiresAt': XboxAccountProfile._dateTimeToJson(instance.expiresAt),
    };
