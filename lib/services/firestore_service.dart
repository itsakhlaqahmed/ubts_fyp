import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:ubts_fyp/widgets/custom_snackbar.dart';

class FirestoreService {
  FirestoreService();

  final _firestore = FirebaseFirestore.instance;
  final String _userCollection = 'users';

  Future<void> addUserData({
    required String id,
    required Map<String, dynamic> userData,
  }) async {
    await _firestore.collection(_userCollection).doc(id).set(userData);
    // handle on success here
  }

  Future<Map<String, dynamic>?> getUserData({required String userId}) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection(_userCollection).doc(userId).get();
    return snapshot.data();
  }
}
