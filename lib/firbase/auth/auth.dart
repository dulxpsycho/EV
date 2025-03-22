// firbase/auth/auth.dart
import 'package:firebase_auth/firebase_auth.dart';

String verificationID = '';

class AuthService {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future phoneNumberAuth(String phoneNumber) async {
    firebaseAuth.verifyPhoneNumber(
      phoneNumber: '+91$phoneNumber',
      verificationCompleted: (phoneAuthCredential) async {
        await firebaseAuth.signInWithCredential(phoneAuthCredential);
      },
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (verificationId, forceResendingToken) {
        verificationID = verificationId;
        // loginScrnGetxController.isLoadingFN(isLoad: false);
        // loginScrnGetxController.isOTPAllowFN(isOtpvalue: true);
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  Future otpverify(String oTPCode) async {
    // loginScrnGetxController.isLoadingFN(isLoad: true);
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: oTPCode);
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user != null) {
        // QuerySnapshot? snapshot =
        //     await DataBaseClass(uid: user.uid).gettingUserData();
        // log('${user.email}::${user.phoneNumber}');
        // if (snapshot == null) {
        //   await DataBaseClass(uid: user.uid).saveUserdata(
        //       phoneNumber: user.phoneNumber!, email: user.email ?? '');
        //   sharedController.saveUserUIDStatus(user.uid);
        //   Get.offAll(() => const DashboardScrn());
        //   loginScrnGetxController.isLoadingFN(isLoad: false);
        // } else {
        //   sharedController.saveUserUIDStatus(user.uid);
        //   loginScrnGetxController.isLoadingFN(isLoad: false);
        //   Get.offAll(() => const DashboardScrn());
        // }
      }
    } catch (e) {
      // loginScrnGetxController.isLoadingFN(isLoad: false);
      // controller.showSnackBar(
      //     title: 'OTP is Incorrect',
      //     content: e.toString(),
      //     errorcolor: colorRed);
    }
  }
}
