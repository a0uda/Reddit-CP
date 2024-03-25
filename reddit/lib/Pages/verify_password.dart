import 'package:flutter/material.dart';

class VerifyPasswordPage extends StatefulWidget {
  const VerifyPasswordPage({Key? key}) : super(key: key);

  @override
  _VerifyPasswordPageState createState() => _VerifyPasswordPageState();
}

class _VerifyPasswordPageState extends State<VerifyPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _verifyPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 30,
              color: Colors.grey[700],
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Image.asset(
            'images/reddit_orange.jpg',
            width: 50,
            height: 50,
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      child: TextField(
                        controller: _verifyPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Verify Password',
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        String password = _passwordController.text;
                        String verifyPassword = _verifyPasswordController.text;

                        if (password.isEmpty || verifyPassword.isEmpty) {
                          _showSnackBar('Please fill all fields');
                        } else if (password != verifyPassword) {
                          _showSnackBar('Passwords do not match');
                        } else {}
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange[400],
                        padding: const EdgeInsets.all(16),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
