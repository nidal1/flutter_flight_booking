class AppUser {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final String? phoneNumber;
  final bool isEmailVerified;

  final String? idToken;
  final String? refreshToken;

  AppUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.phoneNumber,
    this.isEmailVerified = false,
    this.idToken,
    this.refreshToken,
  });

  // JSON → AppUser
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      email: json['email'],
      displayName: json['displayName'],
      photoURL: json['photoURL'],
      phoneNumber: json['phoneNumber'],
      isEmailVerified: json['isEmailVerified'] ?? false,
      idToken: json['idToken'],
      refreshToken: json['refreshToken'],
    );
  }

  // AppUser → JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'isEmailVerified': isEmailVerified,
      'idToken': idToken,
      'refreshToken': refreshToken,
    };
  }
}
