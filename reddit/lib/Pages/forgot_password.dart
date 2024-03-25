import 'package:flutter/material.dart';
import 'package:reddit/Pages/login.dart';
import 'package:reddit/Pages/verify_password.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
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
  double sizedBoxHeightBeforeResetButton = 100;
  double sizedBoxHeightBetweenTextFields = 20;

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
          MediaQuery.of(context).size.height * 0.29;
      sizedBoxHeightBetweenTextFields =
          MediaQuery.of(context).size.height * 0.02;
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
                        decoration: InputDecoration(
                          labelText: 'Email address',
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
                      SizedBox(height: sizedBoxHeightBetweenTextFields),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Username',
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const VerifyPasswordPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange[400],
                          padding: EdgeInsets.all(buttonPadding),
                          textStyle: TextStyle(fontSize: buttonTextSize),
                        ),
                        child: const Text(
                          "Reset Password",
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
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          size: appBarIconSize,
          color: Colors.grey[700],
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
      ),
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
            "Forgot Password?",
            style: TextStyle(
              fontSize: fontSizeFirstHeader,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: sizedBoxHeightHeader),
          Padding(
            padding: EdgeInsets.all(paddingHeader),
            child: Text(
              "Enter your username and your email address and \n we'll send you a link to reset your password.",
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
