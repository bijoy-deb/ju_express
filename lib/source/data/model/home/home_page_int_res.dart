import 'dart:convert';

import '../common/district.dart';

HomePageIntRes homePageIntResFromJson(String str) =>
    HomePageIntRes.fromJson(json.decode(str));

String homePageIntResToJson(HomePageIntRes data) => json.encode(data.toJson());

class HomePageIntRes {
  int? status;
  List<Alert>? alert;
  String? scroller;
  List<District>? districts;
  Map<String, InputField>? inputFields;
  List<BannerItem>? bannerItem;
  List<IdTypes>? idType;
  List<List<dynamic>>? m;
  Map<String, InputField>? registrInputFields;
  List<PopularBusTripsList>? popularBusTripsList;

  HomePageIntRes({
    this.status,
    this.alert,
    this.scroller,
    this.districts,
    this.inputFields,
    this.bannerItem,
    this.idType,
    this.registrInputFields,
    this.popularBusTripsList,
    this.m,
  });

  factory HomePageIntRes.fromJson(Map<String, dynamic> json) {
    Map<String, InputField> inputFields = {};
    if (json["inputFields"] != null) {
      if (json["inputFields"] is List) {
        json["inputFields"].forEach((k) {
          inputFields
              .addAll({"${k["id"]}_${k["type"]}": InputField.fromJson(k)});
          if (inputFields["${k["id"]}_seat"] == null) {
            inputFields.addAll({
              "${k["id"]}_seat": InputField.fromJson(
                  {"id": k["id"], "fillable": 0, "required": 0, "type": "seat"})
            });
          } else if (inputFields["${k["id"]}_invoice"] == null) {
            inputFields.addAll({
              "${k["id"]}_invoice": InputField.fromJson({
                "id": k["id"],
                "fillable": 0,
                "required": 0,
                "type": "invoice"
              })
            });
          }
        });
      } else {
        json["inputFields"].forEach((k, v) {
          inputFields.addAll({k: InputField.fromJson(v)});
        });
      }
    }

    Map<String, InputField> registrInputFields = {};
    if (json["registrInputFields"] != null) {
      if (json["registrInputFields"] is List) {
        json["registrInputFields"].forEach((k) {
          registrInputFields.addAll({"${k["id"]}": InputField.fromJson(k)});
        });
      } else {
        json["registrInputFields"].forEach((k, v) {
          registrInputFields.addAll({k: InputField.fromJson(v)});
        });
      }
    }

    return HomePageIntRes(
      status: json["status"],
      alert: json["alert"] == null
          ? []
          : List<Alert>.from(json["alert"]!.map((x) => Alert.fromJson(x))),
      scroller: json["scroller"],
      districts: json["districts"] == null
          ? []
          : List<District>.from(
              json["districts"]!.map((x) => District.fromJson(x))),
      inputFields: inputFields,
      popularBusTripsList: json["popularBusTripsList"] == null
          ? []
          : List<PopularBusTripsList>.from(json["popularBusTripsList"]!
              .map((x) => PopularBusTripsList.fromJson(x))),
      bannerItem: json["banner"] == null
          ? []
          : List<BannerItem>.from(
              json["banner"]!.map((x) => BannerItem.fromJson(x))),
      idType: json["idTypes"] == null
          ? []
          : List<IdTypes>.from(
              json["idTypes"]!.map((x) => IdTypes.fromJson(x))),
      registrInputFields: registrInputFields,
      m: json["m"] == null
          ? []
          : List<List<dynamic>>.from(
              json["m"]!.map((x) => List<dynamic>.from(x.map((x) => x)))),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "alert": alert == null
            ? []
            : List<dynamic>.from(alert!.map((x) => x.toJson())),
        "scroller": scroller,
        "districts": districts == null
            ? []
            : List<dynamic>.from(districts!.map((x) => x.toJson())),
        "popularBusTripsList": popularBusTripsList == null
            ? []
            : List<dynamic>.from(popularBusTripsList!.map((x) => x.toJson())),
        "idTypes": idType == null
            ? []
            : List<dynamic>.from(idType!.map((x) => x.toJson())),
        "inputFields": inputFields == null
            ? {}
            : Map.from(inputFields!)
                .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "banner": bannerItem == null
            ? []
            : List<dynamic>.from(bannerItem!.map((x) => x.toJson())),
        "registrInputFields": registrInputFields == null
            ? {}
            : Map.from(registrInputFields!)
                .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "m": m == null
            ? []
            : List<dynamic>.from(
                m!.map((x) => List<dynamic>.from(x.map((x) => x)))),
      };
}

class PopularBusTripsList {
  String? pbtUrl;
  String? route;
  String? image;
  String? from;
  String? to;
  String? cheapestTripAmount;
  String? currency;

  PopularBusTripsList({
    this.pbtUrl,
    this.route,
    this.image,
    this.from,
    this.to,
    this.cheapestTripAmount,
    this.currency,
  });

  factory PopularBusTripsList.fromJson(Map<String, dynamic> json) =>
      PopularBusTripsList(
        pbtUrl: json["pbtUrl"],
        route: json["route"],
        image: json["image"],
        from: json["from"],
        to: json["to"],
        cheapestTripAmount: json["cheapest_trip_amount"],
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "pbtUrl": pbtUrl,
        "route": route,
        "image": image,
        "from": from,
        "to": to,
        "cheapest_trip_amount": cheapestTripAmount,
        "currency": currency,
      };
}

class Alert {
  String? banTitle;
  String? banLink;
  String? banContent;
  String? banImage;

  Alert({
    this.banTitle,
    this.banLink,
    this.banContent,
    this.banImage,
  });

  factory Alert.fromJson(Map<String, dynamic> json) => Alert(
        banTitle: json["banTitle"],
        banLink: json["banLink"],
        banContent: json["banContent"],
        banImage: json["banImage"],
      );

  Map<String, dynamic> toJson() => {
        "banTitle": banTitle,
        "banLink": banLink,
        "banContent": banContent,
        "banImage": banImage,
      };
}

class BannerItem {
  String? banTitle;
  String? banLink;
  String? banImage;
  String? banOrder;
  String? lnId;

  BannerItem({
    this.banTitle,
    this.banLink,
    this.banImage,
    this.banOrder,
    this.lnId,
  });

  factory BannerItem.fromJson(Map<String, dynamic> json) => BannerItem(
        banTitle: json["banTitle"],
        banLink: json["banLink"],
        banImage: json["banImage"],
        banOrder: json["banOrder"],
        lnId: json["lnID"],
      );

  Map<String, dynamic> toJson() => {
        "banTitle": banTitle,
        "banLink": banLink,
        "banImage": banImage,
        "banOrder": banOrder,
        "lnID": lnId,
      };
}

class InputField {
  String? id;
  int? fillable;
  int? isRequired;
  String? type;

  InputField({
    this.id,
    this.fillable,
    this.isRequired,
    this.type,
  });

  factory InputField.fromJson(Map<String, dynamic> json) => InputField(
        id: json["id"],
        fillable: json["fillable"],
        isRequired: json["required"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fillable": fillable,
        "required": isRequired,
        "type": type,
      };
}

class IdTypes {
  String? id;
  String? title;
  String? noLabel;

  IdTypes({
    this.id,
    this.title,
    this.noLabel,
  });

  factory IdTypes.fromJson(Map<String, dynamic> json) => IdTypes(
        id: json["id"],
        title: json["title"],
        noLabel: json["noLabel"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "noLabel": noLabel,
      };
}
