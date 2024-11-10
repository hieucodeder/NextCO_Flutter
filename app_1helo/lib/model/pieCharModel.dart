class PieCharModel {
  final int statusId;
  final int quantity;
  final int complete;
  final int processing;
  final int canceled;

  PieCharModel({
    required this.statusId,
    required this.quantity,
    required this.complete,
    required this.processing,
    required this.canceled,
  });

  factory PieCharModel.fromJson(Map<String, dynamic> json) {
    return PieCharModel(
      statusId: json['status_id'] ?? 0,
      quantity: json['quantity'] ?? 0,
      complete: json['complete'] ?? 0,
      processing: json['processing'] ?? 0,
      canceled: json['canceled'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status_id': statusId,
      'quantity': quantity,
      'complete': complete,
      'processing': processing,
      'canceled': canceled,
    };
  }
}
