import 'package:flutter/material.dart';
import 'all_meeting.dart';
import 'user_management.dart';
import '../widgets/footer_widget.dart';

class AdministrationScreen extends StatefulWidget {
  const AdministrationScreen({super.key});

  @override
  State<AdministrationScreen> createState() => _AdministrationScreenState();
}

class _AdministrationScreenState extends State<AdministrationScreen> {
  int _selectedTab = 0; // 0 = Analytics Overview, 1 = User Management, 2 = All Meetings

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Welcome Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 20,
                      runSpacing: 16,
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Administration Portal',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A2E),
                                letterSpacing: -1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Manage platform users, view analytics and oversee meetings',
                              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
                          icon: const Icon(Icons.arrow_back_rounded, size: 18),
                          label: const Text('Back to Dashboard'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade100,
                            foregroundColor: const Color(0xFF1A237E),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    _buildTabNavigation(),
                  ],
                ),
            ),

            Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Content based on selected tab
                  if (_selectedTab == 2)
                    const AllMeetingScreen()
                  else if (_selectedTab == 1)
                    const UserManagementScreen()
                  else ...[
                    // Stats cards
                    _buildStatsRow(),
                    const SizedBox(height: 40),
                    // Bottom section: Activity + Trends
                    _buildBottomSection(),
                  ],
                ],
              ),
            ),
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Image.asset('assets/ntc_logo.png', height: 32, width: 32),
          const SizedBox(width: 12),
          const Flexible(
            child: Text(
              'Administration Portal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none, size: 24),
        ),
        const SizedBox(width: 8),
        _buildTopUserAvatar(context),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildTopUserAvatar(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'signout') {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      offset: const Offset(0, 45),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.amber.shade700,
            radius: 16,
            child: const Icon(Icons.person, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 8),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'System Admin',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
              ),
              Text(
                'Administrator',
                style: TextStyle(fontSize: 10, color: Colors.white70),
              ),
            ],
          ),
          const Icon(Icons.arrow_drop_down, color: Colors.white70),
        ],
      ),
      itemBuilder: (_) => [
        const PopupMenuItem(
          value: 'signout',
          child: Row(
            children: [
              Icon(Icons.logout, size: 18, color: Colors.red),
              SizedBox(width: 12),
              Text('Sign Out'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabNavigation() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTabItem('Analytics Overview', Icons.analytics_outlined, 0),
          const SizedBox(width: 12),
          _buildTabItem('User Management', Icons.people_outline, 1),
          const SizedBox(width: 12),
          _buildTabItem('All Meetings', Icons.event_note_outlined, 2),
        ],
      ),
    );
  }

  Widget _buildTabItem(String label, IconData icon, int index) {
    final bool isActive = _selectedTab == index;
    return InkWell(
      onTap: () => setState(() => _selectedTab = index),
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1A237E) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          boxShadow: isActive ? [BoxShadow(color: const Color(0xFF1A237E).withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))] : null,
          border: Border.all(color: isActive ? const Color(0xFF1A237E) : Colors.grey.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? Colors.white : Colors.grey.shade600,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return const Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _StatCard(
          icon: Icons.event_note_rounded,
          iconColor: Color(0xFF1A237E),
          iconBgColor: Color(0xFFE8EAF6),
          label: 'Total Meetings',
          value: '45',
        ),
        _StatCard(
          icon: Icons.auto_graph_rounded,
          iconColor: Color(0xFFF57C00),
          iconBgColor: Color(0xFFFFF3E0),
          label: 'Today',
          value: '1',
        ),
        _StatCard(
          icon: Icons.assignment_late_rounded,
          iconColor: Color(0xFFE53935),
          iconBgColor: Color(0xFFFFEBEE),
          label: 'Pending MOM',
          value: '4',
        ),
        _StatCard(
          icon: Icons.people_alt_rounded,
          iconColor: Color(0xFF8E24AA),
          iconBgColor: Color(0xFFF3E5F5),
          label: 'Registered',
          value: '3598',
        ),
        _StatCard(
          icon: Icons.analytics_rounded,
          iconColor: Color(0xFF455A64),
          iconBgColor: Color(0xFFECEFF1),
          label: 'System Records',
          value: '3598',
        ),
      ],
    );
  }

  Widget _buildBottomSection() {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: [
        // Recent Platform Activity
        Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: _buildRecentActivity(),
        ),
        // Meeting Trends
        Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: _buildMeetingTrends(),
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              const Text(
                'Recent Platform Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 16, color: Colors.grey.shade600),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Scrollable table
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Table header
                Container(
                  width: 1000, // Fixed width for horizontal scrolling
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 250,
                        child: Text(
                          'MEETING TITLE',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: Text(
                          'ORGANIZER',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        child: Text(
                          'STATUS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        child: Text(
                          'SCHEDULED FOR',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Meeting rows
                _buildMeetingRow(
                  title: 'Report finalization- SIP committee',
                  subtitle: 'CCO OFFICE',
                  organizerInitial: 'S',
                  organizerName: 'SUNIL\nSHRESTHA',
                  status: 'Scheduled',
                  statusColor: Colors.orange,
                  date: '5/13/2026',
                ),
                Container(width: 800, height: 1, color: Colors.grey.shade200),
                _buildMeetingRow(
                  title: 'meeting test',
                  subtitle: 'Information Technology Directorate',
                  organizerInitial: 'N',
                  organizerName: 'NIRMAL RAJ\nCHATALI...',
                  status: 'Completed',
                  statusColor: Colors.green,
                  date: '5/12/2026',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingRow({
    required String title,
    required String subtitle,
    required String organizerInitial,
    required String organizerName,
    required String status,
    required Color statusColor,
    required String date,
  }) {
    return Container(
      width: 1000, // Fixed width
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Row(
        children: [
          SizedBox(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 200,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    organizerInitial,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    organizerName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 150,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  status,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 130,
            child: Text(
              date,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 22),
        ],
      ),
    );
  }

  Widget _buildMeetingTrends() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Meeting Trends',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Meetings by Organized Department',
            style: TextStyle(
              fontSize: 13,
              color: Colors.blue.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          _buildTrendBar(label: 'Other', value: 12, maxValue: 12),
          const SizedBox(height: 18),
          _buildTrendBar(
            label: 'INFORMATION TECHNOLOGY DIRECTORATE',
            value: 5,
            maxValue: 12,
          ),
          const SizedBox(height: 18),
          _buildTrendBar(label: 'CCO OFFICE', value: 4, maxValue: 12),
          const SizedBox(height: 18),
          _buildTrendBar(
            label: 'KATHMANDU REGIONAL DIRECTORATE',
            value: 3,
            maxValue: 12,
          ),
        ],
      ),
    );
  }

  Widget _buildTrendBar({
    required String label,
    required int value,
    required int maxValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$value',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: value / maxValue,
            minHeight: 10,
            backgroundColor: Colors.grey.shade100,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1A237E)),
          ),
        ),
      ],
    );
  }
}

// Stat card widget
class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240, // fixed width for wrapping
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
