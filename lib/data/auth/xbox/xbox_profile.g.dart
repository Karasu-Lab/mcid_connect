// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xbox_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

XboxProfile _$XboxProfileFromJson(Map<String, dynamic> json) => XboxProfile(
  displayName: json['displayName'] as String,
  xuid: json['xuid'] as String,
  profilePicture: json['profilePicture'] as String?,
);

Map<String, dynamic> _$XboxProfileToJson(XboxProfile instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'xuid': instance.xuid,
      'profilePicture': instance.profilePicture,
    };
