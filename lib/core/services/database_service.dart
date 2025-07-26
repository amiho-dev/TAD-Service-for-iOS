import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../app_config.dart';
import '../../models/customer.dart';
import '../../models/meeting.dart';
import '../../models/service_report.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static DatabaseService get instance => _instance;

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<void> initialize() async {
    _database = await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AppConfig.databaseName);

    return await openDatabase(
      path,
      version: AppConfig.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create customers table
    await db.execute('''
      CREATE TABLE customers (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        address TEXT NOT NULL,
        secondary_phone TEXT,
        notes TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        latitude REAL,
        longitude REAL,
        service_history TEXT,
        rating REAL DEFAULT 0.0,
        total_services INTEGER DEFAULT 0,
        preferred_contact_method TEXT,
        is_active INTEGER DEFAULT 1
      )
    ''');

    // Create meetings table
    await db.execute('''
      CREATE TABLE meetings (
        id TEXT PRIMARY KEY,
        customer_id TEXT NOT NULL,
        customer_name TEXT NOT NULL,
        technician_id TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        scheduled_date TEXT NOT NULL,
        end_date TEXT,
        location INTEGER NOT NULL,
        address TEXT,
        status INTEGER NOT NULL DEFAULT 0,
        service_type INTEGER NOT NULL,
        priority INTEGER NOT NULL DEFAULT 1,
        estimated_duration REAL,
        actual_duration REAL,
        notes TEXT,
        required_tools TEXT,
        required_parts TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        cancellation_reason TEXT,
        completed_at TEXT,
        latitude REAL,
        longitude REAL,
        contact_phone TEXT,
        send_reminder INTEGER DEFAULT 1,
        reminder_sent_at TEXT,
        FOREIGN KEY (customer_id) REFERENCES customers (id)
      )
    ''');

    // Create service_reports table
    await db.execute('''
      CREATE TABLE service_reports (
        id TEXT PRIMARY KEY,
        customer_id TEXT NOT NULL,
        customer_name TEXT NOT NULL,
        technician_id TEXT NOT NULL,
        technician_name TEXT NOT NULL,
        meeting_id TEXT,
        title TEXT NOT NULL,
        work_description TEXT NOT NULL,
        service_type INTEGER NOT NULL,
        start_time TEXT NOT NULL,
        end_time TEXT,
        duration REAL,
        parts_used TEXT,
        services_performed TEXT,
        before_photos TEXT,
        after_photos TEXT,
        additional_photos TEXT,
        customer_signature TEXT,
        technician_signature TEXT,
        customer_signed_at TEXT,
        technician_signed_at TEXT,
        recommendations TEXT,
        issue_severity INTEGER NOT NULL DEFAULT 1,
        total_cost REAL,
        labor_cost REAL,
        parts_cost REAL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        is_completed INTEGER DEFAULT 0,
        is_synced INTEGER DEFAULT 0,
        follow_up_date TEXT,
        warranty_months INTEGER,
        customer_rating REAL,
        customer_feedback TEXT,
        notes TEXT,
        invoice_number TEXT,
        is_paid INTEGER DEFAULT 0,
        paid_at TEXT,
        FOREIGN KEY (customer_id) REFERENCES customers (id),
        FOREIGN KEY (meeting_id) REFERENCES meetings (id)
      )
    ''');

    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_customers_name ON customers (name)');
    await db.execute('CREATE INDEX idx_customers_phone ON customers (phone)');
    await db.execute('CREATE INDEX idx_meetings_customer_id ON meetings (customer_id)');
    await db.execute('CREATE INDEX idx_meetings_scheduled_date ON meetings (scheduled_date)');
    await db.execute('CREATE INDEX idx_service_reports_customer_id ON service_reports (customer_id)');
    await db.execute('CREATE INDEX idx_service_reports_created_at ON service_reports (created_at)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < 2) {
      // Add new columns or tables for version 2
    }
  }

  // Customer operations
  Future<int> insertCustomer(Customer customer) async {
    final db = await database;
    return await db.insert(
      'customers',
      _customerToMap(customer),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Customer>> getAllCustomers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('customers');
    return maps.map((map) => _customerFromMap(map)).toList();
  }

  Future<Customer?> getCustomer(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return _customerFromMap(maps.first);
    }
    return null;
  }

  Future<List<Customer>> searchCustomers(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'customers',
      where: 'name LIKE ? OR phone LIKE ? OR email LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'name ASC',
    );
    return maps.map((map) => _customerFromMap(map)).toList();
  }

  Future<int> updateCustomer(Customer customer) async {
    final db = await database;
    return await db.update(
      'customers',
      _customerToMap(customer),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  Future<int> deleteCustomer(String id) async {
    final db = await database;
    return await db.delete(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Meeting operations
  Future<int> insertMeeting(Meeting meeting) async {
    final db = await database;
    return await db.insert(
      'meetings',
      _meetingToMap(meeting),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Meeting>> getAllMeetings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'meetings',
      orderBy: 'scheduled_date DESC',
    );
    return maps.map((map) => _meetingFromMap(map)).toList();
  }

  Future<List<Meeting>> getMeetingsByDateRange(DateTime start, DateTime end) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'meetings',
      where: 'scheduled_date BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'scheduled_date ASC',
    );
    return maps.map((map) => _meetingFromMap(map)).toList();
  }

  Future<Meeting?> getMeeting(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'meetings',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return _meetingFromMap(maps.first);
    }
    return null;
  }

  Future<int> updateMeeting(Meeting meeting) async {
    final db = await database;
    return await db.update(
      'meetings',
      _meetingToMap(meeting),
      where: 'id = ?',
      whereArgs: [meeting.id],
    );
  }

  Future<int> deleteMeeting(String id) async {
    final db = await database;
    return await db.delete(
      'meetings',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Service Report operations
  Future<int> insertServiceReport(ServiceReport report) async {
    final db = await database;
    return await db.insert(
      'service_reports',
      _serviceReportToMap(report),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ServiceReport>> getAllServiceReports() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'service_reports',
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => _serviceReportFromMap(map)).toList();
  }

  Future<ServiceReport?> getServiceReport(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'service_reports',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return _serviceReportFromMap(maps.first);
    }
    return null;
  }

  Future<List<ServiceReport>> getServiceReportsByCustomer(String customerId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'service_reports',
      where: 'customer_id = ?',
      whereArgs: [customerId],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => _serviceReportFromMap(map)).toList();
  }

  Future<int> updateServiceReport(ServiceReport report) async {
    final db = await database;
    return await db.update(
      'service_reports',
      _serviceReportToMap(report),
      where: 'id = ?',
      whereArgs: [report.id],
    );
  }

  Future<int> deleteServiceReport(String id) async {
    final db = await database;
    return await db.delete(
      'service_reports',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Utility methods for data conversion
  Map<String, dynamic> _customerToMap(Customer customer) {
    return {
      'id': customer.id,
      'name': customer.name,
      'email': customer.email,
      'phone': customer.phone,
      'address': customer.address,
      'secondary_phone': customer.secondaryPhone,
      'notes': customer.notes,
      'created_at': customer.createdAt.toIso8601String(),
      'updated_at': customer.updatedAt.toIso8601String(),
      'latitude': customer.latitude,
      'longitude': customer.longitude,
      'service_history': customer.serviceHistory.join(','),
      'rating': customer.rating,
      'total_services': customer.totalServices,
      'preferred_contact_method': customer.preferredContactMethod,
      'is_active': customer.isActive ? 1 : 0,
    };
  }

  Customer _customerFromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      secondaryPhone: map['secondary_phone'],
      notes: map['notes'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      serviceHistory: map['service_history']?.split(',') ?? [],
      rating: map['rating']?.toDouble() ?? 0.0,
      totalServices: map['total_services'] ?? 0,
      preferredContactMethod: map['preferred_contact_method'],
      isActive: (map['is_active'] ?? 1) == 1,
    );
  }

  Map<String, dynamic> _meetingToMap(Meeting meeting) {
    return {
      'id': meeting.id,
      'customer_id': meeting.customerId,
      'customer_name': meeting.customerName,
      'technician_id': meeting.technicianId,
      'title': meeting.title,
      'description': meeting.description,
      'scheduled_date': meeting.scheduledDate.toIso8601String(),
      'end_date': meeting.endDate?.toIso8601String(),
      'location': meeting.location.index,
      'address': meeting.address,
      'status': meeting.status.index,
      'service_type': meeting.serviceType.index,
      'priority': meeting.priority.index,
      'estimated_duration': meeting.estimatedDuration,
      'actual_duration': meeting.actualDuration,
      'notes': meeting.notes,
      'required_tools': meeting.requiredTools.join(','),
      'required_parts': meeting.requiredParts.join(','),
      'created_at': meeting.createdAt.toIso8601String(),
      'updated_at': meeting.updatedAt.toIso8601String(),
      'cancellation_reason': meeting.cancellationReason,
      'completed_at': meeting.completedAt?.toIso8601String(),
      'latitude': meeting.latitude,
      'longitude': meeting.longitude,
      'contact_phone': meeting.contactPhone,
      'send_reminder': meeting.sendReminder ? 1 : 0,
      'reminder_sent_at': meeting.reminderSentAt?.toIso8601String(),
    };
  }

  Meeting _meetingFromMap(Map<String, dynamic> map) {
    return Meeting(
      id: map['id'],
      customerId: map['customer_id'],
      customerName: map['customer_name'],
      technicianId: map['technician_id'],
      title: map['title'],
      description: map['description'],
      scheduledDate: DateTime.parse(map['scheduled_date']),
      endDate: map['end_date'] != null ? DateTime.parse(map['end_date']) : null,
      location: MeetingLocation.values[map['location']],
      address: map['address'],
      status: MeetingStatus.values[map['status']],
      serviceType: ServiceType.values[map['service_type']],
      priority: Priority.values[map['priority']],
      estimatedDuration: map['estimated_duration']?.toDouble(),
      actualDuration: map['actual_duration']?.toDouble(),
      notes: map['notes'],
      requiredTools: map['required_tools']?.split(',') ?? [],
      requiredParts: map['required_parts']?.split(',') ?? [],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      cancellationReason: map['cancellation_reason'],
      completedAt: map['completed_at'] != null ? DateTime.parse(map['completed_at']) : null,
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      contactPhone: map['contact_phone'],
      sendReminder: (map['send_reminder'] ?? 1) == 1,
      reminderSentAt: map['reminder_sent_at'] != null ? DateTime.parse(map['reminder_sent_at']) : null,
    );
  }

  Map<String, dynamic> _serviceReportToMap(ServiceReport report) {
    return {
      'id': report.id,
      'customer_id': report.customerId,
      'customer_name': report.customerName,
      'technician_id': report.technicianId,
      'technician_name': report.technicianName,
      'meeting_id': report.meetingId,
      'title': report.title,
      'work_description': report.workDescription,
      'service_type': report.serviceType.index,
      'start_time': report.startTime.toIso8601String(),
      'end_time': report.endTime?.toIso8601String(),
      'duration': report.duration,
      'parts_used': report.partsUsed.map((item) => item.toJson()).join('|'),
      'services_performed': report.servicesPerformed.map((item) => item.toJson()).join('|'),
      'before_photos': report.beforePhotos.join(','),
      'after_photos': report.afterPhotos.join(','),
      'additional_photos': report.additionalPhotos.join(','),
      'customer_signature': report.customerSignature,
      'technician_signature': report.technicianSignature,
      'customer_signed_at': report.customerSignedAt?.toIso8601String(),
      'technician_signed_at': report.technicianSignedAt?.toIso8601String(),
      'recommendations': report.recommendations,
      'issue_severity': report.issueSeverity.index,
      'total_cost': report.totalCost,
      'labor_cost': report.laborCost,
      'parts_cost': report.partsCost,
      'created_at': report.createdAt.toIso8601String(),
      'updated_at': report.updatedAt.toIso8601String(),
      'is_completed': report.isCompleted ? 1 : 0,
      'is_synced': report.isSynced ? 1 : 0,
      'follow_up_date': report.followUpDate,
      'warranty_months': report.warrantyMonths,
      'customer_rating': report.customerRating,
      'customer_feedback': report.customerFeedback,
      'notes': report.notes,
      'invoice_number': report.invoiceNumber,
      'is_paid': report.isPaid ? 1 : 0,
      'paid_at': report.paidAt?.toIso8601String(),
    };
  }

  ServiceReport _serviceReportFromMap(Map<String, dynamic> map) {
    // Helper function to parse service items
    List<ServiceItem> parseServiceItems(String? data) {
      if (data == null || data.isEmpty) return [];
      try {
        return data.split('|').map((item) => ServiceItem.fromJson(item as Map<String, dynamic>)).toList();
      } catch (e) {
        return [];
      }
    }

    return ServiceReport(
      id: map['id'],
      customerId: map['customer_id'],
      customerName: map['customer_name'],
      technicianId: map['technician_id'],
      technicianName: map['technician_name'],
      meetingId: map['meeting_id'],
      title: map['title'],
      workDescription: map['work_description'],
      serviceType: ServiceType.values[map['service_type']],
      startTime: DateTime.parse(map['start_time']),
      endTime: map['end_time'] != null ? DateTime.parse(map['end_time']) : null,
      duration: map['duration']?.toDouble(),
      partsUsed: parseServiceItems(map['parts_used']),
      servicesPerformed: parseServiceItems(map['services_performed']),
      beforePhotos: map['before_photos']?.split(',') ?? [],
      afterPhotos: map['after_photos']?.split(',') ?? [],
      additionalPhotos: map['additional_photos']?.split(',') ?? [],
      customerSignature: map['customer_signature'],
      technicianSignature: map['technician_signature'],
      customerSignedAt: map['customer_signed_at'] != null ? DateTime.parse(map['customer_signed_at']) : null,
      technicianSignedAt: map['technician_signed_at'] != null ? DateTime.parse(map['technician_signed_at']) : null,
      recommendations: map['recommendations'],
      issueSeverity: Priority.values[map['issue_severity']],
      totalCost: map['total_cost']?.toDouble(),
      laborCost: map['labor_cost']?.toDouble(),
      partsCost: map['parts_cost']?.toDouble(),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      isCompleted: (map['is_completed'] ?? 0) == 1,
      isSynced: (map['is_synced'] ?? 0) == 1,
      followUpDate: map['follow_up_date'],
      warrantyMonths: map['warranty_months'],
      customerRating: map['customer_rating']?.toDouble(),
      customerFeedback: map['customer_feedback'],
      notes: map['notes'],
      invoiceNumber: map['invoice_number'],
      isPaid: (map['is_paid'] ?? 0) == 1,
      paidAt: map['paid_at'] != null ? DateTime.parse(map['paid_at']) : null,
    );
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
    }
  }
}
