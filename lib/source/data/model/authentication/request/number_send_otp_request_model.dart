class NumberSendOtpRequestModel {
  final String? changeMobile;
  final String? changeCode;

  NumberSendOtpRequestModel({
    required this.changeMobile,
    required this.changeCode,
  });

  Map<String, dynamic> toJson() => {
        "changeMobile": changeMobile,
        "changeCode": changeCode,
      };
}
