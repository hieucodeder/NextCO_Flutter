// ignore_for_file: camel_case_types

class bodyTotal {
  String? userId;
  String? userName;

  bodyTotal({this.userId, this.userName});

  bodyTotal.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_name'] = userName;
    return data;
  }
}
