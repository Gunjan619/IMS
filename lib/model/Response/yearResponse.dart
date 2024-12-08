class YearResponse {
  bool? error;
  String? msg;
  List<Data>? data;

  YearResponse({this.error, this.msg, this.data});

  YearResponse.fromJson(Map<String, dynamic> json) {
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
  String? course;
  String? courseName;
  String? subCourse;

  Data({this.id, this.course, this.courseName, this.subCourse});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    course = json['course'];
    courseName = json['courseName'];
    subCourse = json['sub_course'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['course'] = course;
    data['courseName'] = courseName;
    data['sub_course'] = subCourse;
    return data;
  }
}
