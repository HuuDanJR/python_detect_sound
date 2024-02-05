import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toilet_client/api/my_api_service.dart';
import 'package:toilet_client/getx/my_getx_controller.dart';
import 'package:toilet_client/model/user_model.dart';
import 'package:toilet_client/utils/button_close.dart';
import 'package:toilet_client/utils/button_deboucer.dart';
import 'package:toilet_client/utils/dialog_confirm.dart';
import 'package:toilet_client/utils/mycolors.dart';
import 'package:toilet_client/utils/padding.dart';
import 'package:toilet_client/utils/text.dart';

class DialogCheckList extends StatefulWidget {
  const DialogCheckList({super.key});

  @override
  State<DialogCheckList> createState() => _DialogCheckListState();
}

class _DialogCheckListState extends State<DialogCheckList> {
  final controller_getx = Get.put(MyGetXController());
  final MyAPIService service_api = MyAPIService();
  bool isShowDialog = false;
  final double width_item = 117.5;

  @override
  void initState() {
    debugPrint("init dialog checklist");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          width: width * .825,
          height: height * .7,
          decoration: BoxDecoration(
              color: MyColor.white,
              borderRadius: BorderRadius.circular(PaddingDefault.padding32)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //gridview builder
              Container(
                height: height * .6,
                width: width * .825,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(PaddingDefault.padding16),
                ),
                child: FutureBuilder(
                  future: service_api.listUsers(),
                  builder: (context, snapshot) {
                    late UserModel model = snapshot.data as UserModel;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError ||
                        model.data == null ||
                        model == null) {
                      return Center(child: text_custom(text: "An error orcur"));
                    }

                    return GridView.builder(
                      shrinkWrap: false,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: PaddingDefault.padding24,
                        vertical: PaddingDefault.pading12,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4, // 2 columns
                              crossAxisSpacing: PaddingDefault.padding16,
                              mainAxisSpacing: PaddingDefault.padding16,
                              childAspectRatio: 1.25),
                      itemCount: model.data.length,
                      itemBuilder: (context, index) {
                        // var item = controller_getx.items[index];
                        return GestureDetector(
                            onTap: () {
                              print('ontap checklist $index');
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: DialogConfirm(
                                      image_url: model.data[index].imageUrl,
                                      username: model.data[index].username,
                                      usernameEn: model.data[index].usernameEn,
                                      id_user: model.data[index].idUser,
                                      id: model.data[index].id,
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(
                                  PaddingDefault.padding04),
                              decoration: BoxDecoration(
                                  color: MyColor.bedgeLight,
                                  borderRadius: BorderRadius.circular(
                                      PaddingDefault.padding24),
                                  border: Border.all(
                                      color: MyColor.black_text, width: 1)),
                              child: Column(
                                children: [
                                  Container(
                                    height: width_item,
                                    width: width_item,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(width_item),
                                      child: CachedNetworkImage(
                                        imageUrl:"${model.data[index].imageUrl}",
                                        placeholder: (context, url) => SizedBox(
                                            width: PaddingDefault.padding16,
                                            height: PaddingDefault.padding16,
                                            child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            new Icon(
                                          Icons.error,
                                          color: MyColor.grey_tab,
                                        ),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: MyColor.white,
                                      border: Border.all(
                                        color: MyColor.yellow_accent,
                                      ),
                                      shape: BoxShape.circle,
                                      // image: DecorationImage(
                                      //     image: NetworkImage(
                                      //       '${model.data[index].imageUrl}',
                                      //       scale: 1,
                                      //     ),
                                      //     fit: BoxFit.cover,
                                      //     filterQuality: FilterQuality.low)
                                    ),
                                  ),
                                  text_custom(
                                      text:
                                          "${model.data[index].usernameEn!.toUpperCase()}",
                                      weight: FontWeight.bold,
                                      size: TextSizeDefault.text18),
                                  text_custom(
                                      text: "${model.data[index].username!}",
                                      weight: FontWeight.normal,
                                      size: TextSizeDefault.text16)
                                ],
                              ),
                            ));
                      },
                    );
                  },
                ),
              ),
              const SizedBox(
                height: PaddingDefault.pading08,
              ),
            ],
          ),
        ),

        //TEXT TITLE
        Positioned(
            left: PaddingDefault.padding16,
            top: PaddingDefault.pading08,
            child: text_custom(
                text: "CHECKLIST FOR STAFF",
                // textSecond: "DANH SÁCH NHÂN VIÊN",
                color: MyColor.black_text,
                weight: FontWeight.bold,
                size: TextSizeDefault.text24)),
        //ICON CLOSE
        Positioned(
            top: -1,
            right: -1,
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
