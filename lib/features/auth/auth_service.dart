import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


const String backendBaseUrl =
    'https://maapsetu-w1sf.onrender.com';

    
class AuthService {
  // Firebase Authentication instance
  // Used for login and logout operations
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Firebase Firestore instance
  // Used to access user data stored in Firestore
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // Creates a new Firebase Authentication account
  Future<User?> signup(
    String email,
    String password,
  ) async {
    final credential =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential.user;
  }

  // Creates the user's profile in Firestore
  Future<void> createUserProfile({
    required String uid,
    required String name,
    required String email,
    required String employeeId,
    required String role,
    required String district,
    required String state,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'employeeId': employeeId,
      'role': role,
      'district': district,
      'state': state,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Logs the user into Firebase using email and password
  Future<User?> login(
    String email,
    String password,
  ) async {
    final credential =
        await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential.user;
  }

  // ---------------------------------------------------------
  // BACKEND LOGIN
  // Node.js + Express + PostgreSQL
  // ---------------------------------------------------------

  Future<String?> backendLogin(
  String email,
  String password,
) async {
  final response = await http.post(
    Uri.parse(
      '$backendBaseUrl/api/auth/login',
    ),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data['success'] == true) {
      final token = data['token'];

      // Save backend JWT
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('backendToken', token);

      return token;
    }
  }

  return null;
}


  // Gets the role of a user from Firestore
  // using the user's Firebase Authentication UID
  Future<String?> getUserRole(String uid) async {
    final doc =
        await _firestore.collection('users').doc(uid).get();

    if (!doc.exists) {
      return null;
    }

    return doc.data()?['role'];
  }

  // Gets the JWT token saved after backend login
Future<String?> getBackendToken() async {
  final prefs = await SharedPreferences.getInstance();

  return prefs.getString('backendToken');
}

Future<void> saveCertificateLocally(
  String applicationId,
  Map<String, dynamic> certificate,
) async {
  final prefs =
      await SharedPreferences.getInstance();

  await prefs.setString(
    'certificate_$applicationId',
    jsonEncode(certificate),
  );
}

Future<Map<String, dynamic>?> getLocalCertificate(
  String applicationId,
) async {
  final prefs =
      await SharedPreferences.getInstance();

  final value = prefs.getString(
    'certificate_$applicationId',
  );

  if (value == null || value.isEmpty) {
    return null;
  }

  try {
    return Map<String, dynamic>.from(
      jsonDecode(value),
    );
  } catch (_) {
    return null;
  }
}

  // Logs the currently authenticated user out
  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<List<dynamic>> getInspectorApplications() async {
  // Get the JWT token saved during backend login
  final token = await getBackendToken();

  if (token == null) {
    throw Exception('Backend token not found');
  }

  // Call the Node.js backend
  final response = await http.get(
    Uri.parse(
      '$backendBaseUrl/api/inspector/applications',
    ),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  ).timeout(
    const Duration(seconds: 10),
  );

  if (response.statusCode == 200) {
    print('APPLICATION API RESPONSE: ${response.body}');
    final data = jsonDecode(response.body);

    if (data['success'] == true) {
      return data['applications'] ?? [];
    }
  }

  throw Exception(
    'Failed to load applications: ${response.statusCode}',
  );
}
// Gets the logged-in inspector's profile
// from the Node.js backend
Future<Map<String, dynamic>> getInspectorProfile() async {
  print('GET INSPECTOR APPLICATIONS CALLED');
  // Get the JWT token saved during backend login
  final token = await getBackendToken();

  if (token == null) {
    throw Exception('Backend token not found');
  }

  // Call the inspector applications API
  // The response contains both profile and applications
  final response = await http.get(
    Uri.parse(
      '$backendBaseUrl/api/inspector/applications',
    ),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    // print('APPLICATION API RESPONSE: ${response.body}');
    final data = jsonDecode(response.body);

    if (data['success'] == true) {
      return Map<String, dynamic>.from(
        data['profile'] ?? {},
      );
    }
  }

  throw Exception(
    'Failed to load inspector profile: ${response.statusCode}',
  );
}
Future<Map<String, dynamic>> getInspectorApplicationDetails(
  String assignmentId,
) async {
  print('GET ASSIGNMENT DETAILS CALLED');
  print('ASSIGNMENT ID: $assignmentId');

  final applications = await getInspectorApplications();

  for (final application in applications) {
    if (application['applicationId']?.toString() == assignmentId) {
      print('ASSIGNMENT FOUND: $application');

      return Map<String, dynamic>.from(application);
    }
  }

  throw Exception(
    'Assignment not found: $assignmentId',
  );
}
Future<Map<String, dynamic>> saveVerification({
  required String applicationId,
  required String instrumentId,
  required double latitude,
  required double longitude,

  String verificationType = 'Initial Verification',
  String location = '',
  String result = 'PENDING',
  String remarks = '',
  String startTime = '',
  String endTime = '',

  String testName = 'Accuracy Test',
  double standardValue = 0,
  double observedValue = 0,
  double permissibleError = 0,
  double error = 0,
  String unit = '',
  String observationRemarks = '',
}) async {
  // Get JWT token
  final token = await getBackendToken();

  if (token == null || token.isEmpty) {
    throw Exception('Backend token not found. Please login again.');
  }

  print('==============================');
  print('SAVING VERIFICATION');
  print('Application ID: $applicationId');
  print('Instrument ID: $instrumentId');
  print('Latitude: $latitude');
  print('Longitude: $longitude');
  print('==============================');

  final response = await http.post(
    Uri.parse(
      '$backendBaseUrl/api/verifications',
    ),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'verification': {
        'applicationId': applicationId,
        'instrumentId': instrumentId,
        'verificationType': verificationType,
        'verificationDate':
            DateTime.now().toIso8601String(),
        'location': location,
        'result': result,
        'remarks': remarks,
        'startTime': startTime,
        'endTime': endTime,
        'latitude': latitude,
        'longitude': longitude,
      },

      'observation': {
        'observationId':
            'OBS-${DateTime.now().millisecondsSinceEpoch}',
        'testName': testName,
        'standardValue': standardValue,
        'observedValue': observedValue,
        'permissibleError': permissibleError,
        'error': error,
        'result': result,
        'unit': unit,
        'remarks': observationRemarks,
      },
    }),
  ).timeout(
    const Duration(seconds: 15),
  );

  print('SAVE VERIFICATION STATUS: ${response.statusCode}');
  print('SAVE VERIFICATION RESPONSE: ${response.body}');

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data['success'] == true) {
      return Map<String, dynamic>.from(data);
    }

    throw Exception(
      data['message'] ?? 'Failed to save verification',
    );
  }

  try {
    final data = jsonDecode(response.body);

    throw Exception(
      data['message'] ??
          'Failed to save verification: ${response.statusCode}',
    );
  } catch (_) {
    throw Exception(
      'Failed to save verification: ${response.statusCode}',
    );
  }
}

Future<Map<String, dynamic>> createCertificate({
  required String verificationId,
  required String applicationId,
  required String instrumentId,
  String certificateType = 'Verification Certificate',
  String? issueDate,
  String? validUntil,
  String status = 'Valid',
}) async {
  final token = await getBackendToken();

  if (token == null || token.isEmpty) {
    throw Exception(
      'Backend token not found. Please login again.',
    );
  }

  print('==============================================');
  print('CREATING CERTIFICATE');
  print('Verification ID: $verificationId');
  print('Application ID: $applicationId');
  print('Instrument ID: $instrumentId');
  print('==============================================');

  final response = await http.post(
    Uri.parse(
      '$backendBaseUrl/api/certificates',
    ),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'verificationId': verificationId,
      'applicationId': applicationId,
      'instrumentId': instrumentId,
      'certificateType': certificateType,
      'issueDate': issueDate,
      'validUntil': validUntil,
      'status': status,
    }),
  ).timeout(
    const Duration(seconds: 15),
  );

  print(
    'CREATE CERTIFICATE STATUS: ${response.statusCode}',
  );

  print(
    'CREATE CERTIFICATE RESPONSE: ${response.body}',
  );

  if (response.statusCode == 200 ||
      response.statusCode == 201) {
    final data = jsonDecode(response.body);

    if (data['success'] == true) {
      return Map<String, dynamic>.from(data);
    }

    throw Exception(
      data['message'] ??
          'Failed to create certificate',
    );
  }

  try {
    final data = jsonDecode(response.body);

    throw Exception(
      data['message'] ??
          'Failed to create certificate: '
          '${response.statusCode}',
    );
  } catch (_) {
    throw Exception(
      'Failed to create certificate: '
      '${response.statusCode}',
    );
  }
}
}