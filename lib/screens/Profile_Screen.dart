import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player_app/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(
                  profileImage,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("AMAL K A"),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("amallkanill@gmail.com"),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("9778203906"),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text("LOGOUT"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
