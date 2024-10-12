import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
      query = query.where('selectedGroupSize', isEqualTo: selectedGroupSize);
    }

    QuerySnapshot snapshot = await query.get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
                            child: ListTile(
                              title: Text(
                                hotel['hotelName'] ?? 'No Name',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(hotel['hotelAddress'] ?? 'No Address'),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  hotel['hotelDp'] != null && hotel['hotelDp'].isNotEmpty
                                      ? hotel['hotelDp']
                                      : 'https://firebasestorage.googleapis.com/v0/b/traveldb-e33d3.appspot.com/o/no-image.png?alt=media&token=0f26a585-f988-439d-ba97-0dea7cc89218',
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  if (widget.selectedDateRange != null) {
                                    List<DateTime> dateList = _getDatesInRange(widget.selectedDateRange!);

                                    // Show the selected dates in a selection dialog with reduced BoxDecoration width
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
                                                    onPressed: () {
                                                      print('Selected date: ${date.toString().split(' ')[0]}');
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
                            childAspectRatio: 0.44,
                          ),
                          itemCount: attractions.length,
                          itemBuilder: (context, index) {
                            final attraction = attractions[index];

                            return Card(
                              margin: EdgeInsets.all(8.0),
                              color: Colors.white.withOpacity(0.8),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      attraction['attractionDp'] != null && attraction['attractionDp'].isNotEmpty
                                          ? attraction['attractionDp']
                                          : 'https://firebasestorage.googleapis.com/v0/b/traveldb-e33d3.appspot.com/o/no-image.png?alt=media&token=0f26a585-f988-439d-ba97-0dea7cc89218',
                                      height: 150,
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
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      attraction['attractionAddress'] ?? 'No Address',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                  ElevatedButton(
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
                                                return SimpleDialogOption(
                                                  onPressed: () {
                                                    print('Selected date: ${date.toString().split(' ')[0]}');
                                                    Navigator.pop(context); // Close the dialog
                                                  },
                                                  child: Text('${date.toString().split(' ')[0]}'),
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
                                        fontSize: 12,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                    ),
                                  ),
                                ],
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
                            child: ListTile(
                              title: Text(
                                activity['activityName'] ?? 'No Name',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(activity['activityAddress'] ?? 'No Address'),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  activity['activityDp'] != null && activity['activityDp'].isNotEmpty
                                      ? activity['activityDp']
                                      : 'https://firebasestorage.googleapis.com/v0/b/traveldb-e33d3.appspot.com/o/no-image.png?alt=media&token=0f26a585-f988-439d-ba97-0dea7cc89218',
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              trailing: ElevatedButton(
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
                                            return SimpleDialogOption(
                                              onPressed: () {
                                                print('Selected date: ${date.toString().split(' ')[0]}');
                                                Navigator.pop(context); // Close the dialog
                                              },
                                              child: Text('${date.toString().split(' ')[0]}'),
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
                            child: ListTile(
                              title: Text(
                                restaurant['restaurantName'] ?? 'No Name',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(restaurant['restaurantAddress'] ?? 'No Address'),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  restaurant['restaurantDp'] != null && restaurant['restaurantDp'].isNotEmpty
                                      ? restaurant['restaurantDp']
                                      : 'https://firebasestorage.googleapis.com/v0/b/traveldb-e33d3.appspot.com/o/no-image.png?alt=media&token=0f26a585-f988-439d-ba97-0dea7cc89218',
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              trailing: ElevatedButton(
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
                                            return SimpleDialogOption(
                                              onPressed: () {
                                                print('Selected date: ${date.toString().split(' ')[0]}');
                                                Navigator.pop(context); // Close the dialog
                                              },
                                              child: Text('${date.toString().split(' ')[0]}'),
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