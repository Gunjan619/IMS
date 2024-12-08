class EditSlabRequest {
  String id;
  String slab;
  String property;
  String type;
  EditSlabRequest(this.id, this.slab, this.property, this.type);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'id': id.trim(),
      'slab': slab.trim(),
      'property': property.trim(),
      'type': type.trim(),
    };

    return map;
  }
}
