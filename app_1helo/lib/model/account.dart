class Account {
  String? userId;
  String? roleGroup;
  String? firstName;
  String? middleName;
  String? lastName;
  String? fullName;
  Null avatar;
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
        functions!.add(Functions.fromJson(v));
      });
    }
    if (json['actions'] != null) {
      actions = <Actions>[];
      json['actions'].forEach((v) {
        actions!.add(Actions.fromJson(v));
      });
    }
    if (json['customers'] != null) {
      customers = <Customers>[];
      json['customers'].forEach((v) {
        customers!.add(Customers.fromJson(v));
      });
    }
    if (json['employees'] != null) {
      employees = <Employees>[];
      json['employees'].forEach((v) {
        employees!.add(Employees.fromJson(v));
      });
    }
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['role_group'] = roleGroup;
    data['first_name'] = firstName;
    data['middle_name'] = middleName;
    data['last_name'] = lastName;
    data['full_name'] = fullName;
    data['avatar'] = avatar;
    data['gender'] = gender;
    data['date_of_birth'] = dateOfBirth;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['user_name'] = userName;
    data['online_flag'] = onlineFlag;
    if (functions != null) {
      data['functions'] = functions!.map((v) => v.toJson()).toList();
    }
    if (actions != null) {
      data['actions'] = actions!.map((v) => v.toJson()).toList();
    }
    if (customers != null) {
      data['customers'] = customers!.map((v) => v.toJson()).toList();
    }
    if (employees != null) {
      data['employees'] = employees!.map((v) => v.toJson()).toList();
    }
    data['token'] = token;
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
        children!.add(Children.fromJson(v));
      });
    }
    sortOrder = json['sort_order'];
    isLeaf = json['is_leaf'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['key'] = key;
    data['value'] = value;
    data['parent_id'] = parentId;
    data['level'] = level;
    data['url'] = url;
    if (children != null) {
      data['children'] = children!.map((v) => v.toJson()).toList();
    }
    data['sort_order'] = sortOrder;
    data['is_leaf'] = isLeaf;
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
        children!.add(Children.fromJson(v));
      });
    }
    sortOrder = json['sort_order'];
    isLeaf = json['is_leaf'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['key'] = key;
    data['value'] = value;
    data['parent_id'] = parentId;
    data['level'] = level;
    data['url'] = url;
    if (children != null) {
      data['children'] = children!.map((v) => v.toJson()).toList();
    }
    data['sort_order'] = sortOrder;
    data['is_leaf'] = isLeaf;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['action_code'] = actionCode;
    data['action_api_url'] = actionApiUrl;
    data['role_permission_id'] = rolePermissionId;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_id'] = customerId;
    data['customer_name'] = customerName;
    data['tax_code'] = taxCode;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['full_name'] = fullName;
    return data;
  }
}
