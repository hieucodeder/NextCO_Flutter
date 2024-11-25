class Body {
  String? searchContent;
  int? pageIndex;
  int? pageSize;
  DateTime? frCreatedDate;
  DateTime? toCreatedDate;
  String? employeeId;
  String? customerId;
  String? userId;

  Body(
      {this.searchContent,
      this.pageIndex,
      this.pageSize,
      this.frCreatedDate,
      this.toCreatedDate,
      this.employeeId,
      this.customerId,
      this.userId});

  Body.fromJson(Map<String, dynamic> json) {
    searchContent = json['search_content'];
    pageIndex = json['pageIndex'];
    pageSize = json['pageSize'];
    frCreatedDate = json['fr_created_date'];
    toCreatedDate = json['to_created_date'];
    employeeId = json['employee_id'];
    customerId = json['customer_id'];
    userId = json['user_id'];
  }

  // Convert data to JSON, with dates in ISO 8601 format
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['search_content'] = searchContent;
    data['pageIndex'] = pageIndex;
    data['pageSize'] = pageSize;
    data['fr_created_date'] = frCreatedDate?.toIso8601String();
    data['to_created_date'] = toCreatedDate?.toIso8601String();
    data['employee_id'] = employeeId;
    data['customer_id'] = customerId;
    data['user_id'] = userId;
    return data;
  }
}
