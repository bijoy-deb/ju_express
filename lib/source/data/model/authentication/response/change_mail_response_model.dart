// To parse this JSON data, do
//
//     final changeMailResponseModel = changeMailResponseModelFromJson(jsonString);

import 'dart:convert';

ChangeMailResponseModel changeMailResponseModelFromJson(String str) => ChangeMailResponseModel.fromJson(json.decode(str));


class ChangeMailResponseModel {
    int? status;
    List<List<String>>? m;

    ChangeMailResponseModel({
         this.status,
         this.m,
    });

    factory ChangeMailResponseModel.fromJson(Map<String, dynamic> json) => ChangeMailResponseModel(
        status: json["status"],
        m: List<List<String>>.from(json["m"].map((x) => List<String>.from(x.map((x) => x)))),
    );

}
