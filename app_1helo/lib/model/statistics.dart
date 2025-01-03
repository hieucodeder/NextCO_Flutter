import 'package:flutter/src/material/data_table.dart';

class Statuses {
  String? statusName;
  int? quantity;

  Statuses({this.statusName, this.quantity});

  Statuses.fromJson(Map<String, dynamic> json) {
    statusName = json['status_name'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status_name'] = statusName;
    data['quantity'] = quantity;
    return data;
  }
}

class Statistics {
  String? employeeId;
  String? fullName;
  List<Statuses>? statuses;

  Statistics({this.employeeId, this.fullName, this.statuses});

  Statistics.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    fullName = json['full_name'];
    if (json['statuses'] != null) {
      statuses = <Statuses>[];
      json['statuses'].forEach((v) {
        statuses!.add(Statuses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee_id'] = employeeId;
    data['full_name'] = fullName;
    if (statuses != null) {
      data['statuses'] = statuses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StatisticsList {
  List<Statistics>? statistics;

  // Constructor to handle list of Statistics
  StatisticsList({this.statistics});

  // Handle list of Statistics from the response
  StatisticsList.fromJson(List<dynamic> jsonList) {
    statistics = jsonList.map((item) => Statistics.fromJson(item)).toList();
  }

  List<Map<String, dynamic>> toJson() {
    return statistics?.map((e) => e.toJson()).toList() ?? [];
  }
}
