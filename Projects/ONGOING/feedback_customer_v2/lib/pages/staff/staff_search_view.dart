import 'package:feedback_customer/pages/staff/bloc/staff_bloc.dart';
import 'package:feedback_customer/util/color_custom.dart';
import 'package:feedback_customer/util/language_service.dart';
import 'package:feedback_customer/util/string_factory.dart';
import 'package:feedback_customer/widget/text_custom.dart';
import 'package:feedback_customer/widget/textfield_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaffSearchView extends StatelessWidget {
  final double widthArea;
  final double heightTextField;
   StaffSearchView(
      {super.key, required this.widthArea, required this.heightTextField});

  final controllerNote = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height / 4.15;
    return Container(
      alignment: Alignment.topCenter,
      width: widthArea,
      height: height,
      decoration: BoxDecoration(
        color: MyColor.whiteopa,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(StringFactory.padding24),
          bottomRight: Radius.circular(StringFactory.padding24),
          topRight: Radius.circular(StringFactory.padding56),
          topLeft: Radius.circular(StringFactory.padding56),
        ),
      ),
      child: Column(
        children: [
          customTextField(
              onTap: (){
              },
              hasHeight: false,
              hint: translation(context).staff_hint,
              width: widthArea,
              onSubmitted: (value) {
                // print('submitted search  value: $value');
                // context.read<TimerBloc>().add(RestartTimerWithAwait(context,StringFactory.awaitValue));
                context.read<StaffBloc>().add(FilterStaff(value));
              },
              onChanged: (value) {
                // print('onchange value : $value');
                context.read<StaffBloc>().add(FilterStaff(value));
              },
              height: StringFactory.padding48,
              controller: controllerNote,
              text: '',
              keyboarType: TextInputType.text),
          BlocBuilder<StaffBloc, StaffState>(
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
                return state.showList == true
                    ? Expanded(
                        child: Container(
                            padding: const EdgeInsets.only(
                                left: StringFactory.padding16,
                                right: StringFactory.padding16,
                                bottom: StringFactory.padding16),
                            width: widthArea * .875,
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: StringFactory.padding8),
                              itemCount: state.filteredList.length,
                              itemBuilder: (context, index) {
                                return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      // context.read<TimerBloc>().add(RestartTimerWithAwait(context,StringFactory.awaitValue));
                                      context.read<StaffBloc>().add(SelectStaff(state.filteredList[index]));
                                    },
                                    splashColor: MyColor.grey_tab,
                                    child: Padding(
                                      padding: const EdgeInsets.all(
                                          StringFactory.padding8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          textCustomBold(
                                              text: state.filteredList[index].usernameEn,
                                              size: StringFactory.padding24),
                                          textCustom(
                                              text: state.filteredList[index].role,
                                              size: StringFactory.padding20),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )),
                      )
                    : Center(
                      child: Container(
                          alignment: Alignment.center,
                          child:const Icon(
                             Icons.group,
                             size: StringFactory.padding38,
                            color: MyColor.grey_tab,
                          )),
                    );
              }
            },
          )
        ],
      ),
    );
  }
}
