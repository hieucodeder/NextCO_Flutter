// ignore_for_file: file_names

class Bodyuser {
  String? phone;
  String? password;

  Bodyuser({this.phone, this.password});

  Bodyuser.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone'] = phone;
    data['password'] = password;
    return data;
  }
}
