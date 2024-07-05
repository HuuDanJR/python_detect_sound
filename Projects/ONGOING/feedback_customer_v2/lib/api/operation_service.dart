// import 'package:feedback_customer/api/api_service.dart';
// import 'package:feedback_customer/model/staff_model.dart';
// import 'package:feedback_customer/pages/result.dart';
// import 'package:feedback_customer/pages/staff/bloc/staff_bloc.dart';
// import 'package:feedback_customer/widget/loading_dialog.dart';
// import 'package:flutter/material.dart';

// void runFeedbackAPIs(
//       {required StaffState state,
//       required context,
//       required String statusName,
//       required String statusName,
//       required StaffModel userData,
//       required String statusName,
//       required String statusName,
//       required bool? hasState,
//       required List<String> listExp,
//       required ServiceAPIs serviceAPIs}) async {
//     showLoadingDialog(context);
//     try {
//       await serviceAPIs.createFeedBackV2(
//               statusName: widget.statusName.toString(),
//               customerNumber: '${userData!.number}',
//               customerName:
//                   '${widget.userData!.title} ${widget.userData!.preferredName}',
//               customerCode: '',
//               customerNatinality:
//                   '${widget.userData!.nationality} ${widget.userData!.isoCode2}',
//               note: widget.note.toString(),
//               hasNote: widget.hasNote.toString(),
//               service_good: listExp,
//               service_bad: listExp,
//               staffNameEn:hasState==false?"empty": state.selectedStaff!.usernameEn,
//               staffName:hasState==false?"empty": state.selectedStaff!.username,
//               staffCode:hasState==false?"empty": state.selectedStaff!.code,
//               staffRole:hasState==false?"empty": state.selectedStaff!.role,
//               tag: 'PRODUCTION')
//           .then((v) {
//         if (v.status = true) {
//           // customSnackBar(context: context, message: v.message);
//           Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ResultPage()));
//         } else {
//           // customSnackBar( context: context, message: 'Can not create feedback or an error orcur');
//         }
//       }).whenComplete(() {});
//     } catch (e) {
//       // customSnackBar(context: context, message: 'An error occurred: $e');
//       hideLoadingDialog(context);
//     }
//   }

//   void runFeedbackNoSelectedStaf(
//       {required StaffState state,
//       required context,
//       required List<String> listExp,
//       required ServiceAPIs serviceAPIs}) async {
//     showLoadingDialog(context);
//     try {
//       await serviceAPIs
//           .createFeedBackV2(
//               statusName: statusName.toString(),
//               customerNumber: '${userData!.number}',
//               customerName:'${userData!.title} ${userData!.preferredName}',
//               customerCode: '',
//               customerNatinality:'${userData!.nationality} ${userData!.isoCode2}',
//               note: widget.note.toString(),
//               hasNote: widget.hasNote.toString(),
//               service_good: [],
//               service_bad: [],
//               staffNameEn: 'empty',
//               staffName: 'empty',
//               staffCode: 'empty',
//               staffRole: 'empty',
//               tag: 'production')
//           .then((v) {
//         if (v.status = true) {
//           // customSnackBar(context: context, message: v.message);
//           Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ResultPage()));
//         } else {
//           // customSnackBar(
//           //     context: context,
//           //     message: 'Can not create feedback or an error orcur');
//         }
//       }).whenComplete(() {
        
//       });
//     } catch (e) {
//       // customSnackBar(context: context, message: 'An error occurred: $e');
//       hideLoadingDialog(context);
//     }
//   }