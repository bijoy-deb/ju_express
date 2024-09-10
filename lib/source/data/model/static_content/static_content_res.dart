import 'dart:convert';

StaticContentRes staticContentResFromJson(String str) =>
    StaticContentRes.fromJson(json.decode(str));

class StaticContentRes {
  int? status;
  List<StaticContent>? staticContent;
  List<List<dynamic>>? m;

  StaticContentRes({
    this.status,
    this.staticContent,
    this.m,
  });

  factory StaticContentRes.fromJson(Map<String, dynamic> json) =>
      StaticContentRes(
        status: json["status"],
        staticContent: json["staticContent"] == null
            ? []
            : List<StaticContent>.from(
                json["staticContent"]!.map((x) => StaticContent.fromJson(x))),
        m: json["m"] == null
            ? []
            : List<List<dynamic>>.from(
                json["m"]!.map((x) => List<dynamic>.from(x.map((x) => x)))),
      );
}

class StaticContent {
  String? key;
  String? title;
  String? content;

  StaticContent({
    this.key,
    this.title,
    this.content,
  });

  factory StaticContent.fromJson(Map<String, dynamic> json) => StaticContent(
        key: json["key"],
        title: json["title"],
        content: json["content"],
      );
}
