import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/Pages/Plan.dart';
import 'package:travel_app/Pages/bottomnav.dart';
import 'package:travel_app/widget/support_widget.dart';

import '../services/shared_pref.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? profile, name, email;

  getthesharedpref() async{
    profile= await SharedPreferenceHelper().getUserProfile();
    name= await SharedPreferenceHelper().getUserName();
    email= await SharedPreferenceHelper().getUserEmail();
    setState(() {

    });
  }

  onthisload() async{
    await getthesharedpref();
    setState(() {

    });
  }


  // Method to get the appropriate greeting based on the current time
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon";
    } else if (hour >= 17 && hour < 21) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }

  @override
  void initState() {
    onthisload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: name == null
          ? Center(child: CircularProgressIndicator()) // Or any placeholder widget while loading data
          : SingleChildScrollView(
      child: Container(
          margin: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hey, $name", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                      Text(getGreeting(), style: AppWidget.lightTextFieldStyle()),
                    ],
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "images/20171206_01.jpg",
                      height: 50.0,
                      width: 50.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50), // Adjust the height value to move the image down
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.6), // Adjust the opacity to control darkness
                            BlendMode.darken,
                          ),
                          child: Image.asset(
                            "images/first.png",
                            height: 500.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center, // Aligns text to the center
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0), // Adds some horizontal padding
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 80),
                              const Text(
                                'The ultimate\nSri Lanka travel\ncompanion for all',
                                textAlign: TextAlign.center, // Centers the text
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 38,
                                  fontWeight: FontWeight.bold,
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(height: 20), // Adds spacing between the texts
                              const Text(
                                'Welcome to your ultimate travel companion! Discover the\nworld\'s top destinations, hidden gems, and unforgettable\nadventures. Get expert tips, insider insights, and\npersonalized recommendations for a seamless journey.\nWhether you\'re after serene landscapes, vibrant cities, \nor cultural treasures, let us guide you to the wonders of\nthe world.',
                                textAlign: TextAlign.center, // Centers the text
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),

                              const SizedBox(height: 50), // Adds spacing between the text and button
                              Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(20.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Plan(), // Navigate to Plan page
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    width: 150.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xff228B22),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Start Planning",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0,
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
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 100.0), // Set the height
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Explore", style: AppWidget.boldTextFieldStyle()),
                  const SizedBox(height: 5.0), // Set the height
                  const Text(
                    "Popular Travel Areas in Sri Lanka",
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  const SizedBox(height: 30.0),
                  CarouselSlider(
                    items: [
                      // List of containers, each containing an image
                      Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black, // Optional: background color for container
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'images/sri-lanka-5061997_1920.jpg',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                            const Positioned(
                              bottom: 10.0,
                              left: 10.0,
                              child: Text(
                                "Kandy",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  backgroundColor: Colors.black54, // Optional background color for readability
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black, // Optional: background color for container
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'images/tower-7314495_1920.jpg',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                            const Positioned(
                              bottom: 10.0,
                              left: 10.0,
                              child: Text(
                                "Colombo",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  backgroundColor: Colors.black54, // Optional background color for readability
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black, // Optional: background color for container
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'images/ella-4788958_1920 (1).jpg',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                            const Positioned(
                              bottom: 10.0,
                              left: 10.0,
                              child: Text(
                                "Ella",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  backgroundColor: Colors.black54, // Optional background color for readability
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black, // Optional: background color for container
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'images/anuradhapura-7475663_1920.jpg',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                            const Positioned(
                              bottom: 10.0,
                              left: 10.0,
                              child: Text(
                                "Anuradhapura",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  backgroundColor: Colors.black54, // Optional background color for readability
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    options: CarouselOptions(
                      height: 250,
                      aspectRatio: 16 / 8,
                      viewportFraction: 0.6,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100.0),
            ],
          ),
        ),
      ),
    );
  }
}
