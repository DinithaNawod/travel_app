import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class GuideInfoPage extends StatefulWidget {
  final String name;
  final String profession;
  final String imageUrl;

  const GuideInfoPage({
    super.key,
    required this.name,
    required this.profession,
    required this.imageUrl,
  });

  @override
  _GuideInfoPageState createState() => _GuideInfoPageState();
}

class _GuideInfoPageState extends State<GuideInfoPage> {
  String experience = 'No experience added'; // Default message for experience
  String language = 'No languages added'; // Default message for languages
  String services = 'No services added'; // Default message for services
  String contactNumber = ''; // Contact number
  List<String> travelImages = []; // List to store image URLs
  bool isLoadingExperience = true; // Loader for experience data
  bool isLoadingLanguage = true; // Loader for language data
  bool isLoadingServices = true; // Loader for services data
  bool isLoadingContactNumber = true; // Loader for contact number data
  bool isLoadingTravelImages = true; // Loader for travel images data

  @override
  void initState() {
    super.initState();
    _fetchExperience();
    _fetchLanguage();
    _fetchServices();
    _fetchContactNumber();
    _fetchTravelImages();
  }

  Future<void> _fetchExperience() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Guides')
          .doc(widget.name)
          .get();

      if (doc.exists && doc['experience'] != null) {
        setState(() {
          experience = doc['experience'];
          isLoadingExperience = false;
        });
      } else {
        setState(() {
          isLoadingExperience = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoadingExperience = false;
      });
    }
  }

  Future<void> _fetchLanguage() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Guides')
          .doc(widget.name)
          .get();

      if (doc.exists && doc['language'] != null) {
        setState(() {
          language = doc['language'];
          isLoadingLanguage = false;
        });
      } else {
        setState(() {
          isLoadingLanguage = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoadingLanguage = false;
      });
    }
  }

  Future<void> _fetchServices() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Guides')
          .doc(widget.name)
          .get();

      if (doc.exists && doc['services'] != null) {
        setState(() {
          services = doc['services'];
          isLoadingServices = false;
        });
      } else {
        setState(() {
          isLoadingServices = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoadingServices = false;
      });
    }
  }

  Future<void> _fetchContactNumber() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Guides')
          .doc(widget.name)
          .get();

      if (doc.exists && doc['contactNumber'] != null) {
        setState(() {
          contactNumber = doc['contactNumber'];
          isLoadingContactNumber = false;
        });
      } else {
        setState(() {
          isLoadingContactNumber = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoadingContactNumber = false;
      });
    }
  }

  Future<void> _fetchTravelImages() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Guides')
          .doc(widget.name)
          .get();

      if (doc.exists && doc['travelImages'] != null) {
        List<String> images = List<String>.from(doc['travelImages']);
        setState(() {
          travelImages = images;
          isLoadingTravelImages = false;
        });
      } else {
        setState(() {
          isLoadingTravelImages = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoadingTravelImages = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carousel with dynamic images
              Column(
                children: [
                  const SizedBox(height: 10.0),
                  isLoadingTravelImages
                      ? CircularProgressIndicator()
                      : CarouselSlider(
                    items: travelImages.map((imageUrl) {
                      return Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'images/profilecrop.jpg',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              );
                            },
                          ),
                        ),
                      );
                    }).toList(),
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
              SizedBox(height: 20),

              // Guide Name and Profession
              Text(
                widget.name,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.profession,
                style: TextStyle(fontSize: 22, color: Colors.green, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),

              // Experience (Description) Section
              Text(
                'Experience',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              isLoadingExperience
                  ? CircularProgressIndicator()
                  : Text(
                experience,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 40),

              // Languages Section
              Text(
                'Languages',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              isLoadingLanguage
                  ? CircularProgressIndicator()
                  : Text(
                language,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 40),

              // Provided Services Section
              Text(
                'Provided Services',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              isLoadingServices
                  ? CircularProgressIndicator()
                  : Text(
                services,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 60),

              // Contact Button
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (contactNumber.isNotEmpty) {
                      final Uri url = Uri.parse('tel:$contactNumber');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text('Error'),
                            content: Text('Could not launch dialer'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text('No Contact Number'),
                          content: Text('Contact number not available.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Contact',
                    style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: Color(0xff1a5317),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build feature list items
  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Icon(Icons.check, color: Colors.green),
          SizedBox(width: 10),
          Expanded(child: Text(feature, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
