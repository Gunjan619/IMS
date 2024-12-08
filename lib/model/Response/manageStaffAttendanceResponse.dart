/// error : false
/// msg : "data Found"
/// data : [{"id":"1","emp_id":"10000","emp_type":"teaching","attend":"half_day","date":"2024-01-01","present":"0","absent":"0","half_day":"3","paid_leave":"","holiday":"0"},{"id":"4","emp_id":"10007","emp_type":"non-teaching","attend":"present","date":"2024-01-01","present":"1","absent":"0","half_day":"0","paid_leave":"","holiday":"0"},{"id":"12","emp_id":"10007","emp_type":"non-teaching","attend":"present","date":"2024-01-02","present":"1","absent":"0","half_day":"0","paid_leave":"","holiday":"0"},{"id":"11","emp_id":"10006","emp_type":"teaching","attend":"half_day","date":"2024-01-02","present":"0","absent":"0","half_day":"1","paid_leave":"","holiday":"0"}]

class ManageStaffAttendanceResponse {
  ManageStaffAttendanceResponse({
      bool? error, 
      String? msg, 
      List<Data>? data,}){
    _error = error;
    _msg = msg;
    _data = data;
}

  ManageStaffAttendanceResponse.fromJson(dynamic json) {
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
ManageStaffAttendanceResponse copyWith({  bool? error,
  String? msg,
  List<Data>? data,
}) => ManageStaffAttendanceResponse(  error: error ?? _error,
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

/// id : "1"
/// emp_id : "10000"
/// emp_type : "teaching"
/// attend : "half_day"
/// date : "2024-01-01"
/// present : "0"
/// absent : "0"
/// half_day : "3"
/// paid_leave : ""
/// holiday : "0"

class Data {
  Data({
      String? id, 
      String? empId, 
      String? empType, 
      String? attend, 
      String? date, 
      String? present, 
      String? absent, 
      String? halfDay, 
      String? paidLeave, 
      String? holiday,}){
    _id = id;
    _empId = empId;
    _empType = empType;
    _attend = attend;
    _date = date;
    _present = present;
    _absent = absent;
    _halfDay = halfDay;
    _paidLeave = paidLeave;
    _holiday = holiday;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _empId = json['emp_id'];
    _empType = json['emp_type'];
    _attend = json['attend'];
    _date = json['date'];
    _present = json['present'];
    _absent = json['absent'];
    _halfDay = json['half_day'];
    _paidLeave = json['paid_leave'];
    _holiday = json['holiday'];
  }
  String? _id;
  String? _empId;
  String? _empType;
  String? _attend;
  String? _date;
  String? _present;
  String? _absent;
  String? _halfDay;
  String? _paidLeave;
  String? _holiday;
Data copyWith({  String? id,
  String? empId,
  String? empType,
  String? attend,
  String? date,
  String? present,
  String? absent,
  String? halfDay,
  String? paidLeave,
  String? holiday,
}) => Data(  id: id ?? _id,
  empId: empId ?? _empId,
  empType: empType ?? _empType,
  attend: attend ?? _attend,
  date: date ?? _date,
  present: present ?? _present,
  absent: absent ?? _absent,
  halfDay: halfDay ?? _halfDay,
  paidLeave: paidLeave ?? _paidLeave,
  holiday: holiday ?? _holiday,
);
  String? get id => _id;
  String? get empId => _empId;
  String? get empType => _empType;
  String? get attend => _attend;
  String? get date => _date;
  String? get present => _present;
  String? get absent => _absent;
  String? get halfDay => _halfDay;
  String? get paidLeave => _paidLeave;
  String? get holiday => _holiday;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['emp_id'] = _empId;
    map['emp_type'] = _empType;
    map['attend'] = _attend;
    map['date'] = _date;
    map['present'] = _present;
    map['absent'] = _absent;
    map['half_day'] = _halfDay;
    map['paid_leave'] = _paidLeave;
    map['holiday'] = _holiday;
    return map;
  }

}