class Body {
  String? searchContent;
  int? pageIndex;
  int? pageSize;
  Null frCreatedDate;
  Null toCreatedDate;
  String? employeeId;
  Null customerId;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['search_content'] = this.searchContent;
    data['pageIndex'] = this.pageIndex;
    data['pageSize'] = this.pageSize;
    data['fr_created_date'] = this.frCreatedDate;
    data['to_created_date'] = this.toCreatedDate;
    data['employee_id'] = this.employeeId;
    data['customer_id'] = this.customerId;
    data['user_id'] = this.userId;
    return data;
  }
}
