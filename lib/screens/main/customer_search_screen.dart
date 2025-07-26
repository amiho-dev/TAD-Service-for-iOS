import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/customer_provider.dart';
import '../../models/customer.dart';

class CustomerSearchScreen extends StatefulWidget {
  const CustomerSearchScreen({super.key});

  @override
  State<CustomerSearchScreen> createState() => _CustomerSearchScreenState();
}

class _CustomerSearchScreenState extends State<CustomerSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.trim().isEmpty) {
      Provider.of<CustomerProvider>(context, listen: false).clearSearchResults();
      setState(() {
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Debounce search
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_searchController.text == query && mounted) {
        Provider.of<CustomerProvider>(context, listen: false).searchCustomers(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search customers by name, phone, or email...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppTheme.backgroundColor,
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          
          // Results
          Expanded(
            child: Consumer<CustomerProvider>(
              builder: (context, customerProvider, child) {
                if (customerProvider.isSearching) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (_searchController.text.isEmpty) {
                  return _buildRecentCustomers(customerProvider);
                }

                if (customerProvider.searchResults.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildSearchResults(customerProvider.searchResults);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentCustomers(CustomerProvider customerProvider) {
    final recentCustomers = customerProvider.recentCustomers;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Customers',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          if (recentCustomers.isEmpty)
            _buildEmptyState()
          else
            ...recentCustomers.map((customer) => _buildCustomerCard(customer)),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<Customer> customers) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: customers.length,
      itemBuilder: (context, index) {
        return _buildCustomerCard(customers[index]);
      },
    );
  }

  Widget _buildCustomerCard(Customer customer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
          child: Text(
            customer.initials,
            style: const TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          customer.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.phone, size: 16, color: AppTheme.textSecondary),
                const SizedBox(width: 4),
                Text(customer.phone),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: AppTheme.textSecondary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    customer.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (customer.totalServices > 0) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.history, size: 16, color: AppTheme.textSecondary),
                  const SizedBox(width: 4),
                  Text('${customer.totalServices} service${customer.totalServices == 1 ? '' : 's'}'),
                  if (customer.rating > 0) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.star, size: 16, color: AppTheme.warningColor),
                    const SizedBox(width: 2),
                    Text(customer.rating.toStringAsFixed(1)),
                  ],
                ],
              ),
            ],
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'call':
                // TODO: Implement call functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Calling ${customer.name}...')),
                );
                break;
              case 'schedule':
                // TODO: Navigate to schedule meeting
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Schedule meeting feature coming soon')),
                );
                break;
              case 'report':
                // TODO: Navigate to create report
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Create report feature coming soon')),
                );
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'call',
              child: ListTile(
                leading: Icon(Icons.phone),
                title: Text('Call'),
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'schedule',
              child: ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text('Schedule Meeting'),
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'report',
              child: ListTile(
                leading: Icon(Icons.assignment),
                title: Text('Create Report'),
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        onTap: () {
          // TODO: Navigate to customer details
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Opening ${customer.name} details...')),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: AppTheme.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isEmpty 
                  ? 'No customers found' 
                  : 'No customers match your search',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _searchController.text.isEmpty
                  ? 'Add customers to get started'
                  : 'Try searching with a different term',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
