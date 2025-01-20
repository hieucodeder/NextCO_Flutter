class ChatbotAnswerModel {
  final String message;
  final bool results;
  final ResponseData data;

  ChatbotAnswerModel({
    required this.message,
    required this.results,
    required this.data,
  });

  factory ChatbotAnswerModel.fromJson(Map<String, dynamic> json) {
    return ChatbotAnswerModel(
      message: json['message'] ?? '',
      results: json['results'] ?? false,
      data: ResponseData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'results': results,
      'data': data.toJson(),
    };
  }
}

class ResponseData {
  final String message;
  final List<String> images;

  ResponseData({
    required this.message,
    required this.images,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      message: json['message'] ?? '',
      images: List<String>.from(json['images'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'images': images,
    };
  }
}
