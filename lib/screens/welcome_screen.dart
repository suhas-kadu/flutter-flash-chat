import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/RoundedButton.dart';
import 'login_screen.dart';
import 'registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = "welcome_screen";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Animation animation, tweenColorAnimation, tweenAlignmentAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    // Simple curved animation
    animation =
        CurvedAnimation(curve: Curves.easeInOutSine, parent: _controller);

    // ColorTween Animation
    tweenColorAnimation =
        ColorTween(begin: Colors.grey, end: Colors.white).animate(_controller);

    // AlignmentTween Animation
    tweenAlignmentAnimation =
        AlignmentTween(begin: Alignment.topCenter, end: Alignment.center)
            .animate(_controller);

    // allows animation to from small to large
    _controller.forward();

    // repeatign animation
    // animation.addStatusListener((status) {
    //   if(status == AnimationStatus.completed){
    //     _controller.reverse(from: 1.0);
    //   } else if (status == AnimationStatus.dismissed) {
    //     _controller.forward();
    //   }

    // });

    _controller.addListener(() {
      setState(() {});
      // print(_controller.value);
    });
  }

  // To destroy controller
  @override
  void dispose() {
    super.dispose();
    setState(() {
      print("controller disposed");
    });
  }

  @override
  Widget build(BuildContext context) {
     emailController.clear();
                passwordController.clear();
    return Scaffold(
      backgroundColor: tweenColorAnimation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: "logo",
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: animation.value * 100,
                  ),
                ),
                Expanded(
                  child: TyperAnimatedTextKit(
                    text: ['Flash Chat'],
                    speed: Duration(milliseconds: 100),
                    textStyle: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButtonWidget(
              buttonColor: Colors.lightBlue,
              buttonText: "Log in",
              onButtonPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButtonWidget(
                buttonColor: Colors.blueAccent,
                buttonText: "Register",
                onButtonPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                })
          ],
        ),
      ),
    );
  }
}
