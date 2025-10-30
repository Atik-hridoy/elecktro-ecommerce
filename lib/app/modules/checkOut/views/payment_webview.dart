import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentWebView extends StatefulWidget {
  const PaymentWebView({super.key});

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late InAppWebViewController webViewController;
  late String checkoutUrl;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    // Get the checkout URL from arguments
    final args = Get.arguments;
    checkoutUrl = args != null && args['url'] != null
        ? args['url'] as String
        : '';
    
    if (checkoutUrl.isEmpty) {
      hasError = true;
      Get.back();
      Get.snackbar(
        'Error',
        'Invalid payment URL',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Payment Error'),
          backgroundColor: Colors.red,
        ),
        body: const Center(child: Text('Unable to load payment page')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.green,
        actions: [
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator(color: Colors.white)),
            ),
        ],
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(checkoutUrl)),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onLoadStart: (controller, url) {
              setState(() => isLoading = true);
              _handleUrlChange(url?.toString() ?? '');
            },
            onLoadStop: (controller, url) async {
              setState(() => isLoading = false);
              _handleUrlChange(url?.toString() ?? '');
            },
            onLoadError: (controller, url, code, message) {
              setState(() {
                isLoading = false;
                hasError = true;
              });
              Get.snackbar(
                'Error',
                'Failed to load payment page: $message',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            },
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  void _handleUrlChange(String url) {
    if (url.isEmpty) return;
    
    // Handle Stripe success/cancel URLs
    if (url.contains('success') || 
        url.contains('checkout.stripe.com/success') ||
        url.contains('/api/v1/orders/success')) {
      // Close WebView and show success message
      Get.back();
      Get.offAllNamed('/home'); // Navigate to home screen and remove all previous routes
      Get.snackbar(
        'Payment Successful',
        'Your payment was processed successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
      return; // Exit after handling success
    } 
    
    if (url.contains('cancel') || url.contains('checkout.stripe.com/cancel')) {
      // Close WebView and show cancel message
      Get.back();
      Get.snackbar(
        'Payment Cancelled',
        'Your payment was cancelled.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return; // Exit after handling cancel
    }
    
    // Handle deep links or other URL patterns as needed
    if (url.startsWith('http') && !url.contains('checkout.stripe.com')) {
      // Handle other URLs (like 3D Secure) by opening in external browser
      final uri = Uri.tryParse(url);
      if (uri != null) {
        launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }
}
