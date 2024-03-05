import 'package:flutter/material.dart';
import 'package:toilet_client/firebase/controller.dart';
import 'package:toilet_client/widget/item.dart';

class BodyToiletPage extends StatelessWidget {
  BodyToiletPage({super.key});
  final FirebaseDataController _firebaseDataController = FirebaseDataController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    const double heightItem = 135.0;
    const double widthItem = 165.0;
    const double paddingItem = 34.0;
    const double padding08 = 8.0;
    return StreamBuilder<Map<String, dynamic>>(
      stream: _firebaseDataController.dataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final data = snapshot.data!;
          // print('$data');
          final onOffMen2Value = data['OnOffMen2'];
          final onOffMen1Value = data['OnOffMen1'];
          final onOffWomanValue = data['OnOffWoman'];
          final temp = data['Temp'];
          final hum = data['Hum'];
          //LOGIN => false mean AVAILABLE and true mean UN-AVAILABLE

          return Stack(
            alignment: Alignment.center,
            children: [
              mainItem(
                  isUseMen1: onOffMen1Value == 1
                      ? false
                      : onOffMen1Value == 0
                          ? true
                          : null,
                  isUseMen2: onOffMen2Value == 1
                      ? false
                      : onOffMen2Value == 0
                          ? true
                          : null,
                  isUseWoman1: onOffWomanValue == 1
                      ? false
                      : onOffWomanValue == 0
                          ? true
                          : null,
                  width: width,
                  height: height,
                  height_item: heightItem,
                  width_item: widthItem,
                  padding_item: paddingItem),
              GestureDetector(
                onTap: () {
                  // print('move');
                  // navigatorKey.currentState?.pushNamed(NotificationScreen.route, arguments: null);
                },
                child: tempItem(
                    height: height,
                    width: 125.0,
                    humid: hum == null ? '30' : '$hum',
                    tempurature: temp == null ? '50' : '$temp'),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return const Text('An error occurred');
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
