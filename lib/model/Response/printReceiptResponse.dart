class PrintReceiptResponse {
  bool? error;
  String? msg;
  String? logo;
  String? orgname;
  String? address;
  String? email;
  String? phone;
  String? receiptNo;
  String? payDate;
  String? stuName;
  String? course;
  String? year;
  int? grandtotal;
  String? payMode;
  String? refNo;
  List<Data>? data;

  PrintReceiptResponse(
      {this.error,
      this.msg,
      this.logo,
      this.orgname,
      this.address,
      this.email,
      this.phone,
      this.receiptNo,
      this.payDate,
      this.stuName,
      this.course,
      this.year,
      this.grandtotal,
      this.payMode,
      this.refNo,
      this.data});

  PrintReceiptResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    msg = json['msg'];
    logo = json['logo'];
    orgname = json['orgname'];
    address = json['address'];
    email = json['email'];
    phone = json['phone'];
    receiptNo = json['receiptNo'];
    payDate = json['payDate'];
    stuName = json['stuName'];
    course = json['course'];
    year = json['year'];
    grandtotal = json['grandtotal'];
    payMode = json['payMode'];
    refNo = json['refNo'];
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
    data['logo'] = logo;
    data['orgname'] = orgname;
    data['address'] = address;
    data['email'] = email;
    data['phone'] = phone;
    data['receiptNo'] = receiptNo;
    data['payDate'] = payDate;
    data['stuName'] = stuName;
    data['course'] = course;
    data['year'] = year;
    data['grandtotal'] = grandtotal;
    data['payMode'] = payMode;
    data['refNo'] = refNo;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? feeName;
  String? paidAmount;

  Data({this.feeName, this.paidAmount});

  Data.fromJson(Map<String, dynamic> json) {
    feeName = json['fee_name'];
    paidAmount = json['paid_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fee_name'] = feeName;
    data['paid_amount'] = paidAmount;
    return data;
  }
}
