import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/Pages/TripPlanSummary.dart';

import '../services/shared_pref.dart';

class TripDetailsPage extends StatefulWidget {
  final String? selectedDestination;
  final String? selectedGroupSize;
  final DateTimeRange? selectedDateRange;

  TripDetailsPage({
    required this.selectedDestination,
    required this.selectedGroupSize,
    required this.selectedDateRange,
  });

  @override
  _TripDetailsPageState createState() => _TripDetailsPageState();
}

class _TripDetailsPageState extends State<TripDetailsPage> {
  late FirebaseFirestore firestore;

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
  }

  // Generate a list of dates between the start and end dates
  List<DateTime> _getDatesInRange(DateTimeRange dateRange) {
    List<DateTime> dates = [];
    DateTime start = dateRange.start;
    DateTime end = dateRange.end;

    for (DateTime date = start; date.isBefore(end) || date.isAtSameMomentAs(end); date = date.add(Duration(days: 1))) {
      dates.add(date);
    }
    return dates;
  }

  // Fetch data from Firestore based on selected tab and destination
  Future<List<Map<String, dynamic>>> fetchData(String tab) async {
    final destination = widget.selectedDestination;
    final selectedGroupSize = widget.selectedGroupSize;
    if (destination == null) return [];

    Query query = firestore.collection('TripDetails').doc(destination).collection(tab);

    // Filter by selectedGroupSize if it's not null
    if (selectedGroupSize != null && selectedGroupSize.isNotEmpty) {
      // Use array-contains to check if the group size is in the array field
      query = query.where('selectedGroupSize', arrayContains: selectedGroupSize);
    }

    QuerySnapshot snapshot = await query.get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }


  Future<void> saveToFirestore(String hotelName, String hotelAddress, DateTime selectedDate, double price) async {
    String? userEmail = await SharedPreferenceHelper().getUserEmail(); // Get the current user's email

    if (userEmail != null) {
      try {
        // Reference to the user's document in the CreatedPlans collection
        DocumentReference userDocRef = FirebaseFirestore.instance.collection('CreatedPlans').doc(userEmail);

        // Add a new date selection to the user's selectedDates subcollection
        await userDocRef.collection('selectedHotels').add({
          'hotelName': hotelName,
          'hotelAddress': hotelAddress,
          'selectedDate': selectedDate,
          'price': price, // Added price
          'createdAt': FieldValue.serverTimestamp(), // Optional: to keep track of when the entry was created
        });
        print('Data saved successfully');
      } catch (e) {
        print('Error saving data: $e');
      }
    } else {
      print('User email not found');
    }
  }

  Future<void> saveAttractionToFirestore(String attractionName, String attractionAddress, DateTime selectedDate, double price) async {
    String? userEmail = await SharedPreferenceHelper().getUserEmail(); // Get the current user's email

    if (userEmail != null) {
      try {
        // Reference to the user's document in the CreatedPlans collection
        DocumentReference userDocRef = FirebaseFirestore.instance.collection('CreatedPlans').doc(userEmail);

        // Add a new date selection to the user's selectedAttractions subcollection
        await userDocRef.collection('selectedAttractions').add({
          'attractionName': attractionName,
          'attractionAddress': attractionAddress,
          'selectedDate': selectedDate,
          'price': price, // Added price
          'createdAt': FieldValue.serverTimestamp(), // Optional: to keep track of when the entry was created
        });
        print('Attraction data saved successfully');
      } catch (e) {
        print('Error saving attraction data: $e');
      }
    } else {
      print('User email not found');
    }
  }


  Future<void> saveActivityToFirestore(String activityName, String activityAddress, DateTime selectedDate, double price) async {
    String? userEmail = await SharedPreferenceHelper().getUserEmail(); // Get the current user's email

    if (userEmail != null) {
      try {
        // Reference to the user's document in the CreatedPlans collection
        DocumentReference userDocRef = FirebaseFirestore.instance.collection('CreatedPlans').doc(userEmail);

        // Add a new date selection to the user's selectedActivities subcollection
        await userDocRef.collection('selectedActivities').add({
          'activityName': activityName,
          'activityAddress': activityAddress,
          'selectedDate': selectedDate,
          'price': price, // Added price
          'createdAt': FieldValue.serverTimestamp(), // Optional: to keep track of when the entry was created
        });
        print('Activity data saved successfully');
      } catch (e) {
        print('Error saving activity data: $e');
      }
    } else {
      print('User email not found');
    }
  }

  Future<void> saveRestaurantToFirestore(String restaurantName, String restaurantAddress, DateTime selectedDate, double price) async {
    String? userEmail = await SharedPreferenceHelper().getUserEmail(); // Get the current user's email

    if (userEmail != null) {
      try {
        // Reference to the user's document in the CreatedPlans collection
        DocumentReference userDocRef = FirebaseFirestore.instance.collection('CreatedPlans').doc(userEmail);

        // Add a new restaurant selection to the user's selectedRestaurants subcollection
        await userDocRef.collection('selectedRestaurants').add({
          'restaurantName': restaurantName,
          'restaurantAddress': restaurantAddress,
          'selectedDate': selectedDate,
          'price': price, // Added price
          'createdAt': FieldValue.serverTimestamp(), // Optional: to keep track of when the entry was created
        });
        print('Restaurant data saved successfully');
      } catch (e) {
        print('Error saving restaurant data: $e');
      }
    } else {
      print('User email not found');
    }
  }










  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0), // Increased height for better placement
          child: Stack(
            children: [


              AppBar(
                title: Text(''),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(getDestinationImage()),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(50.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      TabBar(
                        indicatorColor: const Color(0xff1a5317),
                        labelColor: const Color(0xff1a5317),
                        unselectedLabelColor: Colors.black,
                        tabs: [
                          Tab(text: 'Hotels'),
                          Tab(text: 'Attractions'),
                          Tab(text: 'Activities'),
                          Tab(text: 'Restaurants'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),



              // Side edge button positioned over the AppBar
              Positioned(
                right: 10.0,
                top: 25.0, // Adjust this value based on your layout
                child: Container(
                  width: 60.0, // Set your desired width
                  height: 50.0, // Set your desired height
                  child: FloatingActionButton(
                    onPressed: () {
                      // Navigate to TripPlanSummary page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TripPlanSummary(logoImagePath: '', tripDestination: '', tripDate: '', groupSize: '',),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.print,
                      color: Colors.white, // Set the icon color to white
                    ),
                    backgroundColor: Colors.black,
                  ),
                ),
              ),





            ],
          ),
        ),



        body: TabBarView(
          children: [

            // Tab 1: Hotels
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchData('Hotels'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading data'));
                }
                final hotels = snapshot.data ?? [];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          'Top Hotel Picks Just For You!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: hotels.length,
                        itemBuilder: (context, index) {
                          final hotel = hotels[index];
                          return Card(
                            margin: EdgeInsets.all(8.0),
                            color: Colors.white.withOpacity(0.8),
                            child: Container(
                              height: 110, // Fixed height for the card
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0), // Uniform padding for the image
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: SizedBox(
                                        width: 90, // Fixed width for the image
                                        height: 90, // Adjusted height for the image
                                        child: Image.network(
                                          hotel['hotelDp'] != null && hotel['hotelDp'].isNotEmpty
                                              ? hotel['hotelDp']
                                              : 'https://firebasestorage.googleapis.com/v0/b/traveldb-e33d3.appspot.com/o/no-image.png?alt=media&token=0f26a585-f988-439d-ba97-0dea7cc89218',
                                          fit: BoxFit.cover, // Cover the area
                                        ),
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    child: ListTile(
                                      title: Text(
                                        hotel['hotelName'] ?? 'No Name',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                      ),
                                      subtitle: Text(
                                        hotel['hotelAddress'] ?? 'No Address',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0), // Right padding for the button
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (widget.selectedDateRange != null) {
                                          List<DateTime> dateList = _getDatesInRange(widget.selectedDateRange!);
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return SimpleDialog(
                                                title: Text('Fix Your Dates'),
                                                children: dateList.map((date) {
                                                  return Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                    child: FractionallySizedBox(
                                                      widthFactor: 0.7,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.black, width: 1.0),
                                                          borderRadius: BorderRadius.circular(20.0),
                                                        ),
                                                        child: SimpleDialogOption(
                                                          onPressed: () async {
                                                            print('Selected date: ${date.toString().split(' ')[0]}');

                                                            // Ensure price is a double
                                                            double priceValue = (hotel['price'] is int) ? (hotel['price'] as int).toDouble() : hotel['price'];

                                                            // Call saveToFirestore with hotel data, selected date, and price
                                                            await saveToFirestore(
                                                              hotel['hotelName'],
                                                              hotel['hotelAddress'],
                                                              date,
                                                              priceValue, // Pass the price value here
                                                            );

                                                            Navigator.pop(context); // Close the dialog
                                                          },
                                                          child: Center(
                                                            child: Text(
                                                              '${date.toString().split(' ')[0]}',
                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              );
                                            },
                                          );
                                        } else {
                                          print('No dates selected');
                                        }
                                      },
                                      child: Text('Select', style: TextStyle(color: Colors.white, fontSize: 14)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                      ),
                                    ),
                                  ),






                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),



            // Tab 2: Attractions
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchData('Attractions'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading data'));
                }
                final attractions = snapshot.data ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          'Top sights in Kandy',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.5, // Adjusted for a smaller card size
                          ),
                          itemCount: attractions.length,
                          itemBuilder: (context, index) {
                            final attraction = attractions[index];

                            return Card(
                              margin: EdgeInsets.all(8.0),
                              color: Colors.white.withOpacity(0.8),
                              child: Container(
                                // Removed height to let it size according to content
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.network(
                                        attraction['attractionDp'] != null && attraction['attractionDp'].isNotEmpty
                                            ? attraction['attractionDp']
                                            : 'https://firebasestorage.googleapis.com/v0/b/traveldb-e33d3.appspot.com/o/no-image.png?alt=media&token=0f26a585-f988-439d-ba97-0dea7cc89218',
                                        height: 150, // Maintain the image height
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        attraction['attractionName'] ?? 'No Name',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        attraction['attractionAddress'] ?? 'No Address',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15.0), // Reduced space above the button
                                    SizedBox(
                                      width: 100, // Set fixed width
                                      height: 40, // Set fixed height
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (widget.selectedDateRange != null) {
                                            // Generate a list of individual dates from the selected date range
                                            List<DateTime> dateList = _getDatesInRange(widget.selectedDateRange!);

                                            // Show the selected dates in a selection dialog
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return SimpleDialog(
                                                  title: Text('Fix Your Dates'),
                                                  children: dateList.map((date) {
                                                    return Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                      child: FractionallySizedBox(
                                                        widthFactor: 0.7, // Reduces the width to 70% of the parent width
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            border: Border.all(color: Colors.black, width: 1.0),
                                                            borderRadius: BorderRadius.circular(20.0),
                                                          ),
                                                          child: SimpleDialogOption(
                                                            onPressed: () async {
                                                              print('Selected date: ${date.toString().split(' ')[0]}');

                                                              // Ensure price is a double
                                                              double priceValue = (attraction['price'] is int) ? (attraction['price'] as int).toDouble() : attraction['price'];

                                                              // Call saveAttractionToFirestore with attraction data and selected date
                                                              await saveAttractionToFirestore(
                                                                attraction['attractionName'],
                                                                attraction['attractionAddress'],
                                                                date,
                                                                priceValue, // Pass the price value here
                                                              );

                                                              Navigator.pop(context); // Close the dialog
                                                            },
                                                            child: Center(
                                                              child: Text(
                                                                '${date.toString().split(' ')[0]}',
                                                                style: TextStyle(fontWeight: FontWeight.bold),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                );
                                              },
                                            );
                                          } else {
                                            print('No dates selected');
                                          }
                                        },
                                        child: Text(
                                          'Select',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),



            // Tab 3: Activities
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchData('Activities'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading data'));
                }
                final activities = snapshot.data ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          'Top Activities to Experience!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: activities.length,
                        itemBuilder: (context, index) {
                          final activity = activities[index];
                          return Card(
                            margin: EdgeInsets.all(8.0),
                            color: Colors.white.withOpacity(0.8),
                            child: Container(
                              height: 110, // Fixed height for the card
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0), // Uniform padding for the image
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: SizedBox(
                                        width: 90, // Fixed width for the image
                                        height: 90, // Adjusted height for the image
                                        child: Image.network(
                                          activity['activityDp'] != null && activity['activityDp'].isNotEmpty
                                              ? activity['activityDp']
                                              : 'https://firebasestorage.googleapis.com/v0/b/traveldb-e33d3.appspot.com/o/no-image.png?alt=media&token=0f26a585-f988-439d-ba97-0dea7cc89218',
                                          fit: BoxFit.cover, // Cover the area
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      title: Text(
                                        activity['activityName'] ?? 'No Name',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                      ),
                                      subtitle: Text(
                                        activity['activityAddress'] ?? 'No Address',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),


                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0), // Right padding for the button
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (widget.selectedDateRange != null) {
                                          List<DateTime> dateList = _getDatesInRange(widget.selectedDateRange!);
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return SimpleDialog(
                                                title: Text('Fix Your Dates'),
                                                children: dateList.map((date) {
                                                  return Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                    child: FractionallySizedBox(
                                                      widthFactor: 0.7,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.black, width: 1.0),
                                                          borderRadius: BorderRadius.circular(20.0),
                                                        ),
                                                        child: SimpleDialogOption(
                                                          onPressed: () async {
                                                            print('Selected date: ${date.toString().split(' ')[0]}');

                                                            // Ensure price is a double
                                                            double priceValue = (activity['price'] is int) ? (activity['price'] as int).toDouble() : activity['price'];

                                                            // Call saveActivityToFirestore with activity data and selected date
                                                            await saveActivityToFirestore(
                                                              activity['activityName'],
                                                              activity['activityAddress'],
                                                              date,
                                                              priceValue, // Pass the price value here
                                                            );

                                                            Navigator.pop(context); // Close the dialog
                                                          },
                                                          child: Center(
                                                            child: Text(
                                                              '${date.toString().split(' ')[0]}',
                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              );
                                            },
                                          );
                                        } else {
                                          print('No dates selected');
                                        }
                                      },
                                      child: Text('Select', style: TextStyle(color: Colors.white)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),




            // Tab 4: Restaurants
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchData('Restaurants'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading data'));
                }
                final restaurants = snapshot.data ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          'Top Restaurants to Visit!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: restaurants.length,
                        itemBuilder: (context, index) {
                          final restaurant = restaurants[index];
                          return Card(
                            margin: EdgeInsets.all(8.0),
                            color: Colors.white.withOpacity(0.8),
                            child: Container(
                              height: 110, // Fixed height for the card
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0), // Uniform padding for the image
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: SizedBox(
                                        width: 90, // Fixed width for the image
                                        height: 90, // Adjusted height for the image
                                        child: Image.network(
                                          restaurant['restaurantDp'] != null && restaurant['restaurantDp'].isNotEmpty
                                              ? restaurant['restaurantDp']
                                              : 'https://firebasestorage.googleapis.com/v0/b/traveldb-e33d3.appspot.com/o/no-image.png?alt=media&token=0f26a585-f988-439d-ba97-0dea7cc89218',
                                          fit: BoxFit.cover, // Cover the area
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      title: Text(
                                        restaurant['restaurantName'] ?? 'No Name',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                      ),
                                      subtitle: Text(
                                        restaurant['restaurantAddress'] ?? 'No Address',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0), // Right padding for the button
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (widget.selectedDateRange != null) {
                                          List<DateTime> dateList = _getDatesInRange(widget.selectedDateRange!);
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return SimpleDialog(
                                                title: Text('Fix Your Dates'),
                                                children: dateList.map((date) {
                                                  return Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                    child: FractionallySizedBox(
                                                      widthFactor: 0.7,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.black, width: 1.0),
                                                          borderRadius: BorderRadius.circular(20.0),
                                                        ),
                                                        child: SimpleDialogOption(
                                                          onPressed: () async {
                                                            print('Selected date: ${date.toString().split(' ')[0]}');

                                                            // Ensure price is a double (you should retrieve the price from the restaurant object)
                                                            double priceValue = (restaurant['price'] is int) ? (restaurant['price'] as int).toDouble() : restaurant['price'];

                                                            // Call saveRestaurantToFirestore with restaurant data, selected date, and price
                                                            await saveRestaurantToFirestore(
                                                              restaurant['restaurantName'],
                                                              restaurant['restaurantAddress'],
                                                              date,
                                                              priceValue, // Pass the price value here
                                                            );

                                                            Navigator.pop(context); // Close the dialog
                                                          },
                                                          child: Center(
                                                            child: Text(
                                                              '${date.toString().split(' ')[0]}',
                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              );
                                            },
                                          );
                                        } else {
                                          print('No dates selected');
                                        }
                                      },
                                      child: Text('Select', style: TextStyle(color: Colors.white, fontSize: 14)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),




          ],
        ),
      ),
    );
  }

  String getDestinationImage() {
    switch (widget.selectedDestination) {
      case 'Galle':
        return 'images/GALLE.png';
      case 'Colombo':
        return 'images/COLOMBO.png';
      case 'Jaffna':
        return 'images/JAFFNA.png';
      case 'Kandy':
        return 'images/KANDY.png';
      default:
        return 'images/default.png';
    }
  }
}