class YearRequest {
  String type;
  String course;
  YearRequest(this.type, this.course);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'type': type.trim(),
      'course': course.trim(),
    };

    return map;
  }
}
