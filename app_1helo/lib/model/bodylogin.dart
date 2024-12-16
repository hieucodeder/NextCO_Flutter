class Bodylogin {
  String? username;
  String? password;
  String? domain;

  Bodylogin({this.username, this.password, this.domain});

  Bodylogin.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    domain = json['domain'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    data['domain'] = this.domain;
    return data;
  }

  String getDomainForBodylogin(String username) {
    if (username.startsWith('admin')) {
      return 'https://admin-api.example.com';
    } else if (username.startsWith('user')) {
      return 'https://user-api.example.com';
    }
    return 'https://default-api.example.com'; // Giá trị mặc định
  }

  Bodylogin buildBodylogin(String username, String password) {
    String domain = getDomainForBodylogin(username);

    // Kiểm tra domain hợp lệ
    if (domain.isEmpty) {
      throw Exception('Domain không hợp lệ cho username: $username');
    }

    return Bodylogin(username: username, password: password, domain: domain);
  }
}
