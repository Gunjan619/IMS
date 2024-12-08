class DashCollectionResponse {
  bool? error;
  String? totalAmount;
  String? totalCollection;
  String? totalDue;
  String? todayCollection;
  String? msg;

  DashCollectionResponse(
      {this.error,
      this.totalAmount,
      this.totalCollection,
      this.totalDue,
      this.todayCollection,
      this.msg});

  DashCollectionResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    totalAmount = json['totalAmount'];
    totalCollection = json['totalCollection'];
    totalDue = json['totalDue'];
    todayCollection = json['todayCollection'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['totalAmount'] = totalAmount;
    data['totalCollection'] = totalCollection;
    data['totalDue'] = totalDue;
    data['todayCollection'] = todayCollection;
    data['msg'] = msg;
    return data;
  }
}
