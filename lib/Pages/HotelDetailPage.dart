import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HotelDetailPage extends StatelessWidget {
  final String hotelName;
  final String hotelDescription;
  final double price;
  final String hotelAddress;
  final String hotelDocumentId;

  // Constructor to receive data from previous page
  const HotelDetailPage({
    Key? key,
    required this.hotelName,
    required this.hotelDescription,
    required this.price,
    required this.hotelAddress,
    required this.hotelDocumentId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hotelName),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fetch the hotel image from Firestore
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('Hotels') // Assuming you have a 'Hotels' collection
                  .doc(hotelDocumentId) // Document ID of the specific hotel
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.hasData && snapshot.data != null) {
                  var data = snapshot.data?.data() as Map<String, dynamic>?;

                  if (data == null || data.isEmpty) {
                    return Center(child: Text('No data available.'));
                  }

                  // Get hotel images, using a default value if null or empty
                  List<dynamic> hotelImages = data['hotelImages'] ?? [];
                  String hotelImage = 'images/no-image.png'; // Default fallback image path

                  // If hotelImages has data, use the first image
                  if (hotelImages.isNotEmpty) {
                    hotelImage = hotelImages.first as String? ?? 'images/no-image.png';
                  }

                  // Banner Image
                  return SizedBox(
                    height: 250,
                    child: Image.asset(
                      hotelImage, // Use Image.asset for local resources
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  );
                }
                return Center(child: Text('No hotel data found.'));
              },
            ),

            // Hotel Name and Price
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotelName,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Price: \$${price.toStringAsFixed(2)} per night',
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                ],
              ),
            ),

            // Hotel Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                hotelDescription,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(height: 20),

            // Hotel Address
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Address: $hotelAddress',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),

            // Book Now Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Handle the booking functionality here
                },
                child: Text('Book Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Use backgroundColor instead of primary
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
