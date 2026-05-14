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
  final TextEditingController _venueController = TextEditingController();
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
    _venueController.dispose();
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
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Schedule a Meeting',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1A2E),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Fill in the details below to set up a new meeting session.',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
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
                              _buildLabel('MEETING TITLE'),
                              const SizedBox(height: 8),
                              TextFormField(
                                decoration: const InputDecoration(
                                  hintText: 'Enter meeting subject...',
                                  prefixIcon: Icon(Icons.title_rounded, size: 20),
                                ),
                                validator: (value) => (value == null || value.isEmpty) ? 'Please enter a title' : null,
                              ),
                              const SizedBox(height: 24),
                              
                              _buildLabel('AGENDA / DESCRIPTION'),
                              const SizedBox(height: 8),
                              TextFormField(
                                maxLines: 3,
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
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(width: 16),
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
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Schedule Meeting',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 80),
                      const AppFooter(),
                    ],
                  ),
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: Color(0xFF475569),
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade50)),
            ),
            child: Row(
              children: [
                Icon(icon, size: 18, color: const Color(0xFF1A237E)),
                const SizedBox(width: 10),
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeSection() {
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      alignment: WrapAlignment.start,
      children: [
        SizedBox(
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('DATE'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  hintText: 'Select date',
                  prefixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(4),
                    child: _buildCalendarToggle(),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('TIME'),
              const SizedBox(height: 8),
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
        SizedBox(
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('VENUE *'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _venueController,
                decoration: const InputDecoration(
                  hintText: 'e.g. Conference Room A',
                  prefixIcon: Icon(Icons.location_on_outlined, size: 18),
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Please enter a venue' : null,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _isOnlineMeeting = !_isOnlineMeeting),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: _isOnlineMeeting,
                    onChanged: (v) => setState(() => _isOnlineMeeting = v ?? false),
                    activeColor: const Color(0xFFB8860B), // Golden/Mustard color as in image
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.videocam_outlined, size: 20, color: Color(0xFF1A237E)),
                const SizedBox(width: 8),
                const Text(
                  'ONLINE MEETING',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Color(0xFF1A237E),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isOnlineMeeting) ...[
          const SizedBox(height: 20),
          _buildLabel('MEETING LINK *'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _linkController,
            decoration: const InputDecoration(
              hintText: 'e.g. https://zoom.us/j/123456789',
              prefixIcon: Icon(Icons.link_rounded, size: 20),
            ),
            validator: (value) => (_isOnlineMeeting && (value == null || value.isEmpty)) ? 'Please enter meeting link' : null,
          ),
        ],
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
          const SizedBox(height: 24),
          _buildMomSearchField(label: 'RECOMMENDED BY', controller: _recommendedByController, role: 'Recommended by'),
          const SizedBox(height: 24),
          _buildMomSearchField(label: 'APPROVED BY', controller: _approvedByController, role: 'Approved by'),
        ],
      ),
    );
  }

  Widget _buildMomSearchField({required String label, required TextEditingController controller, required String role}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Manage Participants',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Add employees or external members to this meeting.',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_circle_outline, size: 18),
                label: const Text('Add Participant'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF1A237E),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.people_outline, size: 32, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text(
                    'No participants added yet',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
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
