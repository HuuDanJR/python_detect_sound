import 'package:bingo_game/public/colors.dart';
import 'package:bingo_game/socket/socket_manager.dart';
import 'package:bingo_game/widget/text.custom.dart';
import 'package:flutter/material.dart';

class DisplayPage extends StatelessWidget {
  SocketManager socketManager = SocketManager();
  Widget? childActive;
  Widget? childUnActive;
  DisplayPage({
    super.key,
    required this.socketManager,
    required this.childActive,
    required this.childUnActive,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: socketManager.dataStreamDisplay,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else if (snapshot.hasError) {
          return textCustom(
              text: 'error ${snapshot.error}', color: MyColor.black_text);
        }
        if (snapshot.data!.isEmpty ||
            snapshot.data == null ||
            snapshot.data == []) {
          return Container();
        } else {
          List<Map<String, dynamic>>? data = snapshot.data;
          if (data == null || data.isEmpty) {
            return Container();
          }

           return data.first['enable'] == true ?  childActive! : childUnActive!;
        }
      },
    );
  }
}
