import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import '../app_config.dart';
import '../theme/app_theme.dart';
import '../../models/meeting.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static NotificationService get instance => _instance;

  final FlutterLocalNotificationsPlugin _notificationsPlugin = 
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Request permission for notifications
    await _requestPermissions();

    // Initialize notifications
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _isInitialized = true;
  }

  Future<void> _requestPermissions() async {
    // Request notification permission
    await Permission.notification.request();

    // For Android 13+ (API level 33+), request POST_NOTIFICATIONS permission
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    final payload = response.payload;
    if (payload != null) {
      // Navigate to appropriate screen based on payload
      _handleNotificationPayload(payload);
    }
  }

  void _handleNotificationPayload(String payload) {
    // Parse payload and navigate to appropriate screen
    try {
      final parts = payload.split('|');
      final type = parts[0];
      final id = parts[1];

      switch (type) {
        case 'meeting':
          // Navigate to meeting details
          break;
        case 'reminder':
          // Navigate to meeting or service reminder
          break;
        case 'report':
          // Navigate to service report
          break;
      }
    } catch (e) {
      // Handle parsing error
    }
  }

  // Schedule meeting reminder notification
  Future<void> scheduleMeetingReminder(Meeting meeting, {Duration? customDelay}) async {
    if (!AppConfig.enableNotifications) return;

    try {
      final reminderTime = customDelay != null 
          ? meeting.scheduledDate.subtract(customDelay)
          : meeting.scheduledDate.subtract(const Duration(hours: 1));

      // Only schedule if reminder time is in the future
      if (reminderTime.isBefore(DateTime.now())) return;

      const androidDetails = AndroidNotificationDetails(
        'meeting_reminders',
        'Meeting Reminders',
        channelDescription: 'Notifications for upcoming meetings',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        color: AppTheme.primaryColor,
        playSound: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notificationsPlugin.schedule(
        meeting.id.hashCode,
        'Upcoming Meeting: ${meeting.title}',
        'Meeting with ${meeting.customerName} in 1 hour at ${meeting.displayLocation}',
        _convertToTimeZone(reminderTime),
        notificationDetails,
        payload: 'meeting|${meeting.id}',
      );
    } catch (e) {
      // Handle scheduling error
      print('Error scheduling meeting reminder: $e');
    }
  }

  // Schedule follow-up reminder for service reports
  Future<void> scheduleFollowUpReminder(String customerId, String customerName, DateTime followUpDate) async {
    if (!AppConfig.enableNotifications) return;

    try {
      // Only schedule if follow-up date is in the future
      if (followUpDate.isBefore(DateTime.now())) return;

      const androidDetails = AndroidNotificationDetails(
        'follow_up_reminders',
        'Follow-up Reminders',
        channelDescription: 'Notifications for customer follow-ups',
        importance: Importance.default,
        priority: Priority.default,
        icon: '@mipmap/ic_launcher',
        color: AppTheme.secondaryColor,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notificationsPlugin.schedule(
        customerId.hashCode + followUpDate.millisecondsSinceEpoch,
        'Follow-up Reminder',
        'Time to follow up with $customerName about their recent service',
        _convertToTimeZone(followUpDate),
        notificationDetails,
        payload: 'reminder|$customerId',
      );
    } catch (e) {
      // Handle scheduling error
      print('Error scheduling follow-up reminder: $e');
    }
  }

  // Show immediate notification
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
    NotificationChannel? channel,
  }) async {
    if (!AppConfig.enableNotifications) return;

    try {
      const androidDetails = AndroidNotificationDetails(
        'general',
        'General Notifications',
        channelDescription: 'General app notifications',
        importance: Importance.default,
        priority: Priority.default,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        notificationDetails,
        payload: payload,
      );
    } catch (e) {
      // Handle notification error
      print('Error showing notification: $e');
    }
  }

  // Cancel specific notification
  Future<void> cancelNotification(int id) async {
    try {
      await _notificationsPlugin.cancel(id);
    } catch (e) {
      print('Error canceling notification: $e');
    }
  }

  // Cancel meeting reminder
  Future<void> cancelMeetingReminder(String meetingId) async {
    try {
      await _notificationsPlugin.cancel(meetingId.hashCode);
    } catch (e) {
      print('Error canceling meeting reminder: $e');
    }
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    try {
      await _notificationsPlugin.cancelAll();
    } catch (e) {
      print('Error canceling all notifications: $e');
    }
  }

  // Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _notificationsPlugin.pendingNotificationRequests();
    } catch (e) {
      print('Error getting pending notifications: $e');
      return [];
    }
  }

  // Helper method to convert DateTime to local time
  DateTime _convertToTimeZone(DateTime dateTime) {
    // For simplicity, using local timezone
    // In a real app, you might want to use timezone package
    return dateTime.toLocal();
  }

  // Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    try {
      final status = await Permission.notification.status;
      return status.isGranted;
    } catch (e) {
      return false;
    }
  }

  // Open app settings for notification permissions
  Future<void> openNotificationSettings() async {
    try {
      await openAppSettings();
    } catch (e) {
      print('Error opening notification settings: $e');
    }
  }
}

// Notification channel types
enum NotificationChannel {
  general,
  meetingReminders,
  followUpReminders,
  serviceAlerts,
}
