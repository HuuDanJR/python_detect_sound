import 'package:volumn_control/public/mypadding.dart';

class MyWidths {
  static const double width_asset = 115.0;
  static const double width_asset_small = 55.0;
  static const double width_asset_button = 35.0;
  static const double width_asset_smalest = 47.5;
  static const double width_logo = 150.0;
  static const double width_borderRadius = 45.0;
  static const double width_borderRadiusSmall = 25.0;
  static const double width_borderRadiusMinial = 7.5;
  static double width_screen_padding(width) {
    return width - (MyWidths.tab_padding(width / 25) * 2);
  }

  static double height_screen_padding(double height) {
    return height / 2 +
        (MyWidths.tab_padding(height / 100)) +
        PaddingD.padding16 +
        PaddingD.pading08;
  }

  static double tab_item_height(double height) {
    return height / 13;
  }

  static double tab_item_height_small(double height) {
    return height / 18;
  }

  static const double slider_image_asset = 50;
  static const double slider_item_width = 54.5;
  static const double slider_item_width_small = 42.5;
  static double height_center_point(double height) {
    return height_child(height)/2 - MyWidths.tab_padding(height / 50);
  }

  static double height_child(double height) {
    double height_left =((MyWidths.tab_padding(height / 50)*2) +
            MyWidths.tab_item_height(height) +
            PaddingD.padding16
    );
    return height- height_left;
  }

  static double height_slider(double height) {
    return height / 2;
  }

  static double width_center_point(double width) {
    return width / 2 - (MyWidths.tab_padding(width / 25));
  }

  static double width_item_tab(double value) {
    return value;
  }

  static double tab_padding(double value) {
    return value;
  }

  static const double switch_width = 100.0;
  static const double switch_height = 42.5;
}
