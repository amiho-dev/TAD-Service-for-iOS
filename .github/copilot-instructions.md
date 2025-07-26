<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

# TAD Service Flutter App - Copilot Instructions

## Project Overview
This is a professional Flutter service management application designed for field technicians. The app features customer management, meeting scheduling, service reporting, and digital signatures, optimized for iOS 16.7+ (iPhone 8 compatible).

## Code Style & Architecture

### Flutter Best Practices
- Use Provider pattern for state management
- Implement proper error handling with try-catch blocks
- Follow Material Design 3 guidelines
- Ensure accessibility compliance
- Use const constructors where possible
- Implement proper null safety

### File Organization
- Models: Data classes with JSON serialization
- Providers: State management with ChangeNotifier
- Services: API calls, database operations, utilities
- Screens: UI components organized by feature
- Core: Configuration, themes, constants

### Naming Conventions
- Files: snake_case (e.g., `customer_provider.dart`)
- Classes: PascalCase (e.g., `CustomerProvider`)
- Variables/Functions: camelCase (e.g., `searchCustomers`)
- Constants: UPPER_SNAKE_CASE (e.g., `API_TIMEOUT`)

## Technical Guidelines

### State Management
- Use Provider for app-wide state
- Implement proper loading states
- Handle errors gracefully with user-friendly messages
- Use Consumer widgets for UI updates

### Database Operations
- All database operations should be async
- Implement proper error handling
- Use transactions for related operations
- Include offline-first approach

### API Integration
- Implement timeout handling (30 seconds)
- Provide fallback to local data when API fails
- Use proper HTTP status code handling
- Implement retry logic for failed requests

### UI/UX Requirements
- Large, touch-friendly buttons (minimum 48dp)
- Professional color scheme (green primary, blue secondary)
- Support both light and dark themes
- Optimize for field work (outdoor visibility)
- Implement proper loading and error states

### Performance Optimization
- Optimize for iPhone 8 and older devices
- Use lazy loading for lists
- Implement image caching
- Minimize memory usage
- Use efficient data structures

### Security Considerations
- Validate all user inputs
- Sanitize data before database operations
- Implement proper authentication
- Secure sensitive data storage
- Use HTTPS for all API calls

## Feature-Specific Guidelines

### Customer Search
- Implement debounced search (300ms delay)
- Support search by name, phone, email
- Show recent customers when search is empty
- Provide autocomplete suggestions

### Meeting Scheduler
- Support both "At Shop" and "Customer Location"
- Implement reminder notifications
- Allow meeting status updates
- Include GPS navigation integration

### Service Reports
- Support photo attachments (before/after)
- Implement digital signature capture
- Generate PDF reports
- Include time tracking
- Support offline creation

### Digital Signatures
- Use signature pad widget
- Save as base64 encoded images
- Include timestamp and metadata
- Support both customer and technician signatures

## Error Handling Patterns

```dart
try {
  final result = await apiService.getData();
  // Handle success
} catch (e) {
  // Log error
  debugPrint('Error: $e');
  // Show user-friendly message
  _showErrorSnackBar('Failed to load data. Please try again.');
  // Update UI state
  setState(() {
    _isLoading = false;
    _error = 'Something went wrong';
  });
}
```

## Common Widget Patterns

### Loading States
```dart
if (isLoading) {
  return const Center(child: CircularProgressIndicator());
}
```

### Empty States
```dart
if (items.isEmpty) {
  return const EmptyStateWidget(
    icon: Icons.inbox,
    title: 'No items found',
    subtitle: 'Add items to get started',
  );
}
```

### Error States
```dart
if (error != null) {
  return ErrorWidget(
    error: error!,
    onRetry: () => loadData(),
  );
}
```

## Dependencies Usage

### Provider Pattern
```dart
// In Widget
Consumer<CustomerProvider>(
  builder: (context, provider, child) {
    return ListView.builder(
      itemCount: provider.customers.length,
      itemBuilder: (context, index) => CustomerCard(provider.customers[index]),
    );
  },
)

// Access provider
final provider = Provider.of<CustomerProvider>(context, listen: false);
await provider.searchCustomers(query);
```

### Database Operations
```dart
// Insert
await DatabaseService.instance.insertCustomer(customer);

// Query
final customers = await DatabaseService.instance.searchCustomers(query);

// Update
await DatabaseService.instance.updateCustomer(customer);
```

### API Calls
```dart
// With error handling
try {
  final customers = await ApiService.instance.searchCustomers(query);
} catch (e) {
  // Fallback to local data
  final customers = await DatabaseService.instance.searchCustomers(query);
}
```

## Testing Guidelines
- Write unit tests for business logic
- Test error scenarios
- Mock external dependencies
- Test offline functionality
- Verify UI responsiveness

## Platform-Specific Considerations

### iOS Optimization
- Test on iPhone 8 specifically
- Ensure iOS 16.7+ compatibility
- Use proper iOS design patterns
- Handle permission requests gracefully

### Android Compatibility
- Support API level 21+
- Handle different screen sizes
- Test on various Android versions
- Implement proper back navigation

## Accessibility Requirements
- Provide semantic labels
- Support screen readers
- Ensure proper contrast ratios
- Implement keyboard navigation
- Add proper focus management

When implementing new features, always consider offline functionality, error handling, and user experience optimization for field technicians working in various conditions.
