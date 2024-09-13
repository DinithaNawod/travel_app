import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to count the number of users in the collection
  Future<int> getUserCount() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error getting user count: $e');
      return 0; // Return 0 if there is an error
    }
  }

  // Method to add user details to the database using userId as the document ID
  Future<void> addUserDetails(Map<String, dynamic> userInfo, String userId) async {
    try {
      // Add user details with the userId as the document ID
      await _firestore.collection('users').doc(userId).set(userInfo);
    } catch (e) {
      print('Error adding user details: $e');
    }
  }

  // Method to get user details by email field inside the document
  Future<QuerySnapshot> getUserDetailsByEmail(String email) async {
    try {
      return await _firestore.collection('users')
          .where('Email', isEqualTo: email) // Use the 'Email' field for querying
          .get();
    } catch (e) {
      print('Error fetching user details: $e');
      rethrow;
    }
  }
}