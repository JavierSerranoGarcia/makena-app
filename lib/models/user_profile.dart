class UserProfile {
  final String email;
  final String? gender;
  final int? height;
  final int? age;
  final double? shoulder;
  final double? bust;
  final double? waist;
  final double? hip;
  final String? undertone;

  UserProfile({
    required this.email,
    this.gender,
    this.height,
    this.age,
    this.shoulder,
    this.bust,
    this.waist,
    this.hip,
    this.undertone,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'gender': gender,
      'height': height,
      'age': age,
      'shoulder': shoulder,
      'bust': bust,
      'waist': waist,
      'hip': hip,
      'undertone': undertone,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      email: json['email'] as String,
      gender: json['gender'] as String?,
      height: json['height'] as int?,
      age: json['age'] as int?,
      shoulder: json['shoulder'] as double?,
      bust: json['bust'] as double?,
      waist: json['waist'] as double?,
      hip: json['hip'] as double?,
      undertone: json['undertone'] as String?,
    );
  }

  UserProfile copyWith({
    String? email,
    String? gender,
    int? height,
    int? age,
    double? shoulder,
    double? bust,
    double? waist,
    double? hip,
    String? undertone,
  }) {
    return UserProfile(
      email: email ?? this.email,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      age: age ?? this.age,
      shoulder: shoulder ?? this.shoulder,
      bust: bust ?? this.bust,
      waist: waist ?? this.waist,
      hip: hip ?? this.hip,
      undertone: undertone ?? this.undertone,
    );
  }
}
