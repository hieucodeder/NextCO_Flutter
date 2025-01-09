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

  StatisticsList({this.statistics});

  StatisticsList.fromJson(dynamic json) {
    if (json is Map<String, dynamic> &&
        json['data'] != null &&
        json['data'] is List) {
      // Handle Map with 'data' key
      statistics = (json['data'] as List)
          .map((item) => Statistics.fromJson(item))
          .toList();
    } else if (json is List<dynamic>) {
      // Handle List directly
      statistics = json.map((item) => Statistics.fromJson(item)).toList();
    } else {
      throw ArgumentError("Invalid JSON structure for StatisticsList");
    }
  }

  List<Map<String, dynamic>> toJson() {
    return statistics?.map((e) => e.toJson()).toList() ?? [];
  }
}
