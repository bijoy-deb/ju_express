class TicketSalePrams {
  String vuHash;
  String from;
  String to;
  String date;
  String? idType;
  String? idNo;
  String? alternativeNumber;
  String? cCode;
  String? firstName;
  String? lastName;
  String? sureName;
  String? alternativeName;
  String? sex;
  String? email;
  String dID;
  String? boarding;
  String? dropping;
  Map<String, String> seats;
  String? promoCode;

  TicketSalePrams({
    this.promoCode,
    required this.vuHash,
    required this.from,
    required this.to,
    required this.date,
    this.idType,
    this.idNo,
    this.alternativeNumber,
    this.cCode,
    this.firstName,
    this.lastName,
    this.sureName,
    this.alternativeName,
    this.sex,
    this.email,
    required this.dID,
    this.boarding,
    this.dropping,
    required this.seats,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "vuHash": vuHash,
      "from": from,
      "to": to,
      "date": date,
      if (idType != null) "idType": idType,
      if (idNo != null) "idNo": idNo,
      if (alternativeNumber != null) "alternativeNumber": alternativeNumber,
      if (cCode != null) "cCode": cCode,
      if (firstName != null) "firstName": firstName,
      if (lastName != null) "lastName": lastName,
      if (sureName != null) "sureName": sureName,
      if (alternativeName != null) "alternativeName": alternativeName,
      if (sex != null) "sex": sex,
      if (email != null) "email": email,
      "dID": dID,
      "boarding": boarding,
      "dropping": dropping,
    };
    map.addAll(seats);
    if (promoCode != null) {
      map["promoCode"] = promoCode!;
    }
    return map;
  }
}
