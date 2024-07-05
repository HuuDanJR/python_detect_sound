// import 'package:feedback_customer/api/api_service.dart';
// import 'package:feedback_customer/getx/getx_controller.dart';
// import 'package:feedback_customer/model/nationality.dart';
// import 'package:feedback_customer/pages/feedback/feedback_title.dart';
// import 'package:feedback_customer/pages/staff/staff_page.dart';
// import 'package:feedback_customer/util/color_custom.dart';
// import 'package:feedback_customer/util/language_service.dart';
// import 'package:feedback_customer/util/string_factory.dart';
// import 'package:feedback_customer/widget/buttom_custom.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class FeedbackGoodPage extends StatefulWidget {
//   final String? statusName;
//   final NatinalityDatum? userData;
//   final bool hasNote;
//   final String note;
//   const FeedbackGoodPage(
//       {super.key,
//       required this.statusName,
//       required this.userData,
//       required this.hasNote,
//       required this.note});

//   @override
//   State<FeedbackGoodPage> createState() => _FeedbackGoodPageState();
// }

// class _FeedbackGoodPageState extends State<FeedbackGoodPage> {
//   final controllerGetx = Get.put(MyGetXController());
//   final service_api = ServiceAPIs();
//   @override
//   void dispose() {
//     super.dispose();
//     controllerGetx.resetListStatusFeedbackGood();
//   }

//   @override
//   void initState() {
//     print('INIT FeedbackGoodPage ${widget.statusName} ${widget.userData!.number} ${widget.hasNote} ${widget.note}');
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double height = MediaQuery.of(context).size.height;
//     final double heightArea = height * 0.675;
//     final double width = MediaQuery.of(context).size.width;
//     final double widthArea = width * 0.7;
//     return Scaffold(
//         resizeToAvoidBottomInset: true,
//         body: SafeArea(
//           child: OrientationBuilder(builder: (context, orientation) {
//             return Container(
//                 alignment: Alignment.center,
//                 height: height,
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: StringFactory.padding32),
//                 width: width,
//                 decoration: const BoxDecoration(
//                   image: DecorationImage(
//                       image: AssetImage(
//                         'asset/background.jpg',
//                       ),
//                       fit: BoxFit.cover,
//                       filterQuality: FilterQuality.low),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     feedBackTitle2(widthArea, context),
//                     const SizedBox(height: StringFactory.padding32),
//                     Container(
//                         // color:MyColor.whiteopa,
//                         width: widthArea,
//                         height: heightArea,
//                         alignment: Alignment.center,
//                         child: Obx(
//                           () => GridView.builder(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             itemCount: controllerGetx.list_feedbackgood.length,
//                             itemBuilder: (context, index) {
//                               return ClipRRect(
//                                 borderRadius: BorderRadius.circular(
//                                     StringFactory.padding24),
//                                 child: Material(
//                                   color: Colors.transparent,
//                                   child: InkWell(
//                                     splashColor: MyColor.grey_tab,
//                                     onTap: () {
//                                       // print('choose feedback good $index : ${controllerGetx.list_feedbackgood[index].name}');
//                                       controllerGetx.changeListStatusFeedbackGood(
//                                               controllerGetx
//                                                   .list_feedbackgood[index].id);
//                                     },
//                                     child: Container(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: StringFactory.padding0,
//                                           vertical: StringFactory.padding24),
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           Container(
//                                             height: orientation ==
//                                                     Orientation.portrait
//                                                 ? heightArea / 3.25
//                                                 : heightArea / 4,
//                                             width: widthArea / 2 * .75,
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal:
//                                                     StringFactory.padding28,
//                                                 vertical:
//                                                     StringFactory.padding28),
//                                             alignment: Alignment.center,
//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(
//                                                       StringFactory.padding42),
//                                               color: controllerGetx
//                                                           .list_feedbackgood[
//                                                               index]
//                                                           .isSelected ==
//                                                       true
//                                                   ? MyColor.yellowSelected
//                                                   : MyColor.background,
//                                             ),
//                                             child: Padding(
//                                               padding: EdgeInsets.all(
//                                                   orientation ==
//                                                           Orientation.portrait
//                                                       ? StringFactory.padding24
//                                                       : StringFactory
//                                                           .padding12),
//                                               child: Image.asset(
//                                                 fit: BoxFit.contain,
//                                                 scale: 1,
//                                                 controllerGetx
//                                                             .list_feedbackgood[
//                                                                 index]
//                                                             .isSelected ==
//                                                         false
//                                                     ? controllerGetx
//                                                         .list_feedbackgood[
//                                                             index]
//                                                         .image
//                                                     : controllerGetx
//                                                         .list_feedbackgood[
//                                                             index]
//                                                         .imageUnSelected,
//                                                 filterQuality:
//                                                     FilterQuality.high,
//                                                 alignment: Alignment.center,
//                                               ),
//                                             ),
//                                           ),
//                                           const SizedBox(
//                                             height: StringFactory.padding4,
//                                           ),
//                                           Text(
//                                             getTranslation(
//                                                 context,
//                                                 controllerGetx
//                                                     .list_feedbackgood[index]
//                                                     .name),
//                                             style: const TextStyle(
//                                                 fontSize:
//                                                     StringFactory.padding26),
//                                             textAlign: TextAlign.center,
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                                     crossAxisCount: 2,
//                                     childAspectRatio:
//                                         orientation == Orientation.portrait
//                                             ? .85
//                                             : 1.5,
//                                     mainAxisSpacing: StringFactory.padding20,
//                                     crossAxisSpacing: StringFactory.padding20),
//                           ),
//                         )),
//                     //button submit
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         customPressButton(
//                             isBoldColor: true,
//                             width: 225.0,
//                             text: translation(context).submit,
//                             padding: StringFactory.padding32,
//                             onPress: () {
//                               // print('press submit ffedback good');
//                               Navigator.of(context).push(MaterialPageRoute(
//                                   builder: (_) =>  StaffPage(
//                                     userData: widget.userData,
//                                     note: widget.note,
//                                     hasNote: widget.hasNote,
//                                     statusName: widget.statusName,
//                                   )));
//                             }),
//                         // const SizedBox(
//                         //   height: StringFactory.padding16,
//                         // ),
//                         // Obx(() => Text(
//                         //     'Auto submit after ${controllerGetx.valueAwait.value} s',
//                         //     style:  const TextStyle(fontSize:StringFactory.padding20, fontWeight: FontWeight.normal),),
//                         // ),
//                       ],
//                     ),
//                   ],
//                 ));
//           }),
//         ));
//   }
// }
