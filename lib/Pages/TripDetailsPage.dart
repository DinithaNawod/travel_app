import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/Pages/TripPlanSummary.dart';

import '../services/shared_pref.dart';
import 'HotelDetailPage.dart';

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
                top: 25.0,
                child: Container(
                  width: 60.0,
                  height: 50.0,
                  child: FloatingActionButton(
                    onPressed: () async {
                      // Example: Retrieve the hotel data based on user selection (adjust Firestore query as needed)
                      String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
                      if (userEmail.isEmpty) {
                        print("User is not logged in");
                        return;
                      }

                      // Reference to the user's created plan document
                      DocumentReference createdPlanRef = FirebaseFirestore.instance.collection('CreatedPlans').doc(userEmail);

                      // Fetch the first selected hotel data from the 'selectedHotels' subcollection
                      QuerySnapshot snapshot = await createdPlanRef.collection('selectedHotels').limit(1).get();

                      if (snapshot.docs.isNotEmpty) {
                        // Assuming you're fetching the first document (adjust as needed)
                        var hotelData = snapshot.docs.first.data() as Map<String, dynamic>; // Cast to Map<String, dynamic>

                        // Extract necessary hotel data
                        String hotelName = hotelData['hotelName'] ?? 'No Name';
                        String hotelAddress = hotelData['hotelAddress'] ?? 'No Address';
                        double price = hotelData['price'] ?? 0.0;
                        List<DateTime> selectedDateRange = [hotelData['selectedDate'].toDate()]; // Assuming selectedDate is stored as a Timestamp

                        // Navigate to TripPlanSummary with Firestore data
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TripPlanSummary(
                              selectedDateRange: selectedDateRange
                            ),
                          ),
                        );
                      } else {
                        print("No hotel data found for this user");
                      }
                    },
                    child: Icon(
                      Icons.print,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.black,
                  ),
                ),
              )




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
                          return GestureDetector(
                            onTap: () {
                              // Navigate to HotelDetailPage when the card is tapped
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HotelDetailPage(
                                    hotelName: hotel['hotelName'] ?? 'No Name',
                                    hotelDescription: hotel['hotelDescription'] ?? 'No Description',
                                    price: double.tryParse(hotel['price']?.toString() ?? '0.0') ?? 0.0,
                                    hotelAddress: hotel['hotelAddress'] ?? 'No Address',
                                    hotelDocumentId: hotel['documentId'], // Pass the document ID here
                                  ),
                                ),
                              );


                            },
                            child: Card(
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
                                        onPressed: () async {
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
                                                              String hotelName = hotel['hotelName'] ?? 'No Name';
                                                              String hotelAddress = hotel['hotelAddress'] ?? 'No Address';
                                                              double price = double.tryParse(hotel['price']?.toString() ?? '0.0') ?? 0.0;
                                                              DateTime selectedDate = date; // Selected date

                                                              Navigator.pop(context);

                                                              String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
                                                              if (userEmail.isEmpty) {
                                                                print("User is not logged in");
                                                                return;
                                                              }

                                                              DocumentReference createdPlanRef = FirebaseFirestore.instance
                                                                  .collection('CreatedPlans')
                                                                  .doc(userEmail);

                                                              DocumentSnapshot docSnapshot = await createdPlanRef.get();
                                                              Map<String, dynamic> selectedHotelData = {
                                                                'hotelName': hotelName,
                                                                'hotelAddress': hotelAddress,
                                                                'price': price,
                                                                'selectedDate': selectedDate,
                                                              };

                                                              if (docSnapshot.exists) {
                                                                await createdPlanRef
                                                                    .collection('selectedHotels')
                                                                    .add(selectedHotelData)
                                                                    .then((value) {
                                                                  print('Hotel data saved to existing document');
                                                                }).catchError((error) {
                                                                  print('Failed to save hotel data: $error');
                                                                });
                                                              } else {
                                                                await createdPlanRef
                                                                    .set({'createdAt': FieldValue.serverTimestamp()})
                                                                    .then((value) async {
                                                                  await createdPlanRef
                                                                      .collection('selectedHotels')
                                                                      .add(selectedHotelData)
                                                                      .then((value) {
                                                                    print('Hotel data saved to new document');
                                                                  }).catchError((error) {
                                                                    print('Failed to save hotel data: $error');
                                                                  });
                                                                }).catchError((error) {
                                                                  print('Failed to create CreatedPlans document: $error');
                                                                });
                                                              }

                                                              if (mounted) {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) => TripPlanSummary(
                                                                      selectedDateRange: [selectedDate],
                                                                    ),
                                                                  ),
                                                                );
                                                              }
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
            future: fetchData('Attractions'), // Fetch data for Attractions
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
                        'Top Attractions Just For You!',
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
                      itemCount: attractions.length,
                      itemBuilder: (context, index) {
                        final attraction = attractions[index];
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
                                        attraction['attractionDp'] != null && attraction['attractionDp'].isNotEmpty
                                            ? attraction['attractionDp']
                                            : 'https://firebasestorage.googleapis.com/v0/b/traveldb-e33d3.appspot.com/o/no-image.png?alt=media&token=0f26a585-f988-439d-ba97-0dea7cc89218',
                                        fit: BoxFit.cover, // Cover the area
                                      ),
                                    ),
                                  ),
                                ),

                                Expanded(
                                  child: ListTile(
                                    title: Text(
                                      attraction['attractionName'] ?? 'No Name',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                    ),
                                    subtitle: Text(
                                      attraction['attractionAddress'] ?? 'No Address',
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0), // Right padding for the button
                                  child: ElevatedButton(
                                    onPressed: () async {
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
                                                          // Retrieve data from the current attraction object
                                                          String attractionName = attraction['attractionName'] ?? 'No Name';
                                                          String attractionAddress = attraction['attractionAddress'] ?? 'No Address';
                                                          double price = double.tryParse(attraction['price']?.toString() ?? '0.0') ?? 0.0;
                                                          DateTime selectedDate = date; // Selected date

                                                          // Close the dialog box
                                                          Navigator.pop(context);

                                                          // Get the current user's email (assuming the user is logged in)
                                                          String userEmail = FirebaseAuth.instance.currentUser?.email ?? ''; // Retrieve current user's email
                                                          if (userEmail.isEmpty) {
                                                            print("User is not logged in");
                                                            return;
                                                          }

                                                          // Reference to the user's CreatedPlans document using email as document ID
                                                          DocumentReference createdPlanRef = FirebaseFirestore.instance
                                                              .collection('CreatedPlans')
                                                              .doc(userEmail); // Using userEmail as the document name

                                                          // Check if the document already exists
                                                          DocumentSnapshot docSnapshot = await createdPlanRef.get();

                                                          // Create a Map for the selected attraction data
                                                          Map<String, dynamic> selectedAttractionData = {
                                                            'attractionName': attractionName,
                                                            'attractionAddress': attractionAddress,
                                                            'price': price,
                                                            'selectedDate': selectedDate,
                                                          };

                                                          if (docSnapshot.exists) {
                                                            // If document exists, add the selected attraction to selectedAttractions collection
                                                            await createdPlanRef
                                                                .collection('selectedAttractions') // Subcollection of selectedAttractions
                                                                .add(selectedAttractionData) // Adding a new document with random ID
                                                                .then((value) {
                                                              print('Attraction data saved to existing document');
                                                            }).catchError((error) {
                                                              print('Failed to save attraction data: $error');
                                                            });
                                                          } else {
                                                            // If document doesn't exist, create a new document and add the attraction data
                                                            await createdPlanRef
                                                                .set({'createdAt': FieldValue.serverTimestamp()}) // Create a document
                                                                .then((value) async {
                                                              // Now save to the selectedAttractions subcollection
                                                              await createdPlanRef
                                                                  .collection('selectedAttractions')
                                                                  .add(selectedAttractionData)
                                                                  .then((value) {
                                                                print('Attraction data saved to new document');
                                                              }).catchError((error) {
                                                                print('Failed to save attraction data: $error');
                                                              });
                                                            }).catchError((error) {
                                                              print('Failed to create CreatedPlans document: $error');
                                                            });
                                                          }

                                                          // Navigate to TripPlanSummary (without passing data directly)
                                                          if (mounted) {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => TripPlanSummary(
                                                                  selectedDateRange: [selectedDate], // Pass only the selected date range
                                                                ),
                                                              ),
                                                            );
                                                          }
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
                                      onPressed: () async {
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
                                                            // Retrieve data from the current activity object
                                                            String activityName = activity['activityName'] ?? 'No Name';
                                                            String activityAddress = activity['activityAddress'] ?? 'No Address';
                                                            double price = double.tryParse(activity['price']?.toString() ?? '0.0') ?? 0.0;
                                                            DateTime selectedDate = date; // Selected date

                                                            // Close the dialog box
                                                            Navigator.pop(context);

                                                            // Get the current user's email (assuming the user is logged in)
                                                            String userEmail = FirebaseAuth.instance.currentUser?.email ?? ''; // Retrieve current user's email
                                                            if (userEmail.isEmpty) {
                                                              print("User is not logged in");
                                                              return;
                                                            }

                                                            // Reference to the user's CreatedPlans document using email as document ID
                                                            DocumentReference createdPlanRef = FirebaseFirestore.instance
                                                                .collection('CreatedPlans')
                                                                .doc(userEmail); // Using userEmail as the document name

                                                            // Check if the document already exists
                                                            DocumentSnapshot docSnapshot = await createdPlanRef.get();

                                                            // Create a Map for the selected activity data
                                                            Map<String, dynamic> selectedActivityData = {
                                                              'activityName': activityName,
                                                              'activityAddress': activityAddress,
                                                              'price': price,
                                                              'selectedDate': selectedDate,
                                                            };

                                                            if (docSnapshot.exists) {
                                                              // If document exists, add the selected activity to selectedActivities collection
                                                              await createdPlanRef
                                                                  .collection('selectedActivities') // Subcollection of selectedActivities
                                                                  .add(selectedActivityData) // Adding a new document with random ID
                                                                  .then((value) {
                                                                print('Activity data saved to existing document');
                                                              }).catchError((error) {
                                                                print('Failed to save activity data: $error');
                                                              });
                                                            } else {
                                                              // If document doesn't exist, create a new document and add the activity data
                                                              await createdPlanRef
                                                                  .set({'createdAt': FieldValue.serverTimestamp()}) // Create a document
                                                                  .then((value) async {
                                                                // Now save to the selectedActivities subcollection
                                                                await createdPlanRef
                                                                    .collection('selectedActivities')
                                                                    .add(selectedActivityData)
                                                                    .then((value) {
                                                                  print('Activity data saved to new document');
                                                                }).catchError((error) {
                                                                  print('Failed to save activity data: $error');
                                                                });
                                                              }).catchError((error) {
                                                                print('Failed to create CreatedPlans document: $error');
                                                              });
                                                            }

                                                            // Navigate to TripPlanSummary (without passing data directly)
                                                            if (mounted) {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => TripPlanSummary(
                                                                    selectedDateRange: [selectedDate], // Pass only the selected date range
                                                                  ),
                                                                ),
                                                              );
                                                            }
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
                                    padding: const EdgeInsets.all(8.0),
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
                                      onPressed: () async {
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
                                                            // Retrieve data from the current restaurant object
                                                            String restaurantName = restaurant['restaurantName'] ?? 'No Name';
                                                            String restaurantAddress = restaurant['restaurantAddress'] ?? 'No Address';
                                                            double price = double.tryParse(restaurant['price']?.toString() ?? '0.0') ?? 0.0;
                                                            DateTime selectedDate = date; // Selected date

                                                            // Close the dialog box
                                                            Navigator.pop(context);

                                                            // Get the current user's email (assuming the user is logged in)
                                                            String userEmail = FirebaseAuth.instance.currentUser?.email ?? ''; // Retrieve current user's email
                                                            if (userEmail.isEmpty) {
                                                              print("User is not logged in");
                                                              return;
                                                            }

                                                            // Reference to the user's CreatedPlans document using email as document ID
                                                            DocumentReference createdPlanRef = FirebaseFirestore.instance
                                                                .collection('CreatedPlans')
                                                                .doc(userEmail); // Using userEmail as the document name

                                                            // Check if the document already exists
                                                            DocumentSnapshot docSnapshot = await createdPlanRef.get();

                                                            // Create a Map for the selected restaurant data
                                                            Map<String, dynamic> selectedRestaurantData = {
                                                              'restaurantName': restaurantName,
                                                              'restaurantAddress': restaurantAddress,
                                                              'price': price,
                                                              'selectedDate': selectedDate,
                                                            };

                                                            if (docSnapshot.exists) {
                                                              // If document exists, add the selected restaurant to selectedRestaurants collection
                                                              await createdPlanRef
                                                                  .collection('selectedRestaurants') // Subcollection of selectedRestaurants
                                                                  .add(selectedRestaurantData) // Adding a new document with random ID
                                                                  .then((value) {
                                                                print('Restaurant data saved to existing document');
                                                              }).catchError((error) {
                                                                print('Failed to save restaurant data: $error');
                                                              });
                                                            } else {
                                                              // If document doesn't exist, create a new document and add the restaurant data
                                                              await createdPlanRef
                                                                  .set({'createdAt': FieldValue.serverTimestamp()}) // Create a document
                                                                  .then((value) async {
                                                                // Now save to the selectedRestaurants subcollection
                                                                await createdPlanRef
                                                                    .collection('selectedRestaurants')
                                                                    .add(selectedRestaurantData)
                                                                    .then((value) {
                                                                  print('Restaurant data saved to new document');
                                                                }).catchError((error) {
                                                                  print('Failed to save restaurant data: $error');
                                                                });
                                                              }).catchError((error) {
                                                                print('Failed to create CreatedPlans document: $error');
                                                              });
                                                            }

                                                            // Navigate to TripPlanSummary (without passing data directly)
                                                            if (mounted) {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => TripPlanSummary(
                                                                    selectedDateRange: [selectedDate], // Pass only the selected date range
                                                                  ),
                                                                ),
                                                              );
                                                            }
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