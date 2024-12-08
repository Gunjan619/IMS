class DeleteStudentRequest {
  String id;
  String type;
  String session;
  DeleteStudentRequest(this.id, this.type, this.session);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'id': id.trim(),
      'type': type.trim(),
      'session': session.trim(),
    };

    return map;
  }
}
