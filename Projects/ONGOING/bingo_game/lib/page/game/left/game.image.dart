import 'package:bingo_game/page/game/right/export.dart';
import 'package:bingo_game/socket/socket_manager.dart';
import 'package:bingo_game/widget/myprogress_circular.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GameImagePage extends StatefulWidget {
  final double width;
  final double height;
  const GameImagePage({super.key, required this.width, required this.height});

  @override
  State<GameImagePage> createState() => _GameImagePageState();
}

class _GameImagePageState extends State<GameImagePage> {
  late final socketManager = SocketManager();
  @override
  void initState() {
    socketManager.initSocket();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    socketManager.disposeSocket();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width,
        height: widget.height,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: StringFactory.padding24),
        decoration: const BoxDecoration(
          // border: Border(
          //   bottom: BorderSide(width: 1, color: MyColor.grey_tab),
          // ),
          // color:MyColor.grey_tab,
        ),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: SocketManager().dataStream,
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
                    
                        // Text('${filteredData[index]['index']}  | ${filteredData[index]['status']}');
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(StringFactory.padding24),
                      child: CachedNetworkImage(
                        width: widget.width,
                        height: widget.height,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.medium,
                        fadeInCurve: Curves.bounceInOut,
                        alignment: Alignment.center,
                        imageUrl: "${filteredData[index]['image_url']}",
                        placeholder: (context, url) =>  myprogress_circular_size(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    );
                  });
            }
          },
        ));
  }
}
