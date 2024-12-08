class SalaryStructureResponse {
  bool? error;
  String? msg;
  List<Data>? data;

  SalaryStructureResponse({this.error, this.msg, this.data});

  SalaryStructureResponse.fromJson(Map<String, dynamic> json) {
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
  String? id;
  String? empId;
  String? payScale;
  String? gradePay;
  String? basicSalary;
  String? additions;
  String? deductions;
  String? additions2;
  String? deductions2;
  String? addTotal;
  String? dedTotal;
  String? netSalary;
  String? empName;
  String? empCode;
  String? designation;
  String? department;

  Data(
      {this.id,
      this.empId,
      this.payScale,
      this.gradePay,
      this.basicSalary,
      this.additions,
      this.deductions,
      this.additions2,
      this.deductions2,
      this.addTotal,
      this.dedTotal,
      this.netSalary,
      this.empName,
      this.empCode,
      this.designation,
      this.department});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    empId = json['emp_id'];
    payScale = json['pay_scale'];
    gradePay = json['grade_pay'];
    basicSalary = json['basic_salary'];
    additions = json['additions'];
    deductions = json['deductions'];
    additions2 = json['additions2'];
    deductions2 = json['deductions2'];
    addTotal = json['add_total'];
    dedTotal = json['ded_total'];
    netSalary = json['net_salary'];
    empName = json['empName'];
    empCode = json['empCode'];
    designation = json['designation'];
    department = json['department'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['emp_id'] = empId;
    data['pay_scale'] = payScale;
    data['grade_pay'] = gradePay;
    data['basic_salary'] = basicSalary;
    data['additions'] = additions;
    data['deductions'] = deductions;
    data['additions2'] = additions2;
    data['deductions2'] = deductions2;
    data['add_total'] = addTotal;
    data['ded_total'] = dedTotal;
    data['net_salary'] = netSalary;
    data['empName'] = empName;
    data['empCode'] = empCode;
    data['designation'] = designation;
    data['department'] = department;
    return data;
  }
}
