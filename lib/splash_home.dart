import 'package:chatapp/pages/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreenHome extends StatefulWidget {
  final dynamic userModel;
  final dynamic firebaseUser;

  const SplashScreenHome({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  State<SplashScreenHome> createState() => _SplashScreenHomeState();
}

class _SplashScreenHomeState extends State<SplashScreenHome> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 6), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(
            userModel: widget.userModel,
            firebaseUser: widget.firebaseUser,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Lottie.network(
            "https://lottie.host/a59d643f-5c20-40e4-b10b-dabe1f1f4795/K86Bp2t1Eq.json",
          ),
        ),
      ),
    );
  }
}
