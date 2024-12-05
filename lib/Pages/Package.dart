import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_app/Pages/PackageInfo.dart';
import 'package:travel_app/widget/support_widget.dart';

class Package extends StatefulWidget {
  const Package({super.key});

  @override
  State<Package> createState() => _PackageState();
}

class _PackageState extends State<Package> {
  // Firestore instance
  final CollectionReference packagesCollection = FirebaseFirestore.instance.collection('Packages');
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _filteredPackages = []; // For filtered packages
  List<DocumentSnapshot> _allPackages = []; // For all packages

  @override
  void initState() {
    super.initState();
    _fetchPackages(); // Fetch packages on initialization
  }

  Future<void> _fetchPackages() async {
    QuerySnapshot snapshot = await packagesCollection.where('status', isEqualTo: 'Accepted').get();
    setState(() {
      _allPackages = snapshot.docs; // Store all accepted packages
      _filteredPackages = _allPackages; // Initialize filtered packages
    });
  }

  void _filterPackages(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredPackages = _allPackages; // Show all packages if query is empty
      });
    } else {
      setState(() {
        _filteredPackages = _allPackages.where((package) {
          var packageData = package.data() as Map<String, dynamic>?; // Safe cast
          String packageName = packageData?['packageName']?.toLowerCase() ?? '';
          String duration = packageData?['duration']?.toLowerCase() ?? '';
          return packageName.contains(query.toLowerCase()) ||
              duration.contains(query.toLowerCase());
        }).toList(); // Filter based on the package name and duration
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add some padding for better spacing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align the text to the left
          children: [
            const SizedBox(height: 40.0),
            // Static header texts
            Text(
              "Packages",
              style: AppWidget.boldTextFieldStyle(),
            ),
            Text(
              "Find the best travel Packages here",
              style: AppWidget.lightTextFieldStyle(),
            ),
            const SizedBox(height: 20.0), // Add space between header and search bar

            // Search bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Packages',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0), // Add border radius here
                  borderSide: BorderSide(color: Colors.grey), // Customize border color if needed
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0), // Add border radius here for focused state
                  borderSide: BorderSide(color: Colors.blue), // Customize focused border color
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _filterPackages(_searchController.text); // Trigger search on button press
                  },
                ),
              ),
              onChanged: (value) {
                _filterPackages(value); // Update search as user types
              },
            ),

            const SizedBox(height: 20.0), // Space between search bar and package list

            Expanded( // Use Expanded to take remaining space
              child: ListView.builder(
                itemCount: _filteredPackages.length,
                itemBuilder: (context, index) {
                  var packageData = _filteredPackages[index].data() as Map<String, dynamic>?;

                  // Retrieve Firestore fields
                  String packageName = packageData?['packageName'] ?? 'Unknown Package';
                  String duration = packageData?['duration'] ?? 'Unknown Duration';
                  String packagePP = packageData?['packagePP'] ?? ''; // Default to empty if null
                  String packageId = _filteredPackages[index].id; // Get the package ID

                  return GestureDetector(
                    onTap: () {
                      // Navigate to the PackageInfoPage with the package ID
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PackageInfoPage(packageId: packageId), // Pass the package ID
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align the text to the left
                      children: [
                        const SizedBox(height: 5.0),
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                height: 340.0,
                                width: 340.0, // Adjust image size as needed
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0), // Rounded corners
                                  image: DecorationImage(
                                    image: packagePP.isNotEmpty
                                        ? NetworkImage(packagePP)
                                        : AssetImage('images/no-image.png') as ImageProvider,
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.3), // Darken the image
                                      BlendMode.darken,
                                    ),
                                  ),
                                ),
                              ),
                              // Move text and icons to the bottom-left corner
                              Positioned(
                                bottom: 16.0, // Distance from the bottom
                                left: 16.0, // Distance from the left
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                                  children: [
                                    // Row for name with location icon
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on, // Location icon
                                          color: Colors.white,
                                          size: 20.0,
                                        ),
                                        const SizedBox(width: 8.0), // Add space between icon and text
                                        Text(
                                          packageName, // Display package name from Firestore
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Row for days with time icon
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time, // Time icon
                                          color: Colors.white,
                                          size: 20.0,
                                        ),
                                        const SizedBox(width: 8.0), // Add space between icon and text
                                        Text(
                                          duration, // Display duration from Firestore
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20.0), // Space between packages
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
