class PollItem {
  final String question;
  final List<String> options;
  List<int> votes;
  List<String> option1Votes;
  List<String> option2Votes;
  final int expirationDate;

  PollItem({
    required this.question,
    required this.options,
    required this.votes,
    required this.option1Votes,
    required this.option2Votes,
    required this.expirationDate,
  });

  static fromJson(json) {
    return PollItem(
      question: json['question'],
      options: json['options'],
      votes: json['votes'],
      option1Votes: json['option1Votes'],
      option2Votes: json['option2Votes'],
      expirationDate: json['expirationDate'],
    );
  }
}
