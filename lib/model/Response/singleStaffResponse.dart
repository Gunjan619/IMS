class SingleStaffResponse {
  SingleStaffResponse({
    this.error,
    this.msg,
    this.id,
    this.category,
    this.dOB,
    this.empCode,
    this.name,
    this.fatherName,
    this.designation,
    this.dept,
    this.pancardNo,
    this.bank,
    this.bankAccNo,
    this.ifsc,
    this.dOJoin,
    this.dORetire,
    this.dOLstIncr,
    this.dOLstPromotn,
    this.dOPhd,
    this.dOPub,
    this.publicationTyp,
    this.payScale,
    this.gradePay,
    this.basic,
    this.address,
    this.contactNo,
    this.email,
    this.religionName,
    this.religion,
    this.cast,
    this.nominee,
    this.nomineeRel,
    this.bloodGroup,
    this.qualification,
  });

  final bool? error;
  final String? msg;
  final String? id;
  final String? category;
  final String? dOB;
  final String? empCode;
  final String? name;
  final String? fatherName;
  final String? designation;
  final String? dept;
  final String? pancardNo;
  final String? bank;
  final String? bankAccNo;
  final String? ifsc;
  final String? dOJoin;
  final String? dORetire;
  final String? dOLstIncr;
  final String? dOLstPromotn;
  final String? dOPhd;
  final String? dOPub;
  final String? publicationTyp;
  final String? payScale;
  final String? gradePay;
  final String? basic;
  final String? address;
  final String? contactNo;
  final String? email;
  final String? religionName;
  final String? religion;
  final String? cast;
  final String? nominee;
  final String? nomineeRel;
  final String? bloodGroup;
  final String? qualification;

  SingleStaffResponse copyWith({
    bool? error,
    String? msg,
    String? id,
    String? category,
    String? dOB,
    String? empCode,
    String? name,
    String? fatherName,
    String? designation,
    String? dept,
    String? pancardNo,
    String? bank,
    String? bankAccNo,
    String? ifsc,
    String? dOJoin,
    String? dORetire,
    String? dOLstIncr,
    String? dOLstPromotn,
    String? dOPhd,
    String? dOPub,
    String? publicationTyp,
    String? payScale,
    String? gradePay,
    String? basic,
    String? address,
    String? contactNo,
    String? email,
    String? religionName,
    String? religion,
    String? cast,
    String? nominee,
    String? nomineeRel,
    String? bloodGroup,
    String? qualification,
  }) {
    return SingleStaffResponse(
      error: error ?? this.error,
      msg: msg ?? this.msg,
      id: id ?? this.id,
      category: category ?? this.category,
      dOB: dOB ?? this.dOB,
      empCode: empCode ?? this.empCode,
      name: name ?? this.name,
      fatherName: fatherName ?? this.fatherName,
      designation: designation ?? this.designation,
      dept: dept ?? this.dept,
      pancardNo: pancardNo ?? this.pancardNo,
      bank: bank ?? this.bank,
      bankAccNo: bankAccNo ?? this.bankAccNo,
      ifsc: ifsc ?? this.ifsc,
      dOJoin: dOJoin ?? this.dOJoin,
      dORetire: dORetire ?? this.dORetire,
      dOLstIncr: dOLstIncr ?? this.dOLstIncr,
      dOLstPromotn: dOLstPromotn ?? this.dOLstPromotn,
      dOPhd: dOPhd ?? this.dOPhd,
      dOPub: dOPub ?? this.dOPub,
      publicationTyp: publicationTyp ?? this.publicationTyp,
      payScale: payScale ?? this.payScale,
      gradePay: gradePay ?? this.gradePay,
      basic: basic ?? this.basic,
      address: address ?? this.address,
      contactNo: contactNo ?? this.contactNo,
      email: email ?? this.email,
      religionName: religionName ?? this.religionName,
      religion: religion ?? this.religion,
      cast: cast ?? this.cast,
      nominee: nominee ?? this.nominee,
      nomineeRel: nomineeRel ?? this.nomineeRel,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      qualification: qualification ?? this.qualification,
    );
  }

  factory SingleStaffResponse.fromJson(Map<String, dynamic> json) {
    return SingleStaffResponse(
      error: json["error"],
      msg: json["msg"],
      id: json["id"],
      category: json["category"],
      dOB: json["d_o_b"],
      empCode: json["emp_code"],
      name: json["name"],
      fatherName: json["father_name"],
      designation: json["designation"],
      dept: json["dept"],
      pancardNo: json["pancard_no"],
      bank: json["bank"],
      bankAccNo: json["bank_acc_no"],
      ifsc: json["ifsc"],
      dOJoin: json["d_o_join"],
      dORetire: json["d_o_retire"],
      dOLstIncr: json["d_o_lst_incr"],
      dOLstPromotn: json["d_o_lst_promotn"],
      dOPhd: json["d_o_phd"],
      dOPub: json["d_o_pub"],
      publicationTyp: json["publication_typ"],
      payScale: json["pay_scale"],
      gradePay: json["grade_pay"],
      basic: json["basic"],
      address: json["address"],
      contactNo: json["contact_no"],
      email: json["email"],
      religionName: json["religionName"],
      religion: json["religion"],
      cast: json["cast"],
      nominee: json["nominee"],
      nomineeRel: json["nominee_rel"],
      bloodGroup: json["blood_group"],
      qualification: json["qualification"],
    );
  }

  Map<String, dynamic> toJson() => {
        "error": error,
        "msg": msg,
        "id": id,
        "category": category,
        "d_o_b": dOB,
        "emp_code": empCode,
        "name": name,
        "father_name": fatherName,
        "designation": designation,
        "dept": dept,
        "pancard_no": pancardNo,
        "bank": bank,
        "bank_acc_no": bankAccNo,
        "ifsc": ifsc,
        "d_o_join": dOJoin,
        "d_o_retire": dORetire,
        "d_o_lst_incr": dOLstIncr,
        "d_o_lst_promotn": dOLstPromotn,
        "d_o_phd": dOPhd,
        "d_o_pub": dOPub,
        "publication_typ": publicationTyp,
        "pay_scale": payScale,
        "grade_pay": gradePay,
        "basic": basic,
        "address": address,
        "contact_no": contactNo,
        "email": email,
        "religionName": religionName,
        "religion": religion,
        "cast": cast,
        "nominee": nominee,
        "nominee_rel": nomineeRel,
        "blood_group": bloodGroup,
        "qualification": qualification,
      };
}
