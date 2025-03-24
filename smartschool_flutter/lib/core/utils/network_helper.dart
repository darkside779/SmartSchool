// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/api_constants.dart';
import 'secure_storage.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;
  
  ApiException(this.message, [this.statusCode, this.errors]);
  
  @override
  String toString() => 'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class NetworkHelper {
  Future<Map<String, String>> _getHeaders() async {
    final token = await SecureStorage.getToken();
    return {
      ...ApiConstants.headers,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> _handleResponse(http.Response response) async {
    print('API Response Status Code: ${response.statusCode}');
    print('API Response Body: ${response.body}');

    try {
      final body = json.decode(response.body);
      
      switch (response.statusCode) {
        case 200:
        case 201:
          return body;
          
        case 401:
          // Handle unauthorized access
          await SecureStorage.clearAuthData();
          throw ApiException(
            body['message'] ?? 'Unauthorized access. Please login again.',
            401,
            body['errors'] as Map<String, dynamic>?,
          );
          
        case 403:
          throw ApiException(
            body['message'] ?? 'Access forbidden. Insufficient permissions.',
            403,
            body['errors'] as Map<String, dynamic>?,
          );
          
        case 404:
          throw ApiException(
            body['message'] ?? 'Resource not found.',
            404,
            body['errors'] as Map<String, dynamic>?,
          );
          
        case 422:
          // Validation errors
          throw ApiException(
            body['message'] ?? 'Validation failed',
            422,
            body['errors'] as Map<String, dynamic>?,
          );
          
        case 500:
          throw ApiException(
            body['message'] ?? 'Internal server error.',
            500,
          );
          
        default:
          throw ApiException(
            body['message'] ?? 'Request failed with status: ${response.statusCode}',
            response.statusCode,
            body['errors'] as Map<String, dynamic>?,
          );
      }
    } on FormatException catch (e) {
      print('Error parsing response: $e');
      print('Response body: ${response.body}');
      throw ApiException(
        'Invalid response format from server',
        response.statusCode,
      );
    }
  }

  Future<dynamic> getData(String endpoint, {Map<String, String>? queryParams}) async {
    try {
      print('GET Request to: ${ApiConstants.baseUrl + endpoint}');
      final headers = await _getHeaders();
      final uri = Uri.parse(ApiConstants.baseUrl + endpoint).replace(
        queryParameters: queryParams,
      );
      
      final response = await http.get(uri, headers: headers);
      return _handleResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<dynamic> postData(String endpoint, Map<String, dynamic> data) async {
    try {
      print('POST Request to: ${ApiConstants.baseUrl + endpoint}');
      print('Request body: $data');
      
      final headers = await _getHeaders();
      final uri = Uri.parse(ApiConstants.baseUrl + endpoint);
      
      final response = await http.post(
        uri,
        headers: headers,
        body: json.encode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<dynamic> putData(String endpoint, Map<String, dynamic> data) async {
    try {
      print('PUT Request to: ${ApiConstants.baseUrl + endpoint}');
      print('Request body: $data');
      
      final headers = await _getHeaders();
      final uri = Uri.parse(ApiConstants.baseUrl + endpoint);
      
      final response = await http.put(
        uri,
        headers: headers,
        body: json.encode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<dynamic> deleteData(String endpoint) async {
    try {
      print('DELETE Request to: ${ApiConstants.baseUrl + endpoint}');
      
      final headers = await _getHeaders();
      final uri = Uri.parse(ApiConstants.baseUrl + endpoint);
      
      final response = await http.delete(uri, headers: headers);
      return _handleResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<dynamic> uploadFile(String endpoint, List<int> fileBytes, String fileName) async {
    try {
      print('File Upload Request to: ${ApiConstants.baseUrl + endpoint}');
      
      final headers = await _getHeaders();
      final uri = Uri.parse(ApiConstants.baseUrl + endpoint);
      
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll(headers);
      
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: fileName,
        ),
      );
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      return _handleResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('File upload error: ${e.toString()}');
    }
  }
}
