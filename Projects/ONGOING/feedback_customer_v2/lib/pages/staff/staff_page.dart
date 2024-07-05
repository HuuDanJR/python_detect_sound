import 'package:feedback_customer/api/api_service.dart';
import 'package:feedback_customer/bloc/timer/timer_bloc.dart';
import 'package:feedback_customer/model/nationality.dart';
import 'package:feedback_customer/pages/result.dart';
import 'package:feedback_customer/pages/staff/bloc/staff_bloc.dart';
import 'package:feedback_customer/pages/staff/staff_search.dart';
import 'package:feedback_customer/pages/staff/staff_view.dart';
import 'package:feedback_customer/util/color_custom.dart';
import 'package:feedback_customer/util/language_service.dart';
import 'package:feedback_customer/util/string_factory.dart';
import 'package:feedback_customer/widget/buttom_custom.dart';
import 'package:feedback_customer/widget/loading_dialog.dart';
import 'package:feedback_customer/widget/snackbar_custom.dart';
import 'package:feedback_customer/widget/text_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaffPage extends StatelessWidget {
  final String? statusName;
  final NatinalityDatum? userData;
  final bool hasNote;
  final String note;
  final List<String> listExp;

  const StaffPage(
      {super.key,
      required this.statusName,
      required this.userData,
      required this.hasNote,
      required this.listExp,
      required this.note});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => StaffBloc(ServiceAPIs())..add(LoadStaff()),
        ),
        BlocProvider(
          // create: (context) => TimerBloc()
          create: (context) => TimerBloc()..add(StartTimer()),
        ),
      ],
      child: StaffPageBody(
          userData: userData,
          statusName: statusName,
          listExp: listExp,
          hasNote: hasNote,
          note: note),
    );
  }
}

class StaffPageBody extends StatefulWidget {
  final String? statusName;
  final List<String> listExp;
  final NatinalityDatum? userData;
  final bool hasNote;
  final String note;
  const StaffPageBody(
      {super.key,
      required this.statusName,
      required this.listExp,
      required this.userData,
      required this.hasNote,
      required this.note});

  @override
  State<StaffPageBody> createState() => _StaffPageBodyState();
}

class _StaffPageBodyState extends State<StaffPageBody> {
  @override
  void initState() {
    debugPrint('INIT STAFF PAGE: ${widget.listExp}');
    super.initState();
  }

  final controllerNote = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double widthArea = width * 0.75;
    final double heightTextField = height * 0.16;
    final serviceAPIs = ServiceAPIs();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: OrientationBuilder(builder: (context, orientation) {
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
          child: BlocBuilder<StaffBloc, StaffState>(
            builder: (context, state) {
              if (state.status == StaffStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                    color: MyColor.grey_tab,
                  ),
                );
              } else if (state.status == StaffStatus.error) {
                return Center(
                  child: Text(
                    state.errorMessage ?? 'An error occurred',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else {
                return BlocListener<TimerBloc, TimerState>(
                  listener: (context, stateTimer) {
                    if (stateTimer.status == TimerStatus.finish) {
                      debugPrint('timer finished');
                      runFeedbackNoSelectedStaf(
                        state: context.read<StaffBloc>().state,
                        context: context,
                        serviceAPIs: serviceAPIs,
                        listExp: widget.listExp,
                      );
                    }
                  },
                  child: BlocBuilder<TimerBloc, TimerState>(
                    builder: (context, stateTimer) {
                      return SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            textCustomBold(
                              isAlignCenter: true,
                              text: translation(context).leave_impression,
                              size: StringFactory.padding28,
                            ),
                            const SizedBox(
                              height: StringFactory.padding26,
                            ),
                            Center(
                              child: StaffSearch(
                              widthArea: widthArea,
                              heightTextField: heightTextField,
                              // data: staffModel,
                            )),
                            const SizedBox(
                              height: StringFactory.padding32,
                            ),
                            SizedBox(
                                width: widthArea,
                                child: const Divider(color: MyColor.grey)),
                            const SizedBox(
                              height: StringFactory.padding32,
                            ),
                            StaffView(
                              widthArea: widthArea-StringFactory.padding72,
                            ),
                            const SizedBox(
                              height: StringFactory.padding72,
                            ),
                            customPressButton(
                                width: 225.0,
                                text: translation(context).submit,
                                padding: StringFactory.padding32,
                                onPress: () {
                                  if (state.selectedStaff == null) {
                                    // customSnackBar( context: context,message: "Please select a staff member to submit");
                                     runFeedbackAPIs(
                                        hasState: false,
                                        state: state,
                                        context: context,
                                        listExp: widget.listExp,
                                        serviceAPIs: serviceAPIs);
                                  } else {
                                    runFeedbackAPIs(
                                        hasState: true,
                                        state: state,
                                        context: context,
                                        listExp: widget.listExp,
                                        serviceAPIs: serviceAPIs);
                                  }
                                  
                                }),
                            //auto submit text
                            const SizedBox(
                              height: StringFactory.padding24,
                            ),
                            Text(
                              '${translation(context).auto_back_home} ${stateTimer.duration}',
                              style: const TextStyle(
                                  fontSize: StringFactory.padding24,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ));
    }));
  }

  void runFeedbackAPIs(
      {required StaffState state,
      required context,
      required bool? hasState,
      required List<String> listExp,
      required ServiceAPIs serviceAPIs}) async {
    showLoadingDialog(context);
    try {
      await serviceAPIs.createFeedBackV2(
              statusName: widget.statusName.toString(),
              customerNumber: '${widget.userData!.number}',
              customerName:
                  '${widget.userData!.title} ${widget.userData!.preferredName}',
              customerCode: '',
              customerNatinality:
                  '${widget.userData!.nationality} ${widget.userData!.isoCode2}',
              note: widget.note.toString(),
              hasNote: widget.hasNote.toString(),
              service_good: listExp,
              service_bad: listExp,
              staffNameEn:hasState==false?"empty": state.selectedStaff!.usernameEn,
              staffName:hasState==false?"empty": state.selectedStaff!.username,
              staffCode:hasState==false?"empty": state.selectedStaff!.code,
              staffRole:hasState==false?"empty": state.selectedStaff!.role,
              tag: 'PRODUCTION')
          .then((v) {
        if (v.status = true) {
          // customSnackBar(context: context, message: v.message);
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ResultPage()));
        } else {
          // customSnackBar( context: context, message: 'Can not create feedback or an error orcur');
        }
      }).whenComplete(() {});
    } catch (e) {
      // customSnackBar(context: context, message: 'An error occurred: $e');
      hideLoadingDialog(context);
    }
  }

  void runFeedbackNoSelectedStaf(
      {required StaffState state,
      required context,
      required List<String> listExp,
      required ServiceAPIs serviceAPIs}) async {
    showLoadingDialog(context);
    try {
      await serviceAPIs
          .createFeedBackV2(
              statusName: widget.statusName.toString(),
              customerNumber: '${widget.userData!.number}',
              customerName:'${widget.userData!.title} ${widget.userData!.preferredName}',
              customerCode: '',
              customerNatinality:'${widget.userData!.nationality} ${widget.userData!.isoCode2}',
              note: widget.note.toString(),
              hasNote: widget.hasNote.toString(),
              service_good: [],
              service_bad: [],
              staffNameEn: 'empty',
              staffName: 'empty',
              staffCode: 'empty',
              staffRole: 'empty',
              tag: 'production')
          .then((v) {
        if (v.status = true) {
          // customSnackBar(context: context, message: v.message);
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ResultPage()));
        } else {
          // customSnackBar(
          //     context: context,
          //     message: 'Can not create feedback or an error orcur');
        }
      }).whenComplete(() {
        
      });
    } catch (e) {
      // customSnackBar(context: context, message: 'An error occurred: $e');
      hideLoadingDialog(context);
    }
  }
}
