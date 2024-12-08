class EditStaffAttendanceRequest {
  String type;
  String date;
  String empId;
  String status;
  String category;
  EditStaffAttendanceRequest(
      this.type, this.date, this.empId, this.status, this.category);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'type': type.trim(),
      'date': date.trim(),
      'empId': empId.trim(),
      'status': status.trim(),
      'category': category.trim(),
    };

    return map;
  }
}
