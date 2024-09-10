// To parse this JSON data, do
//
//     final resendOtpResponseModel = resendOtpResponseModelFromJson(jsonString);

import 'dart:convert';

ResendOtpResponseModel resendOtpResponseModelFromJson(String str) => ResendOtpResponseModel.fromJson(json.decode(str));

class ResendOtpResponseModel {
    int? status;
    List<List<String>>? m;

    ResendOtpResponseModel({
         this.status,
         this.m,
    });

    factory ResendOtpResponseModel.fromJson(Map<String, dynamic> json) => ResendOtpResponseModel(
        status: json["status"],
        m: List<List<String>>.from(json["m"].map((x) => List<String>.from(x.map((x) => x)))),
    );

}
