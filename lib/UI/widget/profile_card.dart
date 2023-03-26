import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movi/UI/home/profile_page.dart';
import 'package:movi/util/responsive.dart';

enum user { profile, logout }

class ProfileCard extends StatelessWidget {
  final String name;
  final String image;
  ProfileCard({
    super.key,
    required this.name,
    required this.image,
  });

  final secondaryColor = Color(0xFF292929);
  final bgColor = Color(0xFF212121);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const ProfilePage()));
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            CachedNetworkImage(
              height: 35,
              width: 35,
              imageUrl: image,
              fit: BoxFit.cover,
              imageBuilder: (context, imageProvider) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
              placeholder: (context, url) => const CircularProgressIndicator(
                strokeWidth: 1,
              ),
              errorWidget: (context, url, error) => const Icon(
                Icons.error,
                size: 20,
                color: Colors.red,
              ),
            ),
            if (!Responsive.isMobile(context))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10 / 2),
                child: Text(
                  name,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            PopupMenuButton<user>(
              offset: const Offset(15, 40),
              color: bgColor,
              onSelected: (value) {
                switch (value) {
                  case user.profile:
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ProfilePage()));
                    break;
                  case user.logout:
                    break;
                }
              },
              child: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 20,
              ),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: user.profile,
                  child: Text(
                    "Profile",
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
                const PopupMenuItem(
                  value: user.logout,
                  child: Text(
                    "Logout",
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
