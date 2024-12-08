class AddCourseRequest {
  String degree;
  String name;
  String year;
  AddCourseRequest(this.degree, this.name, this.year);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'degree': degree.trim(),
      'name': name.trim(),
      'year': year.trim(),
    };

    return map;
  }
}
