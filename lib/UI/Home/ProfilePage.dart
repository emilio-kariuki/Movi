// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:movi/Repository/AuthRepository.dart';
import 'package:movi/Repository/FirebaseRepository.dart';
import 'package:movi/UI/Auth/LoginPage.dart';
import 'package:movi/UI/Home/FavouritesMoviePage.dart';
import 'package:movi/UI/Widget/AuthButton.dart';
import 'package:movi/UI/Widget/SvgContainer.dart';
import 'package:movi/models/UserModel.dart';

enum users { logout, delete }

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black54,
        title: const Text("Profile",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500)),
        actions: [
          PopupMenuButton<users>(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onSelected: (value) async{
              switch (value) {
                case users.logout:
                
                await AuthRepo().logout();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const Login()));
                  break;
                case users.delete:
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            backgroundColor: const Color(0xFF292929),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            title: const Text(
                              "Are you sure you want to delete your account?",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            content: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  AuthButton(
                                    width: 110,
                                    height: 40,
                                    borderRadius: 15,
                                    color: Colors.blue,
                                    text: "Yes",
                                    onPressed: () {
                                      FirebaseRepository().deleteUser(
                                          id: auth.FirebaseAuth.instance
                                              .currentUser!.uid);
                                    },
                                  ),
                                  const Spacer(),
                                  AuthButton(
                                    width: 110,
                                    height: 40,
                                    borderRadius: 15,
                                    color: Colors.blue,
                                    text: "No",
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ));
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<users>>[
              const PopupMenuItem<users>(
                value: users.logout,
                child: Text("Logout"),
              ),
              const PopupMenuItem<users>(
                value: users.delete,
                child: Text("Delete Account"),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: SvgContainer(
                svgPath: 'lib/assets/relax.svg',
                height: 200,
                width: 200,
              ),
            ),
            const SizedBox(height: 40),
            FutureBuilder<User>(
                future: FirebaseRepository()
                    .getUser(id: auth.FirebaseAuth.instance.currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(snapshot.data!.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w500)),
                      Text(snapshot.data!.email,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
                    ],
                  );
                }),
            const SizedBox(height: 40),
            AuthButton(
              text: "Favourite",
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const FavouriteMovies()));
              },
              color: Colors.blue,
              borderRadius: 20,
              height: 50,
              width: 400,
            ),
            const SizedBox(height: 20),
            AuthButton(
              text: "Logout",
              onPressed: () async{
                await AuthRepo().logout();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Login()));
              },
              color: Colors.red,
              borderRadius: 20,
              height: 50,
              width: 400,
            ),
          ],
        ),
      ),
    );
  }
}
