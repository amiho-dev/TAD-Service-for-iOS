import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/app_config.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _technicianId;
  String? _technicianName;
  String? _authToken;
  bool _isLoading = false;

  bool get isAuthenticated => _isAuthenticated;
  String? get technicianId => _technicianId;
  String? get technicianName => _technicianName;
  String? get authToken => _authToken;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _authToken = prefs.getString(AppConfig.userTokenKey);
      _technicianId = prefs.getString(AppConfig.technicianIdKey);
      _technicianName = prefs.getString('technician_name');
      
      _isAuthenticated = _authToken != null && _technicianId != null;
    } catch (e) {
      _isAuthenticated = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call for authentication
      await Future.delayed(const Duration(seconds: 2));

      // For demo purposes, accept any non-empty credentials
      if (username.isNotEmpty && password.isNotEmpty) {
        _authToken = 'demo_token_${DateTime.now().millisecondsSinceEpoch}';
        _technicianId = 'tech_001';
        _technicianName = username;
        _isAuthenticated = true;

        // Save to preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConfig.userTokenKey, _authToken!);
        await prefs.setString(AppConfig.technicianIdKey, _technicianId!);
        await prefs.setString('technician_name', _technicianName!);

        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('Login error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Clear preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConfig.userTokenKey);
      await prefs.remove(AppConfig.technicianIdKey);
      await prefs.remove('technician_name');

      // Clear state
      _authToken = null;
      _technicianId = null;
      _technicianName = null;
      _isAuthenticated = false;
    } catch (e) {
      debugPrint('Logout error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> refreshToken() async {
    if (_authToken == null) return false;

    try {
      // Simulate token refresh
      await Future.delayed(const Duration(seconds: 1));
      
      _authToken = 'refreshed_token_${DateTime.now().millisecondsSinceEpoch}';
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConfig.userTokenKey, _authToken!);
      
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Token refresh error: $e');
      await logout();
      return false;
    }
  }

  bool get isTokenExpired {
    // Simple token expiration check
    // In a real app, you would decode the JWT token and check its expiration
    return false;
  }
}
