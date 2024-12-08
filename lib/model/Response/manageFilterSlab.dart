class ManageFilterSlab {
  bool? error;
  String? msg;
  List<Data>? data;

  ManageFilterSlab({this.error, this.msg, this.data});

  ManageFilterSlab.fromJson(Map<String, dynamic> json) {
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
  String? slabName;
  String? slabProperty;

  Data({this.id, this.slabName, this.slabProperty});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slabName = json['slab_name'];
    slabProperty = json['slab_property'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slab_name'] = slabName;
    data['slab_property'] = slabProperty;
    return data;
  }
}
