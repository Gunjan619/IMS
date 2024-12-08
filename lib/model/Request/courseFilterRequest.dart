class CourseFilterRequest {
  String type;
  String degree;
  CourseFilterRequest(this.type, this.degree);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'type': type.trim(),
      'degree': degree.trim(),
    };

    return map;
  }
}
