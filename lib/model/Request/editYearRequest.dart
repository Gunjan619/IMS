class EditYearRequest {
  String id;
  String course;
  String subCourse;
  EditYearRequest(this.id, this.course, this.subCourse);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'id': id.trim(),
      'course': course.trim(),
      'sub_course': subCourse.trim(),
    };

    return map;
  }
}
