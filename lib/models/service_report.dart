import 'package:uuid/uuid.dart';
import '../core/app_config.dart';

class ServiceReport {
  final String id;
  final String customerId;
  final String customerName;
  final String technicianId;
  final String technicianName;
  final String? meetingId;
  final String title;
  final String workDescription;
  final ServiceType serviceType;
  final DateTime startTime;
  final DateTime? endTime;
  final double? duration; // in hours
  final List<ServiceItem> partsUsed;
  final List<ServiceItem> servicesPerformed;
  final List<String> beforePhotos;
  final List<String> afterPhotos;
  final List<String> additionalPhotos;
  final String? customerSignature;
  final String? technicianSignature;
  final DateTime? customerSignedAt;
  final DateTime? technicianSignedAt;
  final String? recommendations;
  final Priority issueSeverity;
  final double? totalCost;
  final double? laborCost;
  final double? partsCost;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isCompleted;
  final bool isSynced;
  final String? followUpDate;
  final int? warrantyMonths;
  final double? customerRating;
  final String? customerFeedback;
  final String? notes;
  final String? invoiceNumber;
  final bool isPaid;
  final DateTime? paidAt;

  ServiceReport({
    String? id,
    required this.customerId,
    required this.customerName,
    required this.technicianId,
    required this.technicianName,
    this.meetingId,
    required this.title,
    required this.workDescription,
    required this.serviceType,
    DateTime? startTime,
    this.endTime,
    this.duration,
    this.partsUsed = const [],
    this.servicesPerformed = const [],
    this.beforePhotos = const [],
    this.afterPhotos = const [],
    this.additionalPhotos = const [],
    this.customerSignature,
    this.technicianSignature,
    this.customerSignedAt,
    this.technicianSignedAt,
    this.recommendations,
    this.issueSeverity = Priority.medium,
    this.totalCost,
    this.laborCost,
    this.partsCost,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isCompleted = false,
    this.isSynced = false,
    this.followUpDate,
    this.warrantyMonths,
    this.customerRating,
    this.customerFeedback,
    this.notes,
    this.invoiceNumber,
    this.isPaid = false,
    this.paidAt,
  })  : id = id ?? const Uuid().v4(),
        startTime = startTime ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  ServiceReport copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? technicianId,
    String? technicianName,
    String? meetingId,
    String? title,
    String? workDescription,
    ServiceType? serviceType,
    DateTime? startTime,
    DateTime? endTime,
    double? duration,
    List<ServiceItem>? partsUsed,
    List<ServiceItem>? servicesPerformed,
    List<String>? beforePhotos,
    List<String>? afterPhotos,
    List<String>? additionalPhotos,
    String? customerSignature,
    String? technicianSignature,
    DateTime? customerSignedAt,
    DateTime? technicianSignedAt,
    String? recommendations,
    Priority? issueSeverity,
    double? totalCost,
    double? laborCost,
    double? partsCost,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isCompleted,
    bool? isSynced,
    String? followUpDate,
    int? warrantyMonths,
    double? customerRating,
    String? customerFeedback,
    String? notes,
    String? invoiceNumber,
    bool? isPaid,
    DateTime? paidAt,
  }) {
    return ServiceReport(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      technicianId: technicianId ?? this.technicianId,
      technicianName: technicianName ?? this.technicianName,
      meetingId: meetingId ?? this.meetingId,
      title: title ?? this.title,
      workDescription: workDescription ?? this.workDescription,
      serviceType: serviceType ?? this.serviceType,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      partsUsed: partsUsed ?? this.partsUsed,
      servicesPerformed: servicesPerformed ?? this.servicesPerformed,
      beforePhotos: beforePhotos ?? this.beforePhotos,
      afterPhotos: afterPhotos ?? this.afterPhotos,
      additionalPhotos: additionalPhotos ?? this.additionalPhotos,
      customerSignature: customerSignature ?? this.customerSignature,
      technicianSignature: technicianSignature ?? this.technicianSignature,
      customerSignedAt: customerSignedAt ?? this.customerSignedAt,
      technicianSignedAt: technicianSignedAt ?? this.technicianSignedAt,
      recommendations: recommendations ?? this.recommendations,
      issueSeverity: issueSeverity ?? this.issueSeverity,
      totalCost: totalCost ?? this.totalCost,
      laborCost: laborCost ?? this.laborCost,
      partsCost: partsCost ?? this.partsCost,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isCompleted: isCompleted ?? this.isCompleted,
      isSynced: isSynced ?? this.isSynced,
      followUpDate: followUpDate ?? this.followUpDate,
      warrantyMonths: warrantyMonths ?? this.warrantyMonths,
      customerRating: customerRating ?? this.customerRating,
      customerFeedback: customerFeedback ?? this.customerFeedback,
      notes: notes ?? this.notes,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      isPaid: isPaid ?? this.isPaid,
      paidAt: paidAt ?? this.paidAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'technicianId': technicianId,
      'technicianName': technicianName,
      'meetingId': meetingId,
      'title': title,
      'workDescription': workDescription,
      'serviceType': serviceType.index,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'duration': duration,
      'partsUsed': partsUsed.map((item) => item.toJson()).toList(),
      'servicesPerformed': servicesPerformed.map((item) => item.toJson()).toList(),
      'beforePhotos': beforePhotos,
      'afterPhotos': afterPhotos,
      'additionalPhotos': additionalPhotos,
      'customerSignature': customerSignature,
      'technicianSignature': technicianSignature,
      'customerSignedAt': customerSignedAt?.toIso8601String(),
      'technicianSignedAt': technicianSignedAt?.toIso8601String(),
      'recommendations': recommendations,
      'issueSeverity': issueSeverity.index,
      'totalCost': totalCost,
      'laborCost': laborCost,
      'partsCost': partsCost,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isCompleted': isCompleted,
      'isSynced': isSynced,
      'followUpDate': followUpDate,
      'warrantyMonths': warrantyMonths,
      'customerRating': customerRating,
      'customerFeedback': customerFeedback,
      'notes': notes,
      'invoiceNumber': invoiceNumber,
      'isPaid': isPaid,
      'paidAt': paidAt?.toIso8601String(),
    };
  }

  factory ServiceReport.fromJson(Map<String, dynamic> json) {
    return ServiceReport(
      id: json['id'],
      customerId: json['customerId'],
      customerName: json['customerName'],
      technicianId: json['technicianId'],
      technicianName: json['technicianName'],
      meetingId: json['meetingId'],
      title: json['title'],
      workDescription: json['workDescription'],
      serviceType: ServiceType.values[json['serviceType']],
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      duration: json['duration']?.toDouble(),
      partsUsed: (json['partsUsed'] as List?)
          ?.map((item) => ServiceItem.fromJson(item))
          .toList() ?? [],
      servicesPerformed: (json['servicesPerformed'] as List?)
          ?.map((item) => ServiceItem.fromJson(item))
          .toList() ?? [],
      beforePhotos: List<String>.from(json['beforePhotos'] ?? []),
      afterPhotos: List<String>.from(json['afterPhotos'] ?? []),
      additionalPhotos: List<String>.from(json['additionalPhotos'] ?? []),
      customerSignature: json['customerSignature'],
      technicianSignature: json['technicianSignature'],
      customerSignedAt: json['customerSignedAt'] != null 
          ? DateTime.parse(json['customerSignedAt']) : null,
      technicianSignedAt: json['technicianSignedAt'] != null 
          ? DateTime.parse(json['technicianSignedAt']) : null,
      recommendations: json['recommendations'],
      issueSeverity: Priority.values[json['issueSeverity']],
      totalCost: json['totalCost']?.toDouble(),
      laborCost: json['laborCost']?.toDouble(),
      partsCost: json['partsCost']?.toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isCompleted: json['isCompleted'] ?? false,
      isSynced: json['isSynced'] ?? false,
      followUpDate: json['followUpDate'],
      warrantyMonths: json['warrantyMonths'],
      customerRating: json['customerRating']?.toDouble(),
      customerFeedback: json['customerFeedback'],
      notes: json['notes'],
      invoiceNumber: json['invoiceNumber'],
      isPaid: json['isPaid'] ?? false,
      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
    );
  }

  bool get hasCustomerSignature => customerSignature != null;
  bool get hasTechnicianSignature => technicianSignature != null;
  bool get isFullySigned => hasCustomerSignature && hasTechnicianSignature;
  
  double get calculatedPartsCost => 
      partsUsed.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  
  double get calculatedTotalCost => 
      (laborCost ?? 0.0) + calculatedPartsCost;

  int get totalPhotos => 
      beforePhotos.length + afterPhotos.length + additionalPhotos.length;

  String get displayServiceType => serviceType.displayName;
  String get displayIssueSeverity => issueSeverity.displayName;

  @override
  String toString() => 'ServiceReport(id: $id, title: $title, customer: $customerName)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceReport && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class ServiceItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String? partNumber;
  final String? category;
  final String? unit;

  ServiceItem({
    String? id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    this.partNumber,
    this.category,
    this.unit,
  }) : id = id ?? const Uuid().v4();

  double get totalPrice => price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'partNumber': partNumber,
      'category': category,
      'unit': unit,
    };
  }

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      partNumber: json['partNumber'],
      category: json['category'],
      unit: json['unit'],
    );
  }

  ServiceItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? quantity,
    String? partNumber,
    String? category,
    String? unit,
  }) {
    return ServiceItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      partNumber: partNumber ?? this.partNumber,
      category: category ?? this.category,
      unit: unit ?? this.unit,
    );
  }

  @override
  String toString() => 'ServiceItem(name: $name, quantity: $quantity, price: \$${price.toStringAsFixed(2)})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
