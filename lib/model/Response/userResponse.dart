class UserResponse {
  bool? error;
  String? msg;
  List<Data>? data;

  UserResponse({this.error, this.msg, this.data});

  UserResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? userType;
  String? name;
  String? mobile;
  String? email;
  String? username;
  String? permissions;

  Data(
      {this.id,
      this.userType,
      this.name,
      this.mobile,
      this.email,
      this.username,
      this.permissions});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userType = json['userType'];
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    username = json['username'];
    permissions = json['permissions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userType'] = userType;
    data['name'] = name;
    data['mobile'] = mobile;
    data['email'] = email;
    data['permissions'] = permissions;

    return data;
  }
}
