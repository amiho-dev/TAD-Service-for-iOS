class AppConfig {
  static const String appName = 'TAD Service';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://thatoneamiho.cc';
  static const String customerDatabaseEndpoint = '/customer-database.html';
  static const String apiVersion = 'v1';
  
  // Database Configuration
  static const String databaseName = 'tad_service.db';
  static const int databaseVersion = 1;
  
  // Local Storage Keys
  static const String userTokenKey = 'user_token';
  static const String lastSyncKey = 'last_sync';
  static const String offlineModeKey = 'offline_mode';
  static const String technicianIdKey = 'technician_id';
  
  // App Settings
  static const int networkTimeoutSeconds = 30;
  static const int maxPhotoSize = 5; // MB
  static const int autoSyncIntervalMinutes = 15;
  
  // Feature Flags
  static const bool enableOfflineMode = true;
  static const bool enableGPSTracking = true;
  static const bool enableNotifications = true;
  static const bool enableAnalytics = true;
  
  // Contact Information
  static const String supportEmail = 'support@tadservice.com';
  static const String supportPhone = '+1-555-0123';
  
  // File Paths
  static const String documentsPath = 'documents';
  static const String imagesPath = 'images';
  static const String signaturesPath = 'signatures';
  static const String reportsPath = 'reports';
}

// App-wide constants
class AppConstants {
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  
  static const double borderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;
  
  static const double buttonHeight = 56.0;
  static const double inputHeight = 48.0;
  
  static const double iconSize = 24.0;
  static const double smallIconSize = 16.0;
  static const double largeIconSize = 32.0;
}

// Service Types Enum
enum ServiceType {
  installation,
  maintenance,
  repair,
  inspection,
  consultation,
  emergency,
}

// Meeting Locations Enum
enum MeetingLocation {
  atShop,
  customerLocation,
}

// Meeting Status Enum
enum MeetingStatus {
  scheduled,
  inProgress,
  completed,
  cancelled,
  rescheduled,
}

// Priority Levels
enum Priority {
  low,
  medium,
  high,
  urgent,
}

// Extension methods for enums
extension ServiceTypeExtension on ServiceType {
  String get displayName {
    switch (this) {
      case ServiceType.installation:
        return 'Installation';
      case ServiceType.maintenance:
        return 'Maintenance';
      case ServiceType.repair:
        return 'Repair';
      case ServiceType.inspection:
        return 'Inspection';
      case ServiceType.consultation:
        return 'Consultation';
      case ServiceType.emergency:
        return 'Emergency';
    }
  }
}

extension MeetingLocationExtension on MeetingLocation {
  String get displayName {
    switch (this) {
      case MeetingLocation.atShop:
        return 'At Shop';
      case MeetingLocation.customerLocation:
        return 'Customer Location';
    }
  }
}

extension MeetingStatusExtension on MeetingStatus {
  String get displayName {
    switch (this) {
      case MeetingStatus.scheduled:
        return 'Scheduled';
      case MeetingStatus.inProgress:
        return 'In Progress';
      case MeetingStatus.completed:
        return 'Completed';
      case MeetingStatus.cancelled:
        return 'Cancelled';
      case MeetingStatus.rescheduled:
        return 'Rescheduled';
    }
  }
}

extension PriorityExtension on Priority {
  String get displayName {
    switch (this) {
      case Priority.low:
        return 'Low';
      case Priority.medium:
        return 'Medium';
      case Priority.high:
        return 'High';
      case Priority.urgent:
        return 'Urgent';
    }
  }
}
