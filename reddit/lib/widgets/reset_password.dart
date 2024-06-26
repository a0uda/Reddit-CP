import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Pages/forgot_password.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final UserController userController = GetIt.instance.get<UserController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Align(
                  child: ListTile(
                    leading: userController.userAbout!.profilePicture == null ||
                            (userController.userAbout!.profilePicture!) == '' ||
                            userController.userAbout!.profilePicture!.isEmpty
                        ? const CircleAvatar(
                            radius: 25,
                            backgroundImage: AssetImage('images/Greddit.png'),
                          )
                        : CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                                userController.userAbout!.profilePicture!),
                          ),
                    title: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            userController.userAbout!.username,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Arial'),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              userController.userAbout!.email!,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w200,
                                  fontFamily: 'Arial'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 500,
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Current password',
                      labelStyle: const TextStyle(color: Colors.black),
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    obscureText: true,
                    // validator: (String? value) {
                    //   // TODO: check database for password
                    // },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPasswordPage()),
                    );
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 500, // Set your desired width
                  child: TextFormField(
                    controller: _newPasswordController,
                    decoration: InputDecoration(
                      labelText: 'New password',
                      labelStyle: const TextStyle(color: Colors.black),
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    keyboardType: TextInputType.emailAddress,
                    obscureText: true,
                    validator: (String? value) {
                      if (value!.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 500,
                  child: TextFormField(
                    controller: _confirmNewPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm new password',
                      labelStyle: const TextStyle(color: Colors.black),
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    obscureText: true,
                    validator: (String? value) {
                      if (value!.isEmpty ||
                          value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          bool changed = await userController.changePassword(
                            userController.userAbout!.username,
                            _passwordController.text,
                            _newPasswordController.text,
                            _confirmNewPasswordController.text,
                          );
                          if (changed) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Password updated')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Password not updated')),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    child: const Text(
                      'Change Password',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
