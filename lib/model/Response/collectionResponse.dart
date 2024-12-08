class CollectionResponse {
  bool? error;
  String? msg;
  String? receipt;

  CollectionResponse({this.error, this.msg, this.receipt});

  CollectionResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    msg = json['msg'];
    receipt = json['receipt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['msg'] = this.msg;
    data['receipt'] = this.receipt;
    return data;
  }
}
