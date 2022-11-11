import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tim_ui_kit/tim_ui_kit.dart';
import 'package:tim_ui_kit/ui/utils/color.dart';

class UserProfile extends StatelessWidget{
  final String userID;

  const UserProfile({super.key, required this.userID});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.white,
        title: Text(
          ("Profile"),
          style: TextStyle(color: hexToColor("1f2329"), fontSize: 17),
        ),
        backgroundColor: hexToColor("f2f3f5"),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        leading: IconButton(
          padding: const EdgeInsets.only(left: 16),
          icon: Icon(
            Icons.arrow_back_ios,
            color:
            hexToColor("2a2e35"),
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: TIMUIKitProfile(userID: userID),
    );
  }

}