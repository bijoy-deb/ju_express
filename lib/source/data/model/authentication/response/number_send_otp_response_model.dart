// To parse this JSON data, do
//
//     final numberSendOtpResponseModel = numberSendOtpResponseModelFromJson(jsonString);

import 'dart:convert';

NumberSendOtpResponseModel numberSendOtpResponseModelFromJson(String str) => NumberSendOtpResponseModel.fromJson(json.decode(str));


class NumberSendOtpResponseModel {
    int? status;
    int? otp;
    List<List<String>>? m;

    NumberSendOtpResponseModel({
        required this.status,
        required this.otp,
        required this.m,
    });

    factory NumberSendOtpResponseModel.fromJson(Map<String, dynamic> json) => NumberSendOtpResponseModel(
        status: json["status"],
        otp: json["otp"],
        m: List<List<String>>.from(json["m"].map((x) => List<String>.from(x.map((x) => x)))),
    );

}
