import 'dart:developer';

import 'package:feedback_customer/api/api_service.dart';
import 'package:feedback_customer/model/nationality.dart';
import 'package:feedback_customer/pages/result.dart';
import 'package:feedback_customer/pages/staff/bloc/staff_bloc.dart';
import 'package:feedback_customer/pages/staff/staff_page.dart';
import 'package:feedback_customer/util/language_service.dart';
import 'package:feedback_customer/util/string_factory.dart';
import 'package:feedback_customer/widget/buttom_custom.dart';
import 'package:feedback_customer/widget/loading_dialog.dart';
import 'package:feedback_customer/widget/text_custom.dart';
import 'package:feedback_customer/widget/textfield_custom.dart';
import 'package:flutter/material.dart';

class NotePage extends StatefulWidget {
  final String? statusName;
  final NatinalityDatum? userData;
  final bool hasNote;
  final List<String> listExp;
  const NotePage(
      {super.key,
      required this.statusName,
      required this.userData,
      required this.listExp,
      required this.hasNote,
      });

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final controllerNote = TextEditingController();
  final serviceAPIs = ServiceAPIs();
  String myString = '';



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double widthArea = width * 0.7;
    final double heightTextField = height * 0.16;
    return Scaffold(body: OrientationBuilder(builder: (context, orientation) {
      return Container(
          alignment: Alignment.center,
          height: height,
          padding:
              const EdgeInsets.symmetric(horizontal: StringFactory.padding32),
          width: width,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'asset/background.jpeg',
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
                text: translation(context).write_down,
                size: StringFactory.padding28,
              ),
              const SizedBox(
                height: StringFactory.padding24,
              ),
              customTextField(
                  onTap: () {},
                  width: widthArea,
                  onChanged: (value) {
                    setState(() {
                      myString = value;
                    });
                  },
                  onSubmitted: (value) {
                    debugPrint('submitted note  value: $value');
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (_) => StaffPage(
                    //           userData: widget.userData,
                    //           note: value,
                    //           listExp: widget.listExp,
                    //           hasNote: widget.hasNote,
                    //           statusName: widget.statusName,
                    //         )));
                  },
                  height: heightTextField,
                  controller: controllerNote,
                  text: '',
                  keyboarType: TextInputType.text),
              customPressButton(
                  width: 225.0,
                  text: translation(context).submit,
                  padding: StringFactory.padding28,
                  onPress: () {
                    // debugPrint('submit something:  $myString ${widget.hasNote} ${widget.statusName} ${widget.listExp} ${widget.userData?.number}');
                    runFeedbackAPIs(context: context,note: myString,serviceAPIs: serviceAPIs,listExp: widget.listExp);
                  }),
            ],
          ));
    }));
  }
  void runFeedbackAPIs(
      {
      required context,
      required String? note,
      required List<String> listExp,
      required ServiceAPIs serviceAPIs}) async {
    showLoadingDialog(context);
    try {
      await serviceAPIs.createFeedBackV2(
              statusName: widget.statusName.toString(),
              customerNumber: '${widget.userData!.number}',
              customerName:'${widget.userData!.title} ${widget.userData!.preferredName}',
              customerCode: '',
              customerNatinality: '${widget.userData!.nationality} ${widget.userData!.isoCode2}',
              note: note!,
              hasNote: 'true',
              service_good: listExp,
              service_bad: listExp,
              staffNameEn:"empty",
              staffName:"empty",
              staffCode:"empty",
              staffRole:"empty",
              tag: 'PRODUCTION')
          .then((v) {
        if (v.status = true) {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ResultPage()));
        } else {

        }
      }).whenComplete(() {});
    } catch (e) {
      hideLoadingDialog(context);
    }
  }
}
