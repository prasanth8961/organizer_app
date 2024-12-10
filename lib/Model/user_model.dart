import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  final String orgId;
  final String fullName;
  final String email;
  final String countryCode;
  final String mobile;
  final String profile;
  final String verifiedStatus;
  final String location;
  final String collegeName;
  final String collegeCode;

  UserModel({
    required this.orgId,
    required this.fullName,
    required this.email,
    required this.countryCode,
    required this.mobile,
    required this.profile,
    required this.verifiedStatus,
    required this.location,
    required this.collegeName,
    required this.collegeCode,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        orgId: json["org_id"],
        fullName: json["full_name"],
        email: json["email"],
        countryCode: json["country_code"],
        mobile: json["mobile"],
        profile: json["profile"],
        verifiedStatus: json["verified_status"],
        location: json["location"],
        collegeName: json["college_name"],
        collegeCode: json["college_code"],
      );

  Map<String, dynamic> toJson() => {
        "org_id": orgId,
        "full_name": fullName,
        "email": email,
        "country_code": countryCode,
        "mobile": mobile,
        "profile": profile,
        "verified_status": verifiedStatus,
        "location": location,
        "college_name": collegeName,
        "college_code": collegeCode,
      };
}
