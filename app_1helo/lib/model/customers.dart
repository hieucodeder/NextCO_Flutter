class Customers {
  int? totalItems;
  int? page;
  int? pageSize;
  List<Data>? data;
  int? pageCount;

  Customers(
      {this.totalItems, this.page, this.pageSize, this.data, this.pageCount});

  Customers.fromJson(Map<String, dynamic> json) {
    totalItems = json['totalItems'];
    page = json['page'];
    pageSize = json['pageSize'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    pageCount = json['pageCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
  int? processingFee;
  String? customerId;
  String? customerName;
  String? taxCode;
  String? phoneNumber;
  String? address;
  String? recordCount;
  Data(
      {this.rowNumber,
      this.processingFee,
      this.customerId,
      this.customerName,
      this.taxCode,
      this.phoneNumber,
      this.address,
      this.recordCount});

  Data.fromJson(Map<String, dynamic> json) {
    rowNumber = json['RowNumber'];
    processingFee = json['processing_fee'];
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    taxCode = json['tax_code'];
    phoneNumber = json['phone_number'];
    address = json['address'];
    recordCount = json['RecordCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['RowNumber'] = this.rowNumber;
    data['processing_fee'] = this.processingFee;
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.customerName;
    data['tax_code'] = this.taxCode;
    data['phone_number'] = this.phoneNumber;
    data['address'] = this.address;
    data['RecordCount'] = this.recordCount;
    return data;
  }
}
