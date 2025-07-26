import 'package:flutter/foundation.dart';
import '../models/service_report.dart';
import '../core/services/database_service.dart';

class ServiceReportProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService.instance;

  List<ServiceReport> _reports = [];
  ServiceReport? _selectedReport;
  ServiceReport? _currentReport;
  bool _isLoading = false;
  String? _error;

  List<ServiceReport> get reports => _reports;
  ServiceReport? get selectedReport => _selectedReport;
  ServiceReport? get currentReport => _currentReport;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ServiceReportProvider() {
    loadReports();
  }

  Future<void> loadReports() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _reports = await _databaseService.getAllServiceReports();
      _reports.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      _error = 'Failed to load service reports: $e';
      debugPrint('Error loading service reports: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createReport(ServiceReport report) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _databaseService.insertServiceReport(report);
      _reports.insert(0, report);
      _currentReport = report;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to create service report: $e';
      _isLoading = false;
      notifyListeners();
      debugPrint('Error creating service report: $e');
      return false;
    }
  }

  Future<bool> updateReport(ServiceReport report) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedReport = report.copyWith(updatedAt: DateTime.now());
      await _databaseService.updateServiceReport(updatedReport);
      
      final index = _reports.indexWhere((r) => r.id == updatedReport.id);
      if (index != -1) {
        _reports[index] = updatedReport;
      }
      
      if (_selectedReport?.id == updatedReport.id) {
        _selectedReport = updatedReport;
      }
      
      if (_currentReport?.id == updatedReport.id) {
        _currentReport = updatedReport;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to update service report: $e';
      _isLoading = false;
      notifyListeners();
      debugPrint('Error updating service report: $e');
      return false;
    }
  }

  Future<bool> deleteReport(String reportId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _databaseService.deleteServiceReport(reportId);
      _reports.removeWhere((r) => r.id == reportId);
      
      if (_selectedReport?.id == reportId) {
        _selectedReport = null;
      }
      
      if (_currentReport?.id == reportId) {
        _currentReport = null;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to delete service report: $e';
      _isLoading = false;
      notifyListeners();
      debugPrint('Error deleting service report: $e');
      return false;
    }
  }

  Future<void> selectReport(String reportId) async {
    try {
      _selectedReport = await _databaseService.getServiceReport(reportId);
    } catch (e) {
      _error = 'Failed to load service report details: $e';
      debugPrint('Error selecting service report: $e');
    }
    notifyListeners();
  }

  void clearSelectedReport() {
    _selectedReport = null;
    notifyListeners();
  }

  void startNewReport({
    required String customerId,
    required String customerName,
    required String technicianId,
    required String technicianName,
    String? meetingId,
  }) {
    _currentReport = ServiceReport(
      customerId: customerId,
      customerName: customerName,
      technicianId: technicianId,
      technicianName: technicianName,
      meetingId: meetingId,
      title: 'Service Report - ${DateTime.now().toLocal().toString().split(' ')[0]}',
      workDescription: '',
      serviceType: ServiceType.maintenance,
    );
    notifyListeners();
  }

  void clearCurrentReport() {
    _currentReport = null;
    notifyListeners();
  }

  Future<bool> completeReport(String reportId) async {
    try {
      final report = await _databaseService.getServiceReport(reportId);
      if (report != null) {
        final updatedReport = report.copyWith(
          isCompleted: true,
          endTime: DateTime.now(),
          duration: report.startTime != null 
              ? DateTime.now().difference(report.startTime).inMinutes / 60.0
              : null,
        );
        return await updateReport(updatedReport);
      }
      return false;
    } catch (e) {
      _error = 'Failed to complete service report: $e';
      debugPrint('Error completing service report: $e');
      return false;
    }
  }

  Future<bool> addCustomerSignature(String reportId, String signature) async {
    try {
      final report = await _databaseService.getServiceReport(reportId);
      if (report != null) {
        final updatedReport = report.copyWith(
          customerSignature: signature,
          customerSignedAt: DateTime.now(),
        );
        return await updateReport(updatedReport);
      }
      return false;
    } catch (e) {
      _error = 'Failed to add customer signature: $e';
      debugPrint('Error adding customer signature: $e');
      return false;
    }
  }

  Future<bool> addTechnicianSignature(String reportId, String signature) async {
    try {
      final report = await _databaseService.getServiceReport(reportId);
      if (report != null) {
        final updatedReport = report.copyWith(
          technicianSignature: signature,
          technicianSignedAt: DateTime.now(),
        );
        return await updateReport(updatedReport);
      }
      return false;
    } catch (e) {
      _error = 'Failed to add technician signature: $e';
      debugPrint('Error adding technician signature: $e');
      return false;
    }
  }

  Future<bool> addPhoto(String reportId, String photoPath, PhotoType type) async {
    try {
      final report = await _databaseService.getServiceReport(reportId);
      if (report != null) {
        ServiceReport updatedReport;
        switch (type) {
          case PhotoType.before:
            updatedReport = report.copyWith(
              beforePhotos: [...report.beforePhotos, photoPath],
            );
            break;
          case PhotoType.after:
            updatedReport = report.copyWith(
              afterPhotos: [...report.afterPhotos, photoPath],
            );
            break;
          case PhotoType.additional:
            updatedReport = report.copyWith(
              additionalPhotos: [...report.additionalPhotos, photoPath],
            );
            break;
        }
        return await updateReport(updatedReport);
      }
      return false;
    } catch (e) {
      _error = 'Failed to add photo: $e';
      debugPrint('Error adding photo: $e');
      return false;
    }
  }

  Future<bool> removePhoto(String reportId, String photoPath, PhotoType type) async {
    try {
      final report = await _databaseService.getServiceReport(reportId);
      if (report != null) {
        ServiceReport updatedReport;
        switch (type) {
          case PhotoType.before:
            final photos = List<String>.from(report.beforePhotos);
            photos.remove(photoPath);
            updatedReport = report.copyWith(beforePhotos: photos);
            break;
          case PhotoType.after:
            final photos = List<String>.from(report.afterPhotos);
            photos.remove(photoPath);
            updatedReport = report.copyWith(afterPhotos: photos);
            break;
          case PhotoType.additional:
            final photos = List<String>.from(report.additionalPhotos);
            photos.remove(photoPath);
            updatedReport = report.copyWith(additionalPhotos: photos);
            break;
        }
        return await updateReport(updatedReport);
      }
      return false;
    } catch (e) {
      _error = 'Failed to remove photo: $e';
      debugPrint('Error removing photo: $e');
      return false;
    }
  }

  // Get reports by customer
  Future<List<ServiceReport>> getReportsByCustomer(String customerId) async {
    try {
      return await _databaseService.getServiceReportsByCustomer(customerId);
    } catch (e) {
      debugPrint('Error getting reports by customer: $e');
      return [];
    }
  }

  // Get completed reports
  List<ServiceReport> get completedReports {
    return _reports.where((r) => r.isCompleted).toList();
  }

  // Get pending reports
  List<ServiceReport> get pendingReports {
    return _reports.where((r) => !r.isCompleted).toList();
  }

  // Get reports that need signatures
  List<ServiceReport> get reportsNeedingSignature {
    return _reports.where((r) => r.isCompleted && !r.isFullySigned).toList();
  }

  // Get unsynced reports
  List<ServiceReport> get unsyncedReports {
    return _reports.where((r) => !r.isSynced).toList();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Statistics
  int get totalReports => _reports.length;
  int get completedReportsCount => completedReports.length;
  int get pendingReportsCount => pendingReports.length;
  double get averageReportDuration {
    final completedWithDuration = completedReports.where((r) => r.duration != null);
    if (completedWithDuration.isEmpty) return 0.0;
    return completedWithDuration.map((r) => r.duration!).reduce((a, b) => a + b) / completedWithDuration.length;
  }
  double get totalRevenue {
    return completedReports.where((r) => r.totalCost != null).map((r) => r.totalCost!).fold(0.0, (a, b) => a + b);
  }
}

enum PhotoType {
  before,
  after,
  additional,
}
