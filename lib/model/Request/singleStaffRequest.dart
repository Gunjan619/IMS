class SingleStaffRequest {
  String type;
  String id;
  SingleStaffRequest(this.type, this.id);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'type': type.trim(),
      'id': id.trim(),
    };

    return map;
  }
}
