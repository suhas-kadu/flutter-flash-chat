import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/RoundedButton.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final emailController = TextEditingController();
final passwordController = new TextEditingController();

class LoginScreen extends StatefulWidget {
  static const String id = "login_screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String password;
  String email;
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
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
                      controller: emailController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        //Do something with the user input.
                        email = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: "Enter your Email")),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                      controller: passwordController,
                      textAlign: TextAlign.center,
                      obscureText: true,
                      onChanged: (value) {
                        //Do something with the user input.
                        password = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: "Enter your Password")),
                  SizedBox(
                    height: 24.0,
                  ),
                  RoundedButtonWidget(
                      buttonColor: Colors.lightBlueAccent,
                      buttonText: "Log In",
                      onButtonPressed: () async {
                        if (email == null || password == null) {
                          print("Inavlid credentials");
                          Fluttertoast.showToast(
                            msg: "Invalid Credentials",
                            textColor: Colors.white,
                            backgroundColor: Colors.teal,
                          );
                        } else {
                          Constants.prefs.setBool("loggedIn", true);
                          setState(() {
                            showSpinner = true;
                          });
                          try {
                            final newUser =
                                await _auth.signInWithEmailAndPassword(
                                    email: email, password: password, );
                            
                            if (newUser.user.emailVerified) {
                              Navigator.pushReplacementNamed(context, ChatScreen.id);
                              print("User Logged In succesfully");
                            }
                            if (newUser == null) {
                              print("Invalid Credentials");
                            }
                            setState(() {
                              showSpinner = false;
                            });
                          } on FirebaseAuthException catch (e) {
                            if(e.code == "user-not-found") {
                              Fluttertoast.showToast(msg: "No user found for that email");
                              
                            } else if (e.code == "wrong-password") {
                              Fluttertoast.showToast(msg: "Wrong Password");
                            } else {
                              Fluttertoast.showToast(msg: "Something went wrong\nTry Again!");
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
        ),
      ),
    );
  }
}
