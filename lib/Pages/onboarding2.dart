import 'package:flutter/material.dart';
import 'package:travel_app/Pages/onboarding3.dart';
import 'package:travel_app/Pages/Login.dart'; // Import the Login page

class Onboarding2 extends StatefulWidget {
  const Onboarding2({super.key});

  @override
  State<Onboarding2> createState() => _Onboaring2State();
}

class _Onboaring2State extends State<Onboarding2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main content
          Container(
            margin: const EdgeInsets.only(top: 100.0),
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                Image.asset('images/Map dark.png', width: 300,),

                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    "Personalize Your\nAdventure",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Shape your journey by freely adding,\nediting, or deleting activities from your\nitinerary.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),

                const SizedBox(height: 60.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const Onboarding3()));
                      },
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          width: 200.0,
                          decoration: BoxDecoration(
                            color: const Color(0xff1a5317),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: const Center(
                            child: Text(
                              "Next",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                                fontFamily: 'Overlay',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Skip button moved down
          Positioned(
            top: 50, // Adjust the value to move it further down if necessary
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LogIn()));
              },
              child: const Text(
                "Skip",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
