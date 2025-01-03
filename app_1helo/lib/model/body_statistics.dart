class BodyStatistics {
  String? employeeId;
  String? customerId;

  BodyStatistics({this.employeeId, this.customerId});

  BodyStatistics.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    customerId = json['customer_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee_id'] = employeeId;
    data['customer_id'] = customerId;
    return data;
  }
}
