import 'dart:convert';

class PollItem {
  final String question;
  final List<String> options;
  final List<String>? optionId;
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
    this.optionId,
  });

  static fromJson(jsonD) {
    var json = jsonD['polls'];
    List<String> options = [];
    List<String> optionId = [];
    List<int> votes = [];
    List<String> option1Votes = [];
    List<String> option2Votes = [];
    for (var poll in json) {
      options.add(poll['options']);
      votes.add(poll['votes']);
      optionId.add(poll['_id']);
      if (poll['users_ids'] != null) {
        if (options.indexOf(poll['options']) == 0) {
          option1Votes = List<String>.from(poll['users_ids']);
        } else {
          option2Votes = List<String>.from(poll['users_ids']);
        }
      }
    }

    return PollItem(
      question: "",
      options: options,
      votes: votes,
      option1Votes: option1Votes,
      option2Votes: option2Votes,
      expirationDate: jsonD['polls_voting_length'],
      optionId: optionId,
    );
  }
}
