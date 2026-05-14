import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScheduledMeetingScreen extends StatefulWidget {
  const ScheduledMeetingScreen({super.key});

  @override
  State<ScheduledMeetingScreen> createState() => _ScheduledMeetingScreenState();
}

class _ScheduledMeetingScreenState extends State<ScheduledMeetingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _customSmsController = TextEditingController();
  final TextEditingController _customReminderController = TextEditingController();
  final List<PlatformFile> _referenceFiles = [];
  bool _isOnlineMeeting = false;
  bool _useCustomSms = false;
  String _selectedReminder = 'No Reminder';
  
  final Map<String, String> _selectedMomEmployees = {
    'Proposed by': '',
    'Recommended by': '',
    'Approved by': '',
  };
  
  final TextEditingController _proposedByController = TextEditingController();
  final TextEditingController _recommendedByController = TextEditingController();
  final TextEditingController _approvedByController = TextEditingController();
  
  final List<String> _employeeNames = [
    'Alice Johnson', 'Bob Smith', 'Clara Lee', 'David Patel', 'Emma Davis',
    'Farhan Khan', 'Grace Kim', 'Hassan Ali', 'Ibrahim Noor', 'Jaya Reddy',
  ];
  
  String _amPm = 'AM';
  DateTime? _selectedDate;
  String _selectedBsDate = '';
  TimeOfDay? _selectedTime;
  String _calendarType = 'AD';

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _linkController.dispose();
    _customSmsController.dispose();
    _customReminderController.dispose();
    _proposedByController.dispose();
    _recommendedByController.dispose();
    _approvedByController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        elevation: 0,
        title: const Text('Schedule a Meeting'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
          const CircleAvatar(
            radius: 14,
            backgroundColor: Color(0xFFFFB300),
            child: Text('S', style: TextStyle(color: Colors.white, fontSize: 11)),
          ),
          const SizedBox(width: 8),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(child: Text('System Admin', style: TextStyle(fontSize: 12, color: Colors.white))),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              // Header section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.03),
                  border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Schedule a Meeting',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Fill in the details and invite attendees to your next collaboration session.',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),

              // Form section
              Container(
                constraints: const BoxConstraints(maxWidth: 900),
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    // Section: Meeting Details
                    _buildSectionCard(
                      title: 'Meeting Details',
                      icon: Icons.info_outline,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildLabel('MEETING TITLE *'),
                            _buildTextField('e.g. Q2 Planning Meeting'),
                            const SizedBox(height: 24),
                            _buildLabel('ORGANIZED BY: *'),
                            _buildTextField('e.g. Information Technology Directorate'),
                            const SizedBox(height: 24),
                            _buildLabel('AGENDA *'),
                            _buildTextArea('What will be discussed in this meeting?'),
                            const SizedBox(height: 32),
                            _buildDateTimeAndVenueRow(),
                            const SizedBox(height: 24),
                            _buildOnlineMeetingToggle(),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                    _buildNotificationSettings(),
                    
                    const SizedBox(height: 32),
                    _buildMomApprovalWorkflow(),
                    
                    const SizedBox(height: 32),
                    _buildInviteMembers(),

                    const SizedBox(height: 48),
                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Meeting scheduled successfully')));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A237E),
                            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Schedule Meeting', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: Colors.blue.shade800, width: 4)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue.shade800, size: 22),
                const SizedBox(width: 12),
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
              ],
            ),
            const SizedBox(height: 32),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return TextFormField(
      decoration: InputDecoration(hintText: hint, filled: true, fillColor: Colors.grey.shade50, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300))),
      validator: (value) => (value == null || value.trim().isEmpty) ? 'Required' : null,
    );
  }

  Widget _buildTextArea(String hint) {
    return TextFormField(
      minLines: 4, maxLines: 6,
      decoration: InputDecoration(hintText: hint, filled: true, fillColor: Colors.grey.shade50, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300))),
      validator: (value) => (value == null || value.trim().isEmpty) ? 'Required' : null,
    );
  }

  Widget _buildDateTimeAndVenueRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('DATE & TIME *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
            Container(
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  _buildCalendarToggle('BS'),
                  _buildCalendarToggle('AD'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16, runSpacing: 16,
          children: [
            SizedBox(
              width: 250,
              child: TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  hintText: 'Select Date',
                  prefixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
                  filled: true, fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                readOnly: true, onTap: _selectDate,
              ),
            ),
            GestureDetector(
              onTap: _selectTime,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.access_time, size: 20, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(_selectedTime != null ? _selectedTime!.format(context) : 'Select Time', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 300,
              child: TextFormField(
                decoration: InputDecoration(hintText: 'VENUE (e.g. Virtual)', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCalendarToggle(String type) {
    final bool isActive = _calendarType == type;
    return GestureDetector(
      onTap: () => setState(() => _calendarType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: isActive ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(6), boxShadow: isActive ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)] : null),
        child: Text(type, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isActive ? Colors.blue.shade800 : Colors.grey.shade500)),
      ),
    );
  }

  Widget _buildOnlineMeetingToggle() {
    return Row(
      children: [
        Checkbox(value: _isOnlineMeeting, onChanged: (v) => setState(() => _isOnlineMeeting = v ?? false)),
        const SizedBox(width: 8),
        const Text('ONLINE MEETING', style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return _buildSectionCard(
      title: 'Notification Settings',
      icon: Icons.notifications_active_outlined,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildChoiceButton('DEFAULT MESSAGE', !_useCustomSms, () => setState(() => _useCustomSms = false))),
              const SizedBox(width: 12),
              Expanded(child: _buildChoiceButton('CUSTOM SMS', _useCustomSms, () => setState(() => _useCustomSms = true))),
            ],
          ),
          if (_useCustomSms) ...[
            const SizedBox(height: 16),
            TextFormField(controller: _customSmsController, minLines: 3, maxLines: 4, decoration: const InputDecoration(labelText: 'SMS Content', filled: true)),
          ],
        ],
      ),
    );
  }

  Widget _buildChoiceButton(String label, bool active, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: active ? Colors.blue.shade50 : Colors.white,
        side: BorderSide(color: active ? Colors.blue : Colors.grey.shade300),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(label, style: TextStyle(color: active ? Colors.blue.shade900 : Colors.grey.shade700, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildMomApprovalWorkflow() {
    return _buildSectionCard(
      title: 'MOM Approval Workflow',
      icon: Icons.assignment_turned_in_outlined,
      child: Column(
        children: [
          _buildMomSearchField(label: 'PROPOSED BY', controller: _proposedByController, role: 'Proposed by'),
          const SizedBox(height: 20),
          _buildMomSearchField(label: 'RECOMMENDED BY', controller: _recommendedByController, role: 'Recommended by'),
          const SizedBox(height: 20),
          _buildMomSearchField(label: 'APPROVED BY', controller: _approvedByController, role: 'Approved by'),
        ],
      ),
    );
  }

  Widget _buildMomSearchField({required String label, required TextEditingController controller, required String role}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue.shade800)),
        const SizedBox(height: 10),
        Autocomplete<String>(
          optionsBuilder: (val) => val.text.isEmpty ? const Iterable<String>.empty() : _employeeNames.where((n) => n.toLowerCase().contains(val.text.toLowerCase())),
          onSelected: (selection) => setState(() {
            _selectedMomEmployees[role] = selection;
            controller.text = selection;
          }),
          fieldViewBuilder: (ctx, fieldController, focusNode, onSubmitted) {
            if (fieldController.text != controller.text) fieldController.text = controller.text;
            return TextField(
              controller: fieldController, focusNode: focusNode,
              decoration: InputDecoration(hintText: 'Search employee...', filled: true, fillColor: Colors.grey.shade50, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInviteMembers() {
    return _buildSectionCard(
      title: 'Invite Members',
      icon: Icons.person_add_outlined,
      child: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text('Add attendees by searching their name or email.', style: TextStyle(color: Colors.grey)),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() { _selectedDate = picked; _dateController.text = '${picked.year}-${picked.month}-${picked.day}'; });
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: _selectedTime ?? TimeOfDay.now());
    if (picked != null) setState(() { _selectedTime = picked; });
  }
}
