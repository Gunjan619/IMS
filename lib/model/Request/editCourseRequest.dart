class EditCourseRequest {
  String id;
  String degree;
  String name;
  String year;
  EditCourseRequest(this.id, this.degree, this.name, this.year);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'id': id.trim(),
      'degree': degree.trim(),
      'name': name.trim(),
      'year': year.trim(),
    };

    return map;
  }
}
