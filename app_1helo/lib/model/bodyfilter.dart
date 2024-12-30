class Bodyfilter {
  String? searchContent;
  int? pageIndex;
  String? employeeId;
  String? customerId;
  int? pageSize;
  String? userId;
  int? statusId;

  Bodyfilter(
      {this.searchContent,
      this.pageIndex,
      this.employeeId,
      this.customerId,
      this.pageSize,
      this.userId,
      this.statusId});

  Bodyfilter.fromJson(Map<String, dynamic> json) {
    searchContent = json['search_content'];
    pageIndex = json['pageIndex'];
    employeeId = json['employee_id'];
    customerId = json['customer_id'];
    pageSize = json['pageSize'];
    userId = json['user_id'];
    statusId = json['status_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['search_content'] = searchContent;
    data['pageIndex'] = pageIndex;
    data['employee_id'] = employeeId;
    data['customer_id'] = customerId;
    data['pageSize'] = pageSize;
    data['user_id'] = userId;
    data['status_id'] = statusId;
    return data;
  }
}
