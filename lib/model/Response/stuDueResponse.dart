class StuDueResponse {
  bool? error;
  String? msg;
  String? total;
  List<Data>? data;

  StuDueResponse({this.error, this.msg, this.data});

  StuDueResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    msg = json['msg'];
    total = json['total'];
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
    data['total'] = total;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? amount;
  String? advfeeId;
  String? feeName;
  String? oldAmount;
  String? paidAmount;
  String? oldDiscount;
  String? discount;

  Data(
      {this.id,
      this.feeName,
      this.amount,
      this.oldAmount,
      this.paidAmount,
      this.advfeeId,
      this.oldDiscount,
      this.discount});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    feeName = json['feeName'];
    amount = json['amount'];
    oldAmount = json['oldAmount'];
    paidAmount = json['paidAmount'];
    advfeeId = json['adv_feeid'];
    oldDiscount = json['oldDiscount'];
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['feeName'] = feeName;
    data['amount'] = amount;
    data['oldAmount'] = oldAmount;
    data['oldDiscount'] = oldDiscount;
    data['discount'] = discount;
    return data;
  }
}
