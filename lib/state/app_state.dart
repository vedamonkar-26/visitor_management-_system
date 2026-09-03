import 'package:flutter/material.dart';
import '../models/visitor_model.dart';
import '../models/employee_model.dart';
import '../data/dummy_data.dart';

class WatchmanProfileData {
  String fullName;
  String guardId;
  String mobile;
  String email;
  String password;

  WatchmanProfileData({
    required this.fullName,
    required this.guardId,
    required this.mobile,
    required this.email,
    required this.password,
  });
}

class AppState extends ChangeNotifier {
  WatchmanProfileData watchman = WatchmanProfileData(
    fullName: '',
    guardId: '',
    mobile: '',
    email: '',
    password: '',
  );

  List<Visitor> visitors = [];
  List<Employee> employees = List.from(dummyEmployees);

  int get todaysVisitorsCount => visitors.length;
  int get insideCampusCount => visitors.where((v) => v.status == VisitorStatus.insideCampus).length;
  int get pendingApprovalCount => visitors.where((v) => v.status == VisitorStatus.pendingApproval).length;
  int get checkedOutCount => visitors.where((v) => v.status == VisitorStatus.checkedOut).length;

  List<Visitor> get visitorsInside => visitors.where((v) => v.status == VisitorStatus.insideCampus).toList();

  void registerNewVisitor(Visitor visitor) {
    visitors.insert(0, visitor);
    notifyListeners();
  }

  void checkInVisitor(String visitorId) {
    final index = visitors.indexWhere((v) => v.id == visitorId);
    if (index != -1) {
      visitors[index].status = VisitorStatus.insideCampus;
      notifyListeners();
    }
  }

  void checkOutVisitor(String visitorId, {String? vehicleNumber, String? remarks}) {
    final index = visitors.indexWhere((v) => v.id == visitorId);
    if (index != -1) {
      visitors[index].status = VisitorStatus.checkedOut;
      visitors[index].exitTime = DateTime.now();
      if (vehicleNumber != null && vehicleNumber.isNotEmpty) {
        visitors[index].vehicleNumber = vehicleNumber;
      }
      if (remarks != null && remarks.isNotEmpty) {
        visitors[index].remarks = remarks;
      }
      notifyListeners();
    }
  }

  void updateProfile({
    required String fullName,
    required String guardId,
    required String mobile,
    required String email,
    required String password,
  }) {
    watchman.fullName = fullName;
    watchman.guardId = guardId;
    watchman.mobile = mobile;
    watchman.email = email;
    watchman.password = password;
    notifyListeners();
  }
}
