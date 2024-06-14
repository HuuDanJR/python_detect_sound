import 'package:bingo_game/page/game/right/banner/game.video.dart';
import 'package:bingo_game/socket/socket_manager.dart';
import 'package:flutter/material.dart';

class VideoListPage extends StatefulWidget {
  SocketManager socketManager = SocketManager();
  final double width;
  final double height;
  VideoListPage({
    super.key,
    required this.width,required this.height,
    required this.socketManager,
  });

  @override
  State<VideoListPage> createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  @override
  Widget build(BuildContext context) {
   
    return Container(
        width: widget.width,
        height: widget.height,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          // border: Border(
          //   bottom: BorderSide(width: 1, color: MyColor.grey_tab),
          // ),
        ),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: widget.socketManager.dataStreamVideo,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            } else if (snapshot.hasError) {
              return Text('error ${snapshot.error}');
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
              final filteredData = snapshot.data!
                  .where((item) => item['status'] == true)
                  .toList();
              return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(0),
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    return 
                    GameVideoPlay(
                      width: widget.width,
                      height: widget.height,
                      url: filteredData[index]['video_url'],
                    );

                    // Text('${filteredData[index]['index']}  | ${filteredData[index]['status']} ${filteredData[index]['video_url']}');

                    // GameVideoPlayBlocPage(
                    //     url: filteredData[index]['video_url'],
                    //     width: ConfigFactory.ratio_width_parent( width: width - (StringFactory.padding24 * 2)),
                    //     height: ConfigFactory.ratio_height_child( height: 200) - StringFactory.padding16);
                  });
            }
          },
        ));
  }
}
