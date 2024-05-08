import 'package:flutter/material.dart';
import 'package:better_polls/better_polls.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/widgets/post.dart';
import '../Services/post_service.dart';

class PollView extends StatefulWidget {
  final List<Map<String, double>> options;
  final List<String> optionId;
  final String question;
  final String id;
  final List<String> option1UserVotes;
  final List<String> option2UserVotes;
  final String currentUser;
  final String currentUserId;
  final bool isExpired;
  final OnPollVote onPollVote;

  const PollView({
    super.key,
    required this.id,
    required this.options,
    required this.question,
    required this.option1UserVotes,
    required this.option2UserVotes,
    required this.currentUser,
    required this.currentUserId,
    required this.isExpired,
    required this.optionId,
    required this.onPollVote,
  });

  @override
  State<PollView> createState() => _PollViewState();
}

class _PollViewState extends State<PollView> {
  String user = "king@mail.com";
  String username = "king@mail.com";
  Map<String, int> usersWhoVoted = {};
  String creator = "eddy@mail.com";

  @override
  Widget build(BuildContext context) {
    final postService = GetIt.instance.get<PostService>();
    user = widget.currentUserId;
    username = widget.currentUser;
    usersWhoVoted = {
      ...{for (var v in widget.option1UserVotes) v: 0},
      ...{for (var v in widget.option2UserVotes) v: 1},
    };
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Polls(
            key: widget.key,
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
            userChoice: usersWhoVoted[user],
            onVoteBackgroundColor: Colors.lightBlueAccent,
            leadingBackgroundColor: Colors.lightBlue,
            backgroundColor: Colors.white,
            voteCastedBackgroundColor: const Color.fromARGB(255, 230, 231, 232),
            allowCreatorVote: true,
            onVote: (choice) {
              if (widget.isExpired) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Poll Results'),
                      content: Column(
                        children: widget.options.map((option) {
                          return Text(
                              '${option.keys.first}: ${option.values.first}');
                        }).toList(),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
                return;
              }
              setState(() {
                usersWhoVoted[user] = choice;
                widget.options[choice][widget.options[choice].keys.first] =
                    widget.options[choice][widget.options[choice].keys.first]! +
                        1.0;
                widget.onPollVote(widget.id, choice, user);
                postService.updatePoll(
                    widget.id, choice, widget.optionId[choice], username);
              });
            },
          ),
        ),
      ),
    );
  }
}
