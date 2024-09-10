// To parse this JSON data, do
//
//     final otpVerificationResponseModel = otpVerificationResponseModelFromJson(jsonString);

import 'dart:convert';

import 'login_response_model.dart';

OtpVerificationResponseModel otpVerificationResponseModelFromJson(String str) =>
    OtpVerificationResponseModel.fromJson(json.decode(str));

String otpVerificationResponseModelToJson(OtpVerificationResponseModel data) =>
    json.encode(data.toJson());

class OtpVerificationResponseModel {
  int? status;
  String? authcode;
  UserInfo? data;
  List<List<String>>? m;

  OtpVerificationResponseModel({
    this.status,
    this.authcode,
    this.data,
    this.m,
  });

  factory OtpVerificationResponseModel.fromJson(Map<String, dynamic> json) =>
      OtpVerificationResponseModel(
        status: json["status"],
        authcode: json["authcode"],
        data: json["data"] == null ? null : UserInfo.fromJson(json["data"]),
        m: json["m"] == null
            ? []
            : List<List<String>>.from(
                json["m"]!.map((x) => List<String>.from(x.map((x) => x)))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "authcode": authcode,
        "data": data?.toJson(),
        "m": m == null
            ? []
            : List<dynamic>.from(
                m!.map((x) => List<dynamic>.from(x.map((x) => x)))),
      };
}
