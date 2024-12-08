class FeeCollectionReportRequest {
  String type;
  String dd;
  FeeCollectionReportRequest(this.type, this.dd);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'type': type.trim(),
      'dd': dd.trim(),
    };

    return map;
  }
}
