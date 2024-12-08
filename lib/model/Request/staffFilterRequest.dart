class StaffFilterRequest {
  String type;
  String cat;
  StaffFilterRequest(this.type, this.cat);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'type': type.trim(),
      'category': cat.trim(),
    };

    return map;
  }
}
