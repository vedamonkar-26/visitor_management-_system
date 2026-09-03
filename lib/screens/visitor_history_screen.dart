import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import '../models/visitor_model.dart';
import 'checkout_visitor_screen.dart';

class VisitorHistoryScreen extends StatefulWidget {
  const VisitorHistoryScreen({super.key});

  @override
  State<VisitorHistoryScreen> createState() => _VisitorHistoryScreenState();
}

class _VisitorHistoryScreenState extends State<VisitorHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final allVisitors = appState.visitors;

    // Filter by search query
    final filteredVisitors = allVisitors.where((v) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return v.name.toLowerCase().contains(q) ||
          v.company.toLowerCase().contains(q) ||
          v.hostEmployee.toLowerCase().contains(q);
    }).toList();

    // Group visitors by Date
    final Map<String, List<Visitor>> groupedVisitors = {};
    final DateTime now = DateTime.now();

    for (var visitor in filteredVisitors) {
      String key;
      final diffDays = now.difference(visitor.entryTime).inDays;
      if (diffDays == 0 && visitor.entryTime.day == now.day) {
        key = '${DateFormat('dd MMM yyyy').format(visitor.entryTime)} (Today)';
      } else if (diffDays <= 1 && visitor.entryTime.day == now.subtract(const Duration(days: 1)).day) {
        key = '${DateFormat('dd MMM yyyy').format(visitor.entryTime)} (Yesterday)';
      } else {
        key = DateFormat('dd MMM yyyy').format(visitor.entryTime);
      }

      groupedVisitors.putIfAbsent(key, () => []).add(visitor);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Visitor History'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search & Filter Header Bar
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search visitor, company or host',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.inputBorder),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.calendar_month_outlined, color: AppColors.textPrimary, size: 20),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
                          setState(() {
                            _searchQuery = DateFormat('dd MMM').format(picked);
                            _searchController.text = _searchQuery;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Date Grouped Visitor List
            Expanded(
              child: groupedVisitors.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.search_off, size: 48, color: AppColors.textMuted),
                          SizedBox(height: 12),
                          Text(
                            'No visitor records found',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: groupedVisitors.keys.length,
                      itemBuilder: (context, dateIndex) {
                        final dateHeader = groupedVisitors.keys.elementAt(dateIndex);
                        final dateVisitors = groupedVisitors[dateHeader]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
                              child: Text(
                                dateHeader,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: dateVisitors.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 10),
                              itemBuilder: (context, vIndex) {
                                final v = dateVisitors[vIndex];
                                final timeStr = DateFormat('hh:mm a').format(v.entryTime);

                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: AppColors.cardBorder),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CheckOutVisitorScreen(visitor: v),
                                          ),
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(16),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          children: [
                                             CircleAvatar(
                                               radius: 20,
                                               backgroundColor: AppColors.primaryLight,
                                               backgroundImage: v.photoUrl.isNotEmpty ? NetworkImage(v.photoUrl) : null,
                                               child: v.photoUrl.isEmpty ? const Icon(Icons.person, color: AppColors.primary, size: 20) : null,
                                             ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    v.name,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: AppColors.textPrimary,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    v.company,
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
                                                  timeStr,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.textSecondary,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: v.status == VisitorStatus.insideCampus
                                                        ? AppColors.greenInsideBg
                                                        : (v.status == VisitorStatus.checkedOut
                                                            ? AppColors.purpleCheckedOutBg
                                                            : AppColors.orangePendingBg),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Text(
                                                    v.status == VisitorStatus.insideCampus
                                                        ? 'Inside Campus'
                                                        : (v.status == VisitorStatus.checkedOut
                                                            ? 'Checked Out'
                                                            : 'Pending'),
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.bold,
                                                      color: v.status == VisitorStatus.insideCampus
                                                          ? AppColors.greenInside
                                                          : (v.status == VisitorStatus.checkedOut
                                                              ? AppColors.purpleCheckedOut
                                                              : AppColors.orangePending),
                                                    ),
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
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
