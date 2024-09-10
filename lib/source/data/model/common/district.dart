class District {
  int? topDistrict;
  String? distId;
  String? distTitle;

  District({
    this.topDistrict,
    this.distId,
    this.distTitle,
  });

  factory District.fromJson(Map<String, dynamic> json) => District(
        topDistrict: json["topDistrict"],
        distId: json["distID"],
        distTitle: json["distTitle"],
      );
  Map<String, dynamic> toJson() => {
        'topDistrict': topDistrict,
        'distID': distId,
        'distTitle': distTitle,
      };
}
