import 'package:flutter/material.dart';
import 'package:reddit/Pages/login.dart';
import 'package:get_it/get_it.dart';
import '../Services/user_service.dart';
import '../Controllers/user_controller.dart';
import 'package:reddit/widgets/desktop_layout.dart';
import 'package:reddit/widgets/mobile_layout.dart';
import 'package:reddit/widgets/responsive_layout.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String genderSelected = 'Male';
  String emailError = '';
  String usernameError = '';
  String passwordError = '';

  void handleGenderChange(String gender) {
    setState(() {
      genderSelected = gender;
    });
  }

  void validateForm(BuildContext context) async {
    setState(() {
      emailError = '';
      usernameError = '';
      passwordError = '';

      if (emailController.text.isEmpty) {
        emailError = 'Email is required';
      } else if (!_isEmailValid(emailController.text)) {
        emailError = 'Enter a valid email';
      }
      if (usernameController.text.isEmpty) {
        usernameError = 'Username is required';
      }
      if (passwordController.text.isEmpty) {
        passwordError = 'Password is required';
      } else if (passwordController.text.length < 8) {
        passwordError = 'Password must be at least 8 characters long';
      }
      if (usernameController.text == passwordController.text &&
          passwordController.text.isNotEmpty &&
          usernameController.text.isNotEmpty) {
        usernameError = 'Username cannot be same as password';
      }

      if (UserService().availableEmail(emailController.text) == 400) {
        emailError = 'Email already exists';
      }
      if (UserService().availableUsername(usernameController.text) == 400) {
        usernameError = 'Username already exists';
      }
    });

    if (emailError.isEmpty && usernameError.isEmpty && passwordError.isEmpty) {
      int statusCode = await UserService().userSignup(
        usernameController.text,
        passwordController.text,
        emailController.text,
        genderSelected,
      );

      if (statusCode == 200) {
        final userController = GetIt.instance.get<UserController>();
        userController.getUser(usernameController.text);
        // print('User signed up successfully!');
        // print('User data: ${userController.userAbout?.email}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Sign up successful! Redirecting to home page...',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
            duration: Duration(seconds: 3),
          ),
        );
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const ResponsiveLayout(
                mobileLayout: MobileLayout(
                  mobilePageMode: 0,
                ),
                desktopLayout: DesktopHomePage(
                  indexOfPage: 0,
                ),
              ),
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Sign up failed! Please try again.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      _showErrorSnackbar(context);
    }
  }

  bool _isEmailValid(String email) {
    String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    return RegExp(emailRegex).hasMatch(email);
  }

  void _showErrorSnackbar(BuildContext context) {
    String errorMessage = '';
    if (emailError.isNotEmpty) {
      errorMessage += 'Email: $emailError\n';
    }
    if (usernameError.isNotEmpty) {
      errorMessage += 'Username: $usernameError\n';
    }
    if (passwordError.isNotEmpty) {
      errorMessage += 'Password: $passwordError\n';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          errorMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  double marginTopAppBar = 0;
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
  double sizedBoxHeightAppBar = 40;
  double sizedBoxHeightHeader = 30;
  double sizedBoxHeightBetweenButtons = 15;

  double sizedBoxHeightBeforeContinueButton = 30;
  double sizedBoxHeightBetweenTextFields = 15;
  double sizedBoxHeightBetweenTextFieldsAndForgotText = 20;
  double genderTextFontSize = 15;
  double sizedBoxWidthGenders = 20;
  double sizedBoxHeightBetweenDividerAndTextFields = 20;
  double sizedBoxBeforeDivider = 15;

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    if (Theme.of(context).platform == TargetPlatform.android) {
      marginTopAppBar = screenHeight * 0.0128;
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

      sizedBoxHeightBetweenTextFieldsAndForgotText = screenHeight * 0.04;
      sizedBoxHeightBeforeContinueButton = screenHeight * 0.06;
      sizedBoxHeightBetweenTextFields = screenHeight * 0.02;
      genderTextFontSize = screenWidth * 0.04;
      sizedBoxWidthGenders = screenWidth * 0.3;
      sizedBoxHeightBetweenDividerAndTextFields = screenHeight * 0.02;
      sizedBoxBeforeDivider = screenHeight * 0.02;
    }

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.only(top: marginTopAppBar),
                child: _buildAppBar(),
              ),
              SizedBox(height: sizedBoxHeightAppBar),
              _buildHeader(screenWidth, screenHeight),
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
                          labelText: 'Email',
                          errorText: emailError.isNotEmpty ? emailError : null,
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
                      SizedBox(height: sizedBoxHeightBetweenTextFields),
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          errorText:
                              usernameError.isNotEmpty ? usernameError : null,
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
                      SizedBox(height: sizedBoxHeightBetweenTextFields),
                      TextField(
                        controller: passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          errorText:
                              passwordError.isNotEmpty ? passwordError : null,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.circular(textFieldBorderRadius),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            child: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                          contentPadding:
                              EdgeInsets.all(textFieldContentPadding),
                        ),
                      ),
                      SizedBox(height: sizedBoxHeightBetweenTextFields),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Gender",
                            style: TextStyle(
                              fontSize: genderTextFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 'Male',
                                groupValue: genderSelected,
                                onChanged: (value) =>
                                    handleGenderChange(value.toString()),
                                activeColor: Colors.black,
                              ),
                              const Text("Male"),
                              SizedBox(width: sizedBoxWidthGenders),
                              Radio(
                                value: 'Female',
                                groupValue: genderSelected,
                                onChanged: (value) =>
                                    handleGenderChange(value.toString()),
                                activeColor: Colors.black,
                              ),
                              const Text("Female"),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: sizedBoxBeforeDivider),
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
                      ElevatedButton.icon(
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
                      SizedBox(height: sizedBoxHeightBetweenButtons),
                      ElevatedButton.icon(
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
                      SizedBox(height: sizedBoxHeightBeforeContinueButton),
                      ElevatedButton(
                        onPressed: () => validateForm(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange[400],
                          padding: EdgeInsets.all(buttonPadding),
                          textStyle: TextStyle(fontSize: buttonTextSize),
                        ),
                        child: Text(
                          "Continue",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: buttonTextSize,
                            fontWeight: FontWeight.bold,
                          ),
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
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Log In',
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

  Widget _buildHeader(double screenWidth, double screenHeight) {
    return Center(
      child: Column(
        children: [
          Text(
            "Hi new friend,",
            style: TextStyle(
              fontSize: headerFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Welcome to Reddit",
            style: TextStyle(
              fontSize: headerFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
