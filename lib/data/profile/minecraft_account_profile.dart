import 'package:json_annotation/json_annotation.dart';

part 'minecraft_account_profile.g.dart';

@JsonSerializable()
class MinecraftAccountProfile {
  final String id;
  final String name;
  final List<MinecraftSkin> skins;
  final List<MinecraftSkin> capes;
  final Map<String, dynamic> profileActions;

  const MinecraftAccountProfile({
    required this.id,
    required this.name,
    required this.skins,
    required this.capes,
    required this.profileActions,
  });

  MinecraftAccountProfile copyWith({
    String? username,
    String? uuid,
    String? accessToken,
    DateTime? expiresAt,
  }) {
    return MinecraftAccountProfile(
      id: username ?? id,
      name: uuid ?? name,
      skins: skins,
      capes: capes,
      profileActions: profileActions,
    );
  }

  /// Converts a JSON map to a [MinecraftAccountProfile].
  factory MinecraftAccountProfile.fromJson(Map<String, dynamic> json) =>
      _$MinecraftAccountProfileFromJson(json);

  /// Converts this [MinecraftAccountProfile] to a JSON map.
  Map<String, dynamic> toJson() => _$MinecraftAccountProfileToJson(this);
}

@JsonSerializable()
class MinecraftProfileItem {
  final String id;
  final String name;
  final MinecraftSkin? skin;

  const MinecraftProfileItem({required this.id, required this.name, this.skin});

  MinecraftProfileItem copyWith({
    String? id,
    String? name,
    MinecraftSkin? skin,
  }) {
    return MinecraftProfileItem(
      id: id ?? this.id,
      name: name ?? this.name,
      skin: skin ?? this.skin,
    );
  }

  /// Converts a JSON map to a [MinecraftProfileItem].
  factory MinecraftProfileItem.fromJson(Map<String, dynamic> json) =>
      _$MinecraftProfileItemFromJson(json);

  /// Converts this [MinecraftProfileItem] to a JSON map.
  Map<String, dynamic> toJson() => _$MinecraftProfileItemToJson(this);
}

@JsonSerializable()
class MinecraftSkin {
  final String id;
  final String state;
  final String url;

  @JsonKey(includeIfNull: false)
  String? textureKey;
  @JsonKey(includeIfNull: false)
  String? variant;

  MinecraftSkin({
    required this.id,
    required this.state,
    required this.url,
    required this.textureKey,
    this.variant,
  });

  MinecraftSkin copyWith({
    String? id,
    String? state,
    String? url,
    String? textureKey,
    String? variant,
  }) {
    return MinecraftSkin(
      id: id ?? this.id,
      state: state ?? this.state,
      url: url ?? this.url,
      textureKey: textureKey ?? this.textureKey,
      variant: variant ?? this.variant,
    );
  }

  /// Converts a JSON map to a [MinecraftSkin].
  factory MinecraftSkin.fromJson(Map<String, dynamic> json) =>
      _$MinecraftSkinFromJson(json);

  /// Converts this [MinecraftSkin] to a JSON map.
  Map<String, dynamic> toJson() => _$MinecraftSkinToJson(this);
}

@JsonSerializable()
class MinecraftCapes {
  final String id;
  final String state;
  final String url;
  final String alias;

  const MinecraftCapes({
    required this.id,
    required this.state,
    required this.url,
    required this.alias,
  });

  factory MinecraftCapes.fromJson(Map<String, dynamic> json) =>
      _$MinecraftCapesFromJson(json);

  Map<String, dynamic> toJson() => _$MinecraftCapesToJson(this);
}
