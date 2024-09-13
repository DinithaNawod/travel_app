import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GuideInfoPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigates back to the previous page
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
                  CarouselSlider(
                    items: [
                      Container(
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
                                'images/profilecrop.jpg', // Fallback image
                                fit: BoxFit.cover,
                                width: double.infinity,
                              );
                            },
                          ),
                        ),
                      ),
                      // Add more images if needed
                    ],
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

              // Guide Name
              Text(
                name,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                profession,
                style: TextStyle(fontSize: 22, color: Colors.green, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),

              // Description
              Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'This is a sample product description. It provides details about the product, its features, and benefits. This section can include information on materials, dimensions, or any other relevant specifications that the user may find useful.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 40),

              // Provided Packages
              Text(
                'Provided Packages',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildFeatureItem('Knuckles Hike (3 Days)'),
              _buildFeatureItem('Galle Fort (2 Days)'),
              _buildFeatureItem('Jaffna'),
              _buildFeatureItem('Rathnapura (3 days)'),

              SizedBox(height: 60),

              // Contact Button
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final Uri url = Uri.parse('https://t.me/shashini_kavindya'); // Replace with your Telegram link
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text('Error'),
                          content: Text('Could not launch'),
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
                    backgroundColor: Color(0xff002e47),
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
          Expanded(
            child: Text(
              feature,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
