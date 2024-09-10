// To parse this JSON data, do
//
//     final registrationResponeModel = registrationResponeModelFromJson(jsonString);

import 'dart:convert';

RegistrationResponeModel registrationResponeModelFromJson(String str) =>
    RegistrationResponeModel.fromJson(json.decode(str));

class RegistrationResponeModel {
  int? status;
  Customer? customer;
  List<List<String>>? m;

  RegistrationResponeModel({
    this.status,
    this.customer,
    this.m,
  });

  factory RegistrationResponeModel.fromJson(Map<String, dynamic> json) =>
      RegistrationResponeModel(
        status: json["status"],
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
        
        
        m: json["m"] == null
            ? []
            : List<List<String>>.from(
                json["m"].map(
                    (x) => x == null ? [] : List<String>.from(x.map((x) => x))),
              ),
      );
}

class Customer {
  String? cId;
  String? hId;
  String? tftId;
  String? cCardNumber;
  String? cMobile;
  String? cFullmobile;
  String? cCode;
  String? cSortCode;
  // dynamic cAltMobile;
  String? cFirstName;
  String? cLastName;
  String? cSureName;
  String? cFatherName;
  String? cName;
  String? cGender;
  String? cAge;
  String? cAddress;
  String? cEmail;
  String? cPin;
  String? cPassword;
  String? cPassSalt;
  String? cData;
  // dynamic createdBy;
  // dynamic createdOn;
  // dynamic modifiedBy;
  // dynamic modifiedOn;
  // dynamic sUid;
  // dynamic verifiedUser;
  String? isActive;

  Customer({
    this.cId,
    this.hId,
    this.tftId,
    this.cCardNumber,
    this.cMobile,
    this.cFullmobile,
    this.cCode,
    this.cSortCode,
    //  this.cAltMobile,
    this.cFirstName,
    this.cLastName,
    this.cSureName,
    this.cFatherName,
    this.cName,
    this.cGender,
    this.cAge,
    this.cAddress,
    this.cEmail,
    this.cPin,
    this.cPassword,
    this.cPassSalt,
    this.cData,
    //  this.createdBy,
    //  this.createdOn,
    //  this.modifiedBy,
    //  this.modifiedOn,
    //  this.sUid,
    //  this.verifiedUser,
    this.isActive,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        cId: json["cID"] ,
        hId: json["hID"],
        tftId: json["tftID"],
        cCardNumber: json["cCardNumber"],
        cMobile: json["cMobile"],
        cFullmobile: json["cFullmobile"],
        cCode: json["cCode"],
        cSortCode: json["cSortCode"],
        // cAltMobile: json["cAltMobile"],
        cFirstName: json["cFirstName"],
        cLastName: json["cLastName"],
        cSureName: json["cSureName"],
        cFatherName: json["cFatherName"],
        cName: json["cName"],
        cGender: json["cGender"],
        cAge: json["cAge"],
        cAddress: json["cAddress"],
        cEmail: json["cEmail"],
        cPin: json["cPin"],
        cPassword: json["cPassword"],
        cPassSalt: json["cPassSalt"],
        cData: json["cData"],
        // createdBy: json["createdBy"],
        // createdOn: json["createdOn"],
        // modifiedBy: json["modifiedBy"],
        // modifiedOn: json["modifiedOn"],
        // sUid: json["sUID"],
        // verifiedUser: json["verifiedUser"],
        isActive: json["isActive"],
      );

  Map<String, dynamic> toJson() => {
        "cID": cId,
        "hID": hId,
        "tftID": tftId,
        "cCardNumber": cCardNumber,
        "cMobile": cMobile,
        "cFullmobile": cFullmobile,
        "cCode": cCode,
        "cSortCode": cSortCode,
        // "cAltMobile": cAltMobile,
        "cFirstName": cFirstName,
        "cLastName": cLastName,
        "cSureName": cSureName,
        "cFatherName": cFatherName,
        "cName": cName,
        "cGender": cGender,
        "cAge": cAge,
        "cAddress": cAddress,
        "cEmail": cEmail,
        "cPin": cPin,
        "cPassword": cPassword,
        "cPassSalt": cPassSalt,
        "cData": cData,
        // "createdBy": createdBy,
        // "createdOn": createdOn,
        // "modifiedBy": modifiedBy,
        // "modifiedOn": modifiedOn,
        // "sUID": sUid,
        // "verifiedUser": verifiedUser,
        "isActive": isActive,
      };
}
