// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'minecraft_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MinecraftProfile _$MinecraftProfileFromJson(Map<String, dynamic> json) =>
    MinecraftProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      skins:
          (json['skins'] as List<dynamic>?)
              ?.map((e) => MinecraftSkin.fromJson(e as Map<String, dynamic>))
              .toList(),
      capes:
          (json['capes'] as List<dynamic>?)
              ?.map((e) => MinecraftCape.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$MinecraftProfileToJson(MinecraftProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'skins': instance.skins,
      'capes': instance.capes,
    };

MinecraftSkin _$MinecraftSkinFromJson(Map<String, dynamic> json) =>
    MinecraftSkin(
      id: json['id'] as String,
      state: json['state'] as String,
      url: json['url'] as String,
      variant: json['variant'] as String,
      alias: json['alias'] as String?,
    );

Map<String, dynamic> _$MinecraftSkinToJson(MinecraftSkin instance) =>
    <String, dynamic>{
      'id': instance.id,
      'state': instance.state,
      'url': instance.url,
      'variant': instance.variant,
      'alias': instance.alias,
    };

MinecraftCape _$MinecraftCapeFromJson(Map<String, dynamic> json) =>
    MinecraftCape(
      id: json['id'] as String,
      state: json['state'] as String,
      url: json['url'] as String,
      alias: json['alias'] as String,
    );

Map<String, dynamic> _$MinecraftCapeToJson(MinecraftCape instance) =>
    <String, dynamic>{
      'id': instance.id,
      'state': instance.state,
      'url': instance.url,
      'alias': instance.alias,
    };
