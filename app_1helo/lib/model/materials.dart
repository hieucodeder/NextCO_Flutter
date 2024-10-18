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

  Data(
      {this.rowNumber,
      this.materialId,
      this.hsCode,
      this.materialName,
      this.materialCode,
      this.unit,
      this.coAvailable,
      this.coUsing,
      this.recordCount});

  Data.fromJson(Map<String, dynamic> json) {
    rowNumber = json['RowNumber'];
    materialId = json['material_id'];
    hsCode = json['hs_code'];
    materialName = json['material_name'];
    materialCode = json['material_code'];
    unit = json['unit'];
    coAvailable = json['co_available'];
    coUsing = json['co_using'];
    recordCount = json['RecordCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNumber'] = this.rowNumber;
    data['material_id'] = this.materialId;
    data['hs_code'] = this.hsCode;
    data['material_name'] = this.materialName;
    data['material_code'] = this.materialCode;
    data['unit'] = this.unit;
    data['co_available'] = this.coAvailable;
    data['co_using'] = this.coUsing;
    data['RecordCount'] = this.recordCount;
    return data;
  }
}
