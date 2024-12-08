class DeleteHolidayRequest {
  String holiday;
  String type;
  String from;
  String to;
  DeleteHolidayRequest(this.holiday, this.type, this.from, this.to);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'holiday': holiday.trim(),
      'type': type.trim(),
      'from': from.trim(),
      'to': to.trim(),
    };

    return map;
  }
}
