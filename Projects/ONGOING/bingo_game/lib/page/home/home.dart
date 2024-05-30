import 'package:bingo_game/function/generate.number.dart';
import 'package:bingo_game/widget/text.animate.dart';
import 'package:flutter/material.dart';

import '../../widget/text.custom.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int generate_number = 0;
  List<List<int>> grid = [];

  void generateGrid() {
    setState(() {
      grid =
          generateUniqueRandomGrid(50); // You can set the maxNumber as needed
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = const TextTheme().bodyMedium;
    return Scaffold(
      body: SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  print('generate number');
                  setState(() {
                    generate_number = generateRandomNumber(1, 100);
                  });
                },
                child: const Text('generate number')),
            NumberWidget(
              n: generate_number,
            ),

            
            // grid.isNotEmpty
            //     ? SizedBox(
            //         width: MediaQuery.of(context).size.width,
            //         height: MediaQuery.of(context).size.height / 2,
            //         child: ListView.builder(
            //           itemCount: grid.length,
            //           itemBuilder: (context, index) {
            //             return Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Row(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: grid[index].map((e) => Container(
            //                           width: 50.0,
            //                           alignment: Alignment.center,
            //                           margin: const EdgeInsets.all(4.0),
            //                           padding: const EdgeInsets.all(8.0),
            //                           decoration: BoxDecoration(
            //                             border: Border.all(),
            //                             borderRadius: BorderRadius.circular(8.0),
            //                           ),
            //                           child: Text(
            //                             e.toString(),
            //                             style: TextStyle(fontSize: 16.0),
            //                           ),
            //                         ))
            //                     .toList(),
            //               ),
            //             );
            //           },
            //         ),
            //       )
            // : const SizedBox(height: 0.0,width: 0.0,),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                    icon: const Icon(Icons.gamepad),
                    onPressed: () {
                      debugPrint('start game');
                      generateGrid();
                    },
                    label: textcustom('START GAME', textTheme)),
                TextButton.icon(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      debugPrint('reset game');
                    },
                    label: textcustom('RESET GAME', textTheme)),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
