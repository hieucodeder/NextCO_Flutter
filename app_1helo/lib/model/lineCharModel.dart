class LinecharModel {
  bool? success;
  Data? data;

  LinecharModel({this.success, this.data});

  LinecharModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<CompleteCo>? completeCo;
  List<ProcessingCo>? processingCo;
  List<CanceledCo>? canceledCo;

  Data({this.completeCo, this.processingCo, this.canceledCo});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['complete_co'] != null) {
      completeCo = <CompleteCo>[];
      json['complete_co'].forEach((v) {
        completeCo!.add(CompleteCo.fromJson(v));
      });
    }
    if (json['processing_co'] != null) {
      processingCo = <ProcessingCo>[];
      json['processing_co'].forEach((v) {
        processingCo!.add(ProcessingCo.fromJson(v));
      });
    }
    if (json['canceled_co'] != null) {
      canceledCo = <CanceledCo>[];
      json['canceled_co'].forEach((v) {
        canceledCo!.add(CanceledCo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (completeCo != null) {
      data['complete_co'] = completeCo!.map((v) => v.toJson()).toList();
    }
    if (processingCo != null) {
      data['processing_co'] = processingCo!.map((v) => v.toJson()).toList();
    }
    if (canceledCo != null) {
      data['canceled_co'] = canceledCo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CompleteCo {
  String? quantity;
  String? createdDate;
  String? modifiedDate;
  int? modificationCount;

  CompleteCo(
      {this.quantity,
      this.createdDate,
      this.modifiedDate,
      this.modificationCount});

  CompleteCo.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    createdDate = json['created_date'];
    modifiedDate = json['modified_date'];
    modificationCount = json['modification_count'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quantity'] = quantity;
    data['created_date'] = createdDate;
    data['modified_date'] = modifiedDate;
    data['modification_count'] = modificationCount;
    return data;
  }
}

class ProcessingCo {
  String? quantity;
  String? createdDate;
  String? modifiedDate;
  int? modificationCount;

  ProcessingCo(
      {this.quantity,
      this.createdDate,
      this.modifiedDate,
      this.modificationCount});

  ProcessingCo.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    createdDate = json['created_date'];
    modifiedDate = json['modified_date'];
    modificationCount = json['modification_count'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quantity'] = quantity;
    data['created_date'] = createdDate;
    data['modified_date'] = modifiedDate;
    data['modification_count'] = modificationCount;
    return data;
  }
}

class CanceledCo {
  String? quantity;
  String? createdDate;
  String? modifiedDate;
  int? modificationCount;

  CanceledCo(
      {this.quantity,
      this.createdDate,
      this.modifiedDate,
      this.modificationCount});

  CanceledCo.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    createdDate = json['created_date'];
    modifiedDate = json['modified_date'];
    modificationCount = json['modification_count'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quantity'] = quantity;
    data['created_date'] = createdDate;
    data['modified_date'] = modifiedDate;
    data['modification_count'] = modificationCount;
    return data;
  }
}
