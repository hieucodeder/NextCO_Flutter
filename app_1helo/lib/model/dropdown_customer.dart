class DropdownCustomer {
  String? userId;
  String? fullName;
  Null avatar;
  int? gender;
  String? dateOfBirth;
  String? email;
  String? phoneNumber;
  String? userName;
  int? onlineFlag;
  Null description;
  int? positionId;
  int? departmentId;
  int? branchId;
  List<EmployeeCustomer>? employeeCustomer;
  List<EmployeeCustomerForDetail>? employeeCustomerForDetail;

  DropdownCustomer(
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

  DropdownCustomer.fromJson(Map<String, dynamic> json) {
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
        employeeCustomer!.add(EmployeeCustomer.fromJson(v));
      });
    }
    if (json['employee_customer_for_detail'] != null) {
      employeeCustomerForDetail = <EmployeeCustomerForDetail>[];
      json['employee_customer_for_detail'].forEach((v) {
        employeeCustomerForDetail!
            .add(EmployeeCustomerForDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['full_name'] = fullName;
    data['avatar'] = avatar;
    data['gender'] = gender;
    data['date_of_birth'] = dateOfBirth;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['user_name'] = userName;
    data['online_flag'] = onlineFlag;
    data['description'] = description;
    data['position_id'] = positionId;
    data['department_id'] = departmentId;
    data['branch_id'] = branchId;
    if (employeeCustomer != null) {
      data['employee_customer'] =
          employeeCustomer!.map((v) => v.toJson()).toList();
    }
    if (employeeCustomerForDetail != null) {
      data['employee_customer_for_detail'] =
          employeeCustomerForDetail!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee_id'] = employeeId;
    data['customer_id'] = customerId;
    data['customer_name'] = customerName;
    data['tax_code'] = taxCode;
    data['processing_fee'] = processingFee;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee_customer_id'] = employeeCustomerId;
    data['customer_id'] = customerId;
    data['customer_name'] = customerName;
    data['tax_code'] = taxCode;
    data['processing_fee'] = processingFee;
    return data;
  }
}
