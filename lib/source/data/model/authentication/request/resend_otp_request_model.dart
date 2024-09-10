class ResendOtpRequestModel {
  final String mobile;
  final String cCode;
  final String email;
  final String otpResendOption;

  ResendOtpRequestModel({
    required this.mobile,
    required this.cCode,
    required this.email,
    required this.otpResendOption,
  });

  Map<String, dynamic> toJson() {
    return {
      'mobile': mobile,
      'email': email,
      'cCode': cCode,
      'otpresendoption': otpResendOption,
    };
  }
}
