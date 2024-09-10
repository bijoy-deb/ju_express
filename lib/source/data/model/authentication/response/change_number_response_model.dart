// To parse this JSON data, do
//
//     final changeNumberResponseModel = changeNumberResponseModelFromJson(jsonString);

import 'dart:convert';

ChangeNumberResponseModel changeNumberResponseModelFromJson(String str) => ChangeNumberResponseModel.fromJson(json.decode(str));


class ChangeNumberResponseModel {
    int? status;
    List<List<String>>? m;

    ChangeNumberResponseModel({
        required this.status,
        required this.m,
    });

    factory ChangeNumberResponseModel.fromJson(Map<String, dynamic> json) => ChangeNumberResponseModel(
        status: json["status"],
        m: List<List<String>>.from(json["m"].map((x) => List<String>.from(x.map((x) => x)))),
    );

}
