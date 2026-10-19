import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';
import '../models/technician_model.dart';
import '../models/job_model.dart';
import '../models/service_report_model.dart';

class ApiService {
  late Dio _dio;
  String? _token;

  ApiService() {
    _initDio();
    _loadToken();
  }

  void _initDio() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_token != null) {
          options.headers['Authorization'] = 'Bearer $_token';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          _token = null;
        }
        return handler.next(error);
      },
    ));
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('tech_token');
  }

  void setToken(String token) {
    _token = token;
  }

  // Auth endpoints
  Future<AuthResponse> loginWithPhone(String phone, String password) async {
    try {
      final response = await _dio.post('/technicians/login', data: {
        'phone': phone,
        'password': password,
      });
      final authResponse = AuthResponse.fromJson(response.data);
      await _saveToken(authResponse.token);
      return authResponse;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<AuthResponse> loginWithOtp(String phone, String otp) async {
    try {
      final response = await _dio.post('/technicians/login-otp', data: {
        'phone': phone,
        'otp': otp,
      });
      final authResponse = AuthResponse.fromJson(response.data);
      await _saveToken(authResponse.token);
      return authResponse;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> sendOtp(String phone) async {
    try {
      await _dio.post('/technicians/send-otp', data: {'phone': phone});
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/technicians/logout');
      _token = null;
      await _clearToken();
    } catch (e) {
      _token = null;
      await _clearToken();
    }
  }

  // Technician endpoints
  Future<Technician> getTechnicianProfile() async {
    try {
      final response = await _dio.get('/technicians/me');
      return Technician.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Technician> updateTechnicianProfile(Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/technicians/me', data: data);
      return Technician.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Job endpoints
  Future<List<Job>> getTechnicianJobs() async {
    try {
      final response = await _dio.get('/jobs/technician');
      final jobs = (response.data as List).map((job) => Job.fromJson(job)).toList();
      return jobs;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Job> getJobDetail(String jobId) async {
    try {
      final response = await _dio.get('/jobs/$jobId');
      return Job.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> acceptJob(String jobId) async {
    try {
      await _dio.put('/jobs/$jobId/accept');
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> updateJobStatus(String jobId, String status) async {
    try {
      await _dio.put('/jobs/$jobId/status', data: {'status': status});
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Service Report endpoints
  Future<ServiceReport> createServiceReport(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/service-reports', data: data);
      return ServiceReport.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<ServiceReport> submitServiceReport(String reportId, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/service-reports/$reportId/submit', data: data);
      return ServiceReport.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<ServiceReport>> getTechnicianReports() async {
    try {
      final response = await _dio.get('/service-reports/technician');
      final reports = (response.data as List).map((report) => ServiceReport.fromJson(report)).toList();
      return reports;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<ServiceReport> getReportDetail(String reportId) async {
    try {
      final response = await _dio.get('/service-reports/$reportId');
      return ServiceReport.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Helper methods
  Future<void> _saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tech_token', token);
  }

  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('tech_token');
  }

  String _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        final message = error.response?.data['message'] ?? 'Error';
        return message.toString();
      }
      return error.message ?? 'Network error';
    }
    return 'An error occurred';
  }
}
