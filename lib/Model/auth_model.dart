class AuthenticationModel {
  final bool status;
  final String message;
  final String accessToken;

  AuthenticationModel({
    required this.status,
    required this.message,
    required this.accessToken,
  });

  factory AuthenticationModel.fromJson(Map<String, dynamic> json) =>
      AuthenticationModel(
        status: json["status"],
        message: json["message"],
        accessToken: json["accessToken"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "accessToken": accessToken,
      };
}
