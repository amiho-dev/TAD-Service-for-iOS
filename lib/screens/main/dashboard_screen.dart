import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/app_config.dart';
import '../../providers/auth_provider.dart';
import '../../providers/customer_provider.dart';
import '../../providers/meeting_provider.dart';
import '../../providers/service_report_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    final customerProvider = Provider.of<CustomerProvider>(context, listen: false);
    final meetingProvider = Provider.of<MeetingProvider>(context, listen: false);
    final reportProvider = Provider.of<ServiceReportProvider>(context, listen: false);

    await Future.wait([
      customerProvider.refreshCustomers(),
      meetingProvider.loadMeetings(),
      reportProvider.loadReports(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              _buildWelcomeCard(),
              
              const SizedBox(height: 16),
              
              // Quick stats
              _buildQuickStats(),
              
              const SizedBox(height: 24),
              
              // Today's meetings
              _buildTodaysMeetings(),
              
              const SizedBox(height: 24),
              
              // Recent reports
              _buildRecentReports(),
              
              const SizedBox(height: 24),
              
              // Quick actions
              _buildQuickActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final now = DateTime.now();
        final hour = now.hour;
        String greeting;
        if (hour < 12) {
          greeting = 'Good Morning';
        } else if (hour < 17) {
          greeting = 'Good Afternoon';
        } else {
          greeting = 'Good Evening';
        }

        return Card(
          elevation: 2,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryColor.withOpacity(0.8),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting,',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  authProvider.technicianName ?? 'Technician',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ready to tackle today\'s service calls?',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: Consumer<MeetingProvider>(
            builder: (context, meetingProvider, child) {
              return _buildStatCard(
                'Today\'s Meetings',
                meetingProvider.todayMeetings.length.toString(),
                Icons.calendar_today,
                AppTheme.primaryColor,
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Consumer<ServiceReportProvider>(
            builder: (context, reportProvider, child) {
              return _buildStatCard(
                'Pending Reports',
                reportProvider.pendingReportsCount.toString(),
                Icons.assignment,
                AppTheme.warningColor,
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Consumer<CustomerProvider>(
            builder: (context, customerProvider, child) {
              return _buildStatCard(
                'Total Customers',
                customerProvider.totalCustomers.toString(),
                Icons.people,
                AppTheme.secondaryColor,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaysMeetings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today\'s Schedule',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // Switch to schedule tab
                // This would need to be implemented with a callback to parent
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Consumer<MeetingProvider>(
          builder: (context, meetingProvider, child) {
            if (meetingProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (meetingProvider.todayMeetings.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.event_available,
                        size: 48,
                        color: AppTheme.textSecondary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No meetings scheduled for today',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: meetingProvider.todayMeetings.take(3).map((meeting) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(meeting.status).withOpacity(0.2),
                      child: Icon(
                        _getServiceIcon(meeting.serviceType),
                        color: _getStatusColor(meeting.status),
                      ),
                    ),
                    title: Text(meeting.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${meeting.customerName} • ${meeting.displayLocation}'),
                        Text(
                          '${_formatTime(meeting.scheduledDate)} • ${meeting.displayServiceType}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    trailing: Chip(
                      label: Text(
                        meeting.displayStatus,
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor: _getStatusColor(meeting.status).withOpacity(0.2),
                      side: BorderSide.none,
                    ),
                    onTap: () {
                      // Navigate to meeting details
                    },
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentReports() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Reports',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // Switch to reports tab
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Consumer<ServiceReportProvider>(
          builder: (context, reportProvider, child) {
            if (reportProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (reportProvider.reports.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        size: 48,
                        color: AppTheme.textSecondary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No service reports yet',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: reportProvider.reports.take(3).map((report) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: report.isCompleted 
                          ? AppTheme.successColor.withOpacity(0.2)
                          : AppTheme.warningColor.withOpacity(0.2),
                      child: Icon(
                        report.isCompleted ? Icons.check_circle : Icons.pending,
                        color: report.isCompleted ? AppTheme.successColor : AppTheme.warningColor,
                      ),
                    ),
                    title: Text(report.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${report.customerName} • ${report.displayServiceType}'),
                        Text(
                          _formatDate(report.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    trailing: report.isCompleted 
                        ? const Icon(Icons.check_circle, color: AppTheme.successColor)
                        : const Icon(Icons.pending, color: AppTheme.warningColor),
                    onTap: () {
                      // Navigate to report details
                    },
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _buildActionCard(
              'Search Customers',
              Icons.person_search,
              AppTheme.primaryColor,
              () {
                // Navigate to customer search
              },
            ),
            _buildActionCard(
              'New Meeting',
              Icons.add_box,
              AppTheme.secondaryColor,
              () {
                // Navigate to new meeting
              },
            ),
            _buildActionCard(
              'Start Report',
              Icons.assignment_add,
              AppTheme.accentColor,
              () {
                // Navigate to new report
              },
            ),
            _buildActionCard(
              'Scan QR Code',
              Icons.qr_code_scanner,
              AppTheme.warningColor,
              () {
                // Open QR scanner
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('QR Scanner coming soon')),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(MeetingStatus status) {
    switch (status) {
      case MeetingStatus.scheduled:
        return AppTheme.primaryColor;
      case MeetingStatus.inProgress:
        return AppTheme.warningColor;
      case MeetingStatus.completed:
        return AppTheme.successColor;
      case MeetingStatus.cancelled:
        return AppTheme.errorColor;
      case MeetingStatus.rescheduled:
        return AppTheme.secondaryColor;
    }
  }

  IconData _getServiceIcon(ServiceType type) {
    switch (type) {
      case ServiceType.installation:
        return Icons.build;
      case ServiceType.maintenance:
        return Icons.settings;
      case ServiceType.repair:
        return Icons.build_circle;
      case ServiceType.inspection:
        return Icons.search;
      case ServiceType.consultation:
        return Icons.chat;
      case ServiceType.emergency:
        return Icons.warning;
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
