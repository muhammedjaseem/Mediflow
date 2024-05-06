class ProfileModel {
  String? dob;
  String? email;
  String? gender;
  String? name;
  String? userId;
  String? phoneNumber;

  ProfileModel(
      {this.dob,
        this.email,
        this.gender,
        this.name,
        this.userId,
        this.phoneNumber});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    dob = json['dob'];
    email = json['email'];
    gender = json['gender'];
    name = json['name'];
    userId = json['userId'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dob'] = this.dob;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['name'] = this.name;
    data['userId'] = this.userId;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}
