import 'package:json_annotation/json_annotation.dart';

part 'xbox_live_response.g.dart';

@JsonSerializable()
class XboxLiveResponse {
  @JsonKey(name: 'IssueInstant')
  final String issueInstant;

  @JsonKey(name: 'NotAfter')
  final String notAfter;

  @JsonKey(name: 'Token')
  final String token;

  @JsonKey(name: 'DisplayClaims')
  final DisplayClaims displayClaims;

  const XboxLiveResponse({
    required this.issueInstant,
    required this.notAfter,
    required this.token,
    required this.displayClaims,
  });

  XboxLiveResponse copyWith({
    String? issueInstant,
    String? notAfter,
    String? token,
    DisplayClaims? displayClaims,
  }) {
    return XboxLiveResponse(
      issueInstant: issueInstant ?? this.issueInstant,
      notAfter: notAfter ?? this.notAfter,
      token: token ?? this.token,
      displayClaims: displayClaims ?? this.displayClaims,
    );
  }

  /// Converts a JSON map to a [XboxLiveResponse].
  factory XboxLiveResponse.fromJson(Map<String, dynamic> json) =>
      _$XboxLiveResponseFromJson(json);

  /// Converts this [XboxLiveResponse] to a JSON map.
  Map<String, dynamic> toJson() => _$XboxLiveResponseToJson(this);
}

@JsonSerializable()
class DisplayClaims {
  final List<XUI> xui;

  const DisplayClaims({
    required this.xui,
  });

  DisplayClaims copyWith({
    List<XUI>? xui,
  }) {
    return DisplayClaims(
      xui: xui ?? this.xui,
    );
  }

  /// Converts a JSON map to a [DisplayClaims].
  factory DisplayClaims.fromJson(Map<String, dynamic> json) =>
      _$DisplayClaimsFromJson(json);

  /// Converts this [DisplayClaims] to a JSON map.
  Map<String, dynamic> toJson() => _$DisplayClaimsToJson(this);
}

@JsonSerializable()
class XUI {
  final String uhs;

  const XUI({
    required this.uhs,
  });

  XUI copyWith({
    String? uhs,
  }) {
    return XUI(
      uhs: uhs ?? this.uhs,
    );
  }

  /// Converts a JSON map to a [XUI].
  factory XUI.fromJson(Map<String, dynamic> json) => _$XUIFromJson(json);

  /// Converts this [XUI] to a JSON map.
  Map<String, dynamic> toJson() => _$XUIToJson(this);
}
