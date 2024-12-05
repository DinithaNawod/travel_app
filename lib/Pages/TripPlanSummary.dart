import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TripPlanSummary extends StatelessWidget {
  final List<DateTime> selectedDateRange;

  TripPlanSummary({Key? key, required this.selectedDateRange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? userEmail = FirebaseAuth.instance.currentUser?.email;

    if (userEmail == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Trip Plan Summary'),
          centerTitle: true,
          backgroundColor: Color(0xff1a5317),
          foregroundColor: Colors.white,
        ),
        body: Center(child: Text('No user is logged in.')),
      );
    }

    // Firestore paths to the user's selected hotel, attraction, activity, and restaurant data
    final userHotelRef = FirebaseFirestore.instance
        .collection('CreatedPlans')
        .doc(userEmail)
        .collection('selectedHotels');

    final userAttractionRef = FirebaseFirestore.instance
        .collection('CreatedPlans')
        .doc(userEmail)
        .collection('selectedAttractions');

    final userActivityRef = FirebaseFirestore.instance
        .collection('CreatedPlans')
        .doc(userEmail)
        .collection('selectedActivities');

    final userRestaurantRef = FirebaseFirestore.instance
        .collection('CreatedPlans')
        .doc(userEmail)
        .collection('selectedRestaurants');

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        centerTitle: true,
        backgroundColor: Color(0xff1a5317),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Trip Plan Summary',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              _buildSectionTitle('Hotel Details'),
              FutureBuilder<QuerySnapshot>(
                future: userHotelRef.get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No hotel data found.'));
                  }

                  return _buildHotelList(snapshot.data!.docs);
                },
              ),
              SizedBox(height: 50),
              _buildSectionTitle('Attraction Details'),
              FutureBuilder<QuerySnapshot>(
                future: userAttractionRef.get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No attraction data found.'));
                  }

                  return _buildAttractionList(snapshot.data!.docs);
                },
              ),
              SizedBox(height: 50),
              _buildSectionTitle('Activity Details'),
              FutureBuilder<QuerySnapshot>(
                future: userActivityRef.get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No activity data found.'));
                  }

                  return _buildActivityList(snapshot.data!.docs);
                },
              ),
              SizedBox(height: 50),
              _buildSectionTitle('Restaurant Details'),
              FutureBuilder<QuerySnapshot>(
                future: userRestaurantRef.get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No restaurant data found.'));
                  }

                  return _buildRestaurantList(snapshot.data!.docs);
                },
              ),
              SizedBox(height: 20),
              _buildTotalCostSection(userHotelRef, userAttractionRef, userActivityRef, userRestaurantRef),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDatesList() {
    return selectedDateRange.isNotEmpty
        ? Column(
      children: selectedDateRange.map((date) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            date.toString().split(' ')[0], // Display only the date part
            style: TextStyle(fontSize: 16),
          ),
        );
      }).toList(),
    )
        : Text('No dates selected', style: TextStyle(fontSize: 16));
  }

  Widget _buildHotelList(List<QueryDocumentSnapshot> hotelDocs) {
    return ListView.builder(
      shrinkWrap: true, // Prevent scrolling issues when inside SingleChildScrollView
      physics: NeverScrollableScrollPhysics(),
      itemCount: hotelDocs.length,
      itemBuilder: (context, index) {
        var hotelData = hotelDocs[index].data() as Map<String, dynamic>;
        String hotelName = hotelData['hotelName'] ?? 'Not provided';
        String hotelAddress = hotelData['hotelAddress'] ?? 'Not provided';
        double price = hotelData['price']?.toDouble() ?? 0.0;

        // Fetch selectedDate field from the hotel document
        var selectedDate = hotelData['selectedDate']; // Assuming it's a timestamp in Firestore
        String formattedDate = 'No date selected'; // Default if no date is found

        if (selectedDate != null && selectedDate is Timestamp) {
          // Format the date if it's available
          formattedDate = (selectedDate as Timestamp).toDate().toString().split(' ')[0];
        }

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hotel Name: $hotelName', style: TextStyle(fontSize: 16)),
                Text('Hotel Address: $hotelAddress', style: TextStyle(fontSize: 16)),
                Text('Price: \$${price.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
                SizedBox(height: 8.0), // Space between hotel info and date
                Text('Selected Date: $formattedDate', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAttractionList(List<QueryDocumentSnapshot> attractionDocs) {
    return ListView.builder(
      shrinkWrap: true, // Prevent scrolling issues when inside SingleChildScrollView
      physics: NeverScrollableScrollPhysics(),
      itemCount: attractionDocs.length,
      itemBuilder: (context, index) {
        var attractionData = attractionDocs[index].data() as Map<String, dynamic>;
        String attractionName = attractionData['attractionName'] ?? 'Not provided';
        String attractionAddress = attractionData['attractionAddress'] ?? 'Not provided';
        double price = attractionData['price']?.toDouble() ?? 0.0;

        // Fetch selectedDate field from the attraction document
        var selectedDate = attractionData['selectedDate']; // Assuming it's a timestamp in Firestore
        String formattedDate = 'No date selected'; // Default if no date is found

        if (selectedDate != null && selectedDate is Timestamp) {
          // Format the date if it's available
          formattedDate = (selectedDate as Timestamp).toDate().toString().split(' ')[0];
        }

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Attraction Name: $attractionName', style: TextStyle(fontSize: 16)),
                Text('Attraction Address: $attractionAddress', style: TextStyle(fontSize: 16)),
                Text('Price: \$${price.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
                SizedBox(height: 8.0), // Space between attraction info and date
                Text('Selected Date: $formattedDate', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActivityList(List<QueryDocumentSnapshot> activityDocs) {
    return ListView.builder(
      shrinkWrap: true, // Prevent scrolling issues when inside SingleChildScrollView
      physics: NeverScrollableScrollPhysics(),
      itemCount: activityDocs.length,
      itemBuilder: (context, index) {
        var activityData = activityDocs[index].data() as Map<String, dynamic>;
        String activityName = activityData['activityName'] ?? 'Not provided';
        String activityAddress = activityData['activityAddress'] ?? 'Not provided';
        double price = activityData['price']?.toDouble() ?? 0.0;

        // Fetch selectedDate field from the activity document
        var selectedDate = activityData['selectedDate']; // Assuming it's a timestamp in Firestore
        String formattedDate = 'No date selected'; // Default if no date is found

        if (selectedDate != null && selectedDate is Timestamp) {
          // Format the date if it's available
          formattedDate = (selectedDate as Timestamp).toDate().toString().split(' ')[0];
        }

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Activity Name: $activityName', style: TextStyle(fontSize: 16)),
                Text('Activity Address: $activityAddress', style: TextStyle(fontSize: 16)),
                Text('Price: \$${price.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
                SizedBox(height: 8.0), // Space between activity info and date
                Text('Selected Date: $formattedDate', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRestaurantList(List<QueryDocumentSnapshot> restaurantDocs) {
    return ListView.builder(
      shrinkWrap: true, // Prevent scrolling issues when inside SingleChildScrollView
      physics: NeverScrollableScrollPhysics(),
      itemCount: restaurantDocs.length,
      itemBuilder: (context, index) {
        var restaurantData = restaurantDocs[index].data() as Map<String, dynamic>;
        String restaurantName = restaurantData['restaurantName'] ?? 'Not provided';
        String restaurantAddress = restaurantData['restaurantAddress'] ?? 'Not provided';
        double price = restaurantData['price']?.toDouble() ?? 0.0;

        // Fetch selectedDate field from the restaurant document
        var selectedDate = restaurantData['selectedDate']; // Assuming it's a timestamp in Firestore
        String formattedDate = 'No date selected'; // Default if no date is found

        if (selectedDate != null && selectedDate is Timestamp) {
          // Format the date if it's available
          formattedDate = (selectedDate as Timestamp).toDate().toString().split(' ')[0];
        }

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Restaurant Name: $restaurantName', style: TextStyle(fontSize: 16)),
                Text('Restaurant Address: $restaurantAddress', style: TextStyle(fontSize: 16)),
                Text('Price: \$${price.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
                SizedBox(height: 8.0), // Space between restaurant info and date
                Text('Selected Date: $formattedDate', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }

  // This function calculates the total cost
  Widget _buildTotalCostSection(
      CollectionReference userHotelRef,
      CollectionReference userAttractionRef,
      CollectionReference userActivityRef,
      CollectionReference userRestaurantRef) {
    return FutureBuilder<double>(
      future: _calculateTotalCost(
        userHotelRef,
        userAttractionRef,
        userActivityRef,
        userRestaurantRef,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return Text('Error calculating total cost');
        }

        double totalCost = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            'Total Cost: \$${totalCost.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  Future<double> _calculateTotalCost(
      CollectionReference userHotelRef,
      CollectionReference userAttractionRef,
      CollectionReference userActivityRef,
      CollectionReference userRestaurantRef,
      ) async {
    double totalCost = 0.0;

    // Get the costs from the hotels collection
    final hotelSnapshot = await userHotelRef.get();
    totalCost += hotelSnapshot.docs.fold(0.0, (sum, doc) {
      return sum + (doc['price']?.toDouble() ?? 0.0);
    });

    // Get the costs from the attractions collection
    final attractionSnapshot = await userAttractionRef.get();
    totalCost += attractionSnapshot.docs.fold(0.0, (sum, doc) {
      return sum + (doc['price']?.toDouble() ?? 0.0);
    });

    // Get the costs from the activities collection
    final activitySnapshot = await userActivityRef.get();
    totalCost += activitySnapshot.docs.fold(0.0, (sum, doc) {
      return sum + (doc['price']?.toDouble() ?? 0.0);
    });

    // Get the costs from the restaurants collection
    final restaurantSnapshot = await userRestaurantRef.get();
    totalCost += restaurantSnapshot.docs.fold(0.0, (sum, doc) {
      return sum + (doc['price']?.toDouble() ?? 0.0);
    });

    return totalCost;
  }
}
