// To parse this JSON data, do
//
//     final deleteAccountResponseModel = deleteAccountResponseModelFromJson(jsonString);

import 'dart:convert';

DeleteAccountResponseModel deleteAccountResponseModelFromJson(String str) => DeleteAccountResponseModel.fromJson(json.decode(str));


class DeleteAccountResponseModel {
    int? status;
    String? msg;
    List<List<String>>? m;

    DeleteAccountResponseModel({
        required this.status,
        required this.msg,
        required this.m,
    });

    factory DeleteAccountResponseModel.fromJson(Map<String, dynamic> json) => DeleteAccountResponseModel(
        status: json["status"],
        msg: json["msg"],
        m: List<List<String>>.from(json["m"].map((x) => List<String>.from(x.map((x) => x)))),
    );

}
