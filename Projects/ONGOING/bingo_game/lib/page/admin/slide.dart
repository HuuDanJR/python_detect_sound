import 'package:bingo_game/public/colors.dart';
import 'package:bingo_game/socket/socket_manager.dart';
import 'package:bingo_game/widget/myprogress_circular.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SlidePage extends StatefulWidget {
  SocketManager socketManager = SocketManager();
  SlidePage({super.key, required this.socketManager,});

  @override
  State<SlidePage> createState() => _SlidePageState();
}

class _SlidePageState extends State<SlidePage> {
  @override
  Widget build(BuildContext context) {
     final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height/5;
    return Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: MyColor.grey_tab),
          ),
        ),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: widget.socketManager.dataStream,
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
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(0),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        print('click index${data[index]['index']}');
                        widget.socketManager.eventChangeSlide(int.parse(data[index]['index'].toString()));
                        
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width:data[index]['status'] ==true? 4:0,color: data[index]['status'] ==true? MyColor.green : Colors.transparent
                          )
                        ),
                        child: CachedNetworkImage(
                          filterQuality: FilterQuality.medium,
                          fadeInCurve: Curves.bounceInOut,
                          alignment: Alignment.center,
                          height: height,
                          imageUrl: "${data[index]['image_url']}",
                          placeholder: (context, url) => myprogress_circular_size(),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                    );
                    // Text('${data[index]['index']}  | ${data[index]['status']}');
                  });
            }
          },
        ));
  }
}
