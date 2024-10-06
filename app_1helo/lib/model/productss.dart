class Productss {
  int? totalItems;
  int? page;
  int? pageSize;
  List<Data>? data;
  int? pageCount;

  Productss(
      {this.totalItems, this.page, this.pageSize, this.data, this.pageCount});

  Productss.fromJson(Map<String, dynamic> json) {
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
  String? productId;
  Null? normId;
  Null? productExpenseId;
  String? productCode;
  String? hsCode;
  String? productName;
  String? unit;
  String? customerId;
  String? customerName;
  int? ts;
  int? rowNumber;
  String? recordCount;

  Data(
      {this.productId,
      this.normId,
      this.productExpenseId,
      this.productCode,
      this.hsCode,
      this.productName,
      this.unit,
      this.customerId,
      this.customerName,
      this.ts,
      this.rowNumber,
      this.recordCount});

  Data.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    normId = json['norm_id'];
    productExpenseId = json['product_expense_id'];
    productCode = json['product_code'];
    hsCode = json['hs_code'];
    productName = json['product_name'];
    unit = json['unit'];
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    ts = json['ts'];
    rowNumber = json['RowNumber'];
    recordCount = json['RecordCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['norm_id'] = this.normId;
    data['product_expense_id'] = this.productExpenseId;
    data['product_code'] = this.productCode;
    data['hs_code'] = this.hsCode;
    data['product_name'] = this.productName;
    data['unit'] = this.unit;
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.customerName;
    data['ts'] = this.ts;
    data['RowNumber'] = this.rowNumber;
    data['RecordCount'] = this.recordCount;
    return data;
  }
}
