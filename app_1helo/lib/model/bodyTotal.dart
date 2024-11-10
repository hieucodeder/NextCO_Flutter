class bodyTotal {
  String? userId;
  String? userName;

  bodyTotal({this.userId, this.userName});

  bodyTotal.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    return data;
  }
}
