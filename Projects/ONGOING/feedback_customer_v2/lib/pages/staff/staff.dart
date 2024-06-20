import 'package:feedback_customer/model/item.dart';
import 'package:feedback_customer/pages/result.dart';
import 'package:feedback_customer/pages/staff/staff_search.dart';
import 'package:feedback_customer/util/string_factory.dart';
import 'package:feedback_customer/widget/buttom_custom.dart';
import 'package:feedback_customer/widget/text_custom.dart';
import 'package:flutter/material.dart';

class StaffPage extends StatefulWidget {
  StaffPage({super.key, this.item});
  Item? item;

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  final controllerNote = TextEditingController();
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
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double widthArea = width * 0.65;

    final double heightTextField = height * 0.175;
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
            mainAxisSize: MainAxisSize.min,
            children: [
              textCustomBold(
                isAlignCenter: true,
                text: "Did any staff members\nleave a memorable impression?",
                size: StringFactory.padding28,
              ),
              const SizedBox(
                height: StringFactory.padding24,
              ),
              Center(child: StaffSearch(
                widthArea: widthArea,
                heightTextField: heightTextField,
              )),
              customPressButton(
                              width: 225.0,
                              text: 'Submit ',
                              padding: StringFactory.padding32,
                              onPress: () {  
                                Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const ResultPage()));
                              }),   
                  
            ],
          ));
    }));
  }
}
