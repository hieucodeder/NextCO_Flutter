class Tableemployeedmodel {
  int? totalItems;
  int? page;
  int? pageSize;
  List<Data>? data;
  int? pageCount;

  Tableemployeedmodel(
      {this.totalItems, this.page, this.pageSize, this.data, this.pageCount});

  Tableemployeedmodel.fromJson(Map<String, dynamic> json) {
    totalItems = json['totalItems'];
    page = json['page'];
    pageSize = json['pageSize'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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
  int? stt; // Số thứ tự
  String? employeeName; // Họ tên nhân viên
  int? completed; // Hoàn thành
  int? inProgress; // Đang thực hiện
  int? underRepair; // Đang sửa
  int? waitingForRepair; // Chờ sửa
  int? waitingForApproval; // Chờ duyệt
  int? rejected; // Từ chối xét duyệt
  int? waitingForCancellation; // Chờ hủy
  int? cancelled; // Đã hủy
  int? totalQuantity; // Tổng số lượng

  Data({
    this.stt,
    this.employeeName,
    this.completed,
    this.inProgress,
    this.underRepair,
    this.waitingForRepair,
    this.waitingForApproval,
    this.rejected,
    this.waitingForCancellation,
    this.cancelled,
    this.totalQuantity,
  });

  Data.fromJson(Map<String, dynamic> json) {
    stt = json['stt'];
    employeeName = json['employee_name'];
    completed = json['completed'];
    inProgress = json['in_progress'];
    underRepair = json['under_repair'];
    waitingForRepair = json['waiting_for_repair'];
    waitingForApproval = json['waiting_for_approval'];
    rejected = json['rejected'];
    waitingForCancellation = json['waiting_for_cancellation'];
    cancelled = json['cancelled'];
    totalQuantity = json['total_quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stt'] = stt;
    data['employee_name'] = employeeName;
    data['completed'] = completed;
    data['in_progress'] = inProgress;
    data['under_repair'] = underRepair;
    data['waiting_for_repair'] = waitingForRepair;
    data['waiting_for_approval'] = waitingForApproval;
    data['rejected'] = rejected;
    data['waiting_for_cancellation'] = waitingForCancellation;
    data['cancelled'] = cancelled;
    data['total_quantity'] = totalQuantity;
    return data;
  }
}
