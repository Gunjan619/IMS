class EditUserRequest {
  String id;
  String type;
  String name;
  String mobile;
  String email;
  String username;
  String password;
  String permission;

  EditUserRequest(
    this.id,
    this.type,
    this.name,
    this.mobile,
    this.email,
    this.username,
    this.password,
    this.permission,
  );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'id': id.trim(),
      'type': type.trim(),
      'name': name.trim(),
      'mobile': mobile.trim(),
      'email': email.trim(),
      'username': username.trim(),
      'password': password.trim(),
      'permission': permission.trim(),
    };

    return map;
  }
}
