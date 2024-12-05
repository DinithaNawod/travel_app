import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  double? rating; // Store rating
  String review = ''; // Store review
  List<Map<String, dynamic>> reviews = []; // List to store reviews
  bool showAllReviews = false; // Variable to toggle showing all reviews

  @override
  void initState() {
    super.initState();
    _fetchExperience();
    _fetchLanguage();
    _fetchServices();
    _fetchContactNumber();
    _fetchTravelImages();
    _fetchReviews(); // Fetch existing reviews
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

  Future<void> _fetchReviews() async {
    try {
      // Fetch reviews from the subcollection
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Guides')
          .doc(widget.name)
          .collection('reviews')
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          reviews = snapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
        });
      }
    } catch (e) {
      // Handle error if necessary
    }
  }

  Future<void> _submitReview() async {
    User? user = FirebaseAuth.instance.currentUser; // Get current user
    if (user != null && rating != null && review.isNotEmpty) {
      try {
        // Create a new review entry
        final newReview = {
          'rating': rating,
          'review': review,
          'email': user.email, // Include user email
          'timestamp': FieldValue.serverTimestamp(), // Use server timestamp
        };

        // Add the new review to the 'reviews' subcollection for the guide
        await FirebaseFirestore.instance
            .collection('Guides')
            .doc(widget.name)
            .collection('reviews')
            .add(newReview);

        // Clear the input fields after submission
        setState(() {
          rating = null;
          review = '';
        });

        // Fetch updated reviews
        _fetchReviews();

        // Show success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Review submitted successfully!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        // Show failure dialog in case of an error
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Failed to submit review: $e'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        print('Error submitting review: $e'); // Print error for debugging
      }
    } else {
      // Show failure dialog if rating or review is empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Rating or review cannot be empty'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      print('Rating or review is empty'); // Debug message if input is invalid
    }
  }


  Future<void> _launchWhatsApp() async {
    final String whatsappUrl = 'https://wa.me/$contactNumber'; // WhatsApp link

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
                      ? const CircularProgressIndicator()
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
                          child: imageUrl.startsWith('http')
                              ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'images/no-image.png',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              );
                            },
                          )
                              : Image.asset(
                            imageUrl, // Fallback to local asset
                            fit: BoxFit.cover,
                            width: double.infinity,
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
              const SizedBox(height: 20),

              // Guide Name and Profession
              Text(
                widget.name,
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.profession,
                style: const TextStyle(fontSize: 22, color: Colors.green, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              // Experience (Description) Section
              const Text(
                'Experience',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              isLoadingExperience
                  ? const CircularProgressIndicator()
                  : Text(
                experience,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),

              // Language Section
              const Text(
                'Languages',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              isLoadingLanguage
                  ? const CircularProgressIndicator()
                  : Text(
                language,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),

              // Services Section
              const Text(
                'Services',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              isLoadingServices
                  ? const CircularProgressIndicator()
                  : Text(
                services,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),

              // Contact Section
              const SizedBox(height: 10),
              isLoadingContactNumber
                  ? const CircularProgressIndicator()
                  : Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final Uri launchUri = Uri(
                      scheme: 'https',
                      path: 'wa.me/$contactNumber',
                    );
                    await launchUrl(launchUri);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff1a5317), // Button background color
                  ),
                  child: const Text(
                    'Contact Guide', // Button text
                    style: TextStyle(
                      color: Colors.white, // Change text color to white
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),


              Divider(thickness: 2.0),

              const SizedBox(height: 30),



              // Reviews Section
              Text(
                'Rating & Reviews',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              reviews.isEmpty // Check if the reviews list is empty
                  ? const Text(
                'No reviews yet', // Message to show when there are no reviews
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              )
                  : Column(
                children: [
                  ...reviews.take(showAllReviews ? reviews.length : 3).map((review) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0), // Add space below each review
                      child: ListTile(
                        title: Text(review['review']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5), // Space before rating
                            Text('Rating: ${review['rating']}'),
                            const SizedBox(height: 5), // Space before user
                            Text('User: ${review['email'] ?? 'Anonymous'}'), // Display user's email
                            const SizedBox(height: 5), // Space after user
                          ],
                        ),
                        trailing: Text(review['timestamp']?.toDate().toString() ?? ''),
                      ),
                    );
                  }).toList(),
                  if (reviews.length > 3) // Only show the button if there are more than 3 reviews
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showAllReviews = !showAllReviews; // Toggle the state
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Color(0xff1a5317), // Set the text color to green
                      ),
                      child: Text(showAllReviews ? 'Show Less' : 'Show More'),
                    ),

                ],
              ),


              const SizedBox(height: 20),


              Divider(thickness: 2.0),


              // Review Submission Section
              const SizedBox(height: 20),
              const Text(
                'Submit Your Review',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
// Star Rating Input
              const Text('Rating: '),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < (rating ?? 0) ? Icons.star : Icons.star_border,
                      color: index < (rating ?? 0) ? Colors.yellow : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        rating = index + 1; // Set rating based on star index
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  setState(() {
                    review = value; // Update review input
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Write your review',
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitReview, // Submit review when pressed
                child: const Text('Submit Review'),
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xff1a5317),
                  foregroundColor: Colors.white, // Set the text color to green
                ),
              ),

              SizedBox(height: 40.0,)


            ],
          ),
        ),
      ),
    );
  }
}
