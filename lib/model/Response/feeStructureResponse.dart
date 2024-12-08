class FeeStructureResponse {
  bool? error;
  String? msg;
  List<Data>? data;

  FeeStructureResponse({this.error, this.msg, this.data});

  FeeStructureResponse.fromJson(Map<String, dynamic> json) {
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
  String? session;
  String? sessionName;
  String? course;
  String? courseName;
  String? courseYear;
  String? subCourse;
  String? subCourseName;
  String? feeId;
  String? feeName;
  String? amount;

  Data(
      {this.id,
      this.session,
      this.sessionName,
      this.course,
      this.courseName,
      this.courseYear,
      this.subCourse,
      this.subCourseName,
      this.feeId,
      this.feeName,
      this.amount});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    session = json['session'];
    sessionName = json['sessionName'];
    course = json['course'];
    courseName = json['courseName'];
    courseYear = json['courseYear'];
    subCourse = json['sub_course'];
    subCourseName = json['subCourseName'];
    feeId = json['fee_id'];
    feeName = json['feeName'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['session'] = session;
    data['sessionName'] = sessionName;
    data['course'] = course;
    data['courseName'] = courseName;
    data['courseYear'] = courseYear;
    data['sub_course'] = subCourse;
    data['subCourseName'] = subCourseName;
    data['fee_id'] = feeId;
    data['feeName'] = feeName;
    data['amount'] = amount;

    return data;
  }
}
