// firbase/auth/auth.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ev_/model/usermodel.dart';
import 'package:ev_/firbase/db/db.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _verificationId = '';

  Future<void> phoneNumberAuth(
    String phoneNumber,
    Function(bool) updateLoading,
    Function(bool) updateOtpAllowed,
    Function(String) onError,
  ) async {
    try {
      updateLoading(true);

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification completed (usually on Android)
          await _signInWithCredential(credential);
          updateLoading(false);
        },
        verificationFailed: (FirebaseAuthException e) {
          updateLoading(false);
          onError('Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          updateLoading(false);
          updateOtpAllowed(true);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      updateLoading(false);
      onError('Error sending OTP: $e');
    }
  }

  Future<bool> verifyOtp(
    String otpCode,
    Function(bool) updateLoading,
    Function(String) onError,
  ) async {
    try {
      updateLoading(true);

      if (_verificationId.isEmpty) {
        updateLoading(false);
        onError('Verification session expired. Please try again.');
        return false;
      }

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otpCode,
      );

      return await _signInWithCredential(credential);
    } catch (e) {
      updateLoading(false);
      onError('OTP verification failed: $e');
      return false;
    }
  }

  Future<bool> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        UserModel userModel = UserModel(phonenumber: user.phoneNumber ?? '');
        await DataBaseHandler(uid: user.uid).saveUserData(userModel);
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Sign-in failed: $e');
    }
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
