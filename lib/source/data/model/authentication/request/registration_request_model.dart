class RegistrationRequestModel {
  final String? mobile;
  final String? code;
  final String? firstName;
  final String? lastName;
  final String? sureName;
  final String? fatherName;
  final String? email;
  final String? password;
  final String? pin;
  final String? sendOption;

  RegistrationRequestModel({
    required this.lastName,
    required this.fatherName,
    required this.pin,
    required this.mobile,
    required this.code,
    required this.firstName,
    required this.sureName,
    required this.email,
    required this.password,
    required this.sendOption,
  });

  Map<String, dynamic> toJson() => {
        if (mobile != null) "mobile": mobile,
        if (lastName != null) "lastName": lastName,
        if (fatherName != null) "father_name": fatherName,
        if (code != null) "cCode": code,
        if (pin != null) "pin": pin,
        if (firstName != null) "firstName": firstName,
        if (sureName != null) "surName": sureName,
        if (email != null) "email": email,
        if (password != null) "password": password,
        if (sendOption != null) "sendOption": sendOption
      };
}
