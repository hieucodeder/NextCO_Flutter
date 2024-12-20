class Userdomainmodel {
  final String? username;
  final String? password;
  final String? subdomain;

  // Constructor with named parameters and default values
  Userdomainmodel({this.username, this.password, this.subdomain});

  // A factory constructor that takes a Map and returns an instance of Userdomainmodel
  factory Userdomainmodel.fromJson(Map<String, dynamic> json) {
    return Userdomainmodel(
      username: json['username'] as String?,
      password: json['password'] as String?,
      subdomain: json['subdomain'] as String?,
    );
  }

  // Method to convert the Userdomainmodel instance to a Map
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'subdomain': subdomain,
    };
  }
}
