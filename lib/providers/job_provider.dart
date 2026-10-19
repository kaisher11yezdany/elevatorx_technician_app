import 'package:flutter/foundation.dart';
import '../models/job_model.dart';
import '../services/api_service.dart';

class JobProvider extends ChangeNotifier {
  final ApiService _apiService;

  JobProvider(this._apiService);

  List<Job> _jobs = [];
  Job? _selectedJob;
  bool _isLoading = false;
  String? _error;

  List<Job> get jobs => _jobs;
  Job? get selectedJob => _selectedJob;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Job> get todayJobs => _jobs.where((j) =>
    j.scheduledDate.day == DateTime.now().day &&
    j.scheduledDate.month == DateTime.now().month &&
    j.scheduledDate.year == DateTime.now().year
  ).toList();

  List<Job> get pendingJobs => _jobs.where((j) => j.isPending).toList();
  List<Job> get inProgressJobs => _jobs.where((j) => j.isInProgress).toList();
  List<Job> get completedJobs => _jobs.where((j) => j.isCompleted).toList();
  List<Job> get urgentJobs => _jobs.where((j) => j.isUrgent && !j.isCompleted).toList();
  List<Job> get overdueJobs => _jobs.where((j) => j.isOverdue && !j.isCompleted).toList();

  Future<void> loadJobs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _jobs = await _apiService.getTechnicianJobs();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadJobDetail(String jobId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedJob = await _apiService.getJobDetail(jobId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> acceptJob(String jobId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.acceptJob(jobId);
      await loadJobs();
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

  Future<bool> updateJobStatus(String jobId, String status) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.updateJobStatus(jobId, status);
      await loadJobs();
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
