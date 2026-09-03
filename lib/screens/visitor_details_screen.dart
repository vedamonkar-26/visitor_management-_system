import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/visitor_model.dart';
import '../state/app_state.dart';
import 'checkout_visitor_screen.dart';

class VisitorDetailsScreen extends StatelessWidget {
  final Visitor visitor;

  const VisitorDetailsScreen({super.key, required this.visitor});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final String entryTimeStr = DateFormat('hh:mm a').format(visitor.entryTime);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Visitor Details'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Visitor Avatar Header
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: AppColors.primaryLight,
                      backgroundImage: visitor.photoUrl.isNotEmpty ? NetworkImage(visitor.photoUrl) : null,
                      child: visitor.photoUrl.isEmpty ? const Icon(Icons.person, color: AppColors.primary, size: 48) : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      visitor.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      visitor.company,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Details List Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  children: [
                    _DetailRow(
                      label: 'Purpose',
                      value: visitor.purpose,
                    ),
                    const Divider(height: 1, color: AppColors.cardBorder),
                    _DetailRow(
                      label: 'Host',
                      value: visitor.hostEmployee,
                    ),
                    const Divider(height: 1, color: AppColors.cardBorder),
                    _DetailRow(
                      label: 'Department',
                      value: visitor.department,
                    ),
                    const Divider(height: 1, color: AppColors.cardBorder),
                    _DetailRow(
                      label: 'Entry Time',
                      value: entryTimeStr,
                    ),
                    const Divider(height: 1, color: AppColors.cardBorder),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Status',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: visitor.status == VisitorStatus.insideCampus
                                  ? AppColors.greenInsideBg
                                  : (visitor.status == VisitorStatus.checkedOut
                                      ? AppColors.purpleCheckedOutBg
                                      : AppColors.orangePendingBg),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              visitor.status == VisitorStatus.insideCampus
                                  ? 'Inside Campus'
                                  : (visitor.status == VisitorStatus.checkedOut
                                      ? 'Checked Out'
                                      : 'Pending Approval'),
                              style: TextStyle(
                                color: visitor.status == VisitorStatus.insideCampus
                                    ? AppColors.greenInside
                                    : (visitor.status == VisitorStatus.checkedOut
                                        ? AppColors.purpleCheckedOut
                                        : AppColors.orangePending),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              // Action Button
              SizedBox(
                width: double.infinity,
                child: visitor.status == VisitorStatus.insideCampus
                    ? ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.purpleCheckedOut,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckOutVisitorScreen(visitor: visitor),
                            ),
                          );
                        },
                        icon: const Icon(Icons.exit_to_app, color: Colors.white),
                        label: const Text('Check Out'),
                      )
                    : visitor.status == VisitorStatus.checkedOut
                        ? ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade400,
                            ),
                            onPressed: null,
                            icon: const Icon(Icons.check_circle, color: Colors.white),
                            label: const Text('Checked Out'),
                          )
                        : ElevatedButton.icon(
                            onPressed: () {
                              appState.checkInVisitor(visitor.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: AppColors.greenInside,
                                  content: Row(
                                    children: [
                                      const Icon(Icons.check_circle, color: Colors.white),
                                      const SizedBox(width: 8),
                                      Text('${visitor.name} checked in successfully!'),
                                    ],
                                  ),
                                ),
                              );
                              Navigator.popUntil(context, (route) => route.isFirst);
                            },
                            icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                            label: const Text('Check In'),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
