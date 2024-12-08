class PaymentRequest {
  String type;
  String stuId;
  String session;
  String course;
  String subCourse;
  PaymentRequest(
      this.type, this.stuId, this.session, this.course, this.subCourse);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'type': type.trim(),
      'stuId': stuId.trim(),
      'session': session.trim(),
      'course': course.trim(),
      'subCourse': subCourse.trim(),
    };

    return map;
  }
}
