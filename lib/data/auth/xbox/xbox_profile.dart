import 'package:json_annotation/json_annotation.dart';

part 'xbox_profile.g.dart';

@JsonSerializable()
class XboxProfile {
  @JsonKey(name: 'displayName')
  final String displayName;

  @JsonKey(name: 'xuid')
  final String xuid;

  @JsonKey(name: 'profilePicture')
  final String? profilePicture;

  const XboxProfile({
    required this.displayName,
    required this.xuid,
    this.profilePicture,
  });

  XboxProfile copyWith({
    String? displayName,
    String? xuid,
    String? profilePicture,
  }) {
    return XboxProfile(
      displayName: displayName ?? this.displayName,
      xuid: xuid ?? this.xuid,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  /// Converts a JSON map to a [XboxProfile].
  factory XboxProfile.fromJson(Map<String, dynamic> json) =>
      _$XboxProfileFromJson(json);

  /// Converts this [XboxProfile] to a JSON map.
  Map<String, dynamic> toJson() => _$XboxProfileToJson(this);
}
