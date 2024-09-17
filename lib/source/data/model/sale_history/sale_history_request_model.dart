class SaleHistoryRequestModel {
  final String fromDate;
  final String toDate;

  SaleHistoryRequestModel({
    required this.toDate,
    required this.fromDate,
  });

  Map<String, dynamic> toJson() => {
        "to": toDate,
        "from": fromDate,
      };
}
