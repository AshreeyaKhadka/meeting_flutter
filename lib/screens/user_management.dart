import 'package:flutter/material.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _users = [
    {
      'name': 'ISHA PANDEY',
      'email': '8265@import.local',
      'office': 'Bharatpur telecom office',
      'role': 'Assistant Acc Officer',
      'status': 'Active',
      'joined': '4/29/2026',
      'initial': 'I',
    },
    {
      'name': 'TANK SHAH',
      'email': '8264@import.local',
      'office': 'Birgunj telecom office',
      'role': 'Assistant Administrative Officer',
      'status': 'Active',
      'joined': '4/29/2026',
      'initial': 'T',
    },
    {
      'name': 'SEEMA SINGH',
      'email': '8263@import.local',
      'office': 'BACKBONE TRANSMISSION DIRECTORATE',
      'role': 'Senior Engineer Civil',
      'status': 'Active',
      'joined': '4/29/2026',
      'initial': 'S',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Registered Participants',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Manage all users registered in the portal',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(
                  width: 320,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by name or email...',
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1100, // Fixed width for horizontal scrolling
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBFBFB),
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade100),
                        bottom: BorderSide(color: Colors.grey.shade100),
                      ),
                    ),
                    child: Row(
                      children: [
                        _headerCell('FULL NAME', 3),
                        _headerCell('WORK DETAILS', 3),
                        _headerCell('STATUS', 1),
                        _headerCell('JOINED', 1.5),
                        _headerCell('ACTIONS', 3),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._users.map((user) => _buildUserRow(user)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerCell(String label, double flex) {
    return Expanded(
      flex: (flex * 10).toInt(),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
    );
  }

  Widget _buildUserRow(Map<String, dynamic> user) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: Row(
            children: [
              Expanded(
                flex: 30,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: const Color(0xFFE3F2FD),
                        child: Text(
                          user['initial'],
                          style: const TextStyle(color: Color(0xFF1976D2), fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E), fontSize: 14),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user['email'],
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user['office'], style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
                    Text(user['role'], style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  ],
                ),
              ),
              Expanded(
                flex: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(20)),
                  child: const Text('Active', style: TextStyle(color: Color(0xFF43A047), fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ),
              Expanded(
                flex: 15,
                child: Text(user['joined'], style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 30,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      _buildBtn(Icons.person_off, 'Suspend', Colors.red),
                      const SizedBox(width: 8),
                      _buildBtn(Icons.admin_panel_settings, 'Make Admin', const Color(0xFF1976D2)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildBtn(IconData icon, String label, Color color) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 14, color: color),
      label: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        side: BorderSide(color: color.withValues(alpha: 0.2)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: color.withValues(alpha: 0.02),
      ),
    );
  }
}
