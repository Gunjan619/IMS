class PrintReceiptRequest {
  String type;
  String receiptNo;
  PrintReceiptRequest(this.type, this.receiptNo);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'type': type.trim(),
      'receipt_no': receiptNo.trim(),
    };

    return map;
  }
}
