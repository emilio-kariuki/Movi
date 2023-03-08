import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:movi/Repository/FirebaseRepository.dart';
import 'package:movi/Util/SharedPreferencesManager.dart';
import 'package:movi/models/UserModel.dart';

class AuthRepo {
  Future<bool> registerUser(
      {required String email,
      required String password,
      required String name}) async {
    auth.User? user;

    try {
      user = (await auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;

      if (user != null) {
        await SharedPreferenceManager().setLoginStatus(status: true);
        await SharedPreferenceManager().setUserID(userId: user.uid);
        await SharedPreferenceManager().setEmail(email: email);
        await FirebaseRepository().createUser(
          user: User(
            email: email,
            id: user.uid,
            name: name,
            image: "",
            interest: 'movies',
          ),
        );
        return true;
      } else {
        return false;
      }
    } on auth.FirebaseException catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<bool> loginUser(
      {required String email, required String password}) async {
    auth.User? user;
    try {
      user = (await auth.FirebaseAuth.instance.signInWithEmailAndPassword(
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
    } on auth.FirebaseException catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<bool> verifyEmail({required String email}) async {
    auth.User? user;
    try {
      user = (auth.FirebaseAuth.instance.currentUser);
      if (user != null) {
        await user.sendEmailVerification();
        return true;
      } else {
        return false;
      }
    } on auth.FirebaseException catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<bool> resetPassword({required String email}) async {
    try {
      await auth.FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    } on auth.FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> logout() async {
    try {
      await auth.FirebaseAuth.instance.signOut();
      await SharedPreferenceManager().setLoginStatus(status: false);

      return true;
    } on auth.FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }
}
