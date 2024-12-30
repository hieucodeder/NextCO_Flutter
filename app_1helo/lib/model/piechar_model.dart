class PieCharModel {
  int? statusId;
  int? quantity;


  PieCharModel({this.statusId, this.quantity});

  PieCharModel.fromJson(Map<String, dynamic> json) {
    statusId = json['status_id'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status_id'] = statusId;
    data['quantity'] = quantity;
    return data;
  }

  @override
  String toString() {
    return 'PieCharModel(statusId: $statusId, quantity: $quantity)';
  }
}
