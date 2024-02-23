import 'package:flutter/material.dart';
import 'package:volumn_control/public/myassets.dart';
import 'package:volumn_control/public/mypadding.dart';
import 'package:volumn_control/public/mywidths.dart';
import 'package:volumn_control/widget/custom_column.dart';
import 'package:volumn_control/widget/custom_image_asset.dart';
import 'package:volumn_control/widget/custom_row.dart';
import 'package:volumn_control/public/mytextsize.dart';
import 'package:volumn_control/widget/custom_text.dart';
import 'package:volumn_control/widget/text_icon_item.dart';

class ControlPage extends StatefulWidget {
  ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  PageController _pageController = PageController();
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final padding = width / 20;
    final width_item = (width  / 2)-padding-PaddingD.padding16;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage(MyAssets.bg), fit: BoxFit.cover)),
          width: width,
          height: height,
          child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding,vertical:padding),
          child:  PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
          _currentPageIndex = index;
          });
        },
        children: [
          Container(
          color: Colors.blue,
          child: Center(
            child: Text('Page 1'),
          ),
          ),
          Container(
          color: Colors.green,
          child: Center(
            child: Text('Page 2'),
          ),
          ),
        ],
      ),
          
          ),
        ));
  }
}
