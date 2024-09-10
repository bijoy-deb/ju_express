class ChangeMailRequestModel {
  final String? changeEmail;
  final String? otp;

  ChangeMailRequestModel({
    required this.changeEmail,
    required this.otp,
  });

  Map<String, dynamic> toJson() => {
        "changeEmail": changeEmail,
        "otp": otp,
      };
}
