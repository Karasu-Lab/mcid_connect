// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xsts_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

XSTSResponse _$XSTSResponseFromJson(Map<String, dynamic> json) => XSTSResponse(
  issueInstant: json['IssueInstant'] as String,
  notAfter: json['NotAfter'] as String,
  token: json['Token'] as String,
  displayClaims: XSTSDisplayClaims.fromJson(
    json['DisplayClaims'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$XSTSResponseToJson(XSTSResponse instance) =>
    <String, dynamic>{
      'IssueInstant': instance.issueInstant,
      'NotAfter': instance.notAfter,
      'Token': instance.token,
      'DisplayClaims': instance.displayClaims,
    };

XSTSDisplayClaims _$XSTSDisplayClaimsFromJson(Map<String, dynamic> json) =>
    XSTSDisplayClaims(
      xui:
          (json['xui'] as List<dynamic>)
              .map((e) => XSTSXUI.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$XSTSDisplayClaimsToJson(XSTSDisplayClaims instance) =>
    <String, dynamic>{'xui': instance.xui};

XSTSXUI _$XSTSXUIFromJson(Map<String, dynamic> json) =>
    XSTSXUI(uhs: json['uhs'] as String, xid: json['xid'] as String);

Map<String, dynamic> _$XSTSXUIToJson(XSTSXUI instance) => <String, dynamic>{
  'uhs': instance.uhs,
  'xid': instance.xid,
};
