import 'package:flutter/material.dart';
import '../widgets/footer_widget.dart';

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
  bool _isOnlineMeeting = false;
  bool _useCustomSms = false;
  
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
  
  DateTime? _selectedDate;
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
        centerTitle: false,
        foregroundColor: Colors.white,
        title: const Text(
          'Schedule a Meeting',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, size: 22),
            tooltip: 'Notifications',
          ),
          const SizedBox(width: 8),
          _buildUserAvatar(),
          const SizedBox(width: 16),
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
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Schedule a Meeting',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Fill in the details below to set up a new meeting session.',
                      style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: _buildSectionCard(
                        title: 'Meeting Information',
                        icon: Icons.info_outline,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'MEETING TITLE',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1A237E), letterSpacing: 0.5),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Enter meeting subject...',
                                prefixIcon: const Icon(Icons.title_rounded, size: 20),
                              ),
                              validator: (value) => (value == null || value.isEmpty) ? 'Please enter a title' : null,
                            ),
                            const SizedBox(height: 24),
                            
                            const Text(
                              'AGENDA / DESCRIPTION',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1A237E), letterSpacing: 0.5),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              maxLines: 4,
                              decoration: const InputDecoration(
                                hintText: 'Describe the purpose of the meeting...',
                                alignLabelWithHint: true,
                              ),
                            ),
                            const SizedBox(height: 32),
                            
                            _buildDateTimeSection(),
                            const SizedBox(height: 32),
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
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 22),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Meeting scheduled successfully'),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Color(0xFF1A237E),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A237E),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 22),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            elevation: 4,
                            shadowColor: const Color(0xFF1A237E).withValues(alpha: 0.3),
                          ),
                          child: const Text(
                            'Schedule Meeting',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 0.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 80),
                    const AppFooter(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white24, width: 1.5),
          ),
          child: const CircleAvatar(
            radius: 14,
            backgroundColor: Color(0xFFFFB300),
            child: Text(
              'S',
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'System Admin',
          style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade50)),
            ),
            child: Row(
              children: [
                Icon(icon, size: 20, color: const Color(0xFF1A237E)),
                const SizedBox(width: 12),
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeSection() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.start,
      children: [
        SizedBox(
          width: 260,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'DATE',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1A237E), letterSpacing: 0.5),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  hintText: 'Select date',
                  prefixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8)),
                    child: _buildCalendarToggle(),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 240,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TIME',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1A237E), letterSpacing: 0.5),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _timeController,
                readOnly: true,
                onTap: () => _selectTime(context),
                decoration: const InputDecoration(
                  hintText: 'Select time',
                  prefixIcon: Icon(Icons.access_time_rounded, size: 18),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarToggle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _calendarPill('AD'),
        _calendarPill('BS'),
      ],
    );
  }

  Widget _calendarPill(String type) {
    bool isActive = _calendarType == type;
    return InkWell(
      onTap: () => setState(() => _calendarType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isActive ? [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 4, offset: const Offset(0, 2))] : null,
        ),
        child: Text(
          type,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isActive ? const Color(0xFF1A237E) : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }

  Widget _buildOnlineMeetingToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        children: [
          Icon(Icons.video_camera_back_outlined, color: Colors.blue.shade800, size: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'ONLINE MEETING',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5),
            ),
          ),
          Switch.adaptive(
            value: _isOnlineMeeting,
            activeTrackColor: const Color(0xFF1A237E),
            onChanged: (v) => setState(() => _isOnlineMeeting = v),
          ),
        ],
      ),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF1A237E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: active ? const Color(0xFF1A237E) : Colors.grey.shade200),
          boxShadow: active ? [BoxShadow(color: const Color(0xFF1A237E).withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 4))] : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: active ? Colors.white : Colors.grey.shade600,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
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
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1A237E), letterSpacing: 0.5),
        ),
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
              controller: fieldController,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: 'Search employee...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                prefixIcon: const Icon(Icons.person_search_outlined, size: 20),
                filled: true,
                fillColor: const Color(0xFFFBFBFB),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInviteMembers() {
    return _buildSectionCard(
      title: 'Invite Members',
      icon: Icons.group_add_outlined,
      child: Column(
        children: [
          const Text(
            'Add participants to this meeting',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Add Member'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade50,
              foregroundColor: const Color(0xFF1A237E),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.year}-${picked.month}-${picked.day}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }
}
