class PieCharModel {
  String? message;
  bool? success;
  double? inProgress;
  double? completed;
  double? revised;

  PieCharModel({this.message, this.success, this.inProgress, this.completed, this.revised});

  PieCharModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    inProgress = json['inProgress']?.toDouble(); // Ensure this is a double
    completed = json['completed']?.toDouble(); // Ensure this is a double
    revised = json['revised']?.toDouble(); // Ensure this is a double
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'success': success,
      'inProgress': inProgress,
      'completed': completed,
      'revised': revised,
    };
  }
}
