class DeleteCollectionRequest {
  String receipt;
  String advanceFeeId;
  DeleteCollectionRequest(this.receipt, this.advanceFeeId);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'receipt': receipt.trim(),
      'advanceFeeId': advanceFeeId.trim(),
    };

    return map;
  }
}
