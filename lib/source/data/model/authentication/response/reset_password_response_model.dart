// To parse this JSON data, do
//
//     final resetPasswordResponseModel = resetPasswordResponseModelFromJson(jsonString);

import 'dart:convert';

import 'login_response_model.dart';

ResetPasswordResponseModel resetPasswordResponseModelFromJson(String str) =>
    ResetPasswordResponseModel.fromJson(json.decode(str));

class ResetPasswordResponseModel {
  int? status;
  String? authcode;
  UserInfo? data;
  List<List<String>>? m;

  ResetPasswordResponseModel({
    required this.status,
    required this.authcode,
    required this.data,
    required this.m,
  });

  factory ResetPasswordResponseModel.fromJson(Map<String, dynamic> json) =>
      ResetPasswordResponseModel(
        status: json["status"],
        authcode: json["authcode"],
        data: UserInfo.fromJson(json["data"]),
        m: List<List<String>>.from(
            json["m"].map((x) => List<String>.from(x.map((x) => x)))),
      );
}
