// lib/pages/SignUpPage.dart

import 'package:chatapp/models/UIHelper.dart';
import 'package:chatapp/models/UserModel.dart';
import 'package:chatapp/pages/CompleteProfile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Controllers for input fields
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  // Variables to manage password visibility
  bool _isPasswordVisible = false;
  bool _isCPasswordVisible = false;

  // Method to check input values
  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cPassword = cPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || cPassword.isEmpty) {
      UIHelper.showAlertDialog(
          context, "Incomplete Data", "Please fill all the fields");
    } else if (password != cPassword) {
      UIHelper.showAlertDialog(context, "Password Mismatch",
          "The passwords you entered do not match!");
    } else {
      signUp(email, password);
    }
  }

  // Method to handle sign up
  void signUp(String email, String password) async {
    UserCredential? credential;

    UIHelper.showLoadingDialog(context, "Creating new account..");

    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      Navigator.pop(context);
      UIHelper.showAlertDialog(
          context, "An error occurred", ex.message.toString());
    }

    if (credential != null) {
      String uid = credential.user!.uid;
      UserModel newUser =
          UserModel(uid: uid, email: email, fullname: "", profilepic: "");
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newUser.toMap())
          .then((value) {
        print("New User Created!");
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return CompleteProfile(
                userModel: newUser, firebaseUser: credential!.user!);
          }),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define color scheme manually
    final Color primaryBlue = Colors.blue.shade800;
    final Color accentBlue = Colors.blue.shade600;
    final Color backgroundGradientStart = Colors.blue.shade200;
    final Color backgroundGradientEnd = Colors.blue.shade50;
    final Color greyColor = Colors.grey.shade700;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            backgroundGradientStart,
            backgroundGradientEnd,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // App Title
                    Text(
                      "Chat App",
                      style: TextStyle(
                        color: primaryBlue,
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 40),

                    // Email TextField
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.email, color: primaryBlue),
                        labelText: "Email Address",
                        labelStyle: TextStyle(color: primaryBlue),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Password TextField with visibility toggle
                    TextField(
                      controller: passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.lock, color: primaryBlue),
                        labelText: "Password",
                        labelStyle: TextStyle(color: primaryBlue),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: primaryBlue,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          tooltip: _isPasswordVisible
                              ? 'Hide Password'
                              : 'Show Password',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Confirm Password TextField with visibility toggle
                    TextField(
                      controller: cPasswordController,
                      obscureText: !_isCPasswordVisible,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon:
                            Icon(Icons.lock_outline, color: primaryBlue),
                        labelText: "Confirm Password",
                        labelStyle: TextStyle(color: primaryBlue),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isCPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: primaryBlue,
                          ),
                          onPressed: () {
                            setState(() {
                              _isCPasswordVisible = !_isCPasswordVisible;
                            });
                          },
                          tooltip: _isCPasswordVisible
                              ? 'Hide Password'
                              : 'Show Password',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          checkValues();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Divider with OR
                    Row(
                      children: [
                        Expanded(
                            child: Divider(
                                color: Colors.grey.shade400, thickness: 1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text("OR",
                              style: TextStyle(color: Colors.grey.shade700)),
                        ),
                        Expanded(
                            child: Divider(
                                color: Colors.grey.shade400, thickness: 1)),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Optional: Social Sign-Up Buttons (e.g., Google Sign-Up)
                    // You can implement social sign-up options here
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      // Bottom Navigation Bar with "Already have an account? Log In"
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already have an account?",
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            SizedBox(width: 5),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Log In",
                style: TextStyle(
                    fontSize: 16,
                    color: primaryBlue,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
