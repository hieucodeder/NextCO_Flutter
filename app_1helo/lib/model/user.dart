class User {
  int? totalItems;
  int? page;
  int? pageSize;
  List<Data>? data;
  int? pageCount;

  User({this.totalItems, this.page, this.pageSize, this.data, this.pageCount});

  User.fromJson(Map<String, dynamic> json) {
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
  int? rowNumber;
  String? userId;
  String? firstName;
  String? middleName;
  String? lastName;
  String? fullName;
  Null? avatar;
  int? gender;
  String? dateOfBirth;
  String? email;
  String? phoneNumber;
  String? userName;
  int? onlineFlag;
  Null? description;
  String? createdDateTime;
  String? departmentName;
  String? positionName;
  String? branchName;
  String? roleGroup;
  String? recordCount;

  Data(
      {this.rowNumber,
      this.userId,
      this.firstName,
      this.middleName,
      this.lastName,
      this.fullName,
      this.avatar,
      this.gender,
      this.dateOfBirth,
      this.email,
      this.phoneNumber,
      this.userName,
      this.onlineFlag,
      this.description,
      this.createdDateTime,
      this.departmentName,
      this.positionName,
      this.branchName,
      this.roleGroup,
      this.recordCount});

  Data.fromJson(Map<String, dynamic> json) {
    rowNumber = json['RowNumber'];
    userId = json['user_id'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    fullName = json['full_name'];
    avatar = json['avatar'];
    gender = json['gender'];
    dateOfBirth = json['date_of_birth'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    userName = json['user_name'];
    onlineFlag = json['online_flag'];
    description = json['description'];
    createdDateTime = json['created_date_time'];
    departmentName = json['department_name'];
    positionName = json['position_name'];
    branchName = json['branch_name'];
    roleGroup = json['role_group'];
    recordCount = json['RecordCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNumber'] = this.rowNumber;
    data['user_id'] = this.userId;
    data['first_name'] = this.firstName;
    data['middle_name'] = this.middleName;
    data['last_name'] = this.lastName;
    data['full_name'] = this.fullName;
    data['avatar'] = this.avatar;
    data['gender'] = this.gender;
    data['date_of_birth'] = this.dateOfBirth;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['user_name'] = this.userName;
    data['online_flag'] = this.onlineFlag;
    data['description'] = this.description;
    data['created_date_time'] = this.createdDateTime;
    data['department_name'] = this.departmentName;
    data['position_name'] = this.positionName;
    data['branch_name'] = this.branchName;
    data['role_group'] = this.roleGroup;
    data['RecordCount'] = this.recordCount;
    return data;
  }
}
