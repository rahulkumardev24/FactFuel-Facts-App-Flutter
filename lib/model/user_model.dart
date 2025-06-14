class UserModel {
  late String userName;
  late String userProfile;
  late String uid;
  late String email;

  UserModel({
    required this.email,
    required this.userName,
    required this.uid,
    required this.userProfile,
  });

  /// to json
  Map<String, dynamic> toJson() {
    return {
      "userName": userName,
      "uid": uid,
      "email": email,
      "userProfile": userProfile,
    };
  }

  /// from json
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      userName: json['userName'],
      uid: json['uid'],
      userProfile: json['userProfile'],
    );
  }
}
