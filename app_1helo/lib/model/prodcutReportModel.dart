class Prodcutreportmodel {
  int? totalItems;
  int? page;
  int? pageSize;
  List<DataModel>? data;
  int? pageCount;

  Prodcutreportmodel(
      {this.totalItems, this.page, this.pageSize, this.data, this.pageCount});

  Prodcutreportmodel.fromJson(Map<String, dynamic> json) {
    totalItems = json['totalItems'] as int?;
    page = json['page'] as int?;
    pageSize = json['pageSize'] as int?;
    if (json['data'] != null) {
      data = <DataModel>[];
      json['data'].forEach((v) {
        data!.add(DataModel.fromJson(v));
      });
    }
    pageCount = json['pageCount'] as int?;
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

class DataModel {
  int? rowNumber;
  String? exportDeclarationNumber;
  String? exportDeclarationId;
  String? dateOfDeclaration;
  double? usdExchangeRate;
  int? sortOrder;
  String? productCode;
  String? hsCode;
  String? productName;
  String? originCountry;
  double? unitPrice;
  double? taxablePrice;
  String? unit;
  int? quantity;
  int? coAvailable;
  int? coUsed;
  String? customerId;
  String? jsonAmaDetail;
  String? listJsonTamtaiDetail;
  String? listJsonProductNormCoDocuments;
  int? recordCount;

  DataModel(
      {this.rowNumber,
      this.exportDeclarationNumber,
      this.exportDeclarationId,
      this.dateOfDeclaration,
      this.usdExchangeRate,
      this.sortOrder,
      this.productCode,
      this.hsCode,
      this.productName,
      this.originCountry,
      this.unitPrice,
      this.taxablePrice,
      this.unit,
      this.quantity,
      this.coAvailable,
      this.coUsed,
      this.customerId,
      this.jsonAmaDetail,
      this.listJsonTamtaiDetail,
      this.listJsonProductNormCoDocuments,
      this.recordCount});

  DataModel.fromJson(Map<String, dynamic> json) {
    rowNumber = json['RowNumber'] as int?;
    exportDeclarationNumber = json['export_declaration_number'] as String?;
    exportDeclarationId = json['export_declaration_id'] as String?;
    dateOfDeclaration = json['date_of_declaration'] as String?;
    usdExchangeRate = (json['usd_exchange_rate'] as num?)?.toDouble();
    sortOrder = json['sort_order'] as int?;
    productCode = json['product_code'] as String?;
    hsCode = json['hs_code'] as String?;
    productName = json['product_name'] as String?;
    originCountry = json['origin_country'] as String?;
    unitPrice = (json['unit_price'] as num?)?.toDouble();
    taxablePrice = (json['taxable_price'] as num?)?.toDouble();
    unit = json['unit'] as String?;
    quantity = json['quantity'] as int?;
    coAvailable = json['co_available'] as int?;
    coUsed = json['co_used'] as int?;
    customerId = json['customer_id'] as String?;
    jsonAmaDetail = json['json_ama_detail'] as String?;
    listJsonTamtaiDetail = json['list_json_tamtai_detail'] as String?;
    listJsonProductNormCoDocuments =
        json['list_json_product_norm_co_documents'] as String?;
    recordCount = json['RecordCount'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['RowNumber'] = rowNumber;
    data['export_declaration_number'] = exportDeclarationNumber;
    data['export_declaration_id'] = exportDeclarationId;
    data['date_of_declaration'] = dateOfDeclaration;
    data['usd_exchange_rate'] = usdExchangeRate;
    data['sort_order'] = sortOrder;
    data['product_code'] = productCode;
    data['hs_code'] = hsCode;
    data['product_name'] = productName;
    data['origin_country'] = originCountry;
    data['unit_price'] = unitPrice;
    data['taxable_price'] = taxablePrice;
    data['unit'] = unit;
    data['quantity'] = quantity;
    data['co_available'] = coAvailable;
    data['co_used'] = coUsed;
    data['customer_id'] = customerId;
    data['json_ama_detail'] = jsonAmaDetail;
    data['list_json_tamtai_detail'] = listJsonTamtaiDetail;
    data['list_json_product_norm_co_documents'] =
        listJsonProductNormCoDocuments;
    data['RecordCount'] = recordCount;
    return data;
  }
}
