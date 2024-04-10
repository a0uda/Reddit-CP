class AccountSettings {
  String email;
  String verifiedEmailFlag;
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
}
