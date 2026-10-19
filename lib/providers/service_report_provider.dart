import 'package:flutter/foundation.dart';
import '../models/service_report_model.dart';
import '../services/api_service.dart';

class ServiceReportProvider extends ChangeNotifier {
  final ApiService _apiService;

  ServiceReportProvider(this._apiService);

  List<ServiceReport> _reports = [];
  ServiceReport? _selectedReport;
  bool _isLoading = false;
  String? _error;

  List<ServiceReport> get reports => _reports;
  ServiceReport? get selectedReport => _selectedReport;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<ServiceReport> get draftReports => _reports.where((r) => r.isDraft).toList();
  List<ServiceReport> get submittedReports => _reports.where((r) => r.isSubmitted).toList();
  List<ServiceReport> get approvedReports => _reports.where((r) => r.isApproved).toList();

  Future<void> loadReports() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _reports = await _apiService.getTechnicianReports();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadReportDetail(String reportId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedReport = await _apiService.getReportDetail(reportId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createReport(String jobId, String jobNumber, String elevatorId,
      String customerName, String building, String technicianName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final report = await _apiService.createServiceReport({
        'jobId': jobId,
        'jobNumber': jobNumber,
        'elevatorId': elevatorId,
        'customerName': customerName,
        'building': building,
        'technicianName': technicianName,
        'arrivalTime': DateTime.now().toIso8601String(),
        'workPerformed': '',
        'findings': '',
        'equipmentStatus': 'Operational',
        'status': 'Draft',
      });
      _reports.add(report);
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

  Future<bool> submitReport(String reportId, Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedReport = await _apiService.submitServiceReport(reportId, data);
      final index = _reports.indexWhere((r) => r.id == reportId);
      if (index >= 0) {
        _reports[index] = updatedReport;
      }
      _selectedReport = updatedReport;
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
