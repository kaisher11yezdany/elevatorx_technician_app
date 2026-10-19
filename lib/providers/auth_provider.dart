import 'package:flutter/foundation.dart';
import '../models/technician_model.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService;

  AuthProvider(this._apiService);

  Technician? _technician;
  String? _token;
  bool _isLoading = false;
  String? _error;

  Technician? get technician => _technician;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _token != null && _technician != null;

  Future<bool> loginWithPhone(String phone, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.loginWithPhone(phone, password);
      _technician = response.technician;
      _token = response.token;
      _apiService.setToken(response.token);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> sendOtp(String phone) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.sendOtp(phone);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> loginWithOtp(String phone, String otp) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.loginWithOtp(phone, otp);
      _technician = response.technician;
      _token = response.token;
      _apiService.setToken(response.token);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _apiService.logout();
    _technician = null;
    _token = null;
    _error = null;
    notifyListeners();
  }

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      _technician = await _apiService.getTechnicianProfile();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile(String name, String phone) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _technician = await _apiService.updateTechnicianProfile({
        'name': name,
        'phone': phone,
      });
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
