class ConfigFactory {
  static const int TIME_CALL = 300; //5 min
  static const int LIST_LENGTH = 77; //total length of list generate
  static const int LIST_ITEM_CROSS_COUNT = 15; //total length of list generate

  static const int timer_duration_time = 5; //tootal time
  static const int timer_max_round = 77 - (1); //tiotal round
  static const int delay_animation = 2; //delay animation should < timer duration timer




  static double ratio_width_parent({required double width}) {
    //width parent
    return width * .65;
  }

  static double ratio_width_child({required double width}) {
    //width child
    return width * .35;
  }

  static double ratio_height_parent({required double height}) {
    //height parent
    return height * .75;
  }

  static double ratio_height_child({required double height}) {
    //height child
    return height * .25;
  }

  static List<double> area_ball_gen({required double width, required double height}) {
    return [width * .75, height * .55];
  }


    static List<double> area_ball_gen_small({required double width, required double height}) {
      return [width * 0.475, height * 0.475];
    }


  static double borderRadiusCard = 45.0;

  static const String BALL_YELLOW = 'assets/icons/ball_yellow.png';
  static const String BALL_BLUE = 'assets/icons/ball_blue.png';
  static const String BALL_RED = 'assets/icons/ball_red.png';
  static const String BALL_PURPLE = 'assets/icons/ball_purple.png';
  static const String BALL_GREEN = 'assets/icons/ball_green.png';

  static const String tag_red = 'red';
  static const String tag_blue = 'blue';
  static const String tag_green = 'green';
  static const String tag_purple = 'purple';
  static const String tag_yellow = 'yellow';
  static const String tag_grey = 'grey';


}
