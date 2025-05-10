
import 'package:json_annotation/json_annotation.dart';

part 'microsoft_account_profile.g.dart';

@JsonSerializable()
class MicrosoftAccountProfile {
  final String accessToken;
  final String refreshToken;
  
  @JsonKey(
    fromJson: _dateTimeFromJson, 
    toJson: _dateTimeToJson
  )
  final DateTime expiresAt;
  
  final String email;
  final String username;
  final String id;

  const MicrosoftAccountProfile({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.email,
    required this.username,
    required this.id,
  });

  MicrosoftAccountProfile copyWith({
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    String? email,
    String? username,
    String? id,
  }) {
    return MicrosoftAccountProfile(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      email: email ?? this.email,
      username: username ?? this.username,
      id: id ?? this.id,
    );
  }

  /// Converts a JSON map to a [MicrosoftAccountProfile].
  factory MicrosoftAccountProfile.fromJson(Map<String, dynamic> json) => 
      _$MicrosoftAccountProfileFromJson(json);

  /// Converts this [MicrosoftAccountProfile] to a JSON map.
  Map<String, dynamic> toJson() => _$MicrosoftAccountProfileToJson(this);

  /// Helper method for DateTime serialization
  static DateTime _dateTimeFromJson(String date) => DateTime.parse(date);
  
  /// Helper method for DateTime serialization
  static String _dateTimeToJson(DateTime date) => date.toIso8601String();

  /// Checks if the token is expired
  bool get isTokenExpired => DateTime.now().isAfter(expiresAt);
}