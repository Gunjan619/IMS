class ManageStudentRequest {
  String type;
  String year;
  ManageStudentRequest(this.type, this.year);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'type': type.trim(),
      'year': year.trim(),
    };

    return map;
  }
}
