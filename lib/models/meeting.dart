import 'package:uuid/uuid.dart';
import '../core/app_config.dart';

class Meeting {
  final String id;
  final String customerId;
  final String customerName;
  final String technicianId;
  final String title;
  final String description;
  final DateTime scheduledDate;
  final DateTime? endDate;
  final MeetingLocation location;
  final String? address;
  final MeetingStatus status;
  final ServiceType serviceType;
  final Priority priority;
  final double? estimatedDuration; // in hours
  final double? actualDuration; // in hours
  final String? notes;
  final List<String> requiredTools;
  final List<String> requiredParts;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? cancellationReason;
  final DateTime? completedAt;
  final double? latitude;
  final double? longitude;
  final String? contactPhone;
  final bool sendReminder;
  final DateTime? reminderSentAt;

  Meeting({
    String? id,
    required this.customerId,
    required this.customerName,
    required this.technicianId,
    required this.title,
    required this.description,
    required this.scheduledDate,
    this.endDate,
    required this.location,
    this.address,
    this.status = MeetingStatus.scheduled,
    required this.serviceType,
    this.priority = Priority.medium,
    this.estimatedDuration,
    this.actualDuration,
    this.notes,
    this.requiredTools = const [],
    this.requiredParts = const [],
    DateTime? createdAt,
    DateTime? updatedAt,
    this.cancellationReason,
    this.completedAt,
    this.latitude,
    this.longitude,
    this.contactPhone,
    this.sendReminder = true,
    this.reminderSentAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Meeting copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? technicianId,
    String? title,
    String? description,
    DateTime? scheduledDate,
    DateTime? endDate,
    MeetingLocation? location,
    String? address,
    MeetingStatus? status,
    ServiceType? serviceType,
    Priority? priority,
    double? estimatedDuration,
    double? actualDuration,
    String? notes,
    List<String>? requiredTools,
    List<String>? requiredParts,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? cancellationReason,
    DateTime? completedAt,
    double? latitude,
    double? longitude,
    String? contactPhone,
    bool? sendReminder,
    DateTime? reminderSentAt,
  }) {
    return Meeting(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      technicianId: technicianId ?? this.technicianId,
      title: title ?? this.title,
      description: description ?? this.description,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      endDate: endDate ?? this.endDate,
      location: location ?? this.location,
      address: address ?? this.address,
      status: status ?? this.status,
      serviceType: serviceType ?? this.serviceType,
      priority: priority ?? this.priority,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      actualDuration: actualDuration ?? this.actualDuration,
      notes: notes ?? this.notes,
      requiredTools: requiredTools ?? this.requiredTools,
      requiredParts: requiredParts ?? this.requiredParts,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      completedAt: completedAt ?? this.completedAt,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      contactPhone: contactPhone ?? this.contactPhone,
      sendReminder: sendReminder ?? this.sendReminder,
      reminderSentAt: reminderSentAt ?? this.reminderSentAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'technicianId': technicianId,
      'title': title,
      'description': description,
      'scheduledDate': scheduledDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'location': location.index,
      'address': address,
      'status': status.index,
      'serviceType': serviceType.index,
      'priority': priority.index,
      'estimatedDuration': estimatedDuration,
      'actualDuration': actualDuration,
      'notes': notes,
      'requiredTools': requiredTools,
      'requiredParts': requiredParts,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'cancellationReason': cancellationReason,
      'completedAt': completedAt?.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'contactPhone': contactPhone,
      'sendReminder': sendReminder,
      'reminderSentAt': reminderSentAt?.toIso8601String(),
    };
  }

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      id: json['id'],
      customerId: json['customerId'],
      customerName: json['customerName'],
      technicianId: json['technicianId'],
      title: json['title'],
      description: json['description'],
      scheduledDate: DateTime.parse(json['scheduledDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      location: MeetingLocation.values[json['location']],
      address: json['address'],
      status: MeetingStatus.values[json['status']],
      serviceType: ServiceType.values[json['serviceType']],
      priority: Priority.values[json['priority']],
      estimatedDuration: json['estimatedDuration']?.toDouble(),
      actualDuration: json['actualDuration']?.toDouble(),
      notes: json['notes'],
      requiredTools: List<String>.from(json['requiredTools'] ?? []),
      requiredParts: List<String>.from(json['requiredParts'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      cancellationReason: json['cancellationReason'],
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      contactPhone: json['contactPhone'],
      sendReminder: json['sendReminder'] ?? true,
      reminderSentAt: json['reminderSentAt'] != null ? DateTime.parse(json['reminderSentAt']) : null,
    );
  }

  bool get isUpcoming => 
      status == MeetingStatus.scheduled && 
      scheduledDate.isAfter(DateTime.now());

  bool get isToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final meetingDay = DateTime(scheduledDate.year, scheduledDate.month, scheduledDate.day);
    return today == meetingDay;
  }

  bool get isOverdue =>
      status == MeetingStatus.scheduled && 
      scheduledDate.isBefore(DateTime.now());

  Duration get timeUntilMeeting => scheduledDate.difference(DateTime.now());

  String get displayLocation => location.displayName;
  String get displayStatus => status.displayName;
  String get displayServiceType => serviceType.displayName;
  String get displayPriority => priority.displayName;

  @override
  String toString() => 'Meeting(id: $id, title: $title, date: $scheduledDate)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Meeting && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
