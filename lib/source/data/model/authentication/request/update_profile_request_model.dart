class UpdateProfileRequestModel {
  final String? firstName;
  final String? lastName;
  final String? surName;
  final String? fatherName;
  final String? email;

  UpdateProfileRequestModel({
    required this.firstName,
    required this.lastName,
    required this.surName,
    required this.fatherName,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        if (firstName != null) "firstName": firstName,
        if (lastName != null) "lastName": lastName,
        if (surName != null) "surName": surName,
        if (fatherName != null) "fatherName": fatherName,
        if (email != null) "email": email,
      };
}
