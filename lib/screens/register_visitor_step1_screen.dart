import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'register_visitor_step2_screen.dart';

class RegisterVisitorStep1Screen extends StatefulWidget {
  const RegisterVisitorStep1Screen({super.key});

  @override
  State<RegisterVisitorStep1Screen> createState() => _RegisterVisitorStep1ScreenState();
}

class _RegisterVisitorStep1ScreenState extends State<RegisterVisitorStep1Screen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _companyController = TextEditingController();

  String? _selectedDepartment;
  String? _selectedEmployee;
  String? _selectedPurpose;

  final List<String> _departments = [
    'IT Department',
    'Finance Dept',
    'Marketing',
    'Operations',
    'Management',
    'HR',
  ];

  final List<String> _employees = [
    'Rahul Patil',
    'Jane Robert',
    'Emma Smith',
    'Michael Brown',
    'David Lee',
  ];

  final List<String> _purposes = [
    'Meeting',
    'Discussion',
    'Project Review',
    'Site Visit',
    'Delivery',
    'Interview',
  ];

  @override
  Widget build(BuildContext context) {
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Visitor Name
                const _FormLabel('Visitor Name'),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter full name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Please enter visitor name' : null,
                ),
                const SizedBox(height: 16),

                // Mobile Number
                const _FormLabel('Mobile Number'),
                TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: 'Enter mobile number',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Please enter mobile number' : null,
                ),
                const SizedBox(height: 16),

                // Company
                const _FormLabel('Company'),
                TextFormField(
                  controller: _companyController,
                  decoration: const InputDecoration(
                    hintText: 'Enter company name',
                    prefixIcon: Icon(Icons.business_outlined),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Please enter company name' : null,
                ),
                const SizedBox(height: 16),

                // Department Dropdown
                const _FormLabel('Department'),
                DropdownButtonFormField<String>(
                  initialValue: _selectedDepartment,
                  decoration: const InputDecoration(
                    hintText: 'Select department',
                    prefixIcon: Icon(Icons.layers_outlined),
                  ),
                  items: _departments.map((dept) {
                    return DropdownMenuItem(
                      value: dept,
                      child: Text(dept),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedDepartment = val;
                    });
                  },
                  validator: (val) => val == null ? 'Please select department' : null,
                ),
                const SizedBox(height: 16),

                // Person to Visit Dropdown
                const _FormLabel('Person to Visit'),
                DropdownButtonFormField<String>(
                  initialValue: _selectedEmployee,
                  decoration: const InputDecoration(
                    hintText: 'Select employee',
                    prefixIcon: Icon(Icons.person_search_outlined),
                  ),
                  items: _employees.map((emp) {
                    return DropdownMenuItem(
                      value: emp,
                      child: Text(emp),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedEmployee = val;
                    });
                  },
                  validator: (val) => val == null ? 'Please select employee to visit' : null,
                ),
                const SizedBox(height: 16),

                // Purpose of Visit Dropdown
                const _FormLabel('Purpose of Visit'),
                DropdownButtonFormField<String>(
                  initialValue: _selectedPurpose,
                  decoration: const InputDecoration(
                    hintText: 'Select purpose',
                    prefixIcon: Icon(Icons.info_outline),
                  ),
                  items: _purposes.map((p) {
                    return DropdownMenuItem(
                      value: p,
                      child: Text(p),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedPurpose = val;
                    });
                  },
                  validator: (val) => val == null ? 'Please select purpose' : null,
                ),
                const SizedBox(height: 32),

                // Next Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterVisitorStep2Screen(
                            visitorName: _nameController.text.trim(),
                            mobile: _mobileController.text.trim(),
                            company: _companyController.text.trim(),
                            department: _selectedDepartment!,
                            hostEmployee: _selectedEmployee!,
                            purpose: _selectedPurpose!,
                          ),
                        ),
                      );
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Next'),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FormLabel extends StatelessWidget {
  final String text;
  const _FormLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
