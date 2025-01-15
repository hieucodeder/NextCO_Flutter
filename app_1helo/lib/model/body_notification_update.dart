class BodyNotificationUpdate {
  String? recordCount;
  int? rowNumber;
  int? accessCoDetail;
  int? activeFlag;
  String? content;
  String? createdDateTime;
  String? customerName;
  String? historyNotificationsId;
  bool? isRead;
  int? isReceived;
  String? notifyId;
  String? reason;
  int? requestType;
  String? sender;
  String? senderId;
  String? target;

  BodyNotificationUpdate({
    this.recordCount,
    this.rowNumber,
    this.accessCoDetail,
    this.activeFlag,
    this.content,
    this.createdDateTime,
    this.customerName,
    this.historyNotificationsId,
    this.isRead,
    this.isReceived,
    this.notifyId,
    this.reason,
    this.requestType,
    this.sender,
    this.senderId,
    this.target,
  });

  /// Constructor for creating an object from JSON
  factory BodyNotificationUpdate.fromJson(Map<String, dynamic> json) {
    return BodyNotificationUpdate(
      recordCount: json['RecordCount'] as String?,
      rowNumber: json['RowNumber'] as int?,
      accessCoDetail: json['access_co_detail'] as int?,
      activeFlag: json['active_flag'] as int?,
      content: json['content'] as String?,
      createdDateTime: json['created_date_time'] as String?,
      customerName: json['customer_name'] as String?,
      historyNotificationsId: json['history_notifications_id'] as String?,
      isRead: json['is_read'] as bool?,
      isReceived: json['is_received'] as int?,
      notifyId: json['notify_id'] as String?,
      reason: json['reason'] as String?, // Ensure `reason` is of type `String?`
      requestType: json['request_type'] as int?,
      sender: json['sender'] as String?,
      senderId: json['sender_id'] as String?,
      target: json['target'] as String?,
    );
  }

  /// Method to convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'RecordCount': recordCount,
      'RowNumber': rowNumber,
      'access_co_detail': accessCoDetail,
      'active_flag': activeFlag,
      'content': content,
      'created_date_time': createdDateTime,
      'customer_name': customerName,
      'history_notifications_id': historyNotificationsId,
      'is_read': isRead,
      'is_received': isReceived,
      'notify_id': notifyId,
      'reason': reason, // Updated to handle null-safety for `reason`
      'request_type': requestType,
      'sender': sender,
      'sender_id': senderId,
      'target': target,
    };
  }
}
