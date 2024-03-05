import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toilet_client/api/my_api_service.dart';
import 'package:toilet_client/getx/my_getx_controller.dart';
import 'package:toilet_client/utils/button_close.dart';
import 'package:toilet_client/utils/dialog_loading.dart';
import 'package:toilet_client/utils/format.factory.dart';
import 'package:toilet_client/utils/mycolors.dart';
import 'package:toilet_client/utils/padding.dart';
import 'package:toilet_client/utils/text.dart';
import 'package:toilet_client/widget/button.dart';

class DialogConfirm extends StatefulWidget {
  String? username;
  String? usernameEn;
  String? image_url;
  int? id_user;
  String? id;
  DialogConfirm(
      {super.key,
      required this.username,
      required this.usernameEn,
      required this.image_url,
      required this.id_user,
      required this.id});

  @override
  State<DialogConfirm> createState() => _DialogConfirmState();
}

class _DialogConfirmState extends State<DialogConfirm> {
  final controller_getx = Get.put(MyGetXController());
  final MyAPIService service_api = MyAPIService();
  final formatString = StringFormat();
  String title = "CONFIRM YOUR WORK";
  String title_vi = "XÁC NHẬN CÔNG VIỆC CỦA BẠN";
  String text = "Your work will saved if you click confirm button below";
  String text_vi = "Nhấn nút 'CONFIRM' để xác nhận,\nẤn nút 'CANCEL' để huỷ bỏ, nó sẽ không được lưu lại";
  bool isVisible = false;
  String buttonText = "CANCEL";

  @override
  void initState() {
    debugPrint("init dialog confirm");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  void autoBackPage(){
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * .35;
    final width = MediaQuery.of(context).size.width * .5;
    
    return Stack(
      children: [
        Container(
          width: width,
          padding: const EdgeInsets.only(
            left: PaddingDefault.padding16,
            right: PaddingDefault.padding16,
            top: PaddingDefault.padding48,
            bottom: PaddingDefault.padding16,
          ),
          decoration: BoxDecoration(
              color: MyColor.white,
              borderRadius: BorderRadius.circular(PaddingDefault.padding32)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              //gridview builder
               text_custom_2line(
                text: title,
                textSecond: title_vi,
                weight: FontWeight.bold,
                size: 22.0),
              const Divider(),
              Row(
                children: [
                  Container(
                    width: 90.0,
                    height: 90.0,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(PaddingDefault.padding16)),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(PaddingDefault.padding16),
                      child: CachedNetworkImage(
                        imageUrl: "${widget.image_url}",
                        placeholder: (context, url) => const SizedBox(
                            width: PaddingDefault.padding16,
                            height: PaddingDefault.padding16,
                            child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.error,
                          color: MyColor.grey_tab,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: PaddingDefault.padding24,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      text_custom(
                          text: widget.usernameEn!.toUpperCase(),
                          size: TextSizeDefault.text18,
                          weight: FontWeight.bold),
                      const SizedBox(
                        height: PaddingDefault.padding04,
                      ),
                      text_custom(
                          text: "Date & Time: ${formatString.formatDateAndTimeFirst(DateTime.now())}",
                          size: TextSizeDefault.text18,
                          weight: FontWeight.w500),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: PaddingDefault.pading12,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      text_custom_2line(text: text,size: 18,textSecond: text_vi),
                      text_custom(
                          text: isVisible ? "✅" : "",
                          color: MyColor.green,
                          size: TextSizeDefault.text24)
                    ],
                  )),
              const SizedBox(
                height: PaddingDefault.pading12,
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buttonColor(
                    color:!isVisible ? MyColor.red:MyColor.green,
                    onPressed: () {
                      debugPrint('click cancel confirmed');
                      // Navigator.of(context).pop();
                      // Navigator.of(context).pop();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    text: buttonText,
                    hasText: isVisible,
                    secondText: "Click OK to finish (Nhấn OK để kết thúc)"
                  ),
                  Visibility(
                    visible: !isVisible,
                    child: buttonColor(
                      color: MyColor.green,
                      onPressed: () {
                        debugPrint('click confirmed');
                        showLoaderDialog(context);
                        try {
                          service_api.createCheckList(
                            title: "Checklist of ${widget.usernameEn}",
                            body:"checklist of ${widget.username} at ${formatString.formatDateAndTimeFirst(DateTime.now())}",
                            username: "${widget.username}",
                            usernameEn: "${widget.usernameEn}",
                            is_finish: true,
                            createAt: DateTime.now().toString(),
                            updateAt: DateTime.now(),
                          ) .whenComplete(() {
                            setState(() {
                              title = "YOUR  WORK HAS BEEN SAVED";
                              title_vi = "CÔNG VIỆC CỦA BẠN ĐÃ ĐƯỢC LƯU LẠI";
                              text ="Your work has been saved  successfully!, Thank you ";
                              text ="Công việc của bạn đã được lưu thành công!";
                              buttonText="OK";
                              isVisible = !isVisible;
                            });
                            Navigator.pop(context);
                            //auto back to main page
                            autoBackPage();
                          });
                        } catch (e) {
                          Navigator.pop(context);
                          autoBackPage();
                        
                        }
                      },
                      text: "CONFIRM",
                    ),
                  )
                ],
              ),
            ],
          ),
        ),

        //TEXT TITLE
        // Positioned(
        //     left: PaddingDefault.padding16,
        //     top: PaddingDefault.pading08,   
        //     bottom: PaddingDefault.pading08,
        //     child: text_custom_2line(
        //         text: "$title",
        //         textSecond: "$title_vi",
        //         weight: FontWeight.bold,
        //         size: TextSizeDefault.text22)),
        //ICON CLOSE
        Positioned(
            top: -2,
            right: -2,
            child: InkWell(
                onTap: () {
                  print('close checklist');
                  Navigator.of(context).pop();
                },
                child: buttonClose())),
      ],
    );
  }
  
}

