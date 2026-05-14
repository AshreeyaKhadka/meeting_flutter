import 'package:flutter/material.dart';
import '../widgets/footer_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _employeeIdController = TextEditingController();

  @override
  void dispose() {
    _employeeIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFF1A237E), Colors.blue.shade800, Colors.blue.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Main Activation Card Section
              Container(
                constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - 100),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
                child: Container(
                  width: 480,
                  padding: const EdgeInsets.all(48),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F2F5),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Image.asset('assets/ntc_logo.png', height: 60, width: 60),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Activate Account',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A2E),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter your Employee ID to begin',
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                        ),
                        const SizedBox(height: 24),
                        
                        // Stepper Indicators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 36,
                              height: 6,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A237E),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(width: 8),
                            CircleAvatar(radius: 4, backgroundColor: Colors.grey.shade200),
                            const SizedBox(width: 8),
                            CircleAvatar(radius: 4, backgroundColor: Colors.grey.shade200),
                          ],
                        ),
                        const SizedBox(height: 40),

                        // Employee ID Field
                        _buildInputField(
                          label: 'EMPLOYEE ID',
                          hint: 'Enter your ID (e.g. 12345)',
                          icon: Icons.badge_outlined,
                          controller: _employeeIdController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Required';
                            }
                            if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
                              return 'Must contain only digits';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                // Logic for finding account
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A237E),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 4,
                              shadowColor: const Color(0xFF1A237E).withValues(alpha: 0.3),
                            ),
                            child: const Text(
                              'Find My Account',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already have an account?', style: TextStyle(color: Colors.grey.shade600)),
                            TextButton(
                              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                              child: const Text('Sign in', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Footer
              const AppFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E), letterSpacing: 0.5),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20, color: const Color(0xFF1A237E).withValues(alpha: 0.7)),
            filled: true,
            fillColor: const Color(0xFFFBFBFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF1A237E), width: 1.5),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
