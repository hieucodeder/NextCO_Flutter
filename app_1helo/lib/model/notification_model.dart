class NotificationModel {
  int? totalItems;
  int? page;
  int? pageSize;
  List<Data>? data;
  int? pageCount;

  NotificationModel(
      {this.totalItems, this.page, this.pageSize, this.data, this.pageCount});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    totalItems = json['totalItems'];
    page = json['page'];
    pageSize = json['pageSize'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    pageCount = json['pageCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalItems'] = totalItems;
    data['page'] = page;
    data['pageSize'] = pageSize;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['pageCount'] = pageCount;
    return data;
  }
}

class Data {
  int? rowNumber;
  String? notifyId;
  String? content;
  String? reason;
  int? accessCoDetail;
  String? target;
  int? requestType;
  String? sender;
  String? senderId;
  String? createdDateTime;
  int? isRead;
  int? isReceived;
  int? activeFlag;
  String? customerName;
  String? historyNotificationsId;
  String? recordCount;

  Data(
      {this.rowNumber,
      this.notifyId,
      this.content,
      this.reason,
      this.accessCoDetail,
      this.target,
      this.requestType,
      this.sender,
      this.senderId,
      this.createdDateTime,
      this.isRead,
      this.isReceived,
      this.activeFlag,
      this.customerName,
      this.historyNotificationsId,
      this.recordCount});

  Data.fromJson(Map<String, dynamic> json) {
    rowNumber = json['RowNumber'];
    notifyId = json['notify_id'];
    content = json['content'];
    reason = json['reason'];
    accessCoDetail = json['access_co_detail'];
    target = json['target'];
    requestType = json['request_type'];
    sender = json['sender'];
    senderId = json['sender_id'];
    createdDateTime = json['created_date_time'];
    isRead = json['is_read'];
    isReceived = json['is_received'];
    activeFlag = json['active_flag'];
    customerName = json['customer_name'];
    historyNotificationsId = json['history_notifications_id'];
    recordCount = json['RecordCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['RowNumber'] = rowNumber;
    data['notify_id'] = notifyId;
    data['content'] = content;
    data['reason'] = reason;
    data['access_co_detail'] = accessCoDetail;
    data['target'] = target;
    data['request_type'] = requestType;
    data['sender'] = sender;
    data['sender_id'] = senderId;
    data['created_date_time'] = createdDateTime;
    data['is_read'] = isRead;
    data['is_received'] = isReceived;
    data['active_flag'] = activeFlag;
    data['customer_name'] = customerName;
    data['history_notifications_id'] = historyNotificationsId;
    data['RecordCount'] = recordCount;
    return data;
  }
}
