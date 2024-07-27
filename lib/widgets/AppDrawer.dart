import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player_app/screens/Login_screen.dart';
import 'package:video_player_app/screens/MyHome_Page.dart';
import 'package:video_player_app/screens/Profile_Screen.dart';

import '../constants.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(100),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              vertical: 30,
            ),
            child: CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(
                profileImage,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: ListTile(
              onTap: () {
                Get.back();
              },
              leading: Icon(Icons.home),
              title: Text(
                "H O M E",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: ListTile(
              onTap: () {
                Get.to(
                  () => const ProfileScreen(),
                  transition: Transition.cupertino,
                );
              },
              leading: Icon(Icons.person),
              title: Text(
                "P R O F I L E",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: ListTile(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Get.off(() => const LoginScreen());
              },
              leading: Icon(Icons.logout),
              title: Text(
                "L O G O U T",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
