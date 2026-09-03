import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/visitor_model.dart';
import '../state/app_state.dart';

class RegisterVisitorStep2Screen extends StatefulWidget {
  final String visitorName;
  final String mobile;
  final String company;
  final String department;
  final String hostEmployee;
  final String purpose;

  const RegisterVisitorStep2Screen({
    super.key,
    required this.visitorName,
    required this.mobile,
    required this.company,
    required this.department,
    required this.hostEmployee,
    required this.purpose,
  });

  @override
  State<RegisterVisitorStep2Screen> createState() => _RegisterVisitorStep2ScreenState();
}

class _RegisterVisitorStep2ScreenState extends State<RegisterVisitorStep2Screen> {
  String _selectedCategory = 'Regular Visitor';
  bool _photoCaptured = false;
  final DateTime _entryTime = DateTime.now();

  final List<String> _categories = [
    'Regular Visitor',
    'VIP Visitor',
    'Contractor',
    'Delivery Personnel',
  ];

  @override
  Widget build(BuildContext context) {
    final String formattedTime = DateFormat('hh:mm a').format(_entryTime);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Register Visitor'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Visitor Category
              const Text(
                'Visitor Category',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: _categories.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedCategory = val;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // Entry Time (Auto)
              const Text(
                'Entry Time (Auto)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formattedTime,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Icon(Icons.access_time, color: AppColors.textSecondary, size: 20),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Capture Visitor Photo Container
              const Text(
                'Capture Visitor Photo',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              GestureDetector(
                onTap: () {
                  setState(() {
                    _photoCaptured = !_photoCaptured;
                  });
                },
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _photoCaptured ? AppColors.primary : AppColors.inputBorder,
                      width: _photoCaptured ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: _photoCaptured
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryLight,
                                  border: Border.all(color: AppColors.primary, width: 3),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle, color: AppColors.greenInside, size: 18),
                                  SizedBox(width: 4),
                                  Text(
                                    'Photo Captured Successfully',
                                    style: TextStyle(
                                      color: AppColors.greenInside,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Tap to retake',
                                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryLight,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: AppColors.primary,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Capture Visitor Photo',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Tap to simulate camera capture',
                                style: TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // Register Button
              ElevatedButton(
                onPressed: () {
                  final newVisitor = Visitor(
                    id: 'VIS${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                    name: widget.visitorName,
                    mobile: widget.mobile.startsWith('+') ? widget.mobile : '+91 ${widget.mobile}',
                    company: widget.company,
                    department: widget.department,
                    hostEmployee: widget.hostEmployee,
                    purpose: widget.purpose,
                    category: _selectedCategory,
                    photoUrl: '',
                    entryTime: _entryTime,
                    status: VisitorStatus.insideCampus,
                  );

                  Provider.of<AppState>(context, listen: false).registerNewVisitor(newVisitor);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.greenInside,
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Visitor registered successfully!'),
                        ],
                      ),
                    ),
                  );

                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Register'),
                    SizedBox(width: 8),
                    Icon(Icons.check, size: 20),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
