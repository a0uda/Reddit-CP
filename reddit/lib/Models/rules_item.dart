class RulesItem {
  RulesItem({
    this.id,
    required this.ruleTitle,
    required this.appliesTo,
    this.reportReason,
    this.ruleDescription,
  });

  String? id;
  String ruleTitle;
  String appliesTo;
  String? ruleDescription;
  String? reportReason;

  void updateAll(
      {String? id,
      required String ruleTitle,
      required String appliesTo,
      String? ruleDescription,
      String? reportReason}) {
    this.id = id;
    this.appliesTo = appliesTo;
    this.ruleTitle = ruleTitle;
    this.ruleDescription = ruleDescription ?? "";
    this.reportReason = reportReason ?? "";
  }
}
