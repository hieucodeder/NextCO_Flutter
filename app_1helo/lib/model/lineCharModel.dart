class LinecharModel {
  bool? success;
  DataModel? data;

  LinecharModel({this.success, this.data});

  LinecharModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? DataModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DataModel {
  List<Co>? completeCo;
  List<Co>? processingCo;
  List<Co>? canceledCo;

  DataModel({this.completeCo, this.processingCo, this.canceledCo});

  DataModel.fromJson(Map<String, dynamic> json) {
    if (json['complete_co'] != null) {
      completeCo = <Co>[];
      json['complete_co'].forEach((v) {
        completeCo!.add(Co.fromJson(v));
      });
    }
    if (json['processing_co'] != null) {
      processingCo = <Co>[];
      json['processing_co'].forEach((v) {
        processingCo!.add(Co.fromJson(v));
      });
    }
    if (json['canceled_co'] != null) {
      canceledCo = <Co>[];
      json['canceled_co'].forEach((v) {
        canceledCo!.add(Co.fromJson(v));
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

class Co {
  int? id;
  String? name;

  Co({this.id, this.name});

  Co.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
