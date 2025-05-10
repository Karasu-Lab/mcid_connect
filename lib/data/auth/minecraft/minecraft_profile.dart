import 'package:json_annotation/json_annotation.dart';

part 'minecraft_profile.g.dart';

@JsonSerializable()
class MinecraftProfile {
  final String id;
  final String name;
  final List<MinecraftSkin>? skins;
  final List<MinecraftCape>? capes;

  const MinecraftProfile({
    required this.id,
    required this.name,
    this.skins,
    this.capes,
  });

  MinecraftProfile copyWith({
    String? id,
    String? name,
    List<MinecraftSkin>? skins,
    List<MinecraftCape>? capes,
  }) {
    return MinecraftProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      skins: skins ?? this.skins,
      capes: capes ?? this.capes,
    );
  }

  /// スキンのURLを取得するゲッター
  String? get skinUrl {
    // スキンがある場合は最初のスキンのURLを返す
    if (skins != null && skins!.isNotEmpty) {
      return skins![0].url;
    }
    return null;
  }

  /// ケープのURLを取得するゲッター
  String? get capeUrl {
    // ケープがある場合は最初のケープのURLを返す
    if (capes != null && capes!.isNotEmpty) {
      return capes![0].url;
    }
    return null;
  }

  /// Converts a JSON map to a [MinecraftProfile].
  factory MinecraftProfile.fromJson(Map<String, dynamic> json) =>
      _$MinecraftProfileFromJson(json);

  /// Converts this [MinecraftProfile] to a JSON map.
  Map<String, dynamic> toJson() => _$MinecraftProfileToJson(this);
}

@JsonSerializable()
class MinecraftSkin {
  final String id;
  final String state;
  final String url;
  final String variant;
  final String? alias;

  const MinecraftSkin({
    required this.id,
    required this.state,
    required this.url,
    required this.variant,
    this.alias,
  });

  MinecraftSkin copyWith({
    String? id,
    String? state,
    String? url,
    String? variant,
    String? alias,
  }) {
    return MinecraftSkin(
      id: id ?? this.id,
      state: state ?? this.state,
      url: url ?? this.url,
      variant: variant ?? this.variant,
      alias: alias ?? this.alias,
    );
  }

  /// Converts a JSON map to a [MinecraftSkin].
  factory MinecraftSkin.fromJson(Map<String, dynamic> json) =>
      _$MinecraftSkinFromJson(json);

  /// Converts this [MinecraftSkin] to a JSON map.
  Map<String, dynamic> toJson() => _$MinecraftSkinToJson(this);
}

@JsonSerializable()
class MinecraftCape {
  final String id;
  final String state;
  final String url;
  final String alias;

  const MinecraftCape({
    required this.id,
    required this.state,
    required this.url,
    required this.alias,
  });

  MinecraftCape copyWith({
    String? id,
    String? state,
    String? url,
    String? alias,
  }) {
    return MinecraftCape(
      id: id ?? this.id,
      state: state ?? this.state,
      url: url ?? this.url,
      alias: alias ?? this.alias,
    );
  }

  /// Converts a JSON map to a [MinecraftCape].
  factory MinecraftCape.fromJson(Map<String, dynamic> json) =>
      _$MinecraftCapeFromJson(json);

  /// Converts this [MinecraftCape] to a JSON map.
  Map<String, dynamic> toJson() => _$MinecraftCapeToJson(this);
}
