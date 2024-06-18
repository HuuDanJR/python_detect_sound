import 'package:feedback_customer/getx/getx_controller.dart';
import 'package:feedback_customer/util/color_custom.dart';
import 'package:feedback_customer/util/string_custom.dart';
import 'package:feedback_customer/widget/buttom_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    print('INIT RESULT PAGE');
    controllerGetx.startCountdownTimerResultPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
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
                    padding: const EdgeInsets.all(8.0),
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
                width: 200.0,
                height: 200.0,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: MyColor.grey_tab, width: 1),
                    borderRadius: BorderRadius.circular(150.0)),
                child: Image.asset('asset/heart.png'),
              ),
              const SizedBox(height: 32.0),
              SizedBox(
                width: width * 2 / 3,
                child: const Text(
                  resultgood,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 46.0),
              customPressButton(
                  width: 250.0,
                  text: 'Back Home ',
                  padding: 32.0,
                  onPress: () {
                    controllerGetx.cancelResetAllTimer();
                    Navigator.of(context).popAndPushNamed('/home');
                  }),
              const SizedBox(
                height: 24.0,
              ),
              Obx(
                () => Text(
                  'Auto back home after ${controllerGetx.valueAwaitResult.value}s',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
