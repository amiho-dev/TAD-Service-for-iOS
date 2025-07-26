# TAD Service - Professional Service Management App

A comprehensive Flutter application designed for field service technicians, featuring customer management, meeting scheduling, service reporting, and digital signatures.

## Features

### Core Functionality
- **Customer Search & Database Integration**: Real-time customer search with API sync
- **Meeting Scheduler**: Schedule appointments at shop or customer locations
- **Service Report Generation**: Comprehensive reports with photos and signatures
- **Digital Signature Capture**: Customer and technician signatures for work confirmation

### Enhanced Features
- **Offline Mode**: Continue working without internet connection
- **GPS Navigation**: Navigate to customer locations
- **Photo Attachments**: Before/after photos for service documentation
- **Push Notifications**: Meeting reminders and follow-up alerts
- **Invoice Generation**: PDF reports with embedded signatures
- **Analytics Dashboard**: Service history and performance metrics

### Business Intelligence
- Service history timeline per customer
- Revenue tracking and reporting
- Technician performance metrics
- Customer rating system

## Technical Specifications

- **Framework**: Flutter 3.10+
- **Target Platform**: iOS 16.7+ (iPhone 8 compatible)
- **Database**: SQLite with REST API sync
- **Architecture**: Provider pattern for state management
- **Offline Support**: Local storage with cloud synchronization

## Prerequisites

1. **Flutter SDK**: Install Flutter 3.10 or later
   ```bash
   # Download from https://flutter.dev/docs/get-started/install
   flutter --version
   ```

2. **Development Environment**:
   - Visual Studio Code with Flutter extension
   - Android Studio (for Android development)
   - Xcode (for iOS development - Mac required for final deployment)

## Installation & Setup

### 1. Install Flutter (Windows)

```powershell
# Download Flutter SDK
# Extract to C:\flutter
# Add C:\flutter\bin to PATH environment variable

# Verify installation
flutter doctor
```

### 2. Clone and Setup Project

```bash
# Navigate to project directory
cd "C:\Users\amiho\Documents\TAD Service"

# Get dependencies
flutter pub get

# Run code generation (if needed)
flutter packages pub run build_runner build
```

### 3. Configure Development Environment

For **Android Development**:
```bash
# Enable developer options on Android device
# Enable USB debugging
# Connect device via USB

# Check connected devices
flutter devices

# Run on Android
flutter run
```

For **iOS Development** (requires Mac for final steps):
```bash
# Install Xcode on Mac
# Open ios/Runner.xcworkspace in Xcode
# Configure signing certificate
# Connect iOS device

# Run on iOS (from Mac)
flutter run
```

### 4. API Configuration

Update the API endpoint in `lib/core/app_config.dart`:

```dart
static const String baseUrl = 'https://your-api-endpoint.com';
static const String customerDatabaseEndpoint = '/api/customers';
```

## Project Structure

```
lib/
├── core/
│   ├── app_config.dart          # App configuration and constants
│   ├── theme/
│   │   └── app_theme.dart       # App theming and colors
│   └── services/
│       ├── api_service.dart     # REST API integration
│       ├── database_service.dart # Local SQLite database
│       └── notification_service.dart # Push notifications
├── models/
│   ├── customer.dart            # Customer data model
│   ├── meeting.dart             # Meeting/appointment model
│   └── service_report.dart      # Service report model
├── providers/
│   ├── auth_provider.dart       # Authentication state
│   ├── customer_provider.dart   # Customer management
│   ├── meeting_provider.dart    # Meeting scheduling
│   └── service_report_provider.dart # Report management
├── screens/
│   ├── auth/
│   │   └── login_screen.dart    # Login interface
│   ├── main/
│   │   ├── dashboard_screen.dart # Main dashboard
│   │   ├── customer_search_screen.dart # Customer search
│   │   ├── meeting_scheduler_screen.dart # Meeting scheduling
│   │   └── service_reports_screen.dart # Report management
│   └── splash_screen.dart       # App launch screen
└── main.dart                    # App entry point
```

## Building for Production

### Android APK
```bash
# Build release APK
flutter build apk --release

# Install on device
flutter install
```

### iOS IPA (requires Mac + Xcode)
```bash
# Build for iOS
flutter build ios --release

# Archive in Xcode
# Upload to App Store Connect
```

### Alternative iOS Build (Cloud Services)
Use services like Codemagic or GitHub Actions for iOS builds without Mac:

1. **Codemagic**: 
   - Connect GitHub repository
   - Configure iOS certificates
   - Automatic build and distribution

2. **GitHub Actions**:
   - Use macOS runners
   - Configure secrets for certificates
   - Automated CI/CD pipeline

## Key Dependencies

```yaml
dependencies:
  flutter: sdk: flutter
  
  # State Management
  provider: ^6.1.1
  
  # HTTP & API
  http: ^1.1.0
  dio: ^5.3.3
  
  # Local Storage
  sqflite: ^2.3.0
  shared_preferences: ^2.2.2
  
  # UI Components
  cached_network_image: ^3.3.0
  image_picker: ^1.0.4
  signature: ^5.4.0
  
  # Maps & Location
  geolocator: ^10.1.0
  geocoding: ^2.1.1
  
  # Notifications
  flutter_local_notifications: ^16.3.0
  
  # PDF Generation
  pdf: ^3.10.7
  printing: ^5.11.0
```

## Demo Credentials

For testing purposes, use any username and password with at least 6 characters.

**Example**:
- Username: `technician1`
- Password: `password123`

## API Integration

The app is designed to integrate with your existing customer database. Update the API endpoints in `app_config.dart`:

```dart
// Customer database integration
static const String baseUrl = 'https://thatoneamiho.cc';
static const String customerDatabaseEndpoint = '/customer-database.html';
```

Implement the following endpoints on your server:
- `GET /api/customers/search?q={query}` - Search customers
- `GET /api/customers/{id}` - Get customer details
- `POST /api/customers` - Create new customer
- `PUT /api/customers/{id}` - Update customer

## Features Roadmap

### Phase 1 (Current)
- ✅ Basic app structure
- ✅ Customer search interface
- ✅ Authentication system
- ✅ Dashboard with statistics

### Phase 2 (Next)
- 🔄 Meeting scheduler implementation
- 🔄 Service report creation
- 🔄 Digital signature capture
- 🔄 Photo attachment system

### Phase 3 (Future)
- 📋 PDF generation
- 📋 Offline synchronization
- 📋 GPS navigation integration
- 📋 Advanced analytics

## Support

For technical support or questions:
- **Email**: support@tadservice.com
- **Phone**: +1-555-0123

## License

This project is proprietary software developed for TAD Service.

---

## Quick Start Commands

```bash
# Install dependencies
flutter pub get

# Run on connected device
flutter run

# Build for Android
flutter build apk --release

# Run tests
flutter test

# Generate icons
flutter packages pub run flutter_launcher_icons:main

# Clean build
flutter clean && flutter pub get
```

## Troubleshooting

### Common Issues

1. **Flutter Doctor Issues**:
   ```bash
   flutter doctor -v
   # Follow recommendations to fix issues
   ```

2. **Dependency Conflicts**:
   ```bash
   flutter clean
   flutter pub get
   ```

3. **iOS Build Issues**:
   - Ensure Xcode is updated
   - Check provisioning profiles
   - Verify bundle identifier

4. **Android Build Issues**:
   - Update Android SDK
   - Check Gradle version compatibility
   - Verify minimum SDK version (21+)

The app is designed to work perfectly on iPhone 8 (iOS 16.7+) and provides a professional, user-friendly interface for field service management.
