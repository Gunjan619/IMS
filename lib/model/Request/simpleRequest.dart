class SimpleModel {
  String type;
  SimpleModel(this.type);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'type': type.trim(),
    };

    return map;
  }
}
