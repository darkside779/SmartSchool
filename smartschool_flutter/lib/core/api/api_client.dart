import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smartschool_flutter/core/config/api_config.dart';
import '../../models/student_record.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();
  String? _authToken;

  ApiClient({required ApiConfig apiConfig}) {
    _dio.options.baseUrl = apiConfig.baseUrl;
    debugPrint('🌐 API Base URL: ${_dio.options.baseUrl}');
    _setupInterceptors();
  }

  String? get authToken => _authToken;

  Future<void> setAuthToken(String token) async {
    debugPrint('🔐 Setting auth token: $token');
    _authToken = token;
    await _storage.write(key: 'auth_token', value: token);
    debugPrint('✅ Token saved to storage');
  }

  void _setupInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (_authToken != null) {
          debugPrint('🔐 Adding token to request: $_authToken');
          options.headers['Authorization'] = 'Bearer $_authToken';
        } else {
          final token = await _storage.read(key: 'auth_token');
          debugPrint('🔐 Token from storage: $token');
          if (token != null) {
            _authToken = token;
            options.headers['Authorization'] = 'Bearer $token';
            debugPrint('✅ Using stored token');
          } else {
            debugPrint('⚠️ No auth token found!');
          }
        }
        debugPrint('📤 Request Headers: ${options.headers}');
        debugPrint('🌐 Making ${options.method} request to: ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint('📥 Response Status: ${response.statusCode}');
        debugPrint('📦 Response Data: ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        debugPrint('❌ API Error: ${e.message}');
        debugPrint('🔍 Error Response: ${e.response?.data}');
        debugPrint('🌐 Failed URL: ${e.requestOptions.path}');
        if (e.response?.statusCode == 401) {
          debugPrint('🔒 Unauthorized - Clearing token');
          await _storage.delete(key: 'auth_token');
          _authToken = null;
        }
        return handler.next(e);
      }
    ));
  }

  Future<Response> get(String path) async {
    try {
      debugPrint('🔄 Making GET request to: $path');
      final response = await _dio.get(path);
      debugPrint('✅ GET request successful');
      return response;
    } catch (e) {
      debugPrint('❌ GET request failed: $e');
      rethrow;
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      debugPrint('🔄 Making POST request to: $path');
      debugPrint('📦 POST data: $data');
      final response = await _dio.post(path, data: data);
      debugPrint('✅ POST request successful');
      return response;
    } catch (e) {
      debugPrint('❌ POST request failed: $e');
      rethrow;
    }
  }

  Future<List<StudentRecord>> fetchChildren() async {
    try {
      debugPrint('🔄 Fetching children...');
      debugPrint('🔐 Using token: $_authToken');
      debugPrint('🌐 URL: ${_dio.options.baseUrl}/parent/children');
      
      final response = await _dio.get('/parent/children');
      debugPrint('📥 Response Status Code: ${response.statusCode}');
      debugPrint('📥 Response Headers: ${response.headers}');
      debugPrint('📥 Response Data: ${response.data}');
      
      if (response.statusCode == 200) {
        final data = response.data;
        debugPrint('📦 Response status: ${data['status']}');
        debugPrint('📦 Response message: ${data['message']}');
        debugPrint('📦 Response data: ${data['data']}');
        
        if (data['status'] == true && data['data'] != null) {
          final List<dynamic> childrenData = data['data'] as List;
          debugPrint('📦 Parsing ${childrenData.length} children records');
          
          final children = childrenData.map((json) {
            try {
              debugPrint('🔍 Parsing child record: $json');
              return StudentRecord.fromJson(json);
            } catch (e) {
              debugPrint('❌ Error parsing child record: $e');
              debugPrint('🔍 Problematic JSON: $json');
              rethrow;
            }
          }).toList();
          
          debugPrint('✅ Successfully parsed ${children.length} children');
          return children;
        } else {
          final error = data['message'] ?? 'Failed to load children';
          debugPrint('❌ API returned error: $error');
          throw Exception(error);
        }
      }
      final error = 'Failed to load children: ${response.statusCode}';
      debugPrint('❌ $error');
      throw Exception(error);
    } catch (e) {
      debugPrint('❌ Error in fetchChildren: $e');
      if (e is DioException) {
        debugPrint('🔍 DioError type: ${e.type}');
        debugPrint('🔍 DioError message: ${e.message}');
        debugPrint('🔍 DioError response: ${e.response?.data}');
      }
      rethrow;
    }
  }
}
