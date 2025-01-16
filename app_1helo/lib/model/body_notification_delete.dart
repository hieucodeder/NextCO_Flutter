import 'dart:convert';

class BodyNotificationDelete {
  List<String> notifications;

  BodyNotificationDelete({required this.notifications});

  // Parse JSON from a Map
  factory BodyNotificationDelete.fromJson(Map<String, dynamic> json) {
    return BodyNotificationDelete(
      notifications: List<String>.from(json['notifications'] ?? []),
    );
  }

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications,
    };
  }

  // Create an object from a JSON string
  static BodyNotificationDelete fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return BodyNotificationDelete.fromJson(json);
  }

  // Convert object to JSON string
  String toJsonString() {
    return jsonEncode(toJson());
  }
}
