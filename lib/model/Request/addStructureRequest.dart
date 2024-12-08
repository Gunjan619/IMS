class AddStructureRequest {
  String course;
  String subCourse;
  String session;
  String feeId;
  String amount;
  AddStructureRequest(
      this.course, this.subCourse, this.session, this.feeId, this.amount);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'course': course.trim(),
      'subCourse': subCourse.trim(),
      'session': session.trim(),
      'feeId': feeId.trim(),
      'amount': amount.trim(),
    };

    return map;
  }
}
