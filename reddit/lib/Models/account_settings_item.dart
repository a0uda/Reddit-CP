class AccountSettings {
  String email;
  bool verifiedEmailFlag;
  String country;
  String gender;
  String gmail;
  bool connectedGoogle;

  AccountSettings({
    required this.email,
    required this.verifiedEmailFlag,
    required this.country,
    required this.gender,
    required this.gmail,
    required this.connectedGoogle,
  });

  static Future<AccountSettings> fromJson(jsonD) {
    var json = jsonD;
    return Future.value(AccountSettings(
      email: json['email'],
      verifiedEmailFlag: json['verified_email_flag'],
      country: json['country'],
      gender: json['gender'],
      gmail: json['gmail'],
      connectedGoogle: json['connected_google'],
    ));
  }
}
