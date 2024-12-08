class EditSalaryStructureRequest {
  String id;
  String empid;
  String payScale;
  String gradePay;
  String basicSalary;
  String additionResult;
  String deductionResult;
  EditSalaryStructureRequest(this.id, this.empid, this.payScale, this.gradePay,
      this.basicSalary, this.additionResult, this.deductionResult);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'id': id.trim(),
      'empid': empid.trim(),
      'payScale': payScale.trim(),
      'gradePay': gradePay.trim(),
      'basicSalary': basicSalary.trim(),
      'additionResult': additionResult.trim(),
      'deductionResult': deductionResult.trim(),
    };

    return map;
  }
}
