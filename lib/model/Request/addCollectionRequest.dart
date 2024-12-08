class AddCollectionRequest {
  String type;
  String degree;
  String course;
  String year;
  String session;
  String student;
  String feeData;

  String total;
  String totalPaid;
  String due;
  String payMode;
  String refNo;
  String refAmount;
  String refDate;
  String payDate;
  String remark;

  AddCollectionRequest(
      this.type,
      this.degree,
      this.course,
      this.year,
      this.session,
      this.student,
      this.feeData,
      this.total,
      this.totalPaid,
      this.due,
      this.payMode,
      this.refNo,
      this.refAmount,
      this.refDate,
      this.payDate,
      this.remark);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'type': type.trim(),
      'degree': degree.trim(),
      'course': course.trim(),
      'year': year.trim(),
      'session': session.trim(),
      'student': student.trim(),
      'feeData': feeData.trim(),
      'total': total.trim(),
      'totalPaid': totalPaid.trim(),
      'due': due.trim(),
      'payMode': payMode.trim(),
      'refNo': refNo.trim(),
      'refAmount': refAmount.trim(),
      'refDate': refDate.trim(),
      'payDate': payDate.trim(),
      'remark': remark.trim(),
    };

    return map;
  }
}
