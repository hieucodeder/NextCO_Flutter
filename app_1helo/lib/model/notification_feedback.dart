class NotificationFeedback {
  final int type;
  final String content;
  final bool isRead;
  final bool isReceived;
  final String createdByUserId;
  final String createdDateTime;
  final String historyNotificationsId;
  final String receiver;

  final int requestType;
  final String sender;
  final int activeFlag;
  final String target;

  NotificationFeedback({
    required this.activeFlag,
    required this.type,
    required this.content,
    required this.isRead,
    required this.isReceived,
    required this.createdByUserId,
    required this.createdDateTime,
    required this.historyNotificationsId,
    required this.receiver,
    required this.requestType,
    required this.sender,
    required this.target,
  });

  factory NotificationFeedback.fromJson(Map<String, dynamic> json) {
    return NotificationFeedback(
      type: json['type'],
      activeFlag: json['active_flag'],
      content: json['content'],
      isRead: json['is_read'],
      isReceived: json['is_received'],
      createdByUserId: json['created_by_user_id'],
      createdDateTime: json['created_date_time'],
      historyNotificationsId: json['history_notifications_id'],
      receiver: json['receiver'],
      requestType: json['request_type'],
      sender: json['sender'],
      target: json['target'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'content': content,
      'is_read': isRead,
      'active_flag': activeFlag,
      'is_received': isReceived,
      'created_by_user_id': createdByUserId,
      'created_date_time': createdDateTime,
      'history_notifications_id': historyNotificationsId,
      'receiver': receiver,
      'request_type': requestType,
      'sender': sender,
      'target': target,
    };
  }
}
