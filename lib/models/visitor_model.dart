enum VisitorStatus {
  insideCampus,
  checkedOut,
  pendingApproval,
}

class Visitor {
  final String id;
  final String name;
  final String mobile;
  final String company;
  final String department;
  final String hostEmployee;
  final String purpose;
  final String category;
  final String photoUrl;
  final DateTime entryTime;
  DateTime? exitTime;
  VisitorStatus status;
  String? vehicleNumber;
  String? remarks;

  Visitor({
    required this.id,
    required this.name,
    required this.mobile,
    required this.company,
    required this.department,
    required this.hostEmployee,
    required this.purpose,
    required this.category,
    required this.photoUrl,
    required this.entryTime,
    this.exitTime,
    required this.status,
    this.vehicleNumber,
    this.remarks,
  });

  String get durationString {
    final endTime = exitTime ?? DateTime.now();
    final diff = endTime.difference(entryTime);
    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}
