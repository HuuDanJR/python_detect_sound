import 'package:bingo_game/page/game/left/export.dart';

Widget mytextfield({required enable, onChange, onFieldSubmitted,hint,controller,required String textInit,required double height,required double width}) {
  return SizedBox(
    width: width,
    height: height,
    child: TextFormField(
      onFieldSubmitted:onFieldSubmitted ,
      controller: controller,
      enabled: enable,
      onChanged: onChange,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelStyle: const TextStyle(fontWeight: FontWeight.w700),
        labelText:  textInit,
        // border: const OutlineInputBorder.none,
        // const OutlineInputBorder(
        //   borderSide: BorderSide(
        //     color:MyColor.grey_tab,
        //     width: .25,
        //   ),
        //   borderRadius:  BorderRadius.all(
        //     Radius.circular(StringFactory.padding8)
        //   ),
          
        // ),
        prefixIcon: const Icon(Icons.numbers),
        hintText: "$hint"),
    ),
  );
}