class Bodysearchuser {
  String? branchId;
  String? customerId;
  String? departmentId;
  int? pageIndex;
  int? pageSize;
  String? searchContent;
  String? userId;

  Bodysearchuser(
      {this.branchId,
      this.customerId,
      this.departmentId,
      this.pageIndex,
      this.pageSize,
      this.searchContent,
      this.userId});

  Bodysearchuser.fromJson(Map<String, dynamic> json) {
    branchId = json['branch_id'];
    customerId = json['customer_id'];
    departmentId = json['department_id'];
    pageIndex = json['pageIndex'];
    pageSize = json['pageSize'];
    searchContent = json['search_content'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['branch_id'] = this.branchId;
    data['customer_id'] = this.customerId;
    data['department_id'] = this.departmentId;
    data['pageIndex'] = this.pageIndex;
    data['pageSize'] = this.pageSize;
    data['search_content'] = this.searchContent;
    data['user_id'] = this.userId;
    return data;
  }
}
