class Bodyreport {
  String? customerId;
  DateTime? frCreatedDate;
  int? pageIndex;
  int? pageSize;
  String? searchContent;
  DateTime? toCreatedDate;
  int? typeSearch;
  String? userId;

  Bodyreport(
      {this.customerId,
      this.frCreatedDate,
      this.pageIndex,
      this.pageSize,
      this.searchContent,
      this.toCreatedDate,
      this.typeSearch,
      this.userId});

  Bodyreport.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    frCreatedDate = json['fr_created_date'];
    pageIndex = json['pageIndex'];
    pageSize = json['pageSize'];
    searchContent = json['search_content'];
    toCreatedDate = json['to_created_date'];
    typeSearch = json['type_search'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_id'] = customerId;
    data['pageIndex'] = pageIndex;
    data['pageSize'] = pageSize;
    data['search_content'] = searchContent;
    data['fr_created_date'] = frCreatedDate?.toIso8601String();
    data['to_created_date'] = toCreatedDate?.toIso8601String();
    data['type_search'] = typeSearch;
    data['user_id'] = userId;
    return data;
  }
}
