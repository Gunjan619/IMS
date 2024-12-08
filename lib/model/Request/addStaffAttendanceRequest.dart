class AddStaffAttendanceRequest {
  String type;
  String day;
  String month;
  String year;
  String empId;
  String status;
  AddStaffAttendanceRequest(
      this.type, this.day, this.month, this.year, this.empId, this.status);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'type': type.trim(),
      'day': day.trim(),
      'month': month.trim(),
      'year': year.trim(),
      'empId': empId.trim(),
      'status': status.trim(),
    };

    return map;
  }
}
