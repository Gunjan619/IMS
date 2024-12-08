class LoginModel {
  String username;
  String password;
  LoginModel(this.username, this.password);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'username': username.trim(),
      'password': password.trim(),
    };

    return map;
  }
}
