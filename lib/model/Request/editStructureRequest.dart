class EditStructureRequest {
  String id;
  String course;
  String subCourse;
  String session;
  String feeId;
  String amount;
  EditStructureRequest(this.id, this.course, this.subCourse, this.session,
      this.feeId, this.amount);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'id': id.trim(),
      'course': course.trim(),
      'subCourse': subCourse.trim(),
      'session': session.trim(),
      'feeId': feeId.trim(),
      'amount': amount.trim(),
    };

    return map;
  }
}
