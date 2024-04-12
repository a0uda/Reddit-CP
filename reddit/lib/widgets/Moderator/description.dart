import 'package:flutter/material.dart';

class CommunityName extends StatefulWidget {
  const CommunityName({super.key});

  @override
  State<CommunityName> createState() => _CommunityNameState();
}

class _CommunityNameState extends State<CommunityName> {
  TextEditingController inputController = TextEditingController();
  int maxCounter = 500;
  int remainingCharacters = 500;
  @override
  void initState() {
    super.initState();
    remainingCharacters = maxCounter;
  }

  void updateCharachterCounter() {
    setState(() {
      remainingCharacters = maxCounter - inputController.text.length;
      if (remainingCharacters < 0) {
        inputController.text = inputController.text.substring(0, maxCounter);
        inputController.selection = TextSelection.fromPosition(
          TextPosition(offset: inputController.text.length),
        );
        remainingCharacters = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double paddingPercentage = 0.1;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(screenWidth * paddingPercentage),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Row(
              children: [
                Align(
                  alignment: Alignment(0, 0),
                  child: Text(
                    'Describe your community',
                    style: TextStyle(
                      color: Color.fromARGB(255, 48, 129, 185),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            TextField(
              controller: inputController,
              maxLines: null,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 23, 105, 165)),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 23, 105, 165)),
                ),
              ),
              onChanged: ((value) {
                updateCharachterCounter();
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                  child: Text(
                    '$remainingCharacters',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 173, 173, 173),
                      fontSize: 12,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
