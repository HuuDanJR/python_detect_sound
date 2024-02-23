import 'dart:async';
import 'package:get/get.dart';

class MyGetXController extends GetxController {
  RxBool star1 = false.obs;
  RxBool star2 = false.obs;
  RxBool star3 = false.obs;
  RxBool star4 = false.obs;
  RxBool star5 = false.obs;
  RxString starText = ''.obs;
  RxInt starCount = 0.obs;

  RxBool visible = false.obs;

  RxList<String> selectedItemNames =
      <String>[].obs; // New RxList for selected item names

  RxInt count = 0.obs;
  RxBool countdownFinished = false.obs;

  Timer? countdownTimer;

  @override
  void onClose() {
    // Cancel the countdown timer when the controller is closed
    countdownTimer?.cancel();
    super.onClose();
  }

  void resetCountdown(Function? onCountdownFinished) {
    // Reset the countdown values and cancel the timer
    count.value = 10;
    countdownFinished.value = false;
    countdownTimer?.cancel();

    // Restart the countdown
    startCountdown(onCountdownFinished);
  }

  void startCountdown(Function? onCountdownFinished) {
    count.value = 10; // Set the initial value to 10

    // Start the countdown timer
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (count.value > 0) {
        // Decrement count by 1 every second
        count.value--;
      } else {
        // Stop the timer when count reaches 0
        timer.cancel();
        // Set the countdownFinished flag to true
        countdownFinished.value = true;
        // Execute the callback function if provided
        if (onCountdownFinished != null) {
          onCountdownFinished();
        }
      }
    });
  }

  void toggleVisible() {
    visible.toggle();
  }

  void turnOnVisible() {
    visible.value = true;
  }

  void turnOff() {
    // Set the value of 'visible' to false
    visible.value = false;
    // Update the UI reactively
    update();
  }

  static const String NO_TOILET1 = 'No toilet paper';
  static const String NO_TOILET2 = 'Dirty toilet bowl';
  static const String NO_TOILET3 = 'Dirty basin';
  static const String NO_TOILET4 = 'Wet floor';
  static const String NO_TOILET5 = 'Faulty equipment';
  static const String NO_TOILET6 = 'Full trash bin';
  static const String NO_TOILET7 = 'Foul smell';
  static const String NO_TOILET8 = 'Dirty floor';
  static const String NO_TOILET1_image = 'assets/asset2.png';
  static const String NO_TOILET2_image = 'assets/asset5.png';
  static const String NO_TOILET3_image = 'assets/asset4.png';
  static const String NO_TOILET4_image = 'assets/asset7.png';
  static const String NO_TOILET5_image = 'assets/asset3.png';
  static const String NO_TOILET6_image = 'assets/asset8.png';
  static const String NO_TOILET7_image = 'assets/asset1.png';
  static const String NO_TOILET8_image = 'assets/asset6.png';

  resetForm() {
    star1.value = false;
    star2.value = false;
    star3.value = false;
    star4.value = false;
    star5.value = false;

    starCount.value = 0;
    visible.value = false;
    countdownTimer!.cancel();
    selectedItemNames.value = [];
    update();
  }

  changeStarState(index) {
    if (index == 1) {
      starCount.value = 1;
      star1.value = true;
      starText.value = 'BAD';
      if (star2.value = true) {
        star2.value = false;
      }
      if (star3.value = true) {
        star3.value = false;
      }
      if (star4.value = true) {
        star4.value = false;
      }
      if (star5.value = true) {
        star5.value = false;
      }
    } else if (index == 2) {
      starCount.value = 2;
      star1.value = true;
      star2.value = true;
      starText.value = 'BAD';
      if (star3.value = true) {
         star3.value = false;
      }
      if (star4.value = true) {
         star4.value = false;
      }
      if (star5.value = true) {
         star5.value = false;
      }
    } else if (index == 3) {
      starCount.value = 3;
      star1.value = true;
      star2.value = true;
      star3.value = true;
      starText.value = 'GOOD';
      if (star4.value = true) {
        star4.value = false;
      }
      if (star5.value = true) {
        star5.value = false;
      }
    } else if (index == 4) {
      starCount.value = 4;
      star1.value = true;
      star2.value = true;
      star3.value = true;
      star4.value = true;
      if (star5.value = true) {
        star5.value = false;
      }
      starText.value = 'GOOD';
    } else if (index == 5) {
      starCount.value = 5;
      star1.value = true;
      star2.value = true;
      star3.value = true;
      star4.value = true;
      star5.value = true;
      starText.value = 'PERFECT';
    }
  }
}
