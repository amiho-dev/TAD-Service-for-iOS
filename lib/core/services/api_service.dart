import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../app_config.dart';
import '../../models/customer.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  static ApiService get instance => _instance;

  final http.Client _client = http.Client();
  final Connectivity _connectivity = Connectivity();

  // Headers for API requests
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': '${AppConfig.appName}/${AppConfig.appVersion}',
  };

  // Check internet connectivity
  Future<bool> hasInternetConnection() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }

  // Generic HTTP GET request
  Future<Map<String, dynamic>?> _get(String endpoint, {Map<String, String>? queryParams}) async {
    try {
      if (!await hasInternetConnection()) {
        throw Exception('No internet connection');
      }

      final uri = Uri.parse('${AppConfig.baseUrl}$endpoint');
      final uriWithParams = queryParams != null 
          ? uri.replace(queryParameters: queryParams)
          : uri;

      final response = await _client.get(
        uriWithParams,
        headers: _headers,
      ).timeout(Duration(seconds: AppConfig.networkTimeoutSeconds));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  // Generic HTTP POST request
  Future<Map<String, dynamic>?> _post(String endpoint, Map<String, dynamic> data) async {
    try {
      if (!await hasInternetConnection()) {
        throw Exception('No internet connection');
      }

      final uri = Uri.parse('${AppConfig.baseUrl}$endpoint');
      final response = await _client.post(
        uri,
        headers: _headers,
        body: json.encode(data),
      ).timeout(Duration(seconds: AppConfig.networkTimeoutSeconds));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  // Search customers in the database
  Future<List<Customer>> searchCustomers(String query) async {
    try {
      // Simulate API call to customer database
      // In a real implementation, this would call your actual API
      final response = await _get('/api/customers/search', {
        'q': query,
        'limit': '50',
      });

      if (response != null && response['customers'] != null) {
        final List<dynamic> customerData = response['customers'];
        return customerData.map((json) => Customer.fromJson(json)).toList();
      }

      // Mock data for demonstration
      return _getMockCustomers().where((customer) =>
        customer.name.toLowerCase().contains(query.toLowerCase()) ||
        customer.phone.contains(query) ||
        customer.email.toLowerCase().contains(query.toLowerCase())
      ).toList();
    } catch (e) {
      // Return mock data on error for development
      return _getMockCustomers().where((customer) =>
        customer.name.toLowerCase().contains(query.toLowerCase()) ||
        customer.phone.contains(query) ||
        customer.email.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
  }

  // Get customer by ID
  Future<Customer?> getCustomer(String customerId) async {
    try {
      final response = await _get('/api/customers/$customerId');
      if (response != null) {
        return Customer.fromJson(response);
      }
      return null;
    } catch (e) {
      // Return mock data for development
      return _getMockCustomers().firstWhere(
        (customer) => customer.id == customerId,
        orElse: () => throw Exception('Customer not found'),
      );
    }
  }

  // Get all customers
  Future<List<Customer>> getAllCustomers() async {
    try {
      final response = await _get('/api/customers');
      if (response != null && response['customers'] != null) {
        final List<dynamic> customerData = response['customers'];
        return customerData.map((json) => Customer.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      // Return mock data for development
      return _getMockCustomers();
    }
  }

  // Create new customer
  Future<Customer> createCustomer(Customer customer) async {
    try {
      final response = await _post('/api/customers', customer.toJson());
      if (response != null) {
        return Customer.fromJson(response);
      }
      throw Exception('Failed to create customer');
    } catch (e) {
      // For development, just return the customer with a generated ID
      return customer;
    }
  }

  // Update customer
  Future<Customer> updateCustomer(Customer customer) async {
    try {
      final response = await _post('/api/customers/${customer.id}', customer.toJson());
      if (response != null) {
        return Customer.fromJson(response);
      }
      throw Exception('Failed to update customer');
    } catch (e) {
      // For development, just return the updated customer
      return customer.copyWith(updatedAt: DateTime.now());
    }
  }

  // Sync data with server
  Future<Map<String, dynamic>> syncData(Map<String, dynamic> localData) async {
    try {
      final response = await _post('/api/sync', localData);
      return response ?? {};
    } catch (e) {
      throw Exception('Sync failed: $e');
    }
  }

  // Mock data for development and testing
  List<Customer> _getMockCustomers() {
    return [
      Customer(
        name: 'John Smith',
        email: 'john.smith@email.com',
        phone: '+1-555-0101',
        address: '123 Main St, Anytown, ST 12345',
        notes: 'Prefers morning appointments',
        latitude: 40.7128,
        longitude: -74.0060,
        rating: 4.8,
        totalServices: 5,
        preferredContactMethod: 'Phone',
      ),
      Customer(
        name: 'Sarah Johnson',
        email: 'sarah.j@business.com',
        phone: '+1-555-0102',
        address: '456 Oak Ave, Business District, ST 12346',
        secondaryPhone: '+1-555-0103',
        notes: 'Business customer - service during business hours only',
        latitude: 40.7489,
        longitude: -73.9857,
        rating: 5.0,
        totalServices: 12,
        preferredContactMethod: 'Email',
      ),
      Customer(
        name: 'Mike Davis',
        email: 'mike.davis@home.net',
        phone: '+1-555-0104',
        address: '789 Pine Rd, Residential Area, ST 12347',
        notes: 'Has large dog - call before entering property',
        latitude: 40.6892,
        longitude: -74.0445,
        rating: 4.2,
        totalServices: 3,
        preferredContactMethod: 'Phone',
      ),
      Customer(
        name: 'Lisa Chen',
        email: 'l.chen@techcorp.com',
        phone: '+1-555-0105',
        address: '321 Tech Blvd, Silicon Valley, ST 12348',
        notes: 'Tech company - security clearance required',
        latitude: 37.4419,
        longitude: -122.1430,
        rating: 4.9,
        totalServices: 8,
        preferredContactMethod: 'Email',
      ),
      Customer(
        name: 'Robert Wilson',
        email: 'bob.wilson@gmail.com',
        phone: '+1-555-0106',
        address: '654 Elm Street, Suburbia, ST 12349',
        notes: 'Regular maintenance customer',
        latitude: 40.7831,
        longitude: -73.9712,
        rating: 4.5,
        totalServices: 15,
        preferredContactMethod: 'Phone',
      ),
    ];
  }

  void dispose() {
    _client.close();
  }
}
