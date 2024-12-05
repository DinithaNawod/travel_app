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
  final TextEditingController _reviewController = TextEditingController();
  double _userRating = 0;

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
    _reviewController.dispose();
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

  // Function to submit review
  Future<void> submitReview() async {
    if (_reviewController.text.isEmpty || _userRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a review and rating')),
      );
      return;
    }

    await FirebaseFirestore.instance
        .collection('Packages')
        .doc(widget.packageId)
        .collection('reviews')
        .add({
      'userName': 'User', // You can replace it with the current user name
      'rating': _userRating,
      'reviewText': _reviewController.text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _reviewController.clear();
    setState(() {
      _userRating = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Review submitted successfully')),
    );
  }

  // Widget to build the reviews list
  Widget buildReviewList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Packages')
          .doc(widget.packageId)
          .collection('reviews')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No reviews available'));
        }

        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var review = snapshot.data!.docs[index];
            double rating = review['rating'] ?? 0;
            String reviewText = review['reviewText'] ?? '';
            String userName = review['userName'] ?? 'Anonymous';

            return ListTile(
              leading: Icon(Icons.person, size: 40.0),
              title: Text(userName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(5, (i) {
                      return Icon(
                        i < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      );
                    }),
                  ),
                  const SizedBox(height: 4.0),
                  Text(reviewText),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
        future: packagesCollection.doc(widget.packageId).get(),
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

          String packageName = packageData?['packageName'] ?? 'Unknown Package';
          String duration = packageData?['duration'] ?? 'Unknown Duration';
          String description = packageData?['description'] ?? 'No description available';
          String packageImage = packageData?['packageImage'] ?? '';
          String price = packageData?['price'] ?? '0';
          String inclusions = packageData?['includes'] ?? 'No inclusions available';
          String exclusions = packageData?['excludes'] ?? 'No exclusions available';

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Text(
                    packageName,
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    "Duration: $duration",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    description,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Color(0xff1a5317),
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10.0),
                        const Text(
                          'Inclusions',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 24.0,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          inclusions,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10.0),
                        const Text(
                          'Exclusions',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 24.0,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          exclusions,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  ElevatedButton(
                    onPressed: () => openCheckout(price),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff1a5317),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    ),
                    child: const Text(
                      'Proceed to Payment',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Divider(thickness: 2.0),
                  const SizedBox(height: 20.0),


                  const Text(
                    'Reviews & Ratings',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
                  ),
                  const SizedBox(height: 20.0),
                  buildReviewList(),
                  const SizedBox(height: 20.0),
                  Divider(thickness: 2.0),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Submit Your Review',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            _userRating = (index + 1).toDouble();
                          });
                        },
                        icon: Icon(
                          index < _userRating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 30.0,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: _reviewController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Write your review...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: submitReview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff1a5317),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    ),
                    child: const Text(
                      'Submit Review',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 40.0),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
