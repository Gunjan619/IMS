class FilterStaffAttendanceRequest {
  String type;
  String date;
  FilterStaffAttendanceRequest(this.type, this.date);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'type': type.trim(),
      'date': date.trim(),
    };

    return map;
  }
}
