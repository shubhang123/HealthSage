// user_model.dart

class User {
  final String dateOfBirth;
  final String email;
  final String name;
  final String address;
  final String allergies;
  final String bloodGroup;
  final String chronicConditions;
  final String ec1No;
  final String ec2No;
  final String height;
  final String imageUrl;
  final String mobileNo;
  final String pdfUrl;
  final String surgeries;
  final String userId;
  final String username;
  final String weight;

  User({
    required this.dateOfBirth,
    required this.email,
    required this.name,
    required this.address,
    required this.allergies,
    required this.bloodGroup,
    required this.chronicConditions,
    required this.ec1No,
    required this.ec2No,
    required this.height,
    required this.imageUrl,
    required this.mobileNo,
    required this.pdfUrl,
    required this.surgeries,
    required this.userId,
    required this.username,
    required this.weight,
  });

  // Factory method to convert Firestore document snapshot to User object
  factory User.fromFirestore(Map<String, dynamic> json) {
    return User(
      dateOfBirth: json['DateofBirth'] ?? '',
      email: json['E-mail'] ?? '',
      name: json['Name'] ?? '',
      address: json['address'] ?? '',
      allergies: json['allergies'] ?? '',
      bloodGroup: json['bloodGroup'] ?? '',
      chronicConditions: json['chronicConditions'] ?? '',
      ec1No: json['ec1_no'] ?? '',
      ec2No: json['ec2_no'] ?? '',
      height: json['height'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      mobileNo: json['mobile_no'] ?? '',
      pdfUrl: json['pdfUrl'] ?? '',
      surgeries: json['surgeries'] ?? '',
      userId: json['userid'] ?? '',
      username: json['username'] ?? '',
      weight: json['weight'] ?? '',
    );
  }
}
