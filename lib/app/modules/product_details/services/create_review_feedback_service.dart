import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:elecktro_ecommerce/app/core/network/app_urls.dart';
import 'package:elecktro_ecommerce/app/core/stroage/storage_services.dart';
import 'package:elecktro_ecommerce/app/core/util/app_logger.dart';
import '../models/create_review_model.dart';

class CreateReviewFeedbackService {
  static const String _tag = 'CreateReviewFeedbackService';

  Future<CreateReviewResponse?> createReview({
    required String productId,
    required String comment,
    required int rating,
    List<File>? images,
  }) async {
    try {
      // Get token
      await LocalStorage.getAllPrefData();
      final token = LocalStorage.token;

      if (token.isEmpty) {
        AppLogger.error('No authentication token found', tag: _tag);
        throw Exception('Authentication required');
      }

      final url = Uri.parse('${AppUrls.baseUrl}${AppUrls.postReviewFeedback}');

      // If no images, send as JSON
      if (images == null || images.isEmpty) {
        final response = await http.post(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'productId': productId,
            'comment': comment,
            'rating': rating, // Send as number
          }),
        );

        final responseData = json.decode(response.body);

        AppLogger.apiResponse(
          method: 'POST',
          endpoint: url.toString(),
          statusCode: response.statusCode,
          responseData: responseData,
          response: response,
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          AppLogger.success('Review created successfully', tag: _tag);
          return CreateReviewResponse.fromJson(responseData);
        } else {
          final errorMsg = responseData['message'] ?? 'Failed to create review';
          AppLogger.error(errorMsg, tag: _tag);
          throw Exception(errorMsg);
        }
      }

      // If images exist, send as multipart with proper data field
      final request = http.MultipartRequest('POST', url);

      // Add headers
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // Add data as JSON string in a field called 'data'
      request.fields['data'] = json.encode({
        'productId': productId,
        'comment': comment,
        'rating': rating, // Number in JSON
      });

      // Add images
      for (var image in images) {
        final fileStream = http.ByteStream(image.openRead());
        final fileLength = await image.length();
        final multipartFile = http.MultipartFile(
          'images',
          fileStream,
          fileLength,
          filename: image.path.split('/').last,
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);
      }

      AppLogger.apiRequest(
        method: 'POST',
        endpoint: url.toString(),
        body: {
          'productId': productId,
          'comment': comment,
          'rating': rating,
          'images': images.length,
        },
      );

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final responseData = json.decode(response.body);

      AppLogger.apiResponse(
        method: 'POST',
        endpoint: url.toString(),
        statusCode: response.statusCode,
        responseData: responseData,
        response: response,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        AppLogger.success('Review created successfully', tag: _tag);
        return CreateReviewResponse.fromJson(responseData);
      } else {
        final errorMsg = responseData['message'] ?? 'Failed to create review';
        AppLogger.error(errorMsg, tag: _tag);
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to create review: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
