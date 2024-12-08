class TransferYearRequest {
  String course;
  String year;
  String newYear;
  String session;
  String stuList;

  TransferYearRequest(
    this.course,
    this.year,
    this.newYear,
    this.session,
    this.stuList,
  );
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'course': course.trim(),
      'year': year.trim(),
      'newYear': newYear.trim(),
      'session': session.trim(),
      'stuList': stuList.trim(),
    };
    return map;
  }
}
