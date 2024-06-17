class ConfigFactory {
  static const String ADRESS_SERVER = "localhost";
  // static const String ADRESS_SERVER = "192.168.101.58";
  static const String BASE = 'http://$ADRESS_SERVER:8099/api/';
  static const String list_display = "${BASE}display/list_display"; //5 min
  static const String list_gamePlayed = "${BASE}game/list_game"; //5 min
  static const String createNewGame = "${BASE}game/create_game"; //5 min
  //DISPLAY
  static String update_display(id) {
    return '${BASE}update_display/$id';
  }

  static const int TIME_CALL = 300; //5 min
  static const int LIST_LENGTH = 77; //total length of list generate
  static const int LIST_ITEM_CROSS_COUNT = 15; //total length of list generate

  static const int timer_duration_time = 5; //tootal time
  static const int timer_max_round = 77 - (1); //tiotal round
  static const int delay_animation = 1; //delay animation should < timer duration timer

  static double ratio_width_parent({required double width}) {
    //width parent
    return width * .675;
  }

  static double ratio_width_child({required double width}) {
    //width child
    return width * .325;
  }

  static double ratio_height_parent({required double height}) {
    //height parent
    return height * .725;
  }

  static double ratio_height_child({required double height}) {
    //height child
    return height * .275;
  }

  static List<double> area_ball_gen(
      {required double width, required double height}) {
    return [width * .75, height * .55];
  }

  static List<double> area_ball_gen_small(
      {required double width, required double height}) {
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
