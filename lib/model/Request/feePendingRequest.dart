class FeePendingRequest {
  String type;
  String course;
  String year;
  String session;
  FeePendingRequest(this.type, this.course, this.year, this.session);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'type': type.trim(),
      'course': course.trim(),
      'year': year.trim(),
      'session': session.trim(),
    };

    return map;
  }
}
