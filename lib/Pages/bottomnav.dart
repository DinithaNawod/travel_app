import 'package:flutter/material.dart';
import 'package:travel_app/Pages/Guides.dart';
import 'package:travel_app/Pages/Home.dart';
import 'package:travel_app/Pages/Package.dart';
import 'package:travel_app/Pages/Plan.dart';
import 'package:travel_app/Pages/Profile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';


class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late List<Widget> pages;

  late Home HomePage;
  late Package package;
  late Plan plan;
  late Guides guides;
  late Profile profile;
  int currentTabInex=0;

  @override
  void initState() {
    HomePage= const Home();
    package= const Package();
    plan= const Plan();
    guides= const Guides();
    profile= const Profile();
    pages=[HomePage, package, plan, guides, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          height: 65,
          backgroundColor: Colors.white,
          color: Color(0xff1a5317),
          animationDuration: const Duration(milliseconds: 500),
          onTap: (int index){
            setState(() {
              currentTabInex=index;
            });
          },

          items: const [
            Icon(
              Icons.home_outlined,
              color: Colors.white,
            ),

            Icon(
              Icons.gif_box_outlined,
              color: Colors.white,
            ),

            Icon(
              Icons.hdr_plus_outlined,
              color: Colors.white,
            ),

            Icon(
              Icons.man_2_outlined,
              color: Colors.white,
            ),

            Icon(
              Icons.person_2_outlined,
              color: Colors.white,
            )
      ]),

      body: pages[currentTabInex],
    );

  }
}