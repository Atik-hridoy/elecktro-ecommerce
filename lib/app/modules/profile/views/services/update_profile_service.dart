import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:elecktro_ecommerce/app/core/network/app_urls.dart';
import 'package:elecktro_ecommerce/app/core/stroage/storage_services.dart';
import 'package:elecktro_ecommerce/app/core/stroage/storage_keys.dart';
import 'package:elecktro_ecommerce/app/core/util/app_logger.dart';
import '../model/update_profile_model.dart';

class UpdateProfileService {
  // Singleton pattern
  static final UpdateProfileService _instance = UpdateProfileService._internal();
  factory UpdateProfileService() => _instance;
  UpdateProfileService._internal();

  // Update user profile with form data using UpdateProfileModel
  Future<Map<String, dynamic>> updateProfile({
    required UpdateProfileModelInsideApp profileData,
    File? profileImage,
  }) async {
    const String tag = 'UpdateProfileService';
    
    try {
      // Log start of API call
      AppLogger.apiRequest(
        method: 'PATCH',
        endpoint: '${AppUrls.baseUrl}${AppUrls.updateProfileInsideApp}',
        body: profileData.toJson(),
      );

      // Get the access token from local storage
      await LocalStorage.getAllPrefData();
      final token = LocalStorage.token;

      if (token.isEmpty) {
        final error = 'No authentication token found';
        AppLogger.error(error, tag: tag);
        throw Exception(error);
      }

      // Create multipart request
      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse('${AppUrls.baseUrl}${AppUrls.updateProfileInsideApp}'),
      );

      // Add headers
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // Add profile data to request
      final profileJson = profileData.toJson();
      final fields = Map<String, String>.from(
        profileJson.map((key, value) => MapEntry(key, value.toString())),
      );
      request.fields.addAll(fields);
      
      // Log request fields
      AppLogger.debug(
        'Request fields',
        tag: tag,
        details: fields,
      );
      
      if (profileImage != null) {
        AppLogger.debug(
          'Including profile image',
          tag: tag,
          details: {'path': profileImage.path},
        );
      }

      // Add profile image if provided
      if (profileImage != null) {
        var stream = http.ByteStream(profileImage.openRead());
        var length = await profileImage.length();
        
        var multipartFile = http.MultipartFile(
          'profile_image', // This should match your API's expected field name
          stream,
          length,
          filename: basename(profileImage.path),
          contentType: MediaType('image', 'jpeg'), // Adjust based on your image type
        );
        
        request.files.add(multipartFile);
      }

      // Send the request
      final startTime = DateTime.now();
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      final duration = DateTime.now().difference(startTime);

      final responseData = json.decode(response.body);

    
      AppLogger.apiResponse(
        method: 'PATCH',
        endpoint: '${AppUrls.baseUrl}${AppUrls.updateProfileInsideApp}',
        statusCode: response.statusCode,
        responseData: responseData,
        response: response,
        duration: duration,
      );
      
      if (kDebugMode) {
        // Pretty print the response in debug mode
        final prettyResponse = JsonEncoder.withIndent('  ').convert(responseData);
        if (kDebugMode) {
          print('Response body:');
          print(prettyResponse);
        }
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        AppLogger.success(
          'Profile updated successfully',
          tag: tag,
        );
        // Update local storage with the new profile data
        if (profileData.firstName.isNotEmpty) {
          await LocalStorage.preferences?.setString(
            LocalStorageKeys.myName, 
            '${profileData.firstName} ${profileData.lastName}'.trim()
          );
          LocalStorage.myName = '${profileData.firstName} ${profileData.lastName}'.trim();
        }
        if (profileImage != null) {
          // You might want to store the image URL here if your API returns it
          // For now, we're just updating the local path
          await LocalStorage.preferences?.setString(LocalStorageKeys.myImage, profileImage.path);
          LocalStorage.myImage = profileImage.path;
        }
        
        return {
          'success': true,
          'message': 'Profile updated successfully',
          'data': responseData,
        };
      } else {
        final errorMessage = 'Failed to update profile: ${responseData['message'] ?? 'Unknown error'}';
        AppLogger.error(
          errorMessage,
          tag: tag,
          error: responseData,
        );
        throw Exception(errorMessage);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to update profile: $e',
        tag: tag,
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}