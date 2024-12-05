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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['search_content'] = this.searchContent;
    data['pageIndex'] = this.pageIndex;
    data['employee_id'] = this.employeeId;
    data['customer_id'] = this.customerId;
    data['pageSize'] = this.pageSize;
    data['user_id'] = this.userId;
    data['status_id'] = this.statusId;
    return data;
  }
}
