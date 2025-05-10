// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'minecraft_account_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MinecraftAccountProfile _$MinecraftAccountProfileFromJson(
  Map<String, dynamic> json,
) => MinecraftAccountProfile(
  id: json['id'] as String,
  name: json['name'] as String,
  skins:
      (json['skins'] as List<dynamic>)
          .map((e) => MinecraftSkin.fromJson(e as Map<String, dynamic>))
          .toList(),
  capes:
      (json['capes'] as List<dynamic>)
          .map((e) => MinecraftSkin.fromJson(e as Map<String, dynamic>))
          .toList(),
  profileActions: json['profileActions'] as Map<String, dynamic>,
);

Map<String, dynamic> _$MinecraftAccountProfileToJson(
  MinecraftAccountProfile instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'skins': instance.skins,
  'capes': instance.capes,
  'profileActions': instance.profileActions,
};

MinecraftProfileItem _$MinecraftProfileItemFromJson(
  Map<String, dynamic> json,
) => MinecraftProfileItem(
  id: json['id'] as String,
  name: json['name'] as String,
  skin:
      json['skin'] == null
          ? null
          : MinecraftSkin.fromJson(json['skin'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MinecraftProfileItemToJson(
  MinecraftProfileItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'skin': instance.skin,
};

MinecraftSkin _$MinecraftSkinFromJson(Map<String, dynamic> json) =>
    MinecraftSkin(
      id: json['id'] as String,
      state: json['state'] as String,
      url: json['url'] as String,
      textureKey: json['textureKey'] as String?,
      variant: json['variant'] as String?,
    );

Map<String, dynamic> _$MinecraftSkinToJson(MinecraftSkin instance) =>
    <String, dynamic>{
      'id': instance.id,
      'state': instance.state,
      'url': instance.url,
      if (instance.textureKey case final value?) 'textureKey': value,
      if (instance.variant case final value?) 'variant': value,
    };

MinecraftCapes _$MinecraftCapesFromJson(Map<String, dynamic> json) =>
    MinecraftCapes(
      id: json['id'] as String,
      state: json['state'] as String,
      url: json['url'] as String,
      alias: json['alias'] as String,
    );

Map<String, dynamic> _$MinecraftCapesToJson(MinecraftCapes instance) =>
    <String, dynamic>{
      'id': instance.id,
      'state': instance.state,
      'url': instance.url,
      'alias': instance.alias,
    };
