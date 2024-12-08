class DashExpenseResponse {
  bool? error;
  String? totalExpense;
  String? expenseMonth;
  String? expenseYear;
  String? msg;

  DashExpenseResponse(
      {this.error,
      this.totalExpense,
      this.expenseMonth,
      this.expenseYear,
      this.msg});

  DashExpenseResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    totalExpense = json['totalExpense'];
    expenseMonth = json['expenseMonth'];
    expenseYear = json['expenseYear'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['totalExpense'] = totalExpense;
    data['expenseMonth'] = expenseMonth;
    data['expenseYear'] = expenseYear;
    data['msg'] = msg;
    return data;
  }
}
