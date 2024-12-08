class PaymentResponse {
  bool? error;
  String? msg;
  List<Data>? data;

  PaymentResponse({this.error, this.msg, this.data});

  PaymentResponse.fromJson(Map<String, dynamic> json) {
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
  String? entryDate;
  String? invoiceNo;
  String? amtts;
  String? paids;
  String? amount;
  String? discount;
  String? paid;
  String? due;

  Data(
      {this.entryDate,
      this.invoiceNo,
      this.amtts,
      this.paids,
      this.amount,
      this.discount,
      this.paid,
      this.due});

  Data.fromJson(Map<String, dynamic> json) {
    entryDate = json['entry_date'];
    invoiceNo = json['inv_no'];
    amtts = json['amtts'];
    paids = json['paids'];
    amount = json['amount'];
    discount = json['discount'];
    paid = json['paid'];
    due = json['due'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['entry_date'] = entryDate;
    data['inv_no'] = invoiceNo;
    data['amtts'] = amtts;
    data['paids'] = paids;
    data['amount'] = amount;
    data['discount'] = discount;
    data['paid'] = paid;
    data['due'] = due;
    return data;
  }
}
