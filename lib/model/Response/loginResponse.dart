class loginResponse {
  bool? error;
  String? username;
  String? accountType;
  String? name;
  String? id;
  String? permission;
  String? msg;

  loginResponse(
      {this.error,
      this.username,
      this.accountType,
      this.name,
      this.id,
      this.permission,
      this.msg});

  loginResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    username = json['username'];
    accountType = json['account_type'];
    name = json['name'];
    id = json['id'];
    permission = json['permission'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['username'] = username;
    data['account_type'] = accountType;
    data['name'] = name;
    data['id'] = id;
    data['permission'] = permission;
    data['msg'] = msg;
    return data;
  }
}
