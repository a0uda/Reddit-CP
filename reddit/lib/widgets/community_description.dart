import 'package:flutter/material.dart';
import 'package:reddit/Pages/description_widget.dart';



class CommunityDescription extends StatelessWidget {
  const CommunityDescription(this.communityName, this.membersNumber,
      {super.key});

  final String logoPath = 'images/reddit-logo.png';
  final String communityName;
  final int membersNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10, bottom: 0),
                child: CircleAvatar(
                  backgroundImage: AssetImage(logoPath),
                  backgroundColor: Colors.white,
                  radius: 40,
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 10, bottom: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'r/$communityName',
                        style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$membersNumber members',
                        style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12,
                            color: Color.fromARGB(
                                255, 144, 144, 144)), //rgba(144,144,144,255)
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DescriptionWidget(communityDescription: 'nas betheb fouda ka akh kbeer leehom')),
                        );
                      },
                      child: const Text(
                        'See community info',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12,
                            color: Color.fromARGB(255, 38, 73, 150)),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
