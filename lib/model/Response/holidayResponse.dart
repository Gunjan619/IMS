class HolidayResponse {
  bool? error;
  String? msg;
  List<Data>? data;

  HolidayResponse({this.error, this.msg, this.data});

  HolidayResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? holiday;
  String? date;
  String? from;
  String? to;

  Data({this.id, this.holiday, this.date, this.from, this.to});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    holiday = json['holiday'];
    date = json['date'];
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['holiday'] = holiday;
    data['date'] = date;
    data['from'] = from;
    data['to'] = to;
    return data;
  }
}
