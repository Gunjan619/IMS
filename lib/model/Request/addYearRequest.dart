class AddYearRequest {
  String course;
  String subCourse;
  AddYearRequest(this.course, this.subCourse);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'course': course.trim(),
      'sub_course': subCourse.trim(),
    };

    return map;
  }
}
