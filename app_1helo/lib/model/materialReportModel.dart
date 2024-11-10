class Materialreportmodel {
  double? totalItems;
  double? page;
  double? pageSize;
  List<Data>? data;
  double? pageCount;

  Materialreportmodel({
    this.totalItems,
    this.page,
    this.pageSize,
    this.data,
    this.pageCount,
  });

  Materialreportmodel.fromJson(Map<String, dynamic> json) {
    totalItems = (json['totalItems'] as num?)?.toDouble();
    page = (json['page'] as num?)?.toDouble();
    pageSize = (json['pageSize'] as num?)?.toDouble();
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    pageCount = (json['pageCount'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalItems'] = totalItems;
    data['page'] = page;
    data['pageSize'] = pageSize;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['pageCount'] = pageCount;
    return data;
  }
}

class Data {
  int? rowNumber;
  String? importDeclarationVat;
  String? serialNumber;
  String? dateOfDeclaration;
  int? usdExchangeRate;
  int? sortOrder;
  String? materialCode;
  String? hsCode;
  String? materialName;
  String? originCountry;
  double? unitPrice; 
  double? unitPriceTransport; 
  String? unit;
  int? quantity;
  int? coAvailable;
  int? coUsing;
  int? coUsed;
  dynamic listJsonMaterialNormCoDocuments;
  dynamic jsonAmaDetail;
  dynamic jsonThucongDetail;
  dynamic jsonTieuhuyDetail;
  dynamic listJsonTamtaiDetail;
  dynamic listJsonThanhlyDetail;
  double? recordCount;

  Data({
    this.rowNumber,
    this.importDeclarationVat,
    this.serialNumber,
    this.dateOfDeclaration,
    this.usdExchangeRate,
    this.sortOrder,
    this.materialCode,
    this.hsCode,
    this.materialName,
    this.originCountry,
    this.unitPrice,
    this.unitPriceTransport,
    this.unit,
    this.quantity,
    this.coAvailable,
    this.coUsing,
    this.coUsed,
    this.listJsonMaterialNormCoDocuments,
    this.jsonAmaDetail,
    this.jsonThucongDetail,
    this.jsonTieuhuyDetail,
    this.listJsonTamtaiDetail,
    this.listJsonThanhlyDetail,
    this.recordCount,
  });

  Data.fromJson(Map<String, dynamic> json) {
    rowNumber = json['RowNumber'] as int?;
    importDeclarationVat = json['import_declaration_vat'] as String?;
    serialNumber = json['serial_number'] as String?;
    dateOfDeclaration = json['date_of_declaration'] as String?;
    usdExchangeRate = json['usd_exchange_rate'] as int?;
    sortOrder = json['sort_order'] as int?;
    materialCode = json['material_code'] as String?;
    hsCode = json['hs_code'] as String?;
    materialName = json['material_name'] as String?;
    originCountry = json['origin_country'] as String?;
    unitPrice = (json['unit_price'] as num?)?.toDouble(); // Changed to double
    unitPriceTransport =
        (json['unit_price_transport'] as num?)?.toDouble(); // Changed to double
    unit = json['unit'] as String?;
    quantity = json['quantity'] as int?;
    coAvailable = json['co_available'] as int?;
    coUsing = json['co_using'] as int?;
    coUsed = json['co_used'] as int?;
    listJsonMaterialNormCoDocuments =
        json['list_json_material_norm_co_documents'];
    jsonAmaDetail = json['json_ama_detail'];
    jsonThucongDetail = json['json_thucong_detail'];
    jsonTieuhuyDetail = json['json_tieuhuy_detail'];
    listJsonTamtaiDetail = json['list_json_tamtai_detail'];
    listJsonThanhlyDetail = json['list_json_thanhly_detail'];
    recordCount =
        (json['RecordCount'] as num?)?.toDouble(); // Changed to double
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['RowNumber'] = rowNumber;
    data['import_declaration_vat'] = importDeclarationVat;
    data['serial_number'] = serialNumber;
    data['date_of_declaration'] = dateOfDeclaration;
    data['usd_exchange_rate'] = usdExchangeRate;
    data['sort_order'] = sortOrder;
    data['material_code'] = materialCode;
    data['hs_code'] = hsCode;
    data['material_name'] = materialName;
    data['origin_country'] = originCountry;
    data['unit_price'] = unitPrice;
    data['unit_price_transport'] = unitPriceTransport;
    data['unit'] = unit;
    data['quantity'] = quantity;
    data['co_available'] = coAvailable;
    data['co_using'] = coUsing;
    data['co_used'] = coUsed;
    data['list_json_material_norm_co_documents'] =
        listJsonMaterialNormCoDocuments;
    data['json_ama_detail'] = jsonAmaDetail;
    data['json_thucong_detail'] = jsonThucongDetail;
    data['json_tieuhuy_detail'] = jsonTieuhuyDetail;
    data['list_json_tamtai_detail'] = listJsonTamtaiDetail;
    data['list_json_thanhly_detail'] = listJsonThanhlyDetail;
    data['RecordCount'] = recordCount;
    return data;
  }
}
