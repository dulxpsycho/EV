// firbase/db/db.dart
import 'package:ev_/model/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseHandler {
  final String uid;
  DataBaseHandler({required this.uid});
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  Future<String> saveUserData(UserModel userModel) async {
    try {
      userModel = userModel.copyWith(id: uid);
      await userCollection.doc(uid).set(userModel.toMap());
      return 'success';
    } on FirebaseException catch (e) {
      return 'Firebase error: ${e.message}';
    } catch (e) {
      return e.toString();
    }
  }
}
