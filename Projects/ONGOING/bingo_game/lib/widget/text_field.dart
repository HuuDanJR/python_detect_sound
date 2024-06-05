import 'package:bingo_game/page/game/left/export.dart';

Widget mytextfield({hint,controller,required String textInit,required double height,required double width}) {
  return SizedBox(
    width: width,
    height: height,
    child: TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelStyle: const TextStyle(fontWeight: FontWeight.w700),
        labelText:  textInit,
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color:MyColor.grey_tab,
            width: .5,
          ),
          borderRadius:  BorderRadius.all(
            Radius.circular(StringFactory.padding16)
          )
        ),
        prefixIcon: const Icon(Icons.numbers),
        hintText: "$hint"),
    ),
  );
}