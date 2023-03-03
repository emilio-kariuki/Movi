import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movistar/Util/SharedPreferencesManager.dart';

class AuthRepo {
  Future<bool> registerUser(
      {required String email, required String password}) async {
    User? user;

    try {
      user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;

      if (user != null) {
        await SharedPreferenceManager().setLoginStatus(status: true);
        await SharedPreferenceManager().setUserID(userId: user.uid);
        await SharedPreferenceManager().setEmail(email: email);
        return true;
      } else {
        return false;
      }
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<bool> loginUser(
      {required String email, required String password}) async {
    User? user;
    try {
      user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;

      if (user != null) {
        await SharedPreferenceManager().setLoginStatus(status: true);
        await SharedPreferenceManager().setUserID(userId: user.uid);
        await SharedPreferenceManager().setEmail(email: email);

        return true;
      } else {
        return false;
      }
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<bool> verifyEmail({required String email}) async {
    User? user;
    try {
      user = (FirebaseAuth.instance.currentUser);
      if (user != null) {
        await user.sendEmailVerification();
        return true;
      } else {
        return false;
      }
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<bool> resetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      await SharedPreferenceManager().setLoginStatus(status: false);

      return true;
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }
}
