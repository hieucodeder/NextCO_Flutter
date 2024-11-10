class totalModel {
  bool? success;
  Data? data;

  totalModel({this.success, this.data});

  totalModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? customer;
  int? coDocument;
  int? product;
  int? material;
  int? employee;

  Data(
      {this.customer,
      this.coDocument,
      this.product,
      this.material,
      this.employee});

  Data.fromJson(Map<String, dynamic> json) {
    customer = json['customer'];
    coDocument = json['co_document'];
    product = json['product'];
    material = json['material'];
    employee = json['employee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer'] = this.customer;
    data['co_document'] = this.coDocument;
    data['product'] = this.product;
    data['material'] = this.material;
    data['employee'] = this.employee;
    return data;
  }
}
