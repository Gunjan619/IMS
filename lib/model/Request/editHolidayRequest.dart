class EditHolidayRequest {
  String id;
  String holiday;
  String from;
  String to;
  EditHolidayRequest(this.id, this.holiday, this.from, this.to);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'id': id.trim(),
      'holiday': holiday.trim(),
      'from': from.trim(),
      'to': to.trim(),
    };

    return map;
  }
}
