import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppError {
  final String message;
  final dynamic error;

  const AppError({this.message = 'An unexpected error occurred', this.error});

  factory AppError.network(String message) => AppError(message: message);

  factory AppError.fromDioError(dynamic error) {
    if (error.toString().contains('SocketException')) {
      return AppError.network('No internet connection');
    }
    return AppError(message: error.toString());
  }

  @override
  String toString() => 'AppError(message: $message)';
}

class ErrorView extends StatelessWidget {
  final AppError error;
  final VoidCallback? onRetry;

  const ErrorView({super.key, required this.error, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/onboarding/error.svg',
            width: 120,
            height: 120,
          ),
          const SizedBox(height: 16),
          Text('Error', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            error.message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ],
      ),
    );
  }
}
