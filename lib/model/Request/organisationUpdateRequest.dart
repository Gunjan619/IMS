class OrganisationUpdateModel {
  String type;
  String name;
  String branch;
  String city;
  String state;
  String address;
  String mobile;
  String email;
  String boysHostel;
  String boysHostelAddress;
  String girlsHostel;
  String girlsHostelAddress;

  OrganisationUpdateModel(
    this.type,
    this.name,
    this.branch,
    this.city,
    this.state,
    this.address,
    this.mobile,
    this.email,
    this.boysHostel,
    this.boysHostelAddress,
    this.girlsHostel,
    this.girlsHostelAddress,
  );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'type': type.trim(),
      'name': name.trim(),
      'branch': branch.trim(),
      'city': city.trim(),
      'state': state.trim(),
      'address': address.trim(),
      'email': email.trim(),
      'mobile': mobile.trim(),
      'boysHostel': boysHostel.trim(),
      'boysHostelAddress': boysHostelAddress.trim(),
      'girlsHostel': girlsHostel.trim(),
      'girlsHostelAddress': girlsHostelAddress.trim(),
    };

    return map;
  }
}
