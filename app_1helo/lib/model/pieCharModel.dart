class PieCharModel {
  final int statusId;
  final int quantity;

  PieCharModel({required this.statusId, required this.quantity});

  factory PieCharModel.fromJson(Map<String, dynamic> json) {
    return PieCharModel(
      statusId: json['status_id'] ?? 0, 
      quantity: json['quantity'] ?? 0, 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status_id': statusId,
      'quantity': quantity,
    };
  }
}
