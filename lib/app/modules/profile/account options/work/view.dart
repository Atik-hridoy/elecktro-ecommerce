import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkView extends StatelessWidget {
  const WorkView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'At Westfert, we value your trust and are committed to protecting your personal information. This Privacy Policy outlines how we collect, use, and safeguard your data when you use our app and services.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'When you sign up for Westfert, we may collect personal details such as your name, email address, phone number, payment information (securely processed via Square or a similar service), and location data (to match you with nearby barbers). We may also collect non-identifiable data like device type and operating system, app usage data, and IP address.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'We use your information to provide and improve our services, match you with barbers based on your location and preferences, process secure payments, send notifications about bookings, updates, or promotions, and improve user experience through analytics.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'We respect your privacy and only share your data in limited circumstances: with barbers to facilitate bookings, with payment processors for secure transactions, and for legal reasons when required by law. We do not sell your personal information to third parties.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'We take the security of your information seriously. We use encryption, secure servers, and regular monitoring to protect your data from unauthorized access. However, no method of transmission over the internet is 100% secure, so we encourage you to take precautions when sharing sensitive information.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'You can update your profile information through the app at any time, disable location services in your device settings (though this may limit certain app features), and opt-out of promotional emails by clicking "unsubscribe" at the bottom of the email.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'BarberMe may include links to third-party websites or services. We are not responsible for the privacy practices of those third parties. We recommend reviewing their policies before sharing any personal information. BarberMe is not intended for children under 13. We do not knowingly collect information from children.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'We may update this Privacy Policy from time to time. Any changes will be posted here with the updated effective date. We encourage you to review this page regularly. If you have any questions about this Privacy Policy or how we handle your data, please contact us at: privacy@barberme.com',
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
