import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smartschool_flutter/core/api/api_client.dart';
import '../config/api_config.dart';

class AuthResponse {
  final bool success;
  final String? message;
  final String? token;
  final Map<String, dynamic>? userData;

  AuthResponse({
    required this.success,
    this.message,
    this.token,
    this.userData,
  });
}

class AuthService {
  final ApiConfig _apiConfig;
  final ApiClient _apiClient;

  AuthService(this._apiConfig, this._apiClient);

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Future<void> setAuthToken(String token) async {
    await _apiClient.setAuthToken(token);
  }

  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${_apiConfig.baseUrl}/login'),
        headers: _headers,
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      final Map<String, dynamic> data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        return AuthResponse(
          success: true,
          token: data['token'],
          userData: data['user'],
        );
      } else {
        return AuthResponse(
          success: false,
          message: data['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Network error: $e',
      );
    }
  }

  Future<bool> logout(String token) async {
    try {
      final response = await http.post(
        Uri.parse('${_apiConfig.baseUrl}/logout'),
        headers: {
          ..._headers,
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<AuthResponse> checkAuthStatus(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${_apiConfig.baseUrl}/user'),
        headers: {
          ..._headers,
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return AuthResponse(
          success: true,
          userData: data['user'],
        );
      } else {
        return AuthResponse(
          success: false,
          message: 'Failed to verify authentication',
        );
      }
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Network error: $e',
      );
    }
  }
}
