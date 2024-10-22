class Account {
  String? userId;
  String? roleGroup;
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
  List<Functions>? functions;
  List<Actions>? actions;
  List<Customers>? customers;
  List<Employees>? employees;
  String? token;

  Account(
      {this.userId,
      this.roleGroup,
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
      this.functions,
      this.actions,
      this.customers,
      this.employees,
      this.token});

  Account.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    roleGroup = json['role_group'];
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
    if (json['functions'] != null) {
      functions = <Functions>[];
      json['functions'].forEach((v) {
        functions!.add(new Functions.fromJson(v));
      });
    }
    if (json['actions'] != null) {
      actions = <Actions>[];
      json['actions'].forEach((v) {
        actions!.add(new Actions.fromJson(v));
      });
    }
    if (json['customers'] != null) {
      customers = <Customers>[];
      json['customers'].forEach((v) {
        customers!.add(new Customers.fromJson(v));
      });
    }
    if (json['employees'] != null) {
      employees = <Employees>[];
      json['employees'].forEach((v) {
        employees!.add(new Employees.fromJson(v));
      });
    }
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = this.userId;
    data['role_group'] = this.roleGroup;
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
    if (this.functions != null) {
      data['functions'] = this.functions!.map((v) => v.toJson()).toList();
    }
    if (this.actions != null) {
      data['actions'] = this.actions!.map((v) => v.toJson()).toList();
    }
    if (this.customers != null) {
      data['customers'] = this.customers!.map((v) => v.toJson()).toList();
    }
    if (this.employees != null) {
      data['employees'] = this.employees!.map((v) => v.toJson()).toList();
    }
    data['token'] = this.token;
    return data;
  }
}

class Functions {
  String? title;
  String? key;
  String? value;
  String? parentId;
  int? level;
  String? url;
  List<Children>? children;
  int? sortOrder;
  bool? isLeaf;

  Functions(
      {this.title,
      this.key,
      this.value,
      this.parentId,
      this.level,
      this.url,
      this.children,
      this.sortOrder,
      this.isLeaf});

  Functions.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    key = json['key'];
    value = json['value'];
    parentId = json['parent_id'];
    level = json['level'];
    url = json['url'];
    if (json['children'] != null) {
      children = <Children>[];
      json['children'].forEach((v) {
        children!.add(new Children.fromJson(v));
      });
    }
    sortOrder = json['sort_order'];
    isLeaf = json['is_leaf'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['key'] = this.key;
    data['value'] = this.value;
    data['parent_id'] = this.parentId;
    data['level'] = this.level;
    data['url'] = this.url;
    if (this.children != null) {
      data['children'] = this.children!.map((v) => v.toJson()).toList();
    }
    data['sort_order'] = this.sortOrder;
    data['is_leaf'] = this.isLeaf;
    return data;
  }
}

class Children {
  String? title;
  String? key;
  String? value;
  String? parentId;
  int? level;
  String? url;
  List<Children>? children;
  int? sortOrder;
  bool? isLeaf;

  Children(
      {this.title,
      this.key,
      this.value,
      this.parentId,
      this.level,
      this.url,
      this.children,
      this.sortOrder,
      this.isLeaf});

  Children.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    key = json['key'];
    value = json['value'];
    parentId = json['parent_id'];
    level = json['level'];
    url = json['url'];
    if (json['children'] != null) {
      children = <Children>[];
      json['children'].forEach((v) {
        children!.add(new Children.fromJson(v));
      });
    }
    sortOrder = json['sort_order'];
    isLeaf = json['is_leaf'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['key'] = this.key;
    data['value'] = this.value;
    data['parent_id'] = this.parentId;
    data['level'] = this.level;
    data['url'] = this.url;
    if (this.children != null) {
      data['children'] = this.children!.map((v) => v.toJson()).toList();
    }
    data['sort_order'] = this.sortOrder;
    data['is_leaf'] = this.isLeaf;
    return data;
  }
}

class Actions {
  String? actionCode;
  String? actionApiUrl;
  String? rolePermissionId;

  Actions({this.actionCode, this.actionApiUrl, this.rolePermissionId});

  Actions.fromJson(Map<String, dynamic> json) {
    actionCode = json['action_code'];
    actionApiUrl = json['action_api_url'];
    rolePermissionId = json['role_permission_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action_code'] = this.actionCode;
    data['action_api_url'] = this.actionApiUrl;
    data['role_permission_id'] = this.rolePermissionId;
    return data;
  }
}

class Customers {
  String? customerId;
  String? customerName;
  String? taxCode;

  Customers({this.customerId, this.customerName, this.taxCode});

  Customers.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    taxCode = json['tax_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.customerName;
    data['tax_code'] = this.taxCode;
    return data;
  }
}

class Employees {
  String? userId;
  String? userName;
  String? fullName;

  Employees({this.userId, this.userName, this.fullName});

  Employees.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['full_name'] = this.fullName;
    return data;
  }
}
