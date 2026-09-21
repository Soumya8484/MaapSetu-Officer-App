// import 'package:cloud_firestore/cloud_firestore.dart';

// class AssignmentService {
//   final FirebaseFirestore _firestore =
//       FirebaseFirestore.instance;

//   Stream<QuerySnapshot> getMyAssignments(
//     String officerId,
//   ) {
//     return _firestore
//         .collection('assignments')
//         .where(
//           'officerId',
//           isEqualTo: officerId,
//         )
//         .snapshots();
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class AssignmentService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> createTestAssignment({
    required String officerId,
  }) async {
    await _firestore.collection('assignments').add({
      'applicationId': 'LM00125',
      'businessName': 'ABC Traders',
      'instrumentId': 'WM12345',
      'instrumentType': 'Digital Weighing Machine',
      'status': 'SCHEDULED',
      'scheduledDate': Timestamp.fromDate(
        DateTime.now().add(const Duration(days: 1)),
      ),
      'officerId': officerId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}