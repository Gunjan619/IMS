class PermissionResponse {
  PermissionResponse({
    bool? error,
    String? msg,
    List<Data>? data,
  }) {
    _error = error;
    _msg = msg;
    _data = data;
  }

  PermissionResponse.fromJson(dynamic json) {
    _error = json['error'];
    _msg = json['msg'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  bool? _error;
  String? _msg;
  List<Data>? _data;
  PermissionResponse copyWith({
    bool? error,
    String? msg,
    List<Data>? data,
  }) =>
      PermissionResponse(
        error: error ?? _error,
        msg: msg ?? _msg,
        data: data ?? _data,
      );
  bool? get error => _error;
  String? get msg => _msg;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['msg'] = _msg;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// head : "Dashboard"
/// p_per : "home"
/// sub_heads : [{"id":"2","child":"All Session Reports","c_per":null,"sub_innerheads":[{"id":"2","subchild":"Session Report","s_per":"session_report"}]},{"id":"3","child":"All Courses Reports","c_per":null,"sub_innerheads":[{"id":"3","subchild":"Courses Report","s_per":"course_report"}]},{"id":"4","child":"Collection Report","c_per":null,"sub_innerheads":[{"id":"4","subchild":"Total Amount","s_per":"paid_amount"},{"id":"5","subchild":"Total Collection","s_per":"paid_amount_total_collection"},{"id":"6","subchild":"Due Amount","s_per":"view_pending"},{"id":"7","subchild":"Today Collection","s_per":"paid_amount_today_collection"}]},{"id":"8","child":"Expenses Reports","c_per":null,"sub_innerheads":[{"id":"8","subchild":"Total Expenses","s_per":"expense_report_total"},{"id":"9","subchild":"Expenses Month","s_per":"expense_report_month"},{"id":"10","subchild":"Expenses Year","s_per":"expense_report_year"},{"id":"11","subchild":"Expenses Report","s_per":"expense_report_all"}]},{"id":"12","child":"All Reports","c_per":null,"sub_innerheads":[{"id":"12","subchild":"Total Books","s_per":"all_dash_report"},{"id":"13","subchild":"Total Due Books","s_per":"manage_due_book"}]},{"id":"14","child":"Issue & Return Record","c_per":null,"sub_innerheads":[{"id":"14","subchild":"Issue Today","s_per":"manage_issue_book_today"},{"id":"15","subchild":"Issue All","s_per":"manage_issue_book_all"},{"id":"16","subchild":"Return Today","s_per":"book_returndata_today"},{"id":"17","subchild":"Return All","s_per":"book_returndata_all"}]}]

class Data {
  Data({
    String? head,
    String? pPer,
    List<SubHeads>? subHeads,
  }) {
    _head = head;
    _pPer = pPer;
    _subHeads = subHeads;
  }

  Data.fromJson(dynamic json) {
    _head = json['head'];
    _pPer = json['p_per'];
    if (json['sub_heads'] != null) {
      _subHeads = [];
      json['sub_heads'].forEach((v) {
        _subHeads?.add(SubHeads.fromJson(v));
      });
    }
  }
  String? _head;
  String? _pPer;
  List<SubHeads>? _subHeads;
  Data copyWith({
    String? head,
    String? pPer,
    List<SubHeads>? subHeads,
  }) =>
      Data(
        head: head ?? _head,
        pPer: pPer ?? _pPer,
        subHeads: subHeads ?? _subHeads,
      );
  String? get head => _head;
  String? get pPer => _pPer;
  List<SubHeads>? get subHeads => _subHeads;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['head'] = _head;
    map['p_per'] = _pPer;
    if (_subHeads != null) {
      map['sub_heads'] = _subHeads?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : "2"
/// child : "All Session Reports"
/// c_per : null
/// sub_innerheads : [{"id":"2","subchild":"Session Report","s_per":"session_report"}]

class SubHeads {
  SubHeads({
    String? id,
    String? child,
    dynamic cPer,
    List<SubInnerheads>? subInnerheads,
  }) {
    _id = id;
    _child = child;
    _cPer = cPer;
    _subInnerheads = subInnerheads;
  }

  SubHeads.fromJson(dynamic json) {
    _id = json['id'];
    _child = json['child'];
    _cPer = json['c_per'];
    if (json['sub_innerheads'] != null) {
      _subInnerheads = [];
      json['sub_innerheads'].forEach((v) {
        _subInnerheads?.add(SubInnerheads.fromJson(v));
      });
    }
  }
  String? _id;
  String? _child;
  dynamic _cPer;
  List<SubInnerheads>? _subInnerheads;
  SubHeads copyWith({
    String? id,
    String? child,
    dynamic cPer,
    List<SubInnerheads>? subInnerheads,
  }) =>
      SubHeads(
        id: id ?? _id,
        child: child ?? _child,
        cPer: cPer ?? _cPer,
        subInnerheads: subInnerheads ?? _subInnerheads,
      );
  String? get id => _id;
  String? get child => _child;
  dynamic get cPer => _cPer;
  List<SubInnerheads>? get subInnerheads => _subInnerheads;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['child'] = _child;
    map['c_per'] = _cPer;
    if (_subInnerheads != null) {
      map['sub_innerheads'] = _subInnerheads?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : "2"
/// subchild : "Session Report"
/// s_per : "session_report"

class SubInnerheads {
  SubInnerheads({
    String? id,
    String? subchild,
    String? sPer,
  }) {
    _id = id;
    _subchild = subchild;
    _sPer = sPer;
  }

  SubInnerheads.fromJson(dynamic json) {
    _id = json['id'];
    _subchild = json['subchild'];
    _sPer = json['s_per'];
  }
  String? _id;
  String? _subchild;
  String? _sPer;
  SubInnerheads copyWith({
    String? id,
    String? subchild,
    String? sPer,
  }) =>
      SubInnerheads(
        id: id ?? _id,
        subchild: subchild ?? _subchild,
        sPer: sPer ?? _sPer,
      );
  String? get id => _id;
  String? get subchild => _subchild;
  String? get sPer => _sPer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['subchild'] = _subchild;
    map['s_per'] = _sPer;
    return map;
  }
}
