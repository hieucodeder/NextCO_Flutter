class PieCharModel {
  int? statusId;
  int? quantity;


  PieCharModel({this.statusId, this.quantity});

  PieCharModel.fromJson(Map<String, dynamic> json) {
    statusId = json['status_id'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_id'] = this.statusId;
    data['quantity'] = this.quantity;
    return data;
  }

  @override
  String toString() {
    return 'PieCharModel(statusId: $statusId, quantity: $quantity)';
  }
}
