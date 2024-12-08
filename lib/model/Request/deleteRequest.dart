class DeleteRequest {
  String id;
  String type;
  DeleteRequest(this.id, this.type);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'id': id.trim(),
      'type': type.trim(),
    };

    return map;
  }
}
