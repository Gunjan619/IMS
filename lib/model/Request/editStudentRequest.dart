class EditStudentRequest {
  String id;
  String name;
  String fatherName;
  String motherName;
  String aadharNo;
  String mobileNumber;
  String email;
  String parentNo;
  String dob;
  String degree;
  String course;
  String year;
  String session;
  String sessionIdd;
  String gender;
  String religion;
  String category;
  String caste;
  String medium;
  String enrollmentNo;
  String address;
  String city;
  String state;
  String pincode;

  EditStudentRequest(
      this.id,
      this.name,
      this.fatherName,
      this.motherName,
      this.aadharNo,
      this.mobileNumber,
      this.email,
      this.parentNo,
      this.dob,
      this.degree,
      this.course,
      this.year,
      this.session,
      this.sessionIdd,
      this.gender,
      this.religion,
      this.category,
      this.caste,
      this.medium,
      this.enrollmentNo,
      this.address,
      this.city,
      this.state,
      this.pincode);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'id': id.trim(),
      'name': name.trim(),
      'fatherName': fatherName.trim(),
      'motherName': motherName.trim(),
      'aadharNo': aadharNo.trim(),
      'mobileNumber': mobileNumber.trim(),
      'email': email.trim(),
      'parentNo': parentNo.trim(),
      'dob': dob.trim(),
      'degree': degree.trim(),
      'course': course.trim(),
      'year': year.trim(),
      'session': session.trim(),
      'sessionIdd': sessionIdd.trim(),
      'gender': gender.trim(),
      'religion': religion.trim(),
      'category': category.trim(),
      'caste': caste.trim(),
      'medium': medium.trim(),
      'enrollmentNo': enrollmentNo.trim(),
      'address': address.trim(),
      'city': city.trim(),
      'state': state.trim(),
      'pincode': pincode.trim(),
    };

    return map;
  }
}
