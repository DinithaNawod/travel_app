import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Color(0xff1a5317), // Customize your app bar color
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms and Conditions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Last Updated: 2022.12.05',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
            Divider(height: 32, thickness: 1.5),

            // Section 1
            _buildSection(
              '1. Acceptance of Terms',
              'By accessing or using this app, you agree to be bound by these Terms and Conditions. If you do not agree, please discontinue use of the app.',
            ),

            // Section 2
            _buildSection(
              '2. Use of the App',
              'You must be at least 18 years old or have parental consent to use the app. You agree to use the app for lawful purposes only.',
            ),

            // Section 3
            _buildSection(
              '3. Booking and Payments',
              'All bookings and payments are subject to the terms of the respective service providers. We are not responsible for cancellations, refunds, or disputes with service providers.',
            ),

            // Section 4
            _buildSection(
              '4. User-Generated Content',
              'Users may submit reviews, feedback, and other content. Offensive or inappropriate content may be removed.',
            ),

            // Section 5
            _buildSection(
              '5. Privacy',
              'Your personal information is protected under our Privacy Policy. By using the app, you consent to the collection and use of your data as outlined in the policy.',
            ),

            // Section 6
            _buildSection(
              '6. Limitations of Liability',
              'This app is a platform to assist with travel planning. We are not liable for errors, omissions, or third-party services. Use the app at your own risk.',
            ),

            // Section 7
            _buildSection(
              '7. Modifications to Terms',
              'We reserve the right to update these Terms and Conditions at any time. Significant changes will be communicated via the app or email.',
            ),

            // Contact Section
            SizedBox(height: 24),
            Text(
              'Contact Us',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'If you have any questions about these Terms and Conditions, please contact us at:',
            ),
            SizedBox(height: 8),
            Text(
              'Email: islandhevan@gmail.com\nPhone: +94 740586120',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(content, style: TextStyle(fontSize: 16)),
        SizedBox(height: 16),
      ],
    );
  }
}
