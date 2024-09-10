// To parse this JSON data, do
//
//     final updateProfileResponseModel = updateProfileResponseModelFromJson(jsonString);

import 'dart:convert';

UpdateProfileResponseModel updateProfileResponseModelFromJson(String str) => UpdateProfileResponseModel.fromJson(json.decode(str));


class UpdateProfileResponseModel {
    int status;
    String msg;
    List<List<String>> m;

    UpdateProfileResponseModel({
        required this.status,
        required this.msg,
        required this.m,
    });

    factory UpdateProfileResponseModel.fromJson(Map<String, dynamic> json) => UpdateProfileResponseModel(
        status: json["status"],
        msg: json["msg"],
        m: List<List<String>>.from(json["m"].map((x) => List<String>.from(x.map((x) => x)))),
    );

}
