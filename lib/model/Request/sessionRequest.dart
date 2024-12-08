class SessionRequest {
  String type;
  String year;
  SessionRequest(this.type, this.year);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'type': type.trim(),
      'year': year.trim(),
    };

    return map;
  }
}
