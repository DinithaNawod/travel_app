import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_app/Pages/GuideInfo.dart';

import '../widget/support_widget.dart';

class Guides extends StatefulWidget {
  const Guides({super.key});

  @override
  State<Guides> createState() => _GuidesState();
}

class _GuidesState extends State<Guides> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20.0),
                      Text(
                        "Guides",
                        style: AppWidget.boldTextFieldStyle(),
                      ),
                      Text(
                        "Find the best travel guides here",
                        style: AppWidget.lightTextFieldStyle(),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              TextField(
                decoration: InputDecoration(
                  hintText: "Search guides...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (query) {
                  setState(() {
                    searchQuery = query.toLowerCase();
                  });
                },
              ),
              const SizedBox(height: 40.0),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Guides').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text("No guides available.");
                  }
                  final guides = snapshot.data!.docs.where((doc) {
                    final guideData = doc.data() as Map<String, dynamic>;
                    final name = (guideData['Name'] ?? '').toString().toLowerCase();
                    final profession = (guideData['Profession'] ?? '').toString().toLowerCase();
                    return name.contains(searchQuery) || profession.contains(searchQuery);
                  }).toList();

                  if (guides.isEmpty) {
                    return const Text("No matching guides found.");
                  }

                  return Column(
                    children: guides.map((guide) {
                      final guideData = guide.data() as Map<String, dynamic>;
                      return GuideCard(
                        name: guideData['Name'] ?? 'Unknown',
                        profession: guideData['Profession'] ?? 'Traveller/ Guide',
                        imageUrl: guideData['GuidePP'] ?? 'images/user-profile_12589073.png',
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GuideCard extends StatelessWidget {
  final String name;
  final String profession;
  final String imageUrl;

  const GuideCard({
    super.key,
    required this.name,
    required this.profession,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GuideInfoPage(
              name: name,
              profession: profession,
              imageUrl: imageUrl,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          elevation: 5.0,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 20.0,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffa6e5a3).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    imageUrl,
                    height: 50.0,
                    width: 50.0,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'images/no-image.png', // Fallback image
                        height: 50.0,
                        width: 50.0,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        profession,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
