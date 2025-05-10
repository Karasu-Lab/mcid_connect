import 'package:json_annotation/json_annotation.dart';

part 'xsts_response.g.dart';

@JsonSerializable()
class XSTSResponse {
  @JsonKey(name: 'IssueInstant')
  final String issueInstant;

  @JsonKey(name: 'NotAfter')
  final String notAfter;

  @JsonKey(name: 'Token')
  final String token;

  @JsonKey(name: 'DisplayClaims')
  final XSTSDisplayClaims displayClaims;

  const XSTSResponse({
    required this.issueInstant,
    required this.notAfter,
    required this.token,
    required this.displayClaims,
  });

  XSTSResponse copyWith({
    String? issueInstant,
    String? notAfter,
    String? token,
    XSTSDisplayClaims? displayClaims,
  }) {
    return XSTSResponse(
      issueInstant: issueInstant ?? this.issueInstant,
      notAfter: notAfter ?? this.notAfter,
      token: token ?? this.token,
      displayClaims: displayClaims ?? this.displayClaims,
    );
  }

  /// Converts a JSON map to a [XSTSResponse].
  factory XSTSResponse.fromJson(Map<String, dynamic> json) =>
      _$XSTSResponseFromJson(json);

  /// Converts this [XSTSResponse] to a JSON map.
  Map<String, dynamic> toJson() => _$XSTSResponseToJson(this);
}

@JsonSerializable()
class XSTSDisplayClaims {
  final List<XSTSXUI> xui;

  const XSTSDisplayClaims({
    required this.xui,
  });

  XSTSDisplayClaims copyWith({
    List<XSTSXUI>? xui,
  }) {
    return XSTSDisplayClaims(
      xui: xui ?? this.xui,
    );
  }

  /// Converts a JSON map to a [XSTSDisplayClaims].
  factory XSTSDisplayClaims.fromJson(Map<String, dynamic> json) =>
      _$XSTSDisplayClaimsFromJson(json);

  /// Converts this [XSTSDisplayClaims] to a JSON map.
  Map<String, dynamic> toJson() => _$XSTSDisplayClaimsToJson(this);
}

@JsonSerializable()
class XSTSXUI {
  final String uhs;
  final String xid;

  const XSTSXUI({
    required this.uhs,
    required this.xid,
  });

  XSTSXUI copyWith({
    String? uhs,
    String? xid,
  }) {
    return XSTSXUI(
      uhs: uhs ?? this.uhs,
      xid: xid ?? this.xid,
    );
  }

  /// Converts a JSON map to a [XSTSXUI].
  factory XSTSXUI.fromJson(Map<String, dynamic> json) => _$XSTSXUIFromJson(json);

  /// Converts this [XSTSXUI] to a JSON map.
  Map<String, dynamic> toJson() => _$XSTSXUIToJson(this);
}
