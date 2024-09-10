// To parse this JSON data, do
//
//     final mailSendOtpResponseModel = mailSendOtpResponseModelFromJson(jsonString);

import 'dart:convert';

MailSendOtpResponseModel mailSendOtpResponseModelFromJson(String str) => MailSendOtpResponseModel.fromJson(json.decode(str));


class MailSendOtpResponseModel {
    int? status;
    List<List<String>>? m;

    MailSendOtpResponseModel({
         this.status,
         this.m,
    });

    factory MailSendOtpResponseModel.fromJson(Map<String, dynamic> json) => MailSendOtpResponseModel(
        status: json["status"],
        m: List<List<String>>.from(json["m"].map((x) => List<String>.from(x.map((x) => x)))),
    );

}
