class StudentResponse {
  bool? error;
  String? msg;
  List<Data>? data;

  StudentResponse({this.error, this.msg, this.data});

  StudentResponse.fromJson(Map<String, dynamic> json) {
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
  String? fatherName;
  String? motherName;
  String? whatsappNo;
  String? aadharNo;
  String? admissionDate;
  String? session;
  String? degree;
  String? course;
  String? subCourse;
  String? dob;
  String? degName;
  String? courseName;
  String? subCourseName;
  String? sessionName;
  String? photo;
  String? sign;
  String? aadharPhoto;
  String? email;
  String? parentNo;
  String? gender;
  String? religionName;
  String? religion;
  String? category;
  String? categoryName;
  String? caste;
  String? medium;
  String? enrollmentNo;
  String? address;
  String? city;
  String? state;
  String? pincode;
  String? courseYear;

  Data({
    this.id,
    this.name,
    this.fatherName,
    this.motherName,
    this.whatsappNo,
    this.aadharNo,
    this.admissionDate,
    this.session,
    this.degree,
    this.course,
    this.subCourse,
    this.dob,
    this.degName,
    this.courseName,
    this.subCourseName,
    this.sessionName,
    this.photo,
    this.sign,
    this.aadharPhoto,
    this.email,
    this.parentNo,
    this.gender,
    this.religionName,
    this.religion,
    this.category,
    this.categoryName,
    this.caste,
    this.medium,
    this.enrollmentNo,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.courseYear,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    fatherName = json['father_name'];
    motherName = json['mother_name'];
    whatsappNo = json['whtsapp_no'];
    aadharNo = json['aadhar_no'];
    admissionDate = json['entry_date'];
    session = json['session'];
    degree = json['degree'];
    course = json['course'];
    subCourse = json['sub_course'];
    dob = json['dob'];
    degName = json['degName'];
    courseName = json['courseName'];
    subCourseName = json['subCourseName'];
    sessionName = json['sessionName'];
    photo = json['stu_photo'];
    sign = json['stu_sign'];
    aadharPhoto = json['aadar_card'];
    email = json['email'];
    parentNo = json['parent_no'];
    gender = json['gender'];
    religionName = json['religionName'];
    religion = json['religion'];
    category = json['category'];
    categoryName = json['categoryName'];
    caste = json['caste'];
    medium = json['medium'];
    enrollmentNo = json['enrollment_no'];
    address = json['corres_add'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    courseYear = json['courseYear'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['father_name'] = fatherName;
    data['mother_name'] = motherName;
    data['whtsapp_no'] = whatsappNo;
    data['aadhar_no'] = aadharNo;
    data['entry_date'] = admissionDate;
    data['session'] = session;
    data['degree'] = degree;
    data['course'] = course;
    data['sub_course'] = subCourse;
    data['dob'] = dob;
    data['degName'] = degName;
    data['courseName'] = courseName;
    data['subCourseName'] = subCourseName;
    data['sessionName'] = sessionName;
    data['stu_photo'] = photo;
    data['stu_sign'] = sign;
    data['aadar_card'] = aadharPhoto;
    data['email'] = email;
    data['parent_no'] = parentNo;
    data['gender'] = gender;
    data['religionName'] = religionName;
    data['religion'] = religion;
    data['category'] = category;
    data['categoryName'] = categoryName;
    data['caste'] = caste;
    data['medium'] = medium;
    data['enrollment_no'] = enrollmentNo;
    data['corres_add'] = address;
    data['city'] = city;
    data['state'] = state;
    data['pincode'] = pincode;
    data['courseYear'] = courseYear;

    return data;
  }
}
