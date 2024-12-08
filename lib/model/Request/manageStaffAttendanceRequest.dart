class ManageStaffAttendanceRequest {
  String type;
  String fromdate;
  String todate;
  ManageStaffAttendanceRequest(this.type, this.fromdate, this.todate);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'type': type.trim(),
      'fromdate': fromdate.trim(),
      'todate': todate.trim(),
    };

    return map;
  }
}
