class LoginRequestModel {
  final String? mobile;
  final String? email;
  final String password;

  LoginRequestModel({
    this.mobile,
    this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        if (mobile != null) "mobile": mobile,
        if (email != null) "email": email,
        "password": password,
      };
}
