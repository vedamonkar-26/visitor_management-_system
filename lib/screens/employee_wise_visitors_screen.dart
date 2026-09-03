import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/employee_model.dart';
import 'checkout_visitor_screen.dart';
import '../models/visitor_model.dart';

class EmployeeWiseVisitorsScreen extends StatelessWidget {
  final Employee employee;

  const EmployeeWiseVisitorsScreen({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    // Generate dummy visitors for this employee
    final List<Map<String, String>> employeeVisitors = [
      {
        'name': 'John Smith',
        'company': 'ABC Pvt Ltd',
        'dateTime': '06 Aug 2026  10:30 AM',
        'purpose': 'Discussion',
        'photo': '',
      },
      {
        'name': 'Rahul Sharma',
        'company': 'XYZ Solutions',
        'dateTime': '05 Aug 2026  11:20 AM',
        'purpose': 'Discussion',
        'photo': '',
      },
      {
        'name': 'Michael Brown',
        'company': 'Global Tech',
        'dateTime': '04 Aug 2026  09:45 AM',
        'purpose': 'Project Review',
        'photo': '',
      },
      {
        'name': 'Rohit Verma',
        'company': 'BuildCon Pvt Ltd',
        'dateTime': '03 Aug 2026  01:15 PM',
        'purpose': 'Site Visit',
        'photo': '',
      },
      {
        'name': 'David Lee',
        'company': 'TechSoft',
        'dateTime': '02 Aug 2026  02:05 PM',
        'purpose': 'Meeting',
        'photo': '',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Employee Visitors'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Employee Header Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.primaryLight,
                      backgroundImage: employee.photoUrl.isNotEmpty ? NetworkImage(employee.photoUrl) : null,
                      child: employee.photoUrl.isEmpty ? const Icon(Icons.person, color: AppColors.primary, size: 30) : null,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employee.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          employee.title,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Visitors (This Week)',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: employeeVisitors.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = employeeVisitors[index];

                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          final dummyV = Visitor(
                            id: 'VIS99$index',
                            name: item['name']!,
                            mobile: '+91 98765 00000',
                            company: item['company']!,
                            department: employee.department,
                            hostEmployee: employee.name,
                            purpose: item['purpose']!,
                            category: 'Regular Visitor',
                            photoUrl: item['photo']!,
                            entryTime: DateTime.now().subtract(Duration(days: index + 1)),
                            status: VisitorStatus.checkedOut,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckOutVisitorScreen(visitor: dummyV),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColors.primaryLight,
                              backgroundImage: item['photo'] != null && item['photo']!.isNotEmpty ? NetworkImage(item['photo']!) : null,
                              child: item['photo'] == null || item['photo']!.isEmpty ? const Icon(Icons.person, color: AppColors.primary, size: 20) : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name']!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item['company']!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  item['dateTime']!,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item['purpose']!,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 18),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
