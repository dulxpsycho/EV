// firebase/auth/auth.dart
import 'package:ev_/firbase/db/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ev_/model/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:ev_/notification/notification.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _verificationId = '';

  Future<void> phoneNumberAuth(
    String phoneNumber,
    Function(bool) updateLoading,
    Function(bool) updateOtpAllowed,
    BuildContext context,
  ) async {
    try {
      updateLoading(true);

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification completed (usually on Android)
          bool success = await _signInWithCredential(credential, context);
          if (success && context.mounted) {
            await NotificationHandler.snakBarSuccess(
                message: 'Authentication successful 👋😎', context: context);
          }
          updateLoading(false);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (context.mounted) {
            NotificationHandler.snakBarWarning(
                message: '${e.message} 😖', context: context);
          }
          updateLoading(false);
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          updateLoading(false);
          updateOtpAllowed(true);
          if (context.mounted) {
            NotificationHandler.snakBarSuccess(
                message: 'OTP sent successfully 👋😎', context: context);
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      updateLoading(false);
      if (context.mounted) {
        NotificationHandler.snakBarWarning(
            message: 'Error sending OTP: $e 😖', context: context);
      }
    }
  }

  Future<bool> verifyOtp(
    String otpCode,
    Function(bool) updateLoading,
    BuildContext context,
  ) async {
    try {
      updateLoading(true);

      if (_verificationId.isEmpty) {
        updateLoading(false);
        if (context.mounted) {
          NotificationHandler.snakBarWarning(
              message: 'Verification session expired. Please try again 😖',
              context: context);
        }
        return false;
      }

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otpCode,
      );

      return await _signInWithCredential(credential, context);
    } catch (e) {
      updateLoading(false);
      if (context.mounted) {
        NotificationHandler.snakBarWarning(
            message: 'OTP verification failed: $e 😖', context: context);
      }
      return false;
    }
  }

  Future<bool> _signInWithCredential(
      PhoneAuthCredential credential, BuildContext context) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        UserModel userModel = UserModel(phonenumber: user.phoneNumber ?? '');
        await DataBaseHandler(uid: user.uid).saveUserData(userModel);

        if (context.mounted) {
          NotificationHandler.snakBarSuccess(
              message: 'Account authenticated successfully 👋😎',
              context: context);
        }
        return true;
      }

      if (context.mounted) {
        NotificationHandler.snakBarWarning(
            message: 'Authentication failed: user is null 😖',
            context: context);
      }
      return false;
    } catch (e) {
      if (context.mounted) {
        NotificationHandler.snakBarWarning(
            message: 'Authentication failed: ${e.toString()} 😖',
            context: context);
      }
      throw Exception('Sign-in failed: $e');
    }
  }
}
