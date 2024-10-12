import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PackageInfoPage extends StatefulWidget {
  final String packageId; // Pass the package ID to fetch details

  const PackageInfoPage({super.key, required this.packageId});

  @override
  _PackageInfoPageState createState() => _PackageInfoPageState();
}

class _PackageInfoPageState extends State<PackageInfoPage> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear(); // To avoid memory leaks
    super.dispose();
  }

  void openCheckout(String price) async {
    var options = {
      'key': 'YOUR_RAZORPAY_KEY', // Add your Razorpay API key here
      'amount': int.parse(price) * 100, // Razorpay works in paise (INR)
      'name': 'Your Company Name',
      'description': 'Booking for Package',
      'prefill': {'contact': '', 'email': ''}, // Optionally, prefill user details
      'external': {
        'wallets': ['paytm'] // External wallets, optional
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Payment Successful'),
          content: Text('Payment ID: ${response.paymentId}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Payment Failed'),
          content: Text('Error: ${response.message}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('External Wallet Selected'),
          content: Text('Wallet Name: ${response.walletName}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Firestore instance
    final CollectionReference packagesCollection = FirebaseFirestore.instance.collection('Packages');

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
      body: FutureBuilder<DocumentSnapshot>(
        future: packagesCollection.doc(widget.packageId).get(), // Fetch package data by ID
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading package data'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Package not found'));
          }

          var packageData = snapshot.data!.data() as Map<String, dynamic>?;

          // Retrieve Firestore fields
          String packageName = packageData?['packageName'] ?? 'Unknown Package';
          String duration = packageData?['duration'] ?? 'Unknown Duration';
          String description = packageData?['description'] ?? 'No description available';
          String packageImage = packageData?['packageImage'] ?? ''; // Use PackageImage field from Firestore
          String price = packageData?['price'] ?? '0'; // Price
          String inclusions = packageData?['includes'] ?? 'No inclusions available'; // Inclusions
          String exclusions = packageData?['excludes'] ?? 'No exclusions available'; // Exclusions

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Updated Package Image section
                  Container(
                    height: 240.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      image: DecorationImage(
                        image: packageImage.isNotEmpty
                            ? NetworkImage(packageImage)
                            : AssetImage('images/no-image.png') as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  // Package Name
                  Text(
                    packageName,
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  // Package Duration
                  Text(
                    "Duration: $duration",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  // Package Description
                  Text(
                    description,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 20.0),
                  // Price Tag
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      'Price: $price',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  // Inclusions
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 20.0, color: Colors.black),
                      children: [
                        TextSpan(
                          text: "Includes: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: inclusions), // Regular weight for data
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  // Exclusions
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 20.0, color: Colors.black),
                      children: [
                        TextSpan(
                          text: "Excludes: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: exclusions), // Regular weight for data
                      ],
                    ),
                  ),
                  const SizedBox(height: 60.0),
                  // Book Now Button aligned to center
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        openCheckout(price); // Open the payment gateway with the price
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff1a5317), // Background color
                        foregroundColor: Colors.white, // Text color
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0), // Padding for button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0), // Rounded corners
                        ),
                      ),
                      child: const Text("Book Now"),
                    ),
                  ),
                  const SizedBox(height: 80.0),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
