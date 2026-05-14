import 'package:flutter/material.dart';
import 'scheduled_meeting.dart';
import 'buttons_in.dart';
import '../widgets/footer_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedMeetingTab = 0;
  final List<String> _tabs = [
    'Upcoming',
    'All Meetings',
    'Created by Me',
    'Invited To',
    'Past',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/ntc_logo.png', height: 32, width: 32),
            const SizedBox(width: 12),
            const Flexible(
              child: Text(
                'NT Meeting Portal',
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(context),
            const SizedBox(height: 20),
            _buildStatsRow(),
            const SizedBox(height: 24),
            _buildMeetingsSection(context),
            const SizedBox(height: 40),
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  // ─── AppBar ──────────────────────────────────────────────────────────────────

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

  // ─── Welcome Card ─────────────────────────────────────────────────────────

  Widget _buildWelcomeCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF1A237E), Colors.blue.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A237E).withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 24,
            runSpacing: 20,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back, System Admin 👋',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You have 3 meetings scheduled for today. Ready to start?',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ScheduledMeetingScreen()),
                ),
                icon: const Icon(Icons.add_rounded, size: 20),
                label: const Text('New Meeting'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1A237E),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              _buildNavButton(context, 'Dashboard', Icons.dashboard_rounded, true),
              const SizedBox(width: 12),
              _buildNavButton(context, 'Administration', Icons.admin_panel_settings_rounded, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, String label, IconData icon, bool active) {
    return InkWell(
      onTap: !active ? () => Navigator.pushReplacementNamed(context, '/administration') : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: active ? Colors.white.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active ? Colors.white.withValues(alpha: 0.3) : Colors.white24,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Stats Row ────────────────────────────────────────────────────────────

  Widget _buildStatsRow() {
    return const Wrap(
      spacing: 14,
      runSpacing: 14,
      children: [
        _StatCard(
          icon: Icons.event_note,
          iconColor: Color(0xFF1A237E),
          iconBg: Color(0xFFE8EAF6),
          accentColor: Color(0xFF1A237E),
          label: 'Total Meetings',
          value: '17',
        ),
        _StatCard(
          icon: Icons.calendar_today,
          iconColor: Color(0xFFF57C00), // Colors.orange.shade700
          iconBg: Color(0xFFFFF3E0),    // Colors.orange.shade50
          accentColor: Color(0xFFFB8C00), // Colors.orange.shade600
          label: 'Upcoming',
          value: '0',
        ),
        _StatCard(
          icon: Icons.check_circle_outline,
          iconColor: Color(0xFF388E3C), // Colors.green.shade700
          iconBg: Color(0xFFE8F5E9),    // Colors.green.shade50
          accentColor: Color(0xFF43A047), // Colors.green.shade600
          label: 'Completed',
          value: '10',
        ),
      ],
    );
  }

  // ─── Meetings Section ─────────────────────────────────────────────────────

  Widget _buildMeetingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row: "Meetings [count]" + tabs
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.spaceBetween,
          spacing: 20,
          runSpacing: 16,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title + count badge
                const Text(
                  'Meetings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '0',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ),
              ],
            ),
            // Tabs on the right
            _buildTabRow(),
          ],
        ),
        const SizedBox(height: 18),
        // Empty state
        EmptyMeetingSection(
          onSchedule: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ScheduledMeetingScreen()),
          ),
        ),
      ],
    );
  }

  Widget _buildTabRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_tabs.length, (i) {
          final isActive = _selectedMeetingTab == i;
          return Padding(
            padding: const EdgeInsets.only(left: 6),
            child: InkWell(
              onTap: () => setState(() => _selectedMeetingTab = i),
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF1A237E) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive ? const Color(0xFF1A237E) : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  _tabs[i],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive ? Colors.white : Colors.grey.shade700,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─── Stat Card Widget ─────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final Color accentColor;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.accentColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
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
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: iconBg,
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
                    fontSize: 13,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
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
