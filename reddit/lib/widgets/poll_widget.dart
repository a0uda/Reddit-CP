import 'package:flutter/material.dart';
import 'package:better_polls/better_polls.dart';
import 'package:get_it/get_it.dart';
import '../Services/post_service.dart';

class PollView extends StatefulWidget {
  final List<Map<String, double>> options;
  final String question;
  final int id;
  final List<String> option1UserVotes;
  final List<String> option2UserVotes;
  final String currentUser;

  const PollView({
    super.key,
    required this.id,
    required this.options,
    required this.question,
    required this.option1UserVotes,
    required this.option2UserVotes,
    required this.currentUser,
  });

  @override
  State<PollView> createState() => _PollViewState();
}

class _PollViewState extends State<PollView> {
  String user = "king@mail.com";
  Map<String, int> usersWhoVoted = {};
  String creator = "eddy@mail.com";

  @override
  Widget build(BuildContext context) {
    final postService = GetIt.instance.get<PostService>();
    user = widget.currentUser;
    usersWhoVoted = {
      ...Map.fromIterable(widget.option1UserVotes,
          key: (v) => v, value: (v) => 0),
      ...Map.fromIterable(widget.option2UserVotes,
          key: (v) => v, value: (v) => 1),
    };
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Polls(
            children: widget.options
                .map((option) => Polls.options(
                    title: option.keys.first, value: option.values.first))
                .toList(),
            optionBarRadius: 24,
            borderWidth: 1,
            optionHeight: 40,
            optionSpacing: 8,
            question: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                widget.question,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            pollStyle: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            currentUser: user,
            creatorID: creator,
            voteData: usersWhoVoted,
            userChoice: usersWhoVoted![user],
            onVoteBackgroundColor: Colors.lightBlueAccent,
            leadingBackgroundColor: Colors.lightBlue,
            backgroundColor: Colors.white,
            voteCastedBackgroundColor: const Color.fromARGB(255, 230, 231, 232),
            onVote: (choice) {
              setState(() {
                usersWhoVoted![user!] = choice;
                widget.options[choice][widget.options[choice].keys.first] =
                    widget.options[choice][widget.options[choice].keys.first]! +
                        1.0;
                postService.updatePoll(widget.id, choice, user);
              });
            },
          ),
        ),
      ),
    );
  }
}
