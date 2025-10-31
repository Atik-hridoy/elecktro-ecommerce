import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
// Add this at the top of the file
import 'package:flutter/foundation.dart' show kDebugMode;

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
            initialUrlRequest: URLRequest(
              url: WebUri(checkoutUrl),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                useShouldOverrideUrlLoading: true,
                mediaPlaybackRequiresUserGesture: false,
                javaScriptEnabled: true,
              ),
              android: AndroidInAppWebViewOptions(
                useHybridComposition: true,
                allowContentAccess: true,
                builtInZoomControls: false,
                thirdPartyCookiesEnabled: true,
                useWideViewPort: true,
                loadWithOverviewMode: true,
                safeBrowsingEnabled: true,
                mixedContentMode: AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
              ),
            ),
            onWebViewCreated: (controller) {
              webViewController = controller;
              if (kDebugMode) {
                print('WebView created, loading URL: $checkoutUrl');
              }
            },
            onLoadStart: (controller, url) {
              if (kDebugMode) {
                print('WebView load started: $url');
              }
              setState(() => isLoading = true);
              _handleUrlChange(url?.toString() ?? '');
            },
            onLoadStop: (controller, url) async {
              if (kDebugMode) {
                print('WebView load finished: $url');
              }
              setState(() => isLoading = false);
              _handleUrlChange(url?.toString() ?? '');
            },
            onLoadError: (controller, url, code, message) {
              if (kDebugMode) {
                print('WebView load error: $code, $message, URL: $url');
              }
              setState(() {
                isLoading = false;
                hasError = true;
              });
              
              // Don't show error if we're already handling the URL change
              if (url?.toString().contains('success') == true || 
                  url?.toString().contains('cancel') == true) {
                return;
              }
              
              Get.snackbar(
                'Error',
                'Failed to load payment page: ${message ?? 'Unknown error'}. Please check your internet connection and try again.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
                duration: const Duration(seconds: 5),
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

  Future<void> _handleUrlChange(String url) async {
    if (url.isEmpty) return;
    
    if (kDebugMode) {
      print('Handling URL change: $url');
    }
    
    // Handle success URLs
    if (url.contains('success') || 
        url.contains('checkout.stripe.com/success') ||
        url.contains('/api/v1/orders/success')) {
      if (kDebugMode) {
        print('Payment success detected, processing...');
      }
      
      // Close WebView first
      if (mounted) {
        Get.back();
        
        // Add a small delay to ensure smooth navigation
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Navigate to home and show success message
        Get.offAllNamed('/home');
        
        Get.snackbar(
          'Payment Successful',
          'Your payment was processed successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return;
    } 
    
    // Handle cancel URLs
    if (url.contains('cancel') || url.contains('checkout.stripe.com/cancel')) {
      if (kDebugMode) {
        print('Payment cancelled by user');
      }
      
      if (mounted) {
        Get.back();
        
        Get.snackbar(
          'Payment Cancelled',
          'Your payment was cancelled.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return;
    }
    
    // Handle other HTTP URLs (like 3D Secure) by opening in external browser
    if (url.startsWith('http') && !url.contains('checkout.stripe.com')) {
      if (kDebugMode) {
        print('Opening external URL: $url');
      }
      
      try {
        final uri = Uri.tryParse(url);
        if (uri != null) {
          await launchUrl(
            uri, 
            mode: LaunchMode.externalApplication,
            webViewConfiguration: const WebViewConfiguration(
              enableJavaScript: true,
              enableDomStorage: true,
            ),
          );
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error launching URL: $e');
        }
      }
    }
  }
}
