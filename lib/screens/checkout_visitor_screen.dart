import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/visitor_model.dart';
import '../state/app_state.dart';

class CheckOutVisitorScreen extends StatefulWidget {
  final Visitor visitor;

  const CheckOutVisitorScreen({super.key, required this.visitor});

  @override
  State<CheckOutVisitorScreen> createState() => _CheckOutVisitorScreenState();
}

class _CheckOutVisitorScreenState extends State<CheckOutVisitorScreen> {
  @override
  Widget build(BuildContext context) {
    final DateTime exitTime = widget.visitor.exitTime ?? DateTime.now();
    final entryTimeStr = DateFormat('hh:mm a').format(widget.visitor.entryTime);
    final exitTimeStr = DateFormat('hh:mm a').format(exitTime);

    // Calculate duration
    final diff = exitTime.difference(widget.visitor.entryTime);
    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);
    final durationStr = hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Check Out Visitor'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              // Visitor Avatar & Header
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primaryLight,
                      backgroundImage: widget.visitor.photoUrl.isNotEmpty ? NetworkImage(widget.visitor.photoUrl) : null,
                      child: widget.visitor.photoUrl.isEmpty ? const Icon(Icons.person, color: AppColors.primary, size: 44) : null,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.visitor.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.visitor.company,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Visitor Details Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  children: [
                    _DetailRow(
                      label: 'Mobile Number',
                      value: widget.visitor.mobile,
                    ),
                    const Divider(height: 1, color: AppColors.cardBorder),
                    _DetailRow(
                      label: 'Category',
                      value: widget.visitor.category,
                    ),
                    const Divider(height: 1, color: AppColors.cardBorder),
                    _DetailRow(
                      label: 'Purpose',
                      value: widget.visitor.purpose,
                    ),
                    const Divider(height: 1, color: AppColors.cardBorder),
                    _DetailRow(
                      label: 'Host',
                      value: widget.visitor.hostEmployee,
                    ),
                    const Divider(height: 1, color: AppColors.cardBorder),
                    _DetailRow(
                      label: 'Department',
                      value: widget.visitor.department,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Time Details Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Entry Time',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          entryTimeStr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1, color: AppColors.cardBorder),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Exit Time (Auto)',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              exitTimeStr,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
                          ],
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1, color: AppColors.cardBorder),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Duration',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          durationStr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.greenInside,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Confirm Check Out Button
              widget.visitor.status == VisitorStatus.checkedOut
                  ? ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade400,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: null,
                      icon: const Icon(Icons.check_circle, color: Colors.white),
                      label: const Text('Already Checked Out'),
                    )
                  : ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        final appState = Provider.of<AppState>(context, listen: false);
                        appState.checkOutVisitor(widget.visitor.id);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.purpleCheckedOut,
                            content: Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.white),
                                const SizedBox(width: 8),
                                Text('${widget.visitor.name} checked out successfully!'),
                              ],
                            ),
                          ),
                        );

                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                      label: const Text('Confirm Check Out'),
                    ),
              const SizedBox(height: 16),
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
