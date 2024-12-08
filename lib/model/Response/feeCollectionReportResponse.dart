class FeeCollectionReportResponse {
  bool? error;
  String? msg;
  List<Data>? data;

  FeeCollectionReportResponse({this.error, this.msg, this.data});

  FeeCollectionReportResponse.fromJson(Map<String, dynamic> json) {
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
  String? pay_date;
  String? receipt_no;
  String? session;
  String? stu_id;
  String? pay_type;
  String? semester;
  String? advance_fid;
  String? sessionId;
  String? stuName;
  String? courseName;
  String? year;
  String? amount;

  Data({
    this.id,
    this.pay_date,
    this.receipt_no,
    this.session,
    this.stu_id,
    this.pay_type,
    this.semester,
    this.advance_fid,
    this.sessionId,
    this.stuName,
    this.courseName,
    this.year,
    this.amount,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pay_date = json['pay_date'];
    receipt_no = json['receipt_no'];
    session = json['session'];
    stu_id = json['stu_id'];
    pay_type = json['pay_type'];
    semester = json['semester'];
    advance_fid = json['advance_fid'];
    sessionId = json['sessionId'];
    stuName = json['stuName'];
    courseName = json['courseName'];
    year = json['year'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['pay_date'] = pay_date;
    data['receipt_no'] = receipt_no;
    data['session'] = session;
    data['stu_id'] = stu_id;
    data['pay_type'] = pay_type;
    data['semester'] = semester;
    data['advance_fid'] = advance_fid;
    data['sessionId'] = sessionId;
    data['stuName'] = stuName;
    data['courseName'] = courseName;
    data['year'] = year;
    data['amount'] = amount;

    return data;
  }
}
