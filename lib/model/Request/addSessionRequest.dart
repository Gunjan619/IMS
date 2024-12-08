class AddSessionRequest {
  String from;
  String to;
  AddSessionRequest(this.from, this.to);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'from': from.trim(),
      'to': to.trim(),
    };

    return map;
  }
}
