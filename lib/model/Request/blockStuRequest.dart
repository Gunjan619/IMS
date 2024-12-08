class BlockStudentRequest {
  String type;
  String session;
  String id;
  BlockStudentRequest(this.type, this.session, this.id);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'type': type.trim(),
      'session': session.trim(),
      'id': id.trim(),
    };

    return map;
  }
}
