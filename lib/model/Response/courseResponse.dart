class CourseResponse {
  bool? error;
  String? msg;
  List<Data>? data;

  CourseResponse({this.error, this.msg, this.data});

  CourseResponse.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? degree;
  String? year;
  String? degName;
  String? students;

  Data({this.id, this.name, this.degree, this.year, this.degName});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    degree = json['degree'];
    year = json['year'];
    degName = json['degName'];
    students = json['students'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['degree'] = degree;
    data['year'] = year;
    data['degName'] = degName;
    data['students'] = students;

    return data;
  }
}
