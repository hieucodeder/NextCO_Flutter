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
        data!.add(Data.fromJson(v));
      });
    }
    pageCount = json['pageCount'];
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
  int? coDocumentId;
  String? coDocumentNumber; 
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
  String? statusDeclarations;
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
    coDocumentNumber =
        json['co_document_number'] as String?; 
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
    statusDeclarations =
        json['status_declarations'] as String?; 

    numberTkx = json['number_tkx'] != null
        ? List<String>.from(json['number_tkx'])
        : []; 

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['co_document_id'] = coDocumentId;
    data['co_document_number'] = coDocumentNumber;
    data['created_date'] = createdDate;
    data['employee_id'] = employeeId;
    data['employee_name'] = employeeName;
    data['customer_id'] = customerId;
    data['co_form_id'] = coFormId;
    data['status_id'] = statusId;
    data['editable'] = editable;
    data['customer_name'] = customerName;
    data['form_name'] = formName;
    data['status_name'] = statusName;
    data['status_declarations'] = statusDeclarations;
    data['number_tkx'] = numberTkx;
    if (numberTkxWithShippingTerms != null) {
      data['number_tkx_with_shipping_terms'] =
          numberTkxWithShippingTerms!.map((v) => v.toJson()).toList();
    }
    data['ts'] = ts;
    data['result'] = result;
    data['cast'] = cast;
    data['concat'] = concat;
    data['RowNumber'] = rowNumber;
    data['RecordCount'] = recordCount;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['value'] = value;
    data['invoice_number'] = invoiceNumber;
    data['shipping_terms'] = shippingTerms;
    data['export_licence_number'] = exportLicenceNumber;
    return data;
  }
}
