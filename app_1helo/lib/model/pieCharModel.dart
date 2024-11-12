class PieCharModel {
  int? statusId;
  int? quantity;
  String?
      createdDate; // Assuming the date is in string format, or use DateTime directly

  PieCharModel({this.statusId, this.quantity, this.createdDate});

  PieCharModel.fromJson(Map<String, dynamic> json) {
    statusId = json['status_id'];
    quantity = json['quantity'];
    createdDate = json[
        'created_date']; // Assuming created_date is returned from the server
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_id'] = this.statusId;
    data['quantity'] = this.quantity;
    data['created_date'] = this.createdDate;
    return data;
  }
}
