class organisationResponse {
  organisationResponse({
    this.id,
    this.name,
    this.appid,
    this.phone,
    this.email,
    this.logo,
    this.address,
    this.address2,
    this.hostelBoys,
    this.hostelBoysaddress,
    this.hostelGirls,
    this.hostelGirlsaddress,
    this.city,
    this.state,
    this.error,
    this.msg,
  });

  final String? id;
  final String? name;
  final String? appid;
  final String? phone;
  final String? email;
  final String? logo;
  final String? address;
  final String? address2;
  final String? hostelBoys;
  final String? hostelBoysaddress;
  final String? hostelGirls;
  final String? hostelGirlsaddress;
  final String? city;
  final String? state;
  final bool? error;
  final String? msg;

  organisationResponse copyWith({
    String? id,
    String? name,
    String? appid,
    String? phone,
    String? email,
    String? logo,
    String? address,
    String? address2,
    String? hostelBoys,
    String? hostelBoysaddress,
    String? hostelGirls,
    String? hostelGirlsaddress,
    String? city,
    String? state,
    bool? error,
    String? msg,
  }) {
    return organisationResponse(
      id: id ?? this.id,
      name: name ?? this.name,
      appid: appid ?? this.appid,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      logo: logo ?? this.logo,
      address: address ?? this.address,
      address2: address2 ?? this.address2,
      hostelBoys: hostelBoys ?? this.hostelBoys,
      hostelBoysaddress: hostelBoysaddress ?? this.hostelBoysaddress,
      hostelGirls: hostelGirls ?? this.hostelGirls,
      hostelGirlsaddress: hostelGirlsaddress ?? this.hostelGirlsaddress,
      city: city ?? this.city,
      state: state ?? this.state,
      error: error ?? this.error,
      msg: msg ?? this.msg,
    );
  }

  factory organisationResponse.fromJson(Map<String, dynamic> json) {
    return organisationResponse(
      id: json["id"],
      name: json["name"],
      appid: json["appid"],
      phone: json["phone"],
      email: json["email"],
      logo: json["logo"],
      address: json["address"],
      address2: json["address2"],
      hostelBoys: json["hostel_boys"],
      hostelBoysaddress: json["hostel_boysaddress"],
      hostelGirls: json["hostel_girls"],
      hostelGirlsaddress: json["hostel_girlsaddress"],
      city: json["city"],
      state: json["state"],
      error: json["error"],
      msg: json["msg"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "appid": appid,
        "phone": phone,
        "email": email,
        "logo": logo,
        "address": address,
        "address2": address2,
        "hostel_boys": hostelBoys,
        "hostel_boysaddress": hostelBoysaddress,
        "hostel_girls": hostelGirls,
        "hostel_girlsaddress": hostelGirlsaddress,
        "city": city,
        "state": state,
        "error": error,
        "msg": msg,
      };
}
