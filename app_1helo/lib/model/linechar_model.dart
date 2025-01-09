class LinecharModel {
  bool? success;
  Data? data;

  LinecharModel({this.success, this.data});

  // Factory constructor for JSON parsing
  factory LinecharModel.fromJson(Map<String, dynamic> json) {
    return LinecharModel(
      success: json['success'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  // Method to convert LinecharModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
    };
  }
}

class Data {
  List<CompleteCo>? completeCo;
  List<ProcessingCo>? processingCo;
  List<CanceledCo>? canceledCo;

  Data({this.completeCo, this.processingCo, this.canceledCo});

  // Factory constructor for JSON parsing
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      completeCo: json['complete_co'] != null
          ? (json['complete_co'] as List)
              .map((v) => CompleteCo.fromJson(v))
              .toList()
          : null,
      processingCo: json['processing_co'] != null
          ? (json['processing_co'] as List)
              .map((v) => ProcessingCo.fromJson(v))
              .toList()
          : null,
      canceledCo: json['canceled_co'] != null
          ? (json['canceled_co'] as List)
              .map((v) => CanceledCo.fromJson(v))
              .toList()
          : null,
    );
  }

  // Method to convert Data to JSON
  Map<String, dynamic> toJson() {
    return {
      'complete_co': completeCo?.map((v) => v.toJson()).toList(),
      'processing_co': processingCo?.map((v) => v.toJson()).toList(),
      'canceled_co': canceledCo?.map((v) => v.toJson()).toList(),
    };
  }
}

class CompleteCo {
  String? quantity;
  String? createdDate;
  String? modifiedDate;
  int? modificationCount;

  CompleteCo({
    this.quantity,
    this.createdDate,
    this.modifiedDate,
    this.modificationCount,
  });

  // Factory constructor for JSON parsing
  factory CompleteCo.fromJson(Map<String, dynamic> json) {
    return CompleteCo(
      quantity: json['quantity'],
      createdDate: json['created_date'],
      modifiedDate: json['modified_date'],
      modificationCount: json['modification_count'] ?? 0,
    );
  }

  // Method to convert CompleteCo to JSON
  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'created_date': createdDate,
      'modified_date': modifiedDate,
      'modification_count': modificationCount,
    };
  }
}

// ProcessingCo and CanceledCo classes are the same as CompleteCo. Use typedefs for simplicity.
typedef ProcessingCo = CompleteCo;
typedef CanceledCo = CompleteCo;
