class BodyNotification {
  int? pageIndex;
  int? pageSize;
  String? userId;

  BodyNotification({this.pageIndex, this.pageSize, this.userId});

  BodyNotification.fromJson(Map<String, dynamic> json) {
    pageIndex = json['pageIndex'];
    pageSize = json['pageSize'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pageIndex'] = pageIndex;
    data['pageSize'] = pageSize;
    data['user_id'] = userId;
    return data;
  }
}
