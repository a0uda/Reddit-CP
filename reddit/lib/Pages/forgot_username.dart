import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Services/user_service.dart';

class ForgotUsernamePage extends StatefulWidget {
  const ForgotUsernamePage({super.key});

  @override
  ForgotUsernamePageState createState() => ForgotUsernamePageState();
}

class ForgotUsernamePageState extends State<ForgotUsernamePage> {
  final TextEditingController emailController = TextEditingController();

  String emailError = '';
  double marginAppBarTop = 0;
  double appBarIconSize = 30;
  double appBarTitleWidth = 50;
  double appBarTitleHeight = 50;
  double fontSizeFirstHeader = 35;
  double fontSizeSecondHeader = 20;
  double paddingHeader = 20;
  double buttonPadding = 16;
  double buttonTextSize = 17;
  double textFieldBorderRadius = 20;
  double resetButtonTextSize = 20;
  double appBarFontSize = 20;
  double containerWidth = 300;
  double sizedBoxHeightAppBar = 60;
  double sizedBoxHeightHeader = 30;
  double sizedBoxHeightBeforeResetButton = 140;

  void validateForm() async {
    final userService = GetIt.instance.get<UserService>();

    setState(() {
      emailError = '';

      if (emailController.text.isEmpty) {
        emailError = 'Email is required';
      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
          .hasMatch(emailController.text)) {
        emailError = 'Please enter a valid email address';
      }
    });
    if (emailError.isEmpty) {
      int response = await userService.forgetUsername(emailController.text);
      if (response == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Email will be send to you',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.android) {
      marginAppBarTop = MediaQuery.of(context).size.height * 0.0128;
      appBarTitleHeight = MediaQuery.of(context).size.height * 0.05;
      appBarTitleWidth = MediaQuery.of(context).size.width * 0.1;
      fontSizeFirstHeader = MediaQuery.of(context).size.width * 0.0728;
      fontSizeSecondHeader = MediaQuery.of(context).size.width * 0.0487;
      paddingHeader = MediaQuery.of(context).size.width * 0.051;
      buttonPadding = MediaQuery.of(context).size.width * 0.0408;
      buttonTextSize = MediaQuery.of(context).size.width * 0.0459;
      textFieldBorderRadius = MediaQuery.of(context).size.width * 0.0459;
      resetButtonTextSize = MediaQuery.of(context).size.width * 0.0459;
      appBarFontSize = MediaQuery.of(context).size.width * 0.0487;
      containerWidth = MediaQuery.of(context).size.width * 0.9;
      sizedBoxHeightAppBar = MediaQuery.of(context).size.height * 0.0255;
      sizedBoxHeightHeader = MediaQuery.of(context).size.height * 0.03;
      sizedBoxHeightBeforeResetButton =
          MediaQuery.of(context).size.height * 0.42;
    }

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.only(top: marginAppBarTop),
                child: _buildAppBar(),
              ),
              SizedBox(height: sizedBoxHeightAppBar),
              _buildHeader(),
              SizedBox(height: sizedBoxHeightHeader),
              Center(
                child: SizedBox(
                  width: containerWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email address',
                          errorText: emailError.isNotEmpty ? emailError : null,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.circular(textFieldBorderRadius),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          prefixIcon: const Icon(Icons.person),
                        ),
                      ),
                      SizedBox(height: sizedBoxHeightBeforeResetButton),
                      ElevatedButton(
                        onPressed: () {
                          validateForm();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange[400],
                          padding: EdgeInsets.all(buttonPadding),
                          textStyle: TextStyle(fontSize: buttonTextSize),
                        ),
                        child: const Text(
                          "Reset Username",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Image.asset(
        'images/reddit_orange.jpg',
        width: appBarTitleWidth,
        height: appBarTitleHeight,
      ),
      centerTitle: true,
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          Text(
            "Forgot Username?",
            style: TextStyle(
              fontSize: fontSizeFirstHeader,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: sizedBoxHeightHeader),
          Padding(
            padding: EdgeInsets.all(paddingHeader),
            child: Text(
              "Enter your email address and \n we'll send you an email with your Username.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSizeSecondHeader,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
