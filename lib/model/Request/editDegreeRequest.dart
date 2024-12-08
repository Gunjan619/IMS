class EditDegreeRequest {
  String id;
  String name;
  EditDegreeRequest(this.id, this.name);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'id': id.trim(),
      'name': name.trim(),
    };

    return map;
  }
}
