import 'package:flutter/foundation.dart';
import '../models/customer.dart';
import '../core/services/api_service.dart';
import '../core/services/database_service.dart';

class CustomerProvider with ChangeNotifier {
  final ApiService _apiService = ApiService.instance;
  final DatabaseService _databaseService = DatabaseService.instance;

  List<Customer> _customers = [];
  List<Customer> _searchResults = [];
  Customer? _selectedCustomer;
  bool _isLoading = false;
  bool _isSearching = false;
  String? _error;
  String _lastSearchQuery = '';

  List<Customer> get customers => _customers;
  List<Customer> get searchResults => _searchResults;
  Customer? get selectedCustomer => _selectedCustomer;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get error => _error;
  String get lastSearchQuery => _lastSearchQuery;

  CustomerProvider() {
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Try to load from API first, then fallback to local database
      try {
        _customers = await _apiService.getAllCustomers();
        
        // Update local database with latest data
        for (final customer in _customers) {
          await _databaseService.insertCustomer(customer);
        }
      } catch (apiError) {
        // Fallback to local database
        _customers = await _databaseService.getAllCustomers();
        debugPrint('API error, using local data: $apiError');
      }
    } catch (e) {
      _error = 'Failed to load customers: $e';
      debugPrint('Error loading customers: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchCustomers(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      _lastSearchQuery = '';
      notifyListeners();
      return;
    }

    _isSearching = true;
    _lastSearchQuery = query;
    notifyListeners();

    try {
      // Search in API first, then local database
      try {
        _searchResults = await _apiService.searchCustomers(query);
      } catch (apiError) {
        // Fallback to local search
        _searchResults = await _databaseService.searchCustomers(query);
        debugPrint('API search error, using local search: $apiError');
      }
    } catch (e) {
      _error = 'Search failed: $e';
      _searchResults = [];
      debugPrint('Error searching customers: $e');
    }

    _isSearching = false;
    notifyListeners();
  }

  Future<void> selectCustomer(String customerId) async {
    try {
      // Try to get from API first, then local database
      try {
        _selectedCustomer = await _apiService.getCustomer(customerId);
      } catch (apiError) {
        _selectedCustomer = await _databaseService.getCustomer(customerId);
        debugPrint('API error getting customer, using local data: $apiError');
      }
    } catch (e) {
      _error = 'Failed to load customer details: $e';
      debugPrint('Error selecting customer: $e');
    }

    notifyListeners();
  }

  void clearSelectedCustomer() {
    _selectedCustomer = null;
    notifyListeners();
  }

  Future<bool> createCustomer(Customer customer) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Try to create via API first
      Customer createdCustomer;
      try {
        createdCustomer = await _apiService.createCustomer(customer);
      } catch (apiError) {
        // Fallback to local creation
        createdCustomer = customer;
        debugPrint('API error creating customer, saving locally: $apiError');
      }

      // Save to local database
      await _databaseService.insertCustomer(createdCustomer);

      // Update local list
      _customers.insert(0, createdCustomer);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to create customer: $e';
      _isLoading = false;
      notifyListeners();
      debugPrint('Error creating customer: $e');
      return false;
    }
  }

  Future<bool> updateCustomer(Customer customer) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Try to update via API first
      Customer updatedCustomer;
      try {
        updatedCustomer = await _apiService.updateCustomer(customer);
      } catch (apiError) {
        // Fallback to local update
        updatedCustomer = customer.copyWith(updatedAt: DateTime.now());
        debugPrint('API error updating customer, saving locally: $apiError');
      }

      // Update local database
      await _databaseService.updateCustomer(updatedCustomer);

      // Update local lists
      final index = _customers.indexWhere((c) => c.id == updatedCustomer.id);
      if (index != -1) {
        _customers[index] = updatedCustomer;
      }

      final searchIndex = _searchResults.indexWhere((c) => c.id == updatedCustomer.id);
      if (searchIndex != -1) {
        _searchResults[searchIndex] = updatedCustomer;
      }

      if (_selectedCustomer?.id == updatedCustomer.id) {
        _selectedCustomer = updatedCustomer;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to update customer: $e';
      _isLoading = false;
      notifyListeners();
      debugPrint('Error updating customer: $e');
      return false;
    }
  }

  Future<bool> deleteCustomer(String customerId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Delete from local database
      await _databaseService.deleteCustomer(customerId);

      // Remove from local lists
      _customers.removeWhere((c) => c.id == customerId);
      _searchResults.removeWhere((c) => c.id == customerId);

      if (_selectedCustomer?.id == customerId) {
        _selectedCustomer = null;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to delete customer: $e';
      _isLoading = false;
      notifyListeners();
      debugPrint('Error deleting customer: $e');
      return false;
    }
  }

  Future<void> refreshCustomers() async {
    await loadCustomers();
  }

  void clearSearchResults() {
    _searchResults = [];
    _lastSearchQuery = '';
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Get customers with recent service history
  List<Customer> get recentCustomers {
    final recent = List<Customer>.from(_customers);
    recent.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return recent.take(10).toList();
  }

  // Get customers by rating
  List<Customer> get topRatedCustomers {
    final rated = _customers.where((c) => c.rating > 0).toList();
    rated.sort((a, b) => b.rating.compareTo(a.rating));
    return rated;
  }

  // Get frequently serviced customers
  List<Customer> get frequentCustomers {
    final frequent = _customers.where((c) => c.totalServices > 0).toList();
    frequent.sort((a, b) => b.totalServices.compareTo(a.totalServices));
    return frequent.take(10).toList();
  }

  // Statistics
  int get totalCustomers => _customers.length;
  int get activeCustomers => _customers.where((c) => c.isActive).length;
  double get averageRating {
    final ratedCustomers = _customers.where((c) => c.rating > 0);
    if (ratedCustomers.isEmpty) return 0.0;
    return ratedCustomers.map((c) => c.rating).reduce((a, b) => a + b) / ratedCustomers.length;
  }
}
