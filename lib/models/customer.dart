import 'package:uuid/uuid.dart';

class Customer {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String? secondaryPhone;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double? latitude;
  final double? longitude;
  final List<String> serviceHistory;
  final double rating;
  final int totalServices;
  final String? preferredContactMethod;
  final bool isActive;

  Customer({
    String? id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.secondaryPhone,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.latitude,
    this.longitude,
    this.serviceHistory = const [],
    this.rating = 0.0,
    this.totalServices = 0,
    this.preferredContactMethod,
    this.isActive = true,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Customer copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? secondaryPhone,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? latitude,
    double? longitude,
    List<String>? serviceHistory,
    double? rating,
    int? totalServices,
    String? preferredContactMethod,
    bool? isActive,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      secondaryPhone: secondaryPhone ?? this.secondaryPhone,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      serviceHistory: serviceHistory ?? this.serviceHistory,
      rating: rating ?? this.rating,
      totalServices: totalServices ?? this.totalServices,
      preferredContactMethod: preferredContactMethod ?? this.preferredContactMethod,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'secondaryPhone': secondaryPhone,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'serviceHistory': serviceHistory,
      'rating': rating,
      'totalServices': totalServices,
      'preferredContactMethod': preferredContactMethod,
      'isActive': isActive,
    };
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      secondaryPhone: json['secondaryPhone'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      serviceHistory: List<String>.from(json['serviceHistory'] ?? []),
      rating: json['rating']?.toDouble() ?? 0.0,
      totalServices: json['totalServices'] ?? 0,
      preferredContactMethod: json['preferredContactMethod'],
      isActive: json['isActive'] ?? true,
    );
  }

  String get fullAddress => address;
  
  String get displayPhone => phone;
  
  String get initials {
    final words = name.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  String toString() => 'Customer(id: $id, name: $name, phone: $phone)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Customer && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
