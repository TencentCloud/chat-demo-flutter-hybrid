import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tim_ui_kit/ui/utils/color.dart';
import 'package:tim_ui_kit/ui/views/TIMUIKitGroupProfile/tim_uikit_group_profile.dart';

class GroupProfile extends StatelessWidget{
  final String groupID;

  const GroupProfile({super.key, required this.groupID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.white,
        title: Text(
          ("Group profile"),
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
      body: TIMUIKitGroupProfile(groupID: groupID),
    );
  }

}