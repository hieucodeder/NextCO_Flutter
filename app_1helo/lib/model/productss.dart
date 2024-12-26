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
  int? normId; // Update from Null? to int?
  int? productExpenseId; 
  String? productCode;
  String? hsCode;
  String? productName;
  String? unit;
  String? customerId;
  String? customerName;
  int? ts;
  int? rowNumber;
  String? recordCount;

  Data({
    this.productId,
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
    this.recordCount,
  });

  Data.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    normId = json['norm_id'] is int
        ? json['norm_id']
        : int.tryParse(json['norm_id']?.toString() ?? '');
    productExpenseId = json['product_expense_id'] is int
        ? json['product_expense_id']
        : int.tryParse(json['product_expense_id']?.toString() ?? '');
    productCode = json['product_code'];
    hsCode = json['hs_code'];
    productName = json['product_name'];
    unit = json['unit'];
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    ts = json['ts'] is int
        ? json['ts']
        : int.tryParse(json['ts']?.toString() ?? '');
    rowNumber = json['RowNumber'] is int
        ? json['RowNumber']
        : int.tryParse(json['RowNumber']?.toString() ?? '');
    recordCount = json['RecordCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['norm_id'] = normId;
    data['product_expense_id'] = productExpenseId;
    data['product_code'] = productCode;
    data['hs_code'] = hsCode;
    data['product_name'] = productName;
    data['unit'] = unit;
    data['customer_id'] = customerId;
    data['customer_name'] = customerName;
    data['ts'] = ts;
    data['RowNumber'] = rowNumber;
    data['RecordCount'] = recordCount;
    return data;
  }
}
