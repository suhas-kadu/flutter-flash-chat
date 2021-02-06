import 'package:flash_chat/components/RoundedButton.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = "registration_screen";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email;
  String password;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: "logo",
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: "Enter your Email")),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: "Enter your Password")),
              SizedBox(
                height: 24.0,
              ),
              RoundedButtonWidget(
                  buttonColor: Colors.blueAccent,
                  buttonText: "Register",
                  onButtonPressed: () async {
                    // print("Email:$email\nPassword:$_password");
                    if (email == null || password == null) {
                      print("Inavlid credentials");
                      Fluttertoast.showToast(
                        msg: "Invalid Credentials",
                        textColor: Colors.white,
                        backgroundColor: Colors.teal,
                      );
                    } else {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                        await newUser.user.sendEmailVerification();
                        // Fluttertoast.showToast(msg: "An email verification link has been sent to your account\nPlease verify your email");
                        if (newUser != null) {
                          Fluttertoast.showToast(
                            msg:
                                  "An email verification link has been sent to your account\nPlease verify your email");

                          Navigator.pushNamed(context, ChatScreen.id);
                        }
                        // else {
                        //   Fluttertoast.showToast(msg: "An email verification link has been sent to your account");
                        // }
                        setState(() {
                          showSpinner = false;
                        });
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          Fluttertoast.showToast(
                              msg: "The password provided is too weak");
                        } else if (e.code == 'email-already-in-use') {
                          Fluttertoast.showToast(
                              msg: "The account already exists for that email");
                        } else {
                          Fluttertoast.showToast(msg: "Something Went Wrong");
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      }
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
