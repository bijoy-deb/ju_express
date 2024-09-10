// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
  int? status;
  String? authcode;
  UserInfo? data;
  List<List<String>>? m;

  LoginResponseModel({
    this.status,
    this.authcode,
    this.data,
    this.m,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        status: json["status"],
        authcode: json["authcode"],
        data: json["data"] == null ? null : UserInfo.fromJson(json["data"]),
        m: List<List<String>>.from(
            json["m"].map((x) => List<String>.from(x.map((x) => x)))),
      );
}

class UserInfo {
  String? cCode;
  String? cMobile;
  String? cEmail;
  String? cFirstName;
  String? cSureName;
  String? cLastName;
  String? cFatherName;

  UserInfo({
    this.cCode,
    this.cMobile,
    this.cEmail,
    this.cFirstName,
    this.cSureName,
    this.cLastName,
    this.cFatherName,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        cCode: json["cCode"],
        cMobile: json["cMobile"],
        cEmail: json["cEmail"],
        cFirstName: json["cFirstName"],
        cSureName: json["cSureName"],
        cLastName: json["cLastName"],
        cFatherName: json["cFatherName"],
      );

  Map<String, dynamic> toJson() => {
        "cCode": cCode,
        "cMobile": cMobile,
        "cEmail": cEmail,
        "cFirstName": cFirstName,
        "cSureName": cSureName,
        "cLastName": cLastName,
        "cFatherName": cFatherName,
      };
}
