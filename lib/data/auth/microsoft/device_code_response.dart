import 'package:json_annotation/json_annotation.dart';

part 'device_code_response.g.dart';

@JsonSerializable()
class DeviceCodeResponse {
  @JsonKey(name: 'device_code')
  final String deviceCode;

  @JsonKey(name: 'user_code')
  final String userCode;

  @JsonKey(name: 'verification_uri')
  final String verificationUri;

  final int interval;

  @JsonKey(name: 'expires_in')
  final int expiresIn;

  const DeviceCodeResponse({
    required this.deviceCode,
    required this.userCode,
    required this.verificationUri,
    required this.interval,
    required this.expiresIn,
  });

  DeviceCodeResponse copyWith({
    String? deviceCode,
    String? userCode,
    String? verificationUri,
    int? interval,
    int? expiresIn,
  }) {
    return DeviceCodeResponse(
      deviceCode: deviceCode ?? this.deviceCode,
      userCode: userCode ?? this.userCode,
      verificationUri: verificationUri ?? this.verificationUri,
      interval: interval ?? this.interval,
      expiresIn: expiresIn ?? this.expiresIn,
    );
  }

  /// Converts a JSON map to a [DeviceCodeResponse].
  factory DeviceCodeResponse.fromJson(Map<String, dynamic> json) =>
      _$DeviceCodeResponseFromJson(json);

  /// Converts this [DeviceCodeResponse] to a JSON map.
  Map<String, dynamic> toJson() => _$DeviceCodeResponseToJson(this);
}
