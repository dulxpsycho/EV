// firbase/auth/auth.dart
import 'package:ev_/core/helper/shared_preference.dart';
import 'package:ev_/firbase/db/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ev_/model/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:ev_/notification/notification.dart';

class AuthServices {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // ✅ Email & Password Authentication

  /// Register User with Email & Password
  Future<bool> registerWithEmailAndPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        UserModel userModel = UserModel(email: email);
        await DataBaseHandler(uid: user.uid).saveUserData(userModel);
        await NotificationHandler.snakBarSuccess(
            message: 'Account created successfully! 🎉', context: context);
        return true;
      } else {
        await NotificationHandler.snakBarWarning(
            message: 'Registration failed! Try again. 😖', context: context);
        return false;
      }
    } catch (e) {
      await NotificationHandler.snakBarError(
          message: 'Error: ${e.toString()}', context: context);
      return false;
    }
  }

  /// Login User with Email & Password
  Future<bool> loginWithEmailAndPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      await SharedPreference.setLoggedIn(true);
      await SharedPreference.saveUID(user?.uid ?? '');
      if (user != null) {
        await NotificationHandler.snakBarSuccess(
            message: 'Login successful! 👋😎', context: context);

        return true;
      } else {
        await NotificationHandler.snakBarError(
            message: 'Login failed! Try again. 😖', context: context);
        return false;
      }
    } catch (e) {
      await NotificationHandler.snakBarError(
          message: 'Login error: ${e.toString()}', context: context);
      return false;
    }
  }

  /// Sign Out User
  Future<void> signOut(BuildContext context) async {
    try {
      await firebaseAuth.signOut();
      await NotificationHandler.snakBarSuccess(
          message: 'Signed out successfully! 👋', context: context);
    } catch (e) {
      await NotificationHandler.snakBarError(
          message: 'Sign out error: ${e.toString()}', context: context);
    }
  }

  /// Check if User is Logged In
  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }
}
