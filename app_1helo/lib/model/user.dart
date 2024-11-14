class User {
  int? totalItems;
  int? page;
  int? pageSize;
  List<DataUser>? data;
  int? pageCount;

  User({this.totalItems, this.page, this.pageSize, this.data, this.pageCount});

  User.fromJson(Map<String, dynamic> json) {
    totalItems = json['totalItems'] as int?;
    page = json['page'] as int?;
    pageSize = json['pageSize'] as int?;
    if (json['data'] != null) {
      data = (json['data'] as List)
          .map((item) => DataUser.fromJson(item))
          .toList();
    }
    pageCount = json['pageCount'] as int?;
  }

  Map<String, dynamic> toJson() {
    return {
      'totalItems': totalItems,
      'page': page,
      'pageSize': pageSize,
      'data': data?.map((user) => user.toJson()).toList(),
      'pageCount': pageCount,
    };
  }
}

class DataUser {
  int? rowNumber;
  String? userId;
  String? firstName;
  String? middleName;
  String? lastName;
  String? fullName;
  String? avatar;
  int? gender;
  String? dateOfBirth;
  String? email;
  String? phoneNumber;
  String? userName;
  int? onlineFlag;
  String? description;
  String? createdDateTime;
  String? departmentName;
  String? positionName;
  String? branchName;
  String? roleGroup;
  String? recordCount;

  DataUser({
    this.rowNumber,
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
    this.recordCount,
  });

  DataUser.fromJson(Map<String, dynamic> json) {
    rowNumber = json['RowNumber'] as int?;
    userId = json['user_id'] as String?;
    firstName = json['first_name'] as String?;
    middleName = json['middle_name'] as String?;
    lastName = json['last_name'] as String?;
    fullName = json['full_name'] as String?;
    avatar = json['avatar'] as String?;
    gender = json['gender'] as int?;
    dateOfBirth = json['date_of_birth'] as String?;
    email = json['email'] as String?;
    phoneNumber = json['phone_number'] as String?;
    userName = json['user_name'] as String?;
    onlineFlag = json['online_flag'] as int?;
    description = json['description'] as String?;
    createdDateTime = json['created_date_time'] as String?;
    departmentName = json['department_name'] as String?;
    positionName = json['position_name'] as String?;
    branchName = json['branch_name'] as String?;
    roleGroup = json['role_group'] as String?;
    recordCount = json['RecordCount'] as String?;
  }

  Map<String, dynamic> toJson() {
    return {
      'RowNumber': rowNumber,
      'user_id': userId,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'full_name': fullName,
      'avatar': avatar,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'email': email,
      'phone_number': phoneNumber,
      'user_name': userName,
      'online_flag': onlineFlag,
      'description': description,
      'created_date_time': createdDateTime,
      'department_name': departmentName,
      'position_name': positionName,
      'branch_name': branchName,
      'role_group': roleGroup,
      'RecordCount': recordCount,
    };
  }
}
