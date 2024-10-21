import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to count the number of travelers in the collection
  Future<int> getTravelerCount() async {
    try {
      // Get the count of documents in the 'users/UserTraveler/UserTraveler' collection
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc('UserTraveler')
          .collection('UserTraveler')
          .get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error getting traveler count: $e');
      return 0; // Return 0 if there is an error
    }
  }

  // Method to add traveler details to the database using a sequential Traveler ID as the document ID
  Future<void> addTravelerDetails(Map<String, dynamic> travelerInfo) async {
    try {
      // Get the current count of travelers to create the new sequential ID
      int travelerCount = await getTravelerCount();
      String travelerId = 'Traveler ${travelerCount + 1}'.padLeft(2, '0'); // Creates 'Traveler 01', 'Traveler 02', etc.

      // Add traveler details with the travelerId as the document ID in Firestore
      travelerInfo['Id'] = travelerId; // Set 'Id' field as the document ID
      await _firestore
          .collection('users')
          .doc('UserTraveler')
          .collection('UserTraveler')
          .doc(travelerId)
          .set(travelerInfo);
    } catch (e) {
      print('Error adding traveler details: $e');
      rethrow; // Re-throw the error for handling by the caller if needed
    }
  }

  // Method to get traveler details by email
  Future<QuerySnapshot> getTravelerDetailsByEmail(String email) async {
    try {
      // Query the 'UserTraveler' collection where the 'Email' field matches the given email
      return await _firestore
          .collection('users')
          .doc('UserTraveler')
          .collection('UserTraveler')
          .where('Email', isEqualTo: email)
          .get();
    } catch (e) {
      print('Error fetching traveler details: $e');
      rethrow; // Re-throw the error for handling by the caller
    }
  }

  // Method to update traveler details for a specific travelerId
  Future<void> updateTravelerDetails(String travelerId, Map<String, dynamic> updatedInfo) async {
    try {
      // Update traveler details for the given document (travelerId) in Firestore
      await _firestore
          .collection('users')
          .doc('UserTraveler')
          .collection('UserTraveler')
          .doc(travelerId)
          .update(updatedInfo);
    } catch (e) {
      print('Error updating traveler details: $e');
      rethrow;
    }
  }

  // Method to delete a traveler by travelerId
  Future<void> deleteTraveler(String travelerId) async {
    try {
      // Delete the document corresponding to the given travelerId from the Firestore collection
      await _firestore
          .collection('users')
          .doc('UserTraveler')
          .collection('UserTraveler')
          .doc(travelerId)
          .delete();
    } catch (e) {
      print('Error deleting traveler: $e');
      rethrow;
    }
  }

  // Method to retrieve all travelers from the Firestore database
  Future<List<QueryDocumentSnapshot>> getAllTravelers() async {
    try {
      // Fetch all travelers from the 'UserTraveler' collection
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc('UserTraveler')
          .collection('UserTraveler')
          .get();
      return snapshot.docs;
    } catch (e) {
      print('Error retrieving all travelers: $e');
      rethrow;
    }
  }
}
