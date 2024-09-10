// To parse this JSON data, do
//
//     final profileResponseModel = profileResponseModelFromJson(jsonString);

import 'dart:convert';

import 'login_response_model.dart';

ProfileResponseModel profileResponseModelFromJson(String str) =>
    ProfileResponseModel.fromJson(json.decode(str));

class ProfileResponseModel {
  int? status;
  UserInfo? data;
  List<List<String>>? m;

  ProfileResponseModel({
    required this.status,
    required this.data,
    required this.m,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      ProfileResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : UserInfo.fromJson(json["data"]),
        m: json["m"] == null
            ? []
            : List<List<String>>.from(
                json["m"].map(
                    (x) => x == null ? [] : List<String>.from(x.map((x) => x))),
              ),
      );
}
