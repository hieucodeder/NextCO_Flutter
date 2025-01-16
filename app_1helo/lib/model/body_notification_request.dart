class BodyNotificationRequest {
  int? activeFlag;
  String? content;
  String? createdByUserId;
  String? createdDateTime;
  String? historyNotificationsId;
  bool? isRead;
  bool? isReceived;
  String? receiver;
  int? requestType;
  String? senderId;
  String? target;
  int? type;

  BodyNotificationRequest(
      {this.activeFlag,
      this.content,
      this.createdByUserId,
      this.createdDateTime,
      this.historyNotificationsId,
      this.isRead,
      this.isReceived,
      this.receiver,
      this.requestType,
      this.senderId,
      this.target,
      this.type});

  /// Constructor for creating an object from JSON
  factory BodyNotificationRequest.fromJson(Map<String, dynamic> json) {
    return BodyNotificationRequest(
        activeFlag: json['active_flag'] as int?,
        content: json['content'] as String?,
        createdByUserId: json['created_by_user_id'] as String?,
        createdDateTime: json['created_date_time'] as String?,
        historyNotificationsId: json['history_notifications_id'] as String?,
        isRead: json['is_read'] as bool?,
        isReceived: json['is_received'] as bool?,
        receiver: json['receiver'],
        requestType: json['request_type'] as int?,
        senderId: json['sender_id'] as String?,
        target: json['target'] as String?,
        type: json['type'] as int?);
  }

  /// Method to convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'active_flag': activeFlag,
      'content': content,
      'created_by_user_id': createdByUserId,
      'created_date_time': createdDateTime,
      'history_notifications_id': historyNotificationsId,
      'is_read': isRead,
      'is_received': isReceived,
      'receiver': receiver,
      'request_type': requestType,
      'sender': senderId,
      'target': target,
      'type': type
    };
  }
}
