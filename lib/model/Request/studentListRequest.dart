class StudentListsRequest {
  String course;
  String year;
  String session;

  StudentListsRequest(
    this.course,
    this.year,
    this.session,
  );
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'course': course.trim(),
      'year': year.trim(),
      'session': session.trim(),
    };
    return map;
  }
}
