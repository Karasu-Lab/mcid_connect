import 'package:json_annotation/json_annotation.dart';

part 'xbox_account_profile.g.dart';

@JsonSerializable()
class XboxAccountProfile {
  final String token;
  final String userHash;
  final String xuid;
  
  @JsonKey(
    fromJson: _dateTimeFromJson, 
    toJson: _dateTimeToJson
  )
  final DateTime expiresAt;

  const XboxAccountProfile({
    required this.token,
    required this.userHash,
    required this.xuid,
    required this.expiresAt,
  });

  XboxAccountProfile copyWith({
    String? token,
    String? userHash,
    String? xuid,
    DateTime? expiresAt,
  }) {
    return XboxAccountProfile(
      token: token ?? this.token,
      userHash: userHash ?? this.userHash,
      xuid: xuid ?? this.xuid,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  /// Converts a JSON map to a [XboxAccountProfile].
  factory XboxAccountProfile.fromJson(Map<String, dynamic> json) => 
      _$XboxAccountProfileFromJson(json);

  /// Converts this [XboxAccountProfile] to a JSON map.
  Map<String, dynamic> toJson() => _$XboxAccountProfileToJson(this);

  /// Helper method for DateTime serialization
  static DateTime _dateTimeFromJson(String date) => DateTime.parse(date);
  
  /// Helper method for DateTime serialization
  static String _dateTimeToJson(DateTime date) => date.toIso8601String();

  /// Checks if the token is expired
  bool get isTokenExpired => DateTime.now().isAfter(expiresAt);
}