import 'package:feedback_customer/api/api_service.dart';
import 'package:feedback_customer/main.dart';
import 'package:feedback_customer/pages/feedback/feedback_page.dart';
import 'package:feedback_customer/util/string_custom.dart';
import 'package:feedback_customer/util/string_factory.dart';
import 'package:feedback_customer/widget/buttom_custom.dart';
import 'package:feedback_customer/widget/snackbar_custom.dart';
import 'package:feedback_customer/widget/text_custom.dart';
import 'package:feedback_customer/widget/textfield_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MemberPage extends StatefulWidget {
  final String? statusName;
  const MemberPage({super.key, this.statusName});

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  final serviceAPIs = ServiceAPIs();
  String myString = '';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    debugPrint("INIT MemberPage ${widget.statusName} ");
    super.initState();
  }

  void processAPIs(String value) {
    debugPrint('submitted value: $value ${widget.statusName}');
    if (value.isEmpty) {
      customSnackBar(context: context, message: "Please input customer");
    } else if (isValidNumber(value) == false) {
      customSnackBar(context: context, message: "Input should be number ");
    } else {
      try {
        serviceAPIs.getNationalityByCustomer(value).then((v) {
          if (v.data.isEmpty) {
            customSnackBar(context: context, message: "Can not find customer $value");
          }
          if (v.status == true || v.data.isNotEmpty) {
            MyApp.setLocale(
                context, Locale(translateLanguage(v.data.first.isoCode2)));
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => FeedbackPage(
                      statusName: widget.statusName,
                      userData: v.data.first,
                    )));
          } else {
            customSnackBar( context: context, message: "Can not find customer $value");
          }
        }).whenComplete(() {});
      } catch (e) {
        customSnackBar(
            context: context, message: "Wrong input or an error orcur");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double widthArea = width * 0.7;
    final controllerMembership = TextEditingController();

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
                text: "PLEASE ENTER\nYOUR MEMBERSHIP NUMBER",
                size: StringFactory.padding28,
              ),
              const SizedBox(
                height: StringFactory.padding24,
              ),
              customTextField(
                onTap: () {},
                width: widthArea,
                keyboarType: TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  setState(() {
                    myString = value;
                  });
                },
                onSubmitted: (String value) {
                  // print('onSubmitted value: $value');
                  processAPIs(value);
                },
                height: heightTextField,
                controller: controllerMembership,
                text: '',
              ),
              customPressButton(
                  width: 225.0,
                  text: 'Submit ',
                  padding: StringFactory.padding32,
                  onPress: () {
                    processAPIs(myString);
                    // print('text got: ${myString}');
                  }),
            ],
          ));
    }));
  }
}

String translateLanguage(String isoCodeLanguage) {
  switch (isoCodeLanguage) {
    case USA_ISOCODE:
      return ENGLISH_;
    case KOREA_ISOCODE:
      return KOREA;
    case KOREA_ISOCODE2:
      return KOREA;
    case JAPAN_ISOCODE:
      return JAPAN;
    case China_ISOCODE:
      return CHINA;
    case Taiwan_ISOCODE:
      return CHINA;
    case Hongkong_ISOCODE:
      return CHINA;
    case Macao_ISOCODE:
      return CHINA;
    default:
      return ENGLISH_;
  }
}

bool isValidNumber(String input) {
  final RegExp regExp = RegExp(r'^\d*\.?\d*$');
  return regExp.hasMatch(input);
}
