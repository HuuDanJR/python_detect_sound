import 'package:feedback_customer/getx/getx_controller.dart';
import 'package:feedback_customer/main.dart';
import 'package:feedback_customer/util/color_custom.dart';
import 'package:feedback_customer/util/language_service.dart';
import 'package:feedback_customer/util/string_custom.dart';
import 'package:feedback_customer/util/string_factory.dart';
import 'package:feedback_customer/widget/buttom_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({
    super.key,
  });

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final controllerGetx = Get.put(MyGetXController());
  final _formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    debugPrint('INIT RESULT PAGE');
    controllerGetx.startCountdownTimerResultPage();
    super.initState();
  }

  @override
  void dispose() {
    controllerGetx.cancelResetAllTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    const double widthItem = 200.0;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(
            vertical: StringFactory.padding32,
            horizontal: StringFactory.padding16),
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            filterQuality: FilterQuality.low,
            image: AssetImage('asset/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 135.0,
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(StringFactory.padding),
                    width: 95.0,
                    height: 95.0,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: MyColor.grey_tab, width: 1),
                        borderRadius: BorderRadius.circular(95.0)),
                    child: Image.asset('asset/heart.png'),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16.0),
                width: widthItem,
                height: widthItem,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: MyColor.grey_tab, width: 1),
                    borderRadius: BorderRadius.circular(150.0)),
                child: Image.asset('asset/heart.png'),
              ),
              const SizedBox(height: StringFactory.padding32),
              SizedBox(
                width: width * 2 / 3,
                child: Text(
                  translation(context).thank_you,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: StringFactory.padding22,
                      fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: StringFactory.padding48),
              // customPressButton(
              //     width: 250.0,
              //     text: 'Back Home ',
              //     padding: 32.0,
              //     onPress: () async {
              //       controllerGetx.cancelResetAllTimer();
              //       MyApp.setLocale(context, const Locale(ENGLISH_));
              //       await Navigator.of(context).pushNamedAndRemoveUntil(
              //         '/suggestion',
              //         (Route<dynamic> route) => false,
              //       );
              //     }),
              const SizedBox(
                height: StringFactory.padding24,
              ),
              Obx(
                () => Text(
                  '${translation(context).auto_back_home} ${controllerGetx.valueAwaitResult.value}s',
                  style: const TextStyle(
                      fontSize: StringFactory.padding24,
                      fontWeight: FontWeight.w700),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
