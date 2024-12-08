class InvoiceResponse {
  bool? error;
  String? msg;
  List<Data>? data;

  InvoiceResponse({this.error, this.msg, this.data});

  InvoiceResponse.fromJson(Map<String, dynamic> json) {
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
  String? payDate;
  String? receiptNo;
  String? payType;
  String? paid;

  Data({
    this.payDate,
    this.receiptNo,
    this.payType,
    this.paid,
  });

  Data.fromJson(Map<String, dynamic> json) {
    payDate = json['pay_date'];
    receiptNo = json['receipt_no'];
    payType = json['pay_type'];
    paid = json['paid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pay_date'] = payDate;
    data['receipt_no'] = receiptNo;
    data['pay_type'] = payType;
    data['paid'] = paid;

    return data;
  }
}
