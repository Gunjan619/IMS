import 'dart:convert';

/// head_id : "1"
/// head : "home"
/// sub_heads : [{"sub_head_id":"1","sub_head":"today_joining"},{"sub_head_id":"2","sub_head":"month_joining"},{"sub_head_id":"3","sub_head":"total_joining"},{"sub_head_id":"4","sub_head":"today_collection"},{"sub_head_id":"5","sub_head":"month_collection"},{"sub_head_id":"6","sub_head":"total_collection"},{"sub_head_id":"7","sub_head":"today_expense"},{"sub_head_id":"8","sub_head":"month_expense"},{"sub_head_id":"9","sub_head":"total_expense"},{"sub_head_id":"10","sub_head":"live_students"},{"sub_head_id":"11","sub_head":"demo_students"},{"sub_head_id":"12","sub_head":"expired_students"},{"sub_head_id":"13","sub_head":"expiring1_3days"},{"sub_head_id":"14","sub_head":"due_amount"},{"sub_head_id":"15","sub_head":"due_amount_reminder"},{"sub_head_id":"16","sub_head":"birthday"},{"sub_head_id":"17","sub_head":"anniversary"},{"sub_head_id":"18","sub_head":"today_followup"}]
List<ViewPermissionResponse> ViewPermissionResponseModelFromJson(String str) =>
    List<ViewPermissionResponse>.from(
        json.decode(str).map((x) => ViewPermissionResponse.fromJson(x)));
class ViewPermissionResponse {
  ViewPermissionResponse({
      String? headId, 
      String? head, 
      List<SubHeads>? subHeads,}){
    _headId = headId;
    _head = head;
    _subHeads = subHeads;
}

  ViewPermissionResponse.fromJson(dynamic json) {
    _headId = json['head_id'];
    _head = json['head'];
    if (json['sub_heads'] != null) {
      _subHeads = [];
      json['sub_heads'].forEach((v) {
        _subHeads?.add(SubHeads.fromJson(v));
      });
    }
  }
  String? _headId;
  String? _head;
  List<SubHeads>? _subHeads;
ViewPermissionResponse copyWith({  String? headId,
  String? head,
  List<SubHeads>? subHeads,
}) => ViewPermissionResponse(  headId: headId ?? _headId,
  head: head ?? _head,
  subHeads: subHeads ?? _subHeads,
);
  String? get headId => _headId;
  String? get head => _head;
  List<SubHeads>? get subHeads => _subHeads;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['head_id'] = _headId;
    map['head'] = _head;
    if (_subHeads != null) {
      map['sub_heads'] = _subHeads?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// sub_head_id : "1"
/// sub_head : "today_joining"

class SubHeads {
  SubHeads({
      String? subHeadId, 
      String? subHead,}){
    _subHeadId = subHeadId;
    _subHead = subHead;
}

  SubHeads.fromJson(dynamic json) {
    _subHeadId = json['sub_head_id'];
    _subHead = json['sub_head'];
  }
  String? _subHeadId;
  String? _subHead;
SubHeads copyWith({  String? subHeadId,
  String? subHead,
}) => SubHeads(  subHeadId: subHeadId ?? _subHeadId,
  subHead: subHead ?? _subHead,
);
  String? get subHeadId => _subHeadId;
  String? get subHead => _subHead;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sub_head_id'] = _subHeadId;
    map['sub_head'] = _subHead;
    return map;
  }

}