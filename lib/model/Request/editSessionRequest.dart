class EditSessionRequest {
  String id;
  String from;
  String to;
  EditSessionRequest(this.id, this.from, this.to);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'id': id.trim(),
      'from': from.trim(),
      'to': to.trim(),
    };

    return map;
  }
}
