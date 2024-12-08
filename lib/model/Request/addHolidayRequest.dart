class AddHolidayRequest {
  String holiday;
  String from;
  String to;
  AddHolidayRequest(this.holiday, this.from, this.to);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'holiday': holiday.trim(),
      'from': from.trim(),
      'to': to.trim(),
    };

    return map;
  }
}
