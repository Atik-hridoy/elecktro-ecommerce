import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TearmsAndConditionsView extends StatelessWidget {
  const TearmsAndConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        elevation: 4,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
        toolbarTextStyle: const TextStyle(
          color: Colors.black,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms and Conditions',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'By using our app, you agree to be bound by these Terms and Conditions. You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'We strive to provide accurate product information, but we do not guarantee its accuracy. All prices are subject to change and payment must be made in full before shipment. We aim to deliver products within the estimated timeframes but delays may occur.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Products can be returned within 30 days of delivery in original condition. Your use of our app is also governed by our Privacy Policy. All content on this app is the property of Elecktro E-commerce.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'We shall not be liable for any indirect or consequential damages. These terms are governed by the laws of the jurisdiction in which we operate. Last updated: January 15, 2024.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
