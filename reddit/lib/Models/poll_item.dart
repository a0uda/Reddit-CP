class PollItem {
  final String question;
  final List<String> options;
  List<int> votes;
  List<String> option1Votes;
  List<String> option2Votes;

  PollItem({
    required this.question,
    required this.options,
    required this.votes,
    required this.option1Votes,
    required this.option2Votes,
  });
}
