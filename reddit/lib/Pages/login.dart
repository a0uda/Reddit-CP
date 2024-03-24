import 'package:flutter/material.dart';
import 'package:reddit/Pages/sign-up.dart';
import 'package:reddit/Pages/forgot-password.dart';
import 'package:reddit/Pages/forgot-username.dart';
import 'package:reddit/widgets/desktop_layout.dart';
import 'package:reddit/widgets/mobile_layout.dart';
import 'package:reddit/widgets/responsive_layout.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  double marginAppBarTop = 0;
  double appBarIconSize = 30;
  double appBarTitleWidth = 50;
  double appBarTitleHeight = 50;
  double buttonPadding = 16;
  double buttonTextSize = 17;
  double buttonIconSize = 18;
  double headerFontSize = 30;
  double dividerFontSize = 16;
  double textFieldBorderRadius = 20;
  double textFieldContentPadding = 14;
  double textFieldFontSize = 15;
  double forgotTextFontSize = 15;
  double continueButtonTextSize = 20;
  double appBarFontSize = 20;
  double containerWidth = 300;
  double sizedBoxHeightAppBar = 60;
  double sizedBoxHeightHeader = 30;
  double sizedBoxHeightBetweenButtons = 20;
  double sizedBoxHeightBetweenButtonsAndDivider = 40;
  double sizedBoxHeightBeforeContinueButton = 40;
  double sizedBoxHeightBetweenTextFields = 20;
  double sizedBoxHeightBetweenTextFieldsAndForgotText = 20;
  double sizedBoxHeightBetweenDividerAndTextFields = 20;

  bool _isPasswordVisible = false;

  List<Map<String, String>> users = [
    {'username': 'user1', 'password': 'password1'},
    {'username': 'user2', 'password': 'password2'},
  ];
  void validateForm(BuildContext context) {
    bool isValidUser = false;
    for (var user in users) {
      if (user['username'] == usernameController.text &&
          user['password'] == passwordController.text) {
        isValidUser = true;
        break;
      }
    }
    if (!isValidUser) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Incorrect username or password',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.black,
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ResponsiveLayout(
            mobileLayout: MobileLayout(
              mobilePageMode: 0,
            ),
            desktopLayout: DesktopHomePage(
              indexOfPage: 0,
            )),
      ));
    }
  }

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.android &&
        MediaQuery.of(context).size.width < 600) {
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;
      marginAppBarTop = screenHeight * 0.0128;
      appBarTitleHeight = screenHeight * 0.05;
      buttonPadding = screenWidth * 0.0408;
      buttonTextSize = screenWidth * 0.0459;
      textFieldBorderRadius = screenWidth * 0.0459;
      textFieldContentPadding = screenWidth * 0.051;
      textFieldFontSize = screenWidth * 0.0408;
      forgotTextFontSize = screenWidth * 0.035;
      continueButtonTextSize = screenWidth * 0.0459;
      appBarFontSize = screenWidth * 0.0487;
      containerWidth = screenWidth * 0.9;
      sizedBoxHeightAppBar = screenHeight * 0.0255;
      sizedBoxHeightHeader = screenHeight * 0.020;
      sizedBoxHeightBetweenButtons = screenHeight * 0.02;
      sizedBoxHeightBetweenButtonsAndDivider = screenHeight * 0.07;
      sizedBoxHeightBetweenTextFieldsAndForgotText = screenHeight * 0.04;
      sizedBoxHeightBeforeContinueButton = screenHeight * 0.13;
      sizedBoxHeightBetweenTextFields = screenHeight * 0.02;
      sizedBoxHeightBetweenDividerAndTextFields = screenHeight * 0.02;
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
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(buttonPadding),
                            textStyle: TextStyle(fontSize: buttonTextSize),
                          ),
                          icon: Icon(
                            Icons.facebook,
                            color: Colors.blue[900],
                          ),
                          label: Text(
                            "Continue with Facebook",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: buttonTextSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: sizedBoxHeightBetweenButtons),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(buttonPadding),
                            textStyle: TextStyle(fontSize: buttonTextSize),
                          ),
                          icon: Image.asset(
                            'images/google-icon.png',
                            width: 25,
                            height: 25,
                          ),
                          label: Text(
                            "Continue with Google",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: buttonTextSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: sizedBoxHeightBetweenButtonsAndDivider),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey[250],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "OR",
                              style: TextStyle(
                                fontSize: dividerFontSize,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey[250],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: sizedBoxHeightBetweenDividerAndTextFields),
                      SizedBox(
                        width: double.infinity,
                        child: TextField(
                          controller: usernameController,
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
                            contentPadding:
                                EdgeInsets.all(textFieldContentPadding),
                          ),
                        ),
                      ),
                      SizedBox(height: sizedBoxHeightBetweenTextFields),
                      SizedBox(
                        width: double.infinity,
                        child: TextField(
                          controller: passwordController,
                          obscureText: _isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.circular(textFieldBorderRadius),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(_isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            contentPadding:
                                EdgeInsets.all(textFieldContentPadding),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: sizedBoxHeightBetweenTextFieldsAndForgotText),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPasswordPage()),
                              );
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Colors.blue[900],
                                fontSize: forgotTextFontSize,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotUsernamePage()),
                              );
                            },
                            child: Text(
                              "Forgot Username?",
                              style: TextStyle(
                                color: Colors.blue[900],
                                fontSize: forgotTextFontSize,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => const ResponsiveLayout(
                                    mobileLayout: MobileLayout(
                                      mobilePageMode: 1,
                                    ),
                                    desktopLayout: DesktopHomePage(
                                      indexOfPage: 1,
                                    )),
                              ));
                            },
                            child: Text(
                              "Continue as Guest?",
                              style: TextStyle(
                                color: Colors.blue[900],
                                fontSize: forgotTextFontSize,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: sizedBoxHeightBeforeContinueButton),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            validateForm(context);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(buttonPadding),
                            textStyle:
                                TextStyle(fontSize: continueButtonTextSize),
                          ),
                          child: Text("Continue",
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: continueButtonTextSize,
                                  fontWeight: FontWeight.bold)),
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
          // Handle arrow back button press
        },
      ),
      title: Image.asset(
        'images/reddit_orange.jpg',
        width: appBarTitleWidth,
        height: appBarTitleHeight,
      ),
      centerTitle: true,
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpPage()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Sign Up',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: appBarFontSize,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          Text(
            "Log in",
            style: TextStyle(
              fontSize: headerFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: sizedBoxHeightHeader),
        ],
      ),
    );
  }
}
