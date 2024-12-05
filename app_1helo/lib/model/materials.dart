class Materials {
  int? totalItems;
  int? page;
  int? pageSize;
  List<Data>? data;
  int? pageCount;

  Materials(
      {this.totalItems, this.page, this.pageSize, this.data, this.pageCount});

  Materials.fromJson(Map<String, dynamic> json) {
    totalItems = json['totalItems'];
    page = json['page'];
    pageSize = json['pageSize'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    pageCount = json['pageCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalItems'] = this.totalItems;
    data['page'] = this.page;
    data['pageSize'] = this.pageSize;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['pageCount'] = this.pageCount;
    return data;
  }
}

class Data {
  int? rowNumber;
  String? materialId;
  String? hsCode;
  String? materialName;
  String? materialCode;
  String? unit;
  int? coAvailable;
  int? coUsing;
  int? recordCount;

  Data({
    this.rowNumber,
    this.materialId,
    this.hsCode,
    this.materialName,
    this.materialCode,
    this.unit,
    this.coAvailable,
    this.coUsing,
    this.recordCount,
  });

  Data.fromJson(Map<String, dynamic> json) {
    rowNumber = _parseInt(json['RowNumber']);
    materialId = json['material_id'];
    hsCode = json['hs_code'];
    materialName = json['material_name'];
    materialCode = json['material_code'];
    unit = json['unit'];
    coAvailable = _parseInt(json['co_available']);
    coUsing = _parseInt(json['co_using']);
    recordCount = _parseInt(json['RecordCount']);
  }

  int? _parseInt(dynamic value) {
    if (value is int) {
      return value;
    } else if (value is double) {
      return value.toInt();
    } else if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['RowNumber'] = rowNumber;
    data['material_id'] = materialId;
    data['hs_code'] = hsCode;
    data['material_name'] = materialName;
    data['material_code'] = materialCode;
    data['unit'] = unit;
    data['co_available'] = coAvailable;
    data['co_using'] = coUsing;
    data['RecordCount'] = recordCount;
    return data;
  }
}
