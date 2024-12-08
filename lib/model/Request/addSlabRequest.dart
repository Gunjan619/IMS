class AddSlabRequest {
  String slab;
  String property;
  String type;
  AddSlabRequest(this.slab, this.property, this.type);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'slab': slab.trim(),
      'property': property.trim(),
      'type': type.trim(),
    };

    return map;
  }
}
