import 'package:bingo_game/page/game/right/export.dart';
import 'package:bingo_game/socket/socket_manager.dart';
import 'package:bingo_game/widget/myprogress_circular.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GameBanner extends StatelessWidget {
  final double width;
  final double height;
  const GameBanner({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    final SocketManager socketManager = SocketManager();
    return Container(
        width: width,
        // padding: const EdgeInsets.symmetric(horizontal:StringFactory.padding24),
        height: height,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          // border: Border(
          //   top: BorderSide(width: 1, color: MyColor.grey_tab),
          // ),
        ),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: socketManager.dataStreamBanner,
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
                      ClipRRect(
                      borderRadius: BorderRadius.circular(StringFactory.padding42),
                      child: CachedNetworkImage(
                        width: width,
                        height: height,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.medium,
                        fadeInCurve: Curves.bounceInOut,
                        alignment: Alignment.center,
                        imageUrl: "${filteredData[index]['image_url']}",
                        placeholder: (context, url) =>myprogress_circular_size(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    );
                  });
            }
          },
        ));
  }
}
