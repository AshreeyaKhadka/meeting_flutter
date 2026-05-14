import 'package:flutter/material.dart';

class DashboardActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool active;

  const DashboardActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: active ? Colors.blue.shade900 : Colors.white,
        foregroundColor: active ? Colors.white : Colors.grey.shade800,
        elevation: active ? 2 : 0,
        shadowColor: Colors.black12,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        side: BorderSide(
          color: active ? Colors.blue.shade900 : Colors.grey.shade300,
        ),
      ),
    );
  }
}

class EmptyMeetingSection extends StatelessWidget {
  final VoidCallback onSchedule;

  const EmptyMeetingSection({super.key, required this.onSchedule});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inbox_outlined,
              size: 46,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'No meetings found',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          Text(
            'Create your first meeting to get started',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),

          const SizedBox(height: 30),

          DashboardActionButton(
            label: 'Schedule a Meeting',
            icon: Icons.add,
            active: true,
            onPressed: onSchedule,
          ),
        ],
      ),
    );
  }
}
