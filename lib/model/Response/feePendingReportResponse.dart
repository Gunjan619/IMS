class FeePendingReportResponse {
  bool? error;
  String? msg;
  List<Data>? data;

  FeePendingReportResponse({this.error, this.msg, this.data});

  FeePendingReportResponse.fromJson(Map<String, dynamic> json) {
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
  String? stu_id;
  String? session;
  String? course;
  String? sub_course;
  String? sessionName;
  String? stuName;
  String? stuMobile;
  String? courseName;
  String? year;
  String? amount;
  String? famount;
  String? paid;
  String? due;

  Data({
    this.id,
    this.stu_id,
    this.session,
    this.course,
    this.sub_course,
    this.sessionName,
    this.stuName,
    this.stuMobile,
    this.courseName,
    this.year,
    this.amount,
    this.famount,
    this.paid,
    this.due,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stu_id = json['stu_id'];
    session = json['session'];
    course = json['course'];
    sub_course = json['sub_course'];
    sessionName = json['sessionName'];
    stuName = json['stuName'];
    stuMobile = json['stuMobile'];
    courseName = json['courseName'];
    year = json['year'];
    amount = json['amount'];
    famount = json['famount'];
    paid = json['paid'];
    due = json['due'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['stu_id'] = stu_id;
    data['session'] = session;
    data['course'] = course;
    data['sub_course'] = sub_course;
    data['sessionName'] = sessionName;

    data['stuName'] = stuName;
    data['stuMobile'] = stuMobile;
    data['courseName'] = courseName;
    data['year'] = year;
    data['amount'] = amount;
    data['famount'] = famount;
    data['paid'] = paid;
    data['due'] = due;

    return data;
  }
}
