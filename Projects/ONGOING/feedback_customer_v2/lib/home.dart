import 'package:feedback_customer/feedback.dart';
import 'package:feedback_customer/model/item.dart';
import 'package:feedback_customer/util/color_custom.dart';
import 'package:feedback_customer/widget/image_asset_custom.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Item> item = [
    Item(id: 1, name: 'Grrrrrrr!!!!', image: 'asset/angry.png'),
    Item(id: 2, name: 'Hmmm?', image: 'asset/sad.png'),
    Item(id: 3, name: 'Okey!!!', image: 'asset/notbad.png'),
    Item(id: 4, name: 'Yeah!!!', image: 'asset/sacrify.png'),
  ];



  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Container(
              alignment: Alignment.center,
              height: height,
              padding: const EdgeInsets.symmetric(horizontal:32.0),
              width: width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'asset/background.jpg',
                    ),
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.low),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: width,
                    height: height / 6,
                    child: Center(
                      child: RichText(
                        text:  const TextSpan(
                          text: 'HOW IS ',
                          style:TextStyle(
                              fontSize: 46.0,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'YOUR DAY?',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 46.0 ,
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(color: Colors.transparent),
                  Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: item.length,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(32.0),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: MyColor.yellow_gradient1,
                              onTap: () {
                                // Navigator.of(context).pushNamed('/feedback');
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>FeedbackPage(
                                  item: item[index],
                                )));
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(24.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(.1),
                                    borderRadius: BorderRadius.circular(32.0),
                                  ),
                                  child: customImageAssetText(
                                      width: width,
                                      height: height,
                                      image: item[index].image,
                                      text: item[index].name)),
                            ),
                          ),
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio:orientation == Orientation.portrait ? 1 : 1.75,
                          mainAxisSpacing: 16.0,
                          crossAxisSpacing: 16.0),
                    ),
                  )
                ],
              ));
        },
      ),
    );
  }
}
