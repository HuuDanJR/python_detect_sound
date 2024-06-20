import 'package:feedback_customer/util/color_custom.dart';
import 'package:feedback_customer/util/string_factory.dart';
import 'package:feedback_customer/widget/textfield_custom.dart';
import 'package:flutter/material.dart';

class StaffSearch extends StatelessWidget {
  final double widthArea;
  final double heightTextField;
  StaffSearch({super.key,required this.widthArea,required this.heightTextField});
  final controllerNote = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthArea,
      height: MediaQuery.of(context).size.height/3,
      decoration: BoxDecoration(
        color: MyColor.whiteopa,
        borderRadius:const BorderRadius.only(
          bottomLeft:  Radius.circular(StringFactory.padding24),
          bottomRight:  Radius.circular(StringFactory.padding24),
          topRight:  Radius.circular(StringFactory.padding56),
          topLeft:  Radius.circular(StringFactory.padding56),
          ),
      ),
      child: Stack(
        children: [
          customTextField(
              hint: "PLease enter staff's name",
              width: widthArea,
              onSubmitted: (value) {
                print('submitted search  value: $value');
              },
              onChanged: (value){
                print('onchange value : $value');
              },
              height: heightTextField,
              controller: controllerNote,
              text: '',
              keyboarType: TextInputType.text),
        ],
      ),
    );
  }
}
