class dropdownCustomer {
  String? userId;
  String? fullName;
  Null? avatar;
  int? gender;
  String? dateOfBirth;
  String? email;
  String? phoneNumber;
  String? userName;
  int? onlineFlag;
  Null? description;
  int? positionId;
  int? departmentId;
  int? branchId;
  List<EmployeeCustomer>? employeeCustomer;
  List<EmployeeCustomerForDetail>? employeeCustomerForDetail;

  dropdownCustomer(
      {this.userId,
      this.fullName,
      this.avatar,
      this.gender,
      this.dateOfBirth,
      this.email,
      this.phoneNumber,
      this.userName,
      this.onlineFlag,
      this.description,
      this.positionId,
      this.departmentId,
      this.branchId,
      this.employeeCustomer,
      this.employeeCustomerForDetail});

  dropdownCustomer.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    fullName = json['full_name'];
    avatar = json['avatar'];
    gender = json['gender'];
    dateOfBirth = json['date_of_birth'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    userName = json['user_name'];
    onlineFlag = json['online_flag'];
    description = json['description'];
    positionId = json['position_id'];
    departmentId = json['department_id'];
    branchId = json['branch_id'];
    if (json['employee_customer'] != null) {
      employeeCustomer = <EmployeeCustomer>[];
      json['employee_customer'].forEach((v) {
        employeeCustomer!.add(new EmployeeCustomer.fromJson(v));
      });
    }
    if (json['employee_customer_for_detail'] != null) {
      employeeCustomerForDetail = <EmployeeCustomerForDetail>[];
      json['employee_customer_for_detail'].forEach((v) {
        employeeCustomerForDetail!
            .add(new EmployeeCustomerForDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['full_name'] = this.fullName;
    data['avatar'] = this.avatar;
    data['gender'] = this.gender;
    data['date_of_birth'] = this.dateOfBirth;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['user_name'] = this.userName;
    data['online_flag'] = this.onlineFlag;
    data['description'] = this.description;
    data['position_id'] = this.positionId;
    data['department_id'] = this.departmentId;
    data['branch_id'] = this.branchId;
    if (this.employeeCustomer != null) {
      data['employee_customer'] =
          this.employeeCustomer!.map((v) => v.toJson()).toList();
    }
    if (this.employeeCustomerForDetail != null) {
      data['employee_customer_for_detail'] =
          this.employeeCustomerForDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EmployeeCustomer {
  String? employeeId;
  String? customerId;
  String? customerName;
  String? taxCode;
  int? processingFee;

  EmployeeCustomer(
      {this.employeeId,
      this.customerId,
      this.customerName,
      this.taxCode,
      this.processingFee});

  EmployeeCustomer.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    taxCode = json['tax_code'];
    processingFee = json['processing_fee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee_id'] = this.employeeId;
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.customerName;
    data['tax_code'] = this.taxCode;
    data['processing_fee'] = this.processingFee;
    return data;
  }
}

class EmployeeCustomerForDetail {
  int? employeeCustomerId;
  String? customerId;
  String? customerName;
  String? taxCode;
  int? processingFee;

  EmployeeCustomerForDetail(
      {this.employeeCustomerId,
      this.customerId,
      this.customerName,
      this.taxCode,
      this.processingFee});

  EmployeeCustomerForDetail.fromJson(Map<String, dynamic> json) {
    employeeCustomerId = json['employee_customer_id'];
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    taxCode = json['tax_code'];
    processingFee = json['processing_fee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee_customer_id'] = this.employeeCustomerId;
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.customerName;
    data['tax_code'] = this.taxCode;
    data['processing_fee'] = this.processingFee;
    return data;
  }
}
