import 'package:feedback_customer/pages/feedback/feedbackbad_page.dart';
import 'package:feedback_customer/util/string_factory.dart';
import 'package:feedback_customer/widget/buttom_custom.dart';
import 'package:feedback_customer/widget/text_custom.dart';
import 'package:feedback_customer/widget/textfield_custom.dart';
import 'package:flutter/material.dart';

class MemberPage extends StatefulWidget {
  final String? statusName;
  const MemberPage({super.key, this.statusName});

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  final controllerMembership = TextEditingController();
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
    final double widthArea = width * 0.7;

    final double heightTextField = height * 0.2;
    return Scaffold(body: OrientationBuilder(builder: (context, orientation) {
      return Container(
          alignment: Alignment.center,
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
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
                text: "PLEASE ENTER\nYOUR MEMBERSHIP NUMBER",
                size: StringFactory.padding28,
              ),
              const SizedBox(
                height: StringFactory.padding24,
              ),
              customTextField(
                  width: widthArea,
                  onChanged: (value){},
                  onSubmitted: (value) {
                    print('submitted value: $value ${widget.statusName}');
                    // Navigator.of(context).push(MaterialPageRoute(builder: (_)=>FeedbackBadPage()));
                  },
                  height: heightTextField,
                  controller: controllerMembership,
                  text: '',
                  keyboarType: TextInputType.number),
               customPressButton(
                              width: 225.0,
                              text: 'Submit ',
                              padding: StringFactory.padding32,
                              onPress: () { 
                                Navigator.of(context).push(MaterialPageRoute(builder: (_)=>FeedbackBadPage()));
                               }),   
            ],
          ));
    }));
  }
}
