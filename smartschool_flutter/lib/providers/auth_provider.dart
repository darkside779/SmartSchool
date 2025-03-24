import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:smartschool_flutter/core/utils/user_roles.dart';
import '../core/services/auth_service.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
 
class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  User? _userData;
  String? _token;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  AuthProvider(this._authService) {
    _initializeAuth();
  }

  User? get userData => _userData;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  UserRole? get userRole {
    if (_userData == null) return null;
    
    switch (_userData!.userType.toLowerCase()) {
      case 'super_admin':
        return UserRole.super_admin;
      case 'admin':
        return UserRole.admin;
      case 'teacher':
        return UserRole.teacher;
      case 'parent':
        return UserRole.parent;
      case 'student':
        return UserRole.student;
      default:
        return null;
    }
  }

  Future<void> _initializeAuth() async {
    try {
      _setLoading(true);
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('auth_token');
      final userDataString = prefs.getString('user_data');
      
      if (_token != null && userDataString != null) {
        _userData = User.fromJson(jsonDecode(userDataString));
        _isAuthenticated = true;
      }
    } catch (e) {
      debugPrint('Error initializing auth: $e');
      await logout();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      _setLoading(true);
      _error = null;

      debugPrint('🔄 Attempting login for email: $email');
      final response = await _authService.login(email, password);
      debugPrint('✅ Login response success: ${response.success}');
      
      if (response.success && response.token != null && response.userData != null) {
        _token = response.token;
        _userData = User.fromJson(response.userData!);
        _isAuthenticated = true;

        debugPrint('👤 User data: ${response.userData}');
        debugPrint('🔑 User type: ${_userData?.userType}');
        debugPrint('👑 User role: $userRole');
        debugPrint('✅ Is parent: ${_userData?.isParent}');

        // Save to SharedPreferences and set token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
        await prefs.setString('user_data', jsonEncode(response.userData));
        await _authService.setAuthToken(_token!);

        notifyListeners();
        return true;
      } else {
        _error = response.message ?? 'Login failed';
        debugPrint('❌ Login error: $_error');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Login exception: $e');
      _error = 'Login failed: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      _setLoading(true);
      if (_token != null) {
        await _authService.logout(_token!);
      }
      
      // Clear stored data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');
      
      // Reset state
      _token = null;
      _userData = null;
      _isAuthenticated = false;
      _setError(null);
      
    } catch (e) {
      _setError('Logout failed: $e');
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _setError(null);
  }

  String getInitialRoute() {
    if (!_isAuthenticated) return '/login';
    
    if (_userData == null) return '/login';

    if (_userData!.isAdmin) return '/admin/dashboard';
    if (_userData!.isTeacher) return '/teacher/dashboard';
    if (_userData!.isParent) return '/parent/dashboard';
    if (_userData!.isStudent) return '/student/dashboard';
    
    return '/login';
  }
}
