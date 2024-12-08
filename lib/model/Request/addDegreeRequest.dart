class AddDegreeRequest {
  String name;
  AddDegreeRequest(this.name);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'name': name.trim(),
    };

    return map;
  }
}
