import 'package:flutter/foundation.dart';
import '../models/meeting.dart';
import '../core/services/database_service.dart';
import '../core/services/notification_service.dart';

class MeetingProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService.instance;
  final NotificationService _notificationService = NotificationService.instance;

  List<Meeting> _meetings = [];
  List<Meeting> _todayMeetings = [];
  List<Meeting> _upcomingMeetings = [];
  Meeting? _selectedMeeting;
  bool _isLoading = false;
  String? _error;

  List<Meeting> get meetings => _meetings;
  List<Meeting> get todayMeetings => _todayMeetings;
  List<Meeting> get upcomingMeetings => _upcomingMeetings;
  Meeting? get selectedMeeting => _selectedMeeting;
  bool get isLoading => _isLoading;
  String? get error => _error;

  MeetingProvider() {
    loadMeetings();
  }

  Future<void> loadMeetings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _meetings = await _databaseService.getAllMeetings();
      _updateMeetingLists();
    } catch (e) {
      _error = 'Failed to load meetings: $e';
      debugPrint('Error loading meetings: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void _updateMeetingLists() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    _todayMeetings = _meetings
        .where((m) => m.isToday && m.status == MeetingStatus.scheduled)
        .toList()
      ..sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));

    _upcomingMeetings = _meetings
        .where((m) => 
            m.scheduledDate.isAfter(tomorrow) && 
            m.status == MeetingStatus.scheduled)
        .toList()
      ..sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
  }

  Future<bool> createMeeting(Meeting meeting) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _databaseService.insertMeeting(meeting);
      _meetings.insert(0, meeting);
      _updateMeetingLists();

      // Schedule notification reminder
      if (meeting.sendReminder) {
        await _notificationService.scheduleMeetingReminder(meeting);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to create meeting: $e';
      _isLoading = false;
      notifyListeners();
      debugPrint('Error creating meeting: $e');
      return false;
    }
  }

  Future<bool> updateMeeting(Meeting meeting) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _databaseService.updateMeeting(meeting);
      
      final index = _meetings.indexWhere((m) => m.id == meeting.id);
      if (index != -1) {
        _meetings[index] = meeting;
      }
      
      if (_selectedMeeting?.id == meeting.id) {
        _selectedMeeting = meeting;
      }
      
      _updateMeetingLists();

      // Update notification if needed
      if (meeting.sendReminder) {
        await _notificationService.scheduleMeetingReminder(meeting);
      } else {
        await _notificationService.cancelMeetingReminder(meeting.id);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to update meeting: $e';
      _isLoading = false;
      notifyListeners();
      debugPrint('Error updating meeting: $e');
      return false;
    }
  }

  Future<bool> deleteMeeting(String meetingId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _databaseService.deleteMeeting(meetingId);
      _meetings.removeWhere((m) => m.id == meetingId);
      
      if (_selectedMeeting?.id == meetingId) {
        _selectedMeeting = null;
      }
      
      _updateMeetingLists();

      // Cancel notification
      await _notificationService.cancelMeetingReminder(meetingId);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to delete meeting: $e';
      _isLoading = false;
      notifyListeners();
      debugPrint('Error deleting meeting: $e');
      return false;
    }
  }

  Future<void> selectMeeting(String meetingId) async {
    try {
      _selectedMeeting = await _databaseService.getMeeting(meetingId);
    } catch (e) {
      _error = 'Failed to load meeting details: $e';
      debugPrint('Error selecting meeting: $e');
    }
    notifyListeners();
  }

  void clearSelectedMeeting() {
    _selectedMeeting = null;
    notifyListeners();
  }

  Future<bool> startMeeting(String meetingId) async {
    try {
      final meeting = await _databaseService.getMeeting(meetingId);
      if (meeting != null) {
        final updatedMeeting = meeting.copyWith(
          status: MeetingStatus.inProgress,
          updatedAt: DateTime.now(),
        );
        return await updateMeeting(updatedMeeting);
      }
      return false;
    } catch (e) {
      _error = 'Failed to start meeting: $e';
      debugPrint('Error starting meeting: $e');
      return false;
    }
  }

  Future<bool> completeMeeting(String meetingId) async {
    try {
      final meeting = await _databaseService.getMeeting(meetingId);
      if (meeting != null) {
        final updatedMeeting = meeting.copyWith(
          status: MeetingStatus.completed,
          completedAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        return await updateMeeting(updatedMeeting);
      }
      return false;
    } catch (e) {
      _error = 'Failed to complete meeting: $e';
      debugPrint('Error completing meeting: $e');
      return false;
    }
  }

  Future<bool> cancelMeeting(String meetingId, String reason) async {
    try {
      final meeting = await _databaseService.getMeeting(meetingId);
      if (meeting != null) {
        final updatedMeeting = meeting.copyWith(
          status: MeetingStatus.cancelled,
          cancellationReason: reason,
          updatedAt: DateTime.now(),
        );
        return await updateMeeting(updatedMeeting);
      }
      return false;
    } catch (e) {
      _error = 'Failed to cancel meeting: $e';
      debugPrint('Error canceling meeting: $e');
      return false;
    }
  }

  // Get meetings by date range
  List<Meeting> getMeetingsByDateRange(DateTime start, DateTime end) {
    return _meetings
        .where((m) => 
            m.scheduledDate.isAfter(start.subtract(const Duration(days: 1))) &&
            m.scheduledDate.isBefore(end.add(const Duration(days: 1))))
        .toList()
      ..sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
  }

  // Get meetings by status
  List<Meeting> getMeetingsByStatus(MeetingStatus status) {
    return _meetings.where((m) => m.status == status).toList()
      ..sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
  }

  // Get overdue meetings
  List<Meeting> get overdueMeetings {
    return _meetings.where((m) => m.isOverdue).toList()
      ..sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Statistics
  int get totalMeetings => _meetings.length;
  int get completedMeetings => _meetings.where((m) => m.status == MeetingStatus.completed).length;
  int get scheduledMeetings => _meetings.where((m) => m.status == MeetingStatus.scheduled).length;
  int get cancelledMeetings => _meetings.where((m) => m.status == MeetingStatus.cancelled).length;
}
