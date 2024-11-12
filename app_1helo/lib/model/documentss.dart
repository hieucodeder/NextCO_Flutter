class Documentss {
  int? totalItems;
  int? page;
  int? pageSize;
  List<Data>? data;
  int? pageCount;

  Documentss(
      {this.totalItems, this.page, this.pageSize, this.data, this.pageCount});

  Documentss.fromJson(Map<String, dynamic> json) {
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
  int? coDocumentId;
  Null? coDocumentNumber;
  String? createdDate;
  String? employeeId;
  String? employeeName;
  String? customerId;
  String? coFormId;
  int? statusId;
  int? editable;
  String? customerName;
  String? formName;
  String? statusName;
  Null? statusDeclarations;
  List<String>? numberTkx;
  List<NumberTkxWithShippingTerms>? numberTkxWithShippingTerms;
  int? ts;
  int? result;
  String? cast;
  String? concat;
  int? rowNumber;
  String? recordCount;

  Data(
      {this.coDocumentId,
      this.coDocumentNumber,
      this.createdDate,
      this.employeeId,
      this.employeeName,
      this.customerId,
      this.coFormId,
      this.statusId,
      this.editable,
      this.customerName,
      this.formName,
      this.statusName,
      this.statusDeclarations,
      this.numberTkx,
      this.numberTkxWithShippingTerms,
      this.ts,
      this.result,
      this.cast,
      this.concat,
      this.rowNumber,
      this.recordCount});

  Data.fromJson(Map<String, dynamic> json) {
    coDocumentId = json['co_document_id'];
    coDocumentNumber = json['co_document_number'];
    createdDate = json['created_date'];
    employeeId = json['employee_id'];
    employeeName = json['employee_name'];
    customerId = json['customer_id'];
    coFormId = json['co_form_id'];
    statusId = json['status_id'];
    editable = json['editable'];
    customerName = json['customer_name'];
    formName = json['form_name'];
    statusName = json['status_name'];
    statusDeclarations = json['status_declarations'];

    numberTkx = json['number_tkx'] != null
        ? List<String>.from(json['number_tkx'])
        : []; // Default to an empty list if null

    if (json['number_tkx_with_shipping_terms'] != null) {
      numberTkxWithShippingTerms = <NumberTkxWithShippingTerms>[];
      json['number_tkx_with_shipping_terms'].forEach((v) {
        numberTkxWithShippingTerms!.add(NumberTkxWithShippingTerms.fromJson(v));
      });
    }

    ts = json['ts'];
    result = json['result'];
    cast = json['cast'];
    concat = json['concat'];
    rowNumber = json['RowNumber'];
    recordCount = json['RecordCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['co_document_id'] = this.coDocumentId;
    data['co_document_number'] = this.coDocumentNumber;
    data['created_date'] = this.createdDate;
    data['employee_id'] = this.employeeId;
    data['employee_name'] = this.employeeName;
    data['customer_id'] = this.customerId;
    data['co_form_id'] = this.coFormId;
    data['status_id'] = this.statusId;
    data['editable'] = this.editable;
    data['customer_name'] = this.customerName;
    data['form_name'] = this.formName;
    data['status_name'] = this.statusName;
    data['status_declarations'] = this.statusDeclarations;
    data['number_tkx'] = this.numberTkx;
    if (this.numberTkxWithShippingTerms != null) {
      data['number_tkx_with_shipping_terms'] =
          this.numberTkxWithShippingTerms!.map((v) => v.toJson()).toList();
    }
    data['ts'] = this.ts;
    data['result'] = this.result;
    data['cast'] = this.cast;
    data['concat'] = this.concat;
    data['RowNumber'] = this.rowNumber;
    data['RecordCount'] = this.recordCount;
    return data;
  }
}

class NumberTkxWithShippingTerms {
  String? label;
  String? value;
  String? invoiceNumber;
  String? shippingTerms;
  String? exportLicenceNumber;

  NumberTkxWithShippingTerms(
      {this.label,
      this.value,
      this.invoiceNumber,
      this.shippingTerms,
      this.exportLicenceNumber});

  NumberTkxWithShippingTerms.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
    invoiceNumber = json['invoice_number'];
    shippingTerms = json['shipping_terms'];
    exportLicenceNumber = json['export_licence_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['value'] = this.value;
    data['invoice_number'] = this.invoiceNumber;
    data['shipping_terms'] = this.shippingTerms;
    data['export_licence_number'] = this.exportLicenceNumber;
    return data;
  }
}
