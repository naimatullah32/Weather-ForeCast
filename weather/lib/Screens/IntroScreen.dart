import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/Screens/HomeScreen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  static const String UserKey = 'isEnter';

  @override
  void initState() {
    super.initState();
    checkIfUserJoined();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.1000, -1),
            end: Alignment(-0.100, 3),
            colors: <Color>[
              Color(0xff000435),
              Colors.purple,
            ],
            stops: <double>[0.018, 1],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 400,
              width: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/Cludy.png"),
                ),
              ),
            ),
            SizedBox(height: 40),
            Text(
              "Weather",
              style: GoogleFonts.poppins(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 3,
              ),
            ),
            Text(
              "ForeCast",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w700,
                color: Colors.amber,
                letterSpacing: 3,
              ),
            ),
            SizedBox(height: 33),
            InkWell(
              onTap: () async {
                SharedPreferences sp = await SharedPreferences.getInstance();
                sp.setBool(UserKey, true);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Homescreen()),
                );
              },
              child: Container(
                height: 55,
                width: 200,
                decoration: BoxDecoration(
                  color: Color(0xffDDB130),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Get Start",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(width: 18),
                    Icon(
                      CupertinoIcons.arrow_right,
                      color: Colors.deepPurple,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkIfUserJoined() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool isEnterUser = sp.getBool(UserKey) ?? false;

      if (isEnterUser) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Homescreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => IntroScreen()),
        );
      }

  }
}
