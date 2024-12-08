class StudentFilterRequest {
  String type;
  String degree;
  String course;
  String year;
  String session;
  String sessionName;
  StudentFilterRequest(this.type, this.degree, this.course, this.year,
      this.session, this.sessionName);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'type': type.trim(),
      'degree': degree.trim(),
      'course': course.trim(),
      'year': year.trim(),
      'session': session.trim(),
      'sessionName': sessionName.trim(),
    };

    return map;
  }
}
