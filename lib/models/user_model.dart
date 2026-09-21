class UserModel {
  final String uid;
  final String name;
  final String email;
  final String employeeId;
  final String role;
  final String district;
  final String state;

  // Constructor used to create a UserModel object
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.employeeId,
    required this.role,
    required this.district,
    required this.state,
  });

  // Factory constructor that converts Firestore Map data
  // into a UserModel object
  factory UserModel.fromMap(
    String uid,
    Map<String, dynamic> data,
  ) {
    return UserModel(
      // Firebase Authentication UID
      uid: uid,

      // Get name from Firestore
      // Use empty string if the value is null
      name: data['name'] ?? '',

      // Get email from Firestore
      email: data['email'] ?? '',

      // Get employee ID from Firestore
      employeeId: data['employeeId'] ?? '',

      // Get user role from Firestore
      role: data['role'] ?? '',

      // Get district from Firestore
      district: data['district'] ?? '',

      // Get state from Firestore
      state: data['state'] ?? '',
    );
  }

  // Converts the UserModel object into a Map
  // so it can be stored in Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'employeeId': employeeId,
      'role': role,
      'district': district,
      'state': state,
    };
  }
}