import 'package:feedback_customer/api/api_service.dart';
import 'package:feedback_customer/model/item.dart';
import 'package:feedback_customer/pages/member/member.dart';
import 'package:feedback_customer/pages/suggestion/suggesstion_item.dart';
import 'package:feedback_customer/util/string_factory.dart';
import 'package:feedback_customer/widget/image_asset_custom.dart';
import 'package:feedback_customer/widget/text_custom.dart';
import 'package:flutter/material.dart';

class SuggestionPage extends StatefulWidget {
  SuggestionPage({super.key, this.item});
  Item? item;

  @override
  State<SuggestionPage> createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  final service_api = ServiceAPIs();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final double spacingHeight = height * 0.08;
    final double itemHeight = height * 0.45;
    final double itemWidth = width * 0.3;
    return Scaffold(body: OrientationBuilder(builder: (context, orientation) {
      return Container(
          alignment: Alignment.center,
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: StringFactory.padding32),
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
              customImageAssetCover(
                  image: 'asset/logo.png', width: 185.0, height: 85.0),
              SizedBox(
                height: spacingHeight,
              ),
              Container(
                width: width,
                alignment: Alignment.center,
                height: itemHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    suggestionItem(onPressed: (){
                      print('onpress item suggestion');
                       Navigator.push(context, MaterialPageRoute(builder: (_)=>const MemberPage(
                        statusName: 'Great!!!',
                       )));
                    }, width: itemWidth,height: itemWidth,assetPath: 'asset/sad.png',text: "Great!!!"),
                    const SizedBox(width: StringFactory.padding32,),
                    suggestionItem(onPressed: (){
                      print('onpress item suggestion');
                    }, width: itemWidth,height: itemWidth,assetPath: 'asset/notbad.png',text: "Grrrrrrr!!!!"),
                  ],
                ),
              ),
              SizedBox(
                height: spacingHeight,
              ),
              textCustomBold(
                text: "PLEASE RATE OUR SERVICE TODAY",
                size: StringFactory.padding28,
              )
            ],
          ));
    }));
  }
}
