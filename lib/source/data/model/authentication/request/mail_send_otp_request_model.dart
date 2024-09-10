class MailSendOtpRequestModel {
  final String? changeEmail;

  MailSendOtpRequestModel({
    required this.changeEmail,
  });

  Map<String, dynamic> toJson() => {
        "changeEmail": changeEmail,
      };
}
