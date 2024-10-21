import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/shared_pref.dart';

class AccountManagement extends StatefulWidget {
  const AccountManagement({super.key});

  @override
  _AccountManagementState createState() => _AccountManagementState();
}

class _AccountManagementState extends State<AccountManagement> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _gender;
  DateTime? _dob;
  String? _country;
  File? _profilePicture;

  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _name; // Store name retrieved from Shared Preferences
  String? _email; // Store email retrieved from Shared Preferences
  String? _userId; // Store unique user ID
  String? _profilePP; // Store Profile Picture URL from Firestore

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      // Load user profile, name, and email from Shared Preferences
      _name = await SharedPreferenceHelper().getUserName();
      _email = await SharedPreferenceHelper().getUserEmail();

      // Get user data from Firestore
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc('UserTraveler')
          .collection('UserTraveler')
          .where('Email', isEqualTo: _email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot snapshot = querySnapshot.docs.first;
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          _userId = data['Id'] ?? user.uid; // Use the existing Id (Traveler 01, etc.)
          _addressController.text = data['Address'] ?? '';
          _phoneController.text = data['Phone'] ?? '';
          _gender = data['Gender'];
          _dob = (data['Dob'] as Timestamp?)?.toDate();
          _country = data['Country'] ?? '';
          // Load Profile Picture URL
          _profilePP = data['ProfilePP'] ?? ''; // Load the existing ProfilePP URL
        });
      } else {
        print('User data does not exist in Firestore.');
        // Set the _userId to user.uid if this is a new user
        setState(() {
          _userId = user.uid;  // Use UID for new user
        });
      }
    } else {
      print('User is not logged in.');
    }
  }

  Future<void> _selectProfilePicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profilePicture = File(pickedFile.path);
      });

      // Upload to Firebase Storage
      String fileName = DateTime.now().millisecondsSinceEpoch.toString(); // Generate a unique file name
      Reference storageReference = FirebaseStorage.instance.ref().child('profile_pictures/$fileName');
      UploadTask uploadTask = storageReference.putFile(_profilePicture!);

      // Wait for the upload to complete
      await uploadTask.whenComplete(() => null);

      // Get the download URL
      String downloadUrl = await storageReference.getDownloadURL();

      // Save the download URL to Firestore
      await _saveProfilePictureUrl(downloadUrl);

      // Update local variable to reflect the new profile picture URL
      setState(() {
        _profilePP = downloadUrl; // Update _profilePP to display the new image
      });
    }
  }

  Future<void> _saveProfilePictureUrl(String url) async {
    User? user = _auth.currentUser;
    if (user != null && _email != null) {
      try {
        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .doc('UserTraveler')
            .collection('UserTraveler')
            .where('Email', isEqualTo: _email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentReference documentRef = querySnapshot.docs.first.reference;
          await documentRef.update({'ProfilePP': url}); // Save the URL in the ProfilePP field
        }
      } catch (e) {
        print('Error saving profile picture URL: $e');
      }
    }
  }

  Future<void> _saveUserData() async {
    User? user = _auth.currentUser;
    if (user != null && _email != null) {
      try {
        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .doc('UserTraveler')
            .collection('UserTraveler')
            .where('Email', isEqualTo: _email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentReference documentRef = querySnapshot.docs.first.reference;

          // Fetch the existing document data
          Map<String, dynamic> existingData = querySnapshot.docs.first.data() as Map<String, dynamic>;
          String existingId = existingData['Id'] ?? '';
          String existingProfilePP = existingData['ProfilePP'] ?? ''; // Get the existing ProfilePP

          await documentRef.update({
            'Address': _addressController.text,
            'Gender': _gender,
            'Dob': _dob != null ? Timestamp.fromDate(_dob!) : null,
            'Phone': _phoneController.text,
            'Country': _country,
            'Id': existingId,
            'Name': _name,
            'Email': _email,
            'ProfilePP': _profilePP ?? existingProfilePP, // Use new URL if available, otherwise use existing
          });

          await _loadUserData(); // Refresh data

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No document found for this email')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: $e')),
        );
      }
    } else {
      print('User is not authenticated or email is null');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User is not authenticated or email is null')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Management'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            GestureDetector(
              onTap: _selectProfilePicture,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profilePicture != null
                    ? FileImage(_profilePicture!)
                    : _profilePP != null && _profilePP!.isNotEmpty
                    ? NetworkImage(_profilePP!) // Load from Firestore if available
                    : AssetImage('images/istockphoto-1135563582-612x612.jpg') as ImageProvider,
              ),
            ),
            SizedBox(height: 16),

            // Name (Read-only)
            TextField(
              controller: TextEditingController(text: _name), // Display the retrieved name
              decoration: InputDecoration(labelText: 'Name'),
              readOnly: true, // Make it read-only
            ),
            SizedBox(height: 16),

            // Email (Read-only)
            TextField(
              controller: TextEditingController(text: _email), // Display the retrieved email
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              readOnly: true, // Make it read-only
            ),
            SizedBox(height: 16),

            // Address
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 16),

            // Gender Dropdown
            DropdownButton<String>(
              value: _gender != null && ['Male', 'Female', 'Other'].contains(_gender) ? _gender : null,
              hint: Text('Select Gender'),
              items: ['Male', 'Female', 'Other']
                  .map((gender) => DropdownMenuItem(
                value: gender,
                child: Text(gender),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _gender = value;
                });
              },
            ),
            SizedBox(height: 16),

            // Date of Birth Input
            TextField(
              controller: TextEditingController(
                text: _dob != null ? '${_dob!.day}/${_dob!.month}/${_dob!.year}' : '',
              ),
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                hintText: 'DD/MM/YYYY',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _dob ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null && pickedDate != _dob) {
                      setState(() {
                        _dob = pickedDate; // Update the date when a new one is selected
                      });
                    }
                  },
                ),
              ),
              readOnly: true, // Make it read-only to prevent manual editing
            ),
            SizedBox(height: 16),

            // Phone Number
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),

            // Country
            TextField(
              controller: TextEditingController(text: _country),
              decoration: InputDecoration(labelText: 'Country'),
              onChanged: (value) {
                _country = value; // Update country when changed
              },
            ),
            SizedBox(height: 30),

            // Save Button
            ElevatedButton(
              onPressed: _saveUserData,
              child: Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff1a5317), // Set the background color using hex code
                foregroundColor: Colors.white, // Set the text color to white
              ),
            ),




            SizedBox(height: 30)
          ],
        ),
      ),
    );
  }

}
