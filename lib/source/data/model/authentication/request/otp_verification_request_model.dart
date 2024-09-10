class OtpVerificationRequestModel {
  final String otpCode;
  final String mail;
  final String phone;

  OtpVerificationRequestModel({
    required this.otpCode,
    required this.mail,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'otp': otpCode,
      'email': mail,
      'mobile': phone,
    };
  }
}
