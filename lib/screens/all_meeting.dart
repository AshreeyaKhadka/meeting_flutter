import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// --- Meeting Model ---
class Meeting {
  final String title;
  final String agenda;
  final String organizerName;
  final String department;
  final String organization;
  final String status; // 'Scheduled', 'Completed', 'Cancelled'
  final DateTime dateTime;
  final int memberCount;

  const Meeting({
    required this.title,
    required this.agenda,
    required this.organizerName,
    required this.department,
    required this.organization,
    required this.status,
    required this.dateTime,
    required this.memberCount,
  });
}

// --- Mock Data ---
final List<Meeting> _allMeetings = [
  Meeting(
    title: 'Final Test of Hierarchy',
    agenda: '1. test of MOM 2. Test of hierarchy and seniori...',
    organizerName: 'MURARI SHARMA',
    department: 'INFORMATION TECHNOLOGY DIRECTORATE',
    organization: 'Nepal Telecom',
    status: 'Scheduled',
    dateTime: DateTime(2026, 5, 1, 12, 0),
    memberCount: 5,
  ),
  Meeting(
    title: 'final schedule',
    agenda: 'fdsjfdshbhfdkshf',
    organizerName: 'MURARI SHARMA',
    department: 'INFORMATION TECHNOLOGY DIRECTORATE',
    organization: 'Nepal Telecom',
    status: 'Completed',
    dateTime: DateTime(2026, 4, 30, 11, 0),
    memberCount: 1,
  ),
  Meeting(
    title: 'second after migration',
    agenda: 'test',
    organizerName: 'MURARI SHARMA',
    department: 'INFORMATION TECHNOLOGY DIRECTORATE',
    organization: 'Nepal Telecom',
    status: 'Completed',
    dateTime: DateTime(2026, 4, 30, 10, 0),
    memberCount: 1,
  ),
  Meeting(
    title: 'test meeting',
    agenda: 'dsjklfhdshrjkdshf',
    organizerName: 'MURARI SHARMA',
    department: 'INFORMATION TECHNOLOGY DIRECTORATE',
    organization: 'Nepal Telecom',
    status: 'Completed',
    dateTime: DateTime(2026, 4, 9, 17, 48),
    memberCount: 1,
  ),
  Meeting(
    title: 'Report finalization- SIP committee',
    agenda: 'Finalize quarterly SIP report',
    organizerName: 'SUNIL SHRESTHA',
    department: 'CCO OFFICE',
    organization: 'Nepal Telecom',
    status: 'Scheduled',
    dateTime: DateTime(2026, 5, 13, 10, 0),
    memberCount: 3,
  ),
  Meeting(
    title: 'Budget Review Meeting',
    agenda: 'Review Q3 budget allocations',
    organizerName: 'NIRMAL RAJ CHATALI',
    department: 'FINANCE DIRECTORATE',
    organization: 'Nepal Telecom',
    status: 'Completed',
    dateTime: DateTime(2026, 3, 15, 14, 0),
    memberCount: 8,
  ),
  Meeting(
    title: 'Network Expansion Planning',
    agenda: 'Plan fiber expansion for Province 2',
    organizerName: 'RAMESH ADHIKARI',
    department: 'KATHMANDU REGIONAL DIRECTORATE',
    organization: 'Nepal Telecom',
    status: 'Completed',
    dateTime: DateTime(2026, 2, 20, 11, 30),
    memberCount: 6,
  ),
  Meeting(
    title: 'HR Policy Update Discussion',
    agenda: 'Discuss new employee welfare policies',
    organizerName: 'SITA DEVI THAPA',
    department: 'HUMAN RESOURCE DIRECTORATE',
    organization: 'Nepal Telecom',
    status: 'Cancelled',
    dateTime: DateTime(2026, 3, 5, 15, 0),
    memberCount: 4,
  ),
  Meeting(
    title: 'Cybersecurity Awareness Training',
    agenda: 'Mandatory security training for all IT staff',
    organizerName: 'MURARI SHARMA',
    department: 'INFORMATION TECHNOLOGY DIRECTORATE',
    organization: 'Nepal Telecom',
    status: 'Completed',
    dateTime: DateTime(2026, 1, 18, 9, 0),
    memberCount: 12,
  ),
  Meeting(
    title: 'Annual Performance Review',
    agenda: 'Review performance metrics for FY 2025/26',
    organizerName: 'SUNIL SHRESTHA',
    department: 'CCO OFFICE',
    organization: 'NTC Subsidiary',
    status: 'Scheduled',
    dateTime: DateTime(2026, 5, 20, 10, 0),
    memberCount: 10,
  ),
];

// --- Main Widget ---
class AllMeetingScreen extends StatefulWidget {
  const AllMeetingScreen({super.key});

  @override
  State<AllMeetingScreen> createState() => _AllMeetingScreenState();
}

class _AllMeetingScreenState extends State<AllMeetingScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedStatus = 'All';
  String _selectedDepartment = 'All';
  String _selectedOrganization = 'All';
  String _sortBy = 'date_desc';

  List<Meeting> get _filteredMeetings {
    List<Meeting> results = List.from(_allMeetings);

    // Search filter
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      results = results.where((m) {
        return m.title.toLowerCase().contains(q) ||
            m.agenda.toLowerCase().contains(q) ||
            m.organizerName.toLowerCase().contains(q) ||
            m.department.toLowerCase().contains(q) ||
            m.organization.toLowerCase().contains(q);
      }).toList();
    }

    // Status filter
    if (_selectedStatus != 'All') {
      results = results.where((m) => m.status == _selectedStatus).toList();
    }

    // Department filter
    if (_selectedDepartment != 'All') {
      results =
          results.where((m) => m.department == _selectedDepartment).toList();
    }

    // Organization filter
    if (_selectedOrganization != 'All') {
      results = results
          .where((m) => m.organization == _selectedOrganization)
          .toList();
    }

    // Sort
    if (_sortBy == 'date_desc') {
      results.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    } else if (_sortBy == 'date_asc') {
      results.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    } else if (_sortBy == 'title') {
      results.sort((a, b) => a.title.compareTo(b.title));
    } else if (_sortBy == 'members') {
      results.sort((a, b) => b.memberCount.compareTo(a.memberCount));
    }

    return results;
  }

  List<String> get _departments {
    final deps = _allMeetings.map((m) => m.department).toSet().toList();
    deps.sort();
    return ['All', ...deps];
  }

  List<String> get _organizations {
    final orgs = _allMeetings.map((m) => m.organization).toSet().toList();
    orgs.sort();
    return ['All', ...orgs];
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedStatus = 'All';
      _selectedDepartment = 'All';
      _selectedOrganization = 'All';
      _sortBy = 'date_desc';
    });
  }

  bool get _hasActiveFilters =>
      _searchQuery.isNotEmpty ||
      _selectedStatus != 'All' ||
      _selectedDepartment != 'All' ||
      _selectedOrganization != 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredMeetings;
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(32),
            child: Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'All Platform Meetings (${filtered.length})',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Overview of all meetings scheduled on the platform',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                    ),
                  ],
                ),
                SizedBox(
                  width: 320,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: 'Search by title or organizer...',
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      filled: true,
                      fillColor: const Color(0xFFFBFBFB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade100),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: _buildFilterRow(),
          ),
          const SizedBox(height: 24),

          // Scrollable table section
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1000, // Fixed width for horizontal scrolling
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBFBFB),
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade100),
                        bottom: BorderSide(color: Colors.grey.shade100),
                      ),
                    ),
                    child: Row(
                      children: [
                        _tableHeader('TITLE / AGENDA', 3),
                        _tableHeader('ORGANIZER', 3),
                        _tableHeader('STATUS', 2),
                        _tableHeader('DATE & TIME', 2),
                        _tableHeader('MEMBERS', 1),
                        _tableHeader('ACTIONS', 1),
                      ],
                    ),
                  ),
                  // Meeting rows
                  if (filtered.isEmpty)
                    _buildEmptyState()
                  else
                    ...filtered.map((m) => _buildMeetingRow(m)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Status chips
        ..._buildStatusChips(),
        const SizedBox(width: 4),
        // Department dropdown
        _buildDropdownFilter(
          label: 'Department',
          value: _selectedDepartment,
          items: _departments,
          onChanged: (v) => setState(() => _selectedDepartment = v ?? 'All'),
        ),
        // Organization dropdown
        _buildDropdownFilter(
          label: 'Organization',
          value: _selectedOrganization,
          items: _organizations,
          onChanged: (v) => setState(() => _selectedOrganization = v ?? 'All'),
        ),
        // Sort dropdown
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _sortBy,
              isDense: true,
              icon: Icon(Icons.sort, size: 16, color: Colors.grey.shade600),
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              items: const [
                DropdownMenuItem(
                  value: 'date_desc',
                  child: Text('Newest First'),
                ),
                DropdownMenuItem(
                  value: 'date_asc',
                  child: Text('Oldest First'),
                ),
                DropdownMenuItem(value: 'title', child: Text('By Title')),
                DropdownMenuItem(value: 'members', child: Text('By Members')),
              ],
              onChanged: (v) => setState(() => _sortBy = v ?? 'date_desc'),
            ),
          ),
        ),
        if (_hasActiveFilters)
          TextButton.icon(
            onPressed: _clearFilters,
            icon: const Icon(Icons.clear_all, size: 16),
            label: const Text('Clear Filters', style: TextStyle(fontSize: 12)),
            style: TextButton.styleFrom(foregroundColor: Colors.red.shade400),
          ),
      ],
    );
  }

  List<Widget> _buildStatusChips() {
    const statuses = ['All', 'Scheduled', 'Completed', 'Cancelled'];
    return statuses.map((s) {
      final isActive = _selectedStatus == s;
      Color chipColor;
      switch (s) {
        case 'Scheduled':
          chipColor = Colors.orange;
          break;
        case 'Completed':
          chipColor = Colors.green;
          break;
        case 'Cancelled':
          chipColor = Colors.red;
          break;
        default:
          chipColor = const Color(0xFF1A237E);
      }
      return InkWell(
        onTap: () => setState(() => _selectedStatus = s),
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: isActive ? chipColor.withValues(alpha: 0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isActive ? chipColor : Colors.grey.shade300,
            ),
          ),
          child: Text(
            s,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive ? chipColor : Colors.grey.shade600,
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildDropdownFilter({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          hint: Text(label, style: TextStyle(fontSize: 12)),
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item == 'All' ? '$label: All' : item,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _tableHeader(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.grey.shade500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMeetingRow(Meeting m) {
    Color statusColor;
    Color statusBgColor;
    switch (m.status) {
      case 'Scheduled':
        statusColor = const Color(0xFF1E88E5);
        statusBgColor = const Color(0xFFE3F2FD);
        break;
      case 'Completed':
        statusColor = const Color(0xFF43A047);
        statusBgColor = const Color(0xFFE8F5E9);
        break;
      case 'Cancelled':
        statusColor = const Color(0xFFE53935);
        statusBgColor = const Color(0xFFFFEBEE);
        break;
      default:
        statusColor = Colors.grey;
        statusBgColor = Colors.grey.shade100;
    }

    final dateStr = DateFormat('M/d/yyyy').format(m.dateTime);
    final timeStr = DateFormat('hh:mm a').format(m.dateTime);

    return Column(
      children: [
        InkWell(
          onTap: () => _showMeetingDetail(m),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Row(
              children: [
                // Title / Agenda
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '—',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.blue.shade100),
                        ),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.blue.shade50,
                          child: Text(
                            m.organizerName.substring(0, 1),
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m.organizerName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              m.department,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Status
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        m.status,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ),
                ),
                // Date & Time
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateStr,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        timeStr,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Members
                Expanded(
                  flex: 1,
                  child: Text(
                    '${m.memberCount}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ),
                // Actions
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: () => _showMeetingDetail(m),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      side: const BorderSide(color: Color(0xFFE0E0E0)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.chevron_right, size: 16, color: Color(0xFF1976D2)),
                        SizedBox(width: 4),
                        Text(
                          'Details',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1976D2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(height: 1, color: Colors.grey.shade100),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.event_busy, size: 52, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No meetings match your filters',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _clearFilters,
              child: const Text('Clear all filters'),
            ),
          ],
        ),
      ),
    );
  }

  void _showMeetingDetail(Meeting m) {
    final dateStr = DateFormat('EEEE, MMMM d, yyyy').format(m.dateTime);
    final timeStr = DateFormat('hh:mm a').format(m.dateTime);

    Color statusColor;
    switch (m.status) {
      case 'Scheduled':
        statusColor = Colors.orange;
        break;
      case 'Completed':
        statusColor = Colors.green;
        break;
      case 'Cancelled':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 520,
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      m.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      m.status,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _detailRow(Icons.description, 'Agenda', m.agenda),
              _detailRow(Icons.person, 'Organizer', m.organizerName),
              _detailRow(Icons.business, 'Department', m.department),
              _detailRow(Icons.corporate_fare, 'Organization', m.organization),
              _detailRow(Icons.calendar_today, 'Date', dateStr),
              _detailRow(Icons.access_time, 'Time', timeStr),
              _detailRow(
                Icons.people,
                'Members',
                '${m.memberCount} member(s)',
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF1A237E)),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, color: Color(0xFF1A1A2E)),
            ),
          ),
        ],
      ),
    );
  }
}
