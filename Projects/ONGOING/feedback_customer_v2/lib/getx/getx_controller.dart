import 'package:feedback_customer/model/item_status.dart';
import 'package:feedback_customer/pages/suggestion/suggestion.dart';
import 'package:get/get.dart';
import 'dart:async';

class MyGetXController extends GetxController {
  RxList<ItemStatus> list = <ItemStatus>[
    ItemStatus(
        id: 0,
        name: 'Gaming\nExperience',
        image: 'asset/gaming.png',
        isSelected: false),
    ItemStatus(
        id: 1,
        name: "Staff's Service\nPerformance",
        image: 'asset/staff.png',
        isSelected: false),
    ItemStatus(
        id: 2,
        name: 'Food & Beverage\n',
        image: 'asset/food.png',
        isSelected: false),
    ItemStatus(
        id: 3,
        name: 'Cleanliness\n& Hygiene',
        image: 'asset/clean.png',
        isSelected: false),
  ].obs;
  RxInt valueAwait = 10.obs;
  RxInt valueAwaitResult = 3.obs;
  RxInt remainingTime = 0.obs;
  Timer? _countdownTimer, _countdownTimerResult;

  @override
  void onClose() {
    // Call resetListStatus when the controller is disposed
    resetListStatus();
    _countdownTimer!.cancel();
    _countdownTimerResult!.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    // Call resetListStatus() when the controller is initialized
    resetListStatus();
    super.onInit();
  }

  changeListStatus(int id) {
    // Find the item with the given id in the list
    final item = list.firstWhere((element) => element.id == id,
        orElse: () =>
            ItemStatus(id: id, name: '', image: '', isSelected: false));
    // Toggle the isSelected value
    item.isSelected = !item.isSelected;
    // Update the list
    list.refresh();
    update();
  }

  resetListStatus() {
    // Set all isSelected values to false
    for (final item in list) {
      item.isSelected = false;
    }
    // Update the list
    list.refresh();
    update();
  }

  List<String> getListStatusName() {
    // Filter the list to get the names of items whose isSelected property is true
    final selectedNames =
        list.where((element) => element.isSelected).map((e) => e.name).toList();
    // print(selectedNames.toString());
    return selectedNames;
  }

  //TIMER ALARM CLOCK
  void startCountdownTimer(Function? function) {
    print('startCountdownTimer');
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (valueAwait.value > 0) {
        valueAwait.value = valueAwait.value - 1;
        // print(valueAwait.value);
      }
      if (valueAwait.value == 0) {
        // If valueAwait reaches 0, navigate to WelcomeScreen
        // Get.offAll(const ResultPage(), transition: Transition.fade);
        print('startCountdownTimer = 0');
        _countdownTimer!.cancel();
        function?.call(); 
        valueAwait = 10.obs;
      }
    });
  }

  void startCountdownTimerResultPage() {
    print('startCountdownTimerResultPage');
    _countdownTimerResult = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (valueAwaitResult.value > 0) {
        valueAwaitResult.value = valueAwaitResult.value - 1;
        // print(valueAwait.value);
      }
      if (valueAwaitResult.value == 0) {
        print('startCountdownTimerResultPage = 0');
        // If valueAwait reaches 0, navigate to WelcomeScreen
        resetListStatus();
        Get.offAll( SuggestionPage(), transition: Transition.fade);
        _countdownTimerResult!.cancel();
        valueAwaitResult = 3.obs;
      }
    });
  }

  void cancelResetAllTimer() {
    resetListStatus();
    valueAwait = 10.obs;
    valueAwaitResult = 5.obs;
    _countdownTimer!.cancel();
    _countdownTimerResult!.cancel();
  }

  void pauseTimer() {
    _countdownTimer!.cancel();
  }

  void restartTimer(Function? function) {
    _countdownTimer!.cancel();
    update();
    valueAwait.value = 10;
    startCountdownTimer((){function!();});
  }
}
