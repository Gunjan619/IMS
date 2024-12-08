class StuDueRequest {
  String degree;
  String course;
  String year;
  String session;
  String stuid;
  StuDueRequest(this.degree, this.course, this.year, this.session, this.stuid);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'degree': degree.trim(),
      'course': course.trim(),
      'year': year.trim(),
      'session': session.trim(),
      'stuid': stuid.trim(),
    };

    return map;
  }
}
