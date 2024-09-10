class ForgotPasswordRequestModel {
  final String? mobile;
  final String? email;

  ForgotPasswordRequestModel({
    required this.mobile,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      if (mobile != null) 'mobile': mobile,
      if (email != null) 'email': email,
    };
  }
}
