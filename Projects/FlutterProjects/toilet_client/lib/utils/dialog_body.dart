// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
// import 'package:toilet_client/getx/my_getx_controller.dart';
// import 'package:toilet_client/utils/mycolors.dart';
// import 'package:toilet_client/utils/padding.dart';
// import 'package:toilet_client/utils/text.dart';
// import 'package:toilet_client/widget/button_custom.dart';

// Widget dialogBody({height, width, MyGetXController? controller_getx}) {
//   final _debouncer = Debouncer(delay: Duration(seconds: 1));

//   return Container(
//     width: width * .825,
//     height: height * .725,
//     decoration: BoxDecoration(
//         color: MyColor.white, borderRadius: BorderRadius.circular(45)),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         //gridview builder
//         Container(
//           height: height * .555,
//           // height: height * .555,
//           width: width * .725,
//           decoration: BoxDecoration(
//             color: MyColor.bedge,
//             borderRadius: BorderRadius.circular(PaddingDefault.padding24),
//           ),
//           child: GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             padding: const EdgeInsets.all(PaddingDefault.padding24),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 4, // 2 columns
//                 crossAxisSpacing: PaddingDefault.padding24,
//                 mainAxisSpacing: PaddingDefault.padding24,
//                 childAspectRatio: 1),
//             itemCount: controller_getx!.items.length,
//             itemBuilder: (context, index) {
//               var item = controller_getx.items[index];
//               return GestureDetector(
//                   onTap: () {
//                     print('ontap $index ${controller_getx.items[index].name} ${controller_getx.items[index].isSelect} ');
//                     // controller_getx.toggleSelection(index);
//                   },
//                   child: Column(
//                     children: [
//                       Obx(
//                         () => Container(
//                           padding:
//                               const EdgeInsets.all(PaddingDefault.padding24),
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(
//                                   PaddingDefault.padding24),
//                               border: Border.all(
//                                   color:
//                                       controller_getx.items[index].isSelect ==
//                                               true
//                                           ? MyColor.purpleBG
//                                           : MyColor.black_text,
//                                   width:
//                                       controller_getx.items[index].isSelect ==
//                                               true
//                                           ? 5
//                                           : 1)),
//                           child: Container(
//                             height: 85.0,
//                             width: 85.0,
//                             decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                     image: AssetImage(
//                                         controller_getx.items[index].image),
//                                     fit: BoxFit.contain,
//                                     filterQuality: FilterQuality.high)),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: PaddingDefault.pading08,
//                       ),
//                       text_custom(
//                           text: controller_getx.items[index].name,
//                           size: TextSizeDefault.text16,
//                           weight: FontWeight.w500)
//                     ],
//                   ));
//             },
//           ),
//         ),
//         const SizedBox(
//           height: 25.0,
//         ),
//         GetBuilder<MyGetXController>(
//           builder: (controller) {
//             return customPressButton(
//               padding: PaddingDefault.padding24,
//               width: 175.0,
//               onPress: () {
//                 // controller_getx.turnOff();
//                 // controller.resetForm();
//                 print('click submit');
//                 print( 'content: ${controller.selectedItemNames.value.toString()}');
//                 print('star: ${controller.starCount.value}');
                
//               },
//               child: text_custom(
//                   text: 'SUBMIT',
//                   size: TextSizeDefault.text28,
//                   weight: FontWeight.bold,
//                   color: MyColor.white),
//             );
//           },
//         ),
//         const SizedBox(
//           height: PaddingDefault.pading12,
//         ),
//         Obx(() => text_custom(
//             text:
//                 'Auto submit after ${controller_getx.count.value} seconds without action',
//             size: TextSizeDefault.text18,
//             color: MyColor.grey,
//             weight: FontWeight.w600))
//       ],
//     ),
//   );
// }
