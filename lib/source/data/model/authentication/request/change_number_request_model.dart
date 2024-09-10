class ChangeNumberRequestModel {
  final String? changeMobile;
  final String? changeCode;
  final String? otp;

  ChangeNumberRequestModel({
    required this.changeMobile,
    required this.changeCode,
    required this.otp,
  });

  Map<String, dynamic> toJson() => {
        "changeMobile": changeMobile,
        "changeCode": changeCode,
        "otp": otp,
      };
}
