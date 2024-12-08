class EditStaffRequest {
  String id;
  String category;
  String name;
  String fatherName;
  String dob;
  String designation;
  String department;
  String pan;
  String bank;
  String account;
  String ifsc;
  String mobile;
  String email;
  String religion;
  String caste;
  String blood;
  String qualification;
  String address;
  String joining;
  String retirement;
  String increment;
  String promotion;
  String phd;
  String publication;
  String pubType;
  String nominee;
  String relationship;
  EditStaffRequest(
      this.id,
      this.category,
      this.name,
      this.fatherName,
      this.dob,
      this.designation,
      this.department,
      this.pan,
      this.bank,
      this.account,
      this.ifsc,
      this.mobile,
      this.email,
      this.religion,
      this.caste,
      this.blood,
      this.qualification,
      this.address,
      this.joining,
      this.retirement,
      this.increment,
      this.promotion,
      this.phd,
      this.publication,
      this.pubType,
      this.nominee,
      this.relationship);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'id': id.trim(),
      'category': category.trim(),
      'name': name.trim(),
      'father_name': fatherName.trim(),
      'today1': dob.trim(),
      'designation': designation.trim(),
      'dept': department.trim(),
      'pancard_no': pan.trim(),
      'bank': bank.trim(),
      'bank_acc_no': account.trim(),
      'ifsc': ifsc.trim(),
      'mobile': mobile.trim(),
      'email': email.trim(),
      'religion': religion.trim(),
      'cast': caste.trim(),
      'blood_group': blood.trim(),
      'qualification': qualification.trim(),
      'address': address.trim(),
      'today2': joining.trim(),
      'today3': retirement.trim(),
      'today4': increment.trim(),
      'today5': promotion.trim(),
      'today6': phd.trim(),
      'today7': publication.trim(),
      'publication_typ': pubType.trim(),
      'nominee': nominee.trim(),
      'nominee_rel': relationship.trim(),
    };

    return map;
  }
}
