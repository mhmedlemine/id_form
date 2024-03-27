enum SexType { male, female }

class IDForm {
  String? countryCode;
  String? lname;
  String? fname;
  String? nationalityCountryCode;
  DateTime? birthDate;
  SexType? sex;
  DateTime? expiryDate;
  String? nni;

  IDForm({
    this.countryCode,
    this.lname,
    this.fname,
    this.nationalityCountryCode,
    this.birthDate,
    this.sex,
    this.expiryDate,
    this.nni,
  });

  factory IDForm.fromJson(Map<String, dynamic> json) => IDForm(
      countryCode: json['countryCode'],
      lname: json['lname'],
      fname: json['fname'],
      nationalityCountryCode: json['nationalityCountryCode'],
      birthDate: json['birthDate'],
      sex: json['sex'],
      expiryDate: json['expiryDate'],
      nni: json['nni'],
      );

  Map<String, dynamic> toJson() => {
        "countryCode": countryCode,
        "lname": lname,
        "fname": fname,
        "nationalityCountryCode": nationalityCountryCode,
        "birthDate": birthDate,
        "sex": sex,
        "expiryDate": expiryDate,
        "nni": nni,
      };
  
}
