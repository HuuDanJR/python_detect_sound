
import 'package:feedback_customer/pages/staff/bloc/staff_bloc.dart';
import 'package:feedback_customer/util/color_custom.dart';
import 'package:feedback_customer/util/string_factory.dart';
import 'package:feedback_customer/widget/image_network.dart';
import 'package:feedback_customer/widget/text_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaffView extends StatelessWidget {
  final double widthArea;
  const StaffView(
      {super.key, required this.widthArea, });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height / 3.5;
    final heightListView = height - StringFactory.padding64;
    return BlocBuilder<StaffBloc, StaffState>(
      builder: (context, state) {
        if (state.selectedStaff == null) {
          return Container(
            width: widthArea,
            height: heightListView,
            alignment: Alignment.center,
            child: textCustom(text: '', size: StringFactory.padding22),
          );
        }
        return Container(
          alignment: Alignment.center,
          width: widthArea,
          height: heightListView,
          // color:MyColor.whiteopa,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  // ClipRRect(
                  //    borderRadius: BorderRadius.circular(StringFactory.padding18),
                  //   child: Container(
                  //     width: widthArea * .375,
                  //     height: heightListView,
                  //     decoration: BoxDecoration(
                  //          color:MyColor.whiteopa,
                  //         image: const DecorationImage(
                  //             image: AssetImage('asset/background_staff.png'),
                  //             fit: BoxFit.contain),
                  //         borderRadius: BorderRadius.circular(StringFactory.padding18)),
                  //   ),
                  // ),
                  Container(
                      width: widthArea * .4 - StringFactory.padding16 ,
                      height: heightListView ,
                      decoration: BoxDecoration(
                        border:Border.all(color:MyColor.yellowAccent),
                        borderRadius: BorderRadius.circular(StringFactory.padding18)
                      ),
                      // padding: const EdgeInsets.all(StringFactory.padding16),
                      child: loadingImage(networkUrl: state.selectedStaff!.imageUrl,isCover: true),
                  ),
                ],
                
              ),
              Container(
                width: widthArea * .6 - StringFactory.padding16,
                height: heightListView,
                // color:MyColor.whiteopa,
                padding: const EdgeInsets.all(StringFactory.padding),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textCustomBold(
                      isAlignCenter: true,
                        text: state.selectedStaff!.username,
                        size: StringFactory.padding22),
                    textCustomBold(
                      isAlignCenter: true,
                        text: state.selectedStaff!.usernameEn,
                        size: StringFactory.padding22),
                    const SizedBox(
                      height: StringFactory.padding16,
                    ),
                    textCustomLinestextAlign(
                        textalign: TextAlign.start,
                        lines: 1,
                        text: state.selectedStaff!.code,
                        size: StringFactory.padding22),
                    const SizedBox(
                      height: StringFactory.padding24,
                    ),
                    textCustomLinestextAlign(
                        textalign: TextAlign.start,
                        lines: 2,
                        text: state.selectedStaff!.role,
                        size: StringFactory.padding22),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
