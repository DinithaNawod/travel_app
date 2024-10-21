import 'package:flutter/material.dart';

class TripPlanSummary extends StatelessWidget {
  final String logoImagePath; // Path for the logo image
  final String tripDestination; // Example trip destination
  final String tripDate; // Example trip date
  final String groupSize; // Example group size

  TripPlanSummary({
    Key? key,
    required this.logoImagePath,
    required this.tripDestination,
    required this.tripDate,
    required this.groupSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Plan Summary'),
        centerTitle: true,
        backgroundColor: Color(0xff1a5317),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo Image
            Center(
              child: Image.asset(
                'images/IsleHevan text.balck.png', // Updated image path
                height: 70, // Adjust height as needed
              ),
            ),

            SizedBox(height: 30),

            // Header Title
            Center(
              child: Text(
                'Your Plan Summary',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Trip Details
            Text(
              'Destination: $tripDestination',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Trip Date: $tripDate',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Group Size: $groupSize',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
