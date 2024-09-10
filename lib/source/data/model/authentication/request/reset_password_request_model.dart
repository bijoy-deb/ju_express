class ResetPasswordRequestModel {
  final String? mobile;
  final String otp;
  final String? email;
  final String password;
  final String confirmPassword;

  ResetPasswordRequestModel({
    required this.mobile,
    required this.otp,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      if (mobile != null) 'mobile': mobile,
      if (email != null) 'email': email,
      'otp': otp,
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}
