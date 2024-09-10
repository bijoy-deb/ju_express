// To parse this JSON data, do
//
//     final forgotPasswordResponseModel = forgotPasswordResponseModelFromJson(jsonString);

import 'dart:convert';

ForgotPasswordResponseModel forgotPasswordResponseModelFromJson(String str) => ForgotPasswordResponseModel.fromJson(json.decode(str));


class ForgotPasswordResponseModel {
    int? status;
    List<List<String>>? m;

    ForgotPasswordResponseModel({
        required this.status,
        required this.m,
    });

    factory ForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) => ForgotPasswordResponseModel(
        status: json["status"],
        m: List<List<String>>.from(json["m"].map((x) => List<String>.from(x.map((x) => x)))),
    );


}
