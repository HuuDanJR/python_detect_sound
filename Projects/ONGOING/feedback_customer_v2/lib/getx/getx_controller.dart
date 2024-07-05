import 'package:feedback_customer/model/item_status.dart';
import 'package:feedback_customer/pages/result.dart';
import 'package:feedback_customer/pages/suggestion/suggestion.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class MyGetXController extends GetxController {
  //LIST FEEDBACK BAD
  RxList<ItemStatus> list_feedback = <ItemStatus>[
    ItemStatus(
        id: 0,
        name: 'item_gaming_exp',
        nameNoTranslate: 'Gaming Experience',
        image: 'asset/gaming.png',
        imageUnSelected: "asset/gaming2.png",
        isSelected: false),
    ItemStatus(
        id: 1,
        name: "item_staff",
        nameNoTranslate: "Staff’s service performance",
        image: 'asset/staff.png',
        imageUnSelected: "asset/staff2.png",
        isSelected: false),
    ItemStatus(
        id: 2,
        name: 'item_food',
        nameNoTranslate: "Food and Beverage",
        image: 'asset/food.png',
        imageUnSelected: "asset/food2.png",
        isSelected: false),
    ItemStatus(
        id: 3,
        name: 'item_clean',
        nameNoTranslate: 'Cleanliness and Hygiene',
        image: 'asset/clean.png',
        imageUnSelected: "asset/clean2.png",
        isSelected: false),
  ].obs;
//LIST FEEDBACK GOOD
  // RxList<ItemStatus> list_feedbackgood = <ItemStatus>[
  //   ItemStatus(
  //       id: 0,
  //       name: 'item_gaming_exp',
  //       image: 'asset/gaming.png',
  //       nameNoTranslate: 'Gaming Experience',
  //       imageUnSelected: "asset/gaming2.png",
  //       isSelected: false),
  //   ItemStatus(
  //       id: 1,
  //       name: "item_staff",
  //       nameNoTranslate: "Staff’s service performance",
  //       image: 'asset/staff.png',
  //       imageUnSelected: "asset/staff2.png",
  //       isSelected: false),
  //   ItemStatus(
  //       id: 2,
  //       name: 'item_food',
  //       image: 'asset/food.png',
  //       nameNoTranslate: "Food and Beverage",
  //       imageUnSelected: "asset/food2.png",
  //       isSelected: false),
  //   ItemStatus(
  //       id: 3,
  //       name: 'item_clean',
  //       nameNoTranslate: 'Cleanliness and Hygiene',
  //       image: 'asset/clean.png',
  //       imageUnSelected: "asset/clean2.png",
  //       isSelected: false),
  // ].obs;
  int timer_default_value = 10;
  int timer_result_default_value = 5;
  RxInt valueAwait = 10.obs;
  RxInt valueAwaitResult = 5.obs;
  RxInt remainingTime = 0.obs;
  Timer? _countdownTimer;
  Timer? _countdownTimerResult;

  @override
  void onClose() {
    _countdownTimer!.cancel();
    _countdownTimerResult!.cancel();
    cancelResetAllTimer();
    super.onClose();
  }

  @override
  void onInit() {
    cancelResetAllTimer();
    resetListStatusFeedback();
    super.onInit();
  }

  List<String> getSelectedFeedbackNames() {
    return list_feedback
        .where((item) => item.isSelected)
        .map((item) => item.nameNoTranslate)
        .toList();
  }

  // List<String> getSelectedFeedbackGoodNames() {
  //   return list_feedback
  //       .where((item) => item.isSelected)
  //       .map((item) => item.nameNoTranslate)
  //       .toList();
  // }

  changeListStatusFeedback(int id) {
    final item = list_feedback.firstWhere((element) => element.id == id,
        orElse: () => ItemStatus(
            id: id,
            name: '',
            nameNoTranslate: '',
            image: '',
            imageUnSelected: "",
            isSelected: false));
    item.isSelected = !item.isSelected;
    list_feedback.refresh();
    update();
  }

  // changeListStatusFeedbackGood(int id) {
  //   final item = list_feedbackgood.firstWhere((element) => element.id == id,
  //       orElse: () => ItemStatus(
  //           id: id,
  //           name: '',
  //           nameNoTranslate: '',
  //           image: '',
  //           imageUnSelected: "",
  //           isSelected: false));
  //   item.isSelected = !item.isSelected;
  //   list_feedbackgood.refresh();
  //   update();
  // }

  resetListStatusFeedback() {
    for (final item in list_feedback) {
      item.isSelected = false;
    }
    // Update the list
    list_feedback.refresh();
    update();
  }

  // resetListStatusFeedbackGood() {
  //   for (final item in list_feedbackgood) {
  //     item.isSelected = false;
  //   }
  //   // Update the list
  //   list_feedbackgood.refresh();
  //   update();
  // }

  List<String> getListFeedbackStatusName() {
    final selectedNames = list_feedback
        .where((element) => element.isSelected)
        .map((e) => e.name)
        .toList();
    debugPrint('getListFeedbackBadStatusName: $selectedNames');
    return selectedNames;
  }

  // List<String> getListFeedbackGoodStatusName() {
  //   final selectedNames = list_feedbackgood
  //       .where((element) => element.isSelected)
  //       .map((e) => e.name)
  //       .toList();
  //   debugPrint('getListFeedbackGoodStatusName: $selectedNames');
  //   return selectedNames;
  // }

  //TIMER ALARM CLOCK
  // void startCountdownTimer(Function? function) {
  //   debugPrint('startCountdownTimer');
  //   _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     if (valueAwait.value > 0) {
  //       valueAwait.value = valueAwait.value - 1;
  //       debugPrint('value await: ${valueAwait.value}');
  //     }
  //     if (valueAwait.value == 0) {
  //       // If valueAwait reaches 0, navigate to WelcomeScreen
  //       Get.offAll(const ResultPage(), transition: Transition.fade);
  //       debugPrint('startCount  downTimer = 0');
  //       function?.call();
  //       valueAwait = timer_default_value.obs;
  //       _countdownTimer!.cancel();
  //     }
  //   });
  // }

  void startCountdownTimerResultPage() {
    debugPrint('startCountdownTimerResultPage');
    _countdownTimerResult = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (valueAwaitResult.value > 0) {
        valueAwaitResult.value = valueAwaitResult.value - 1;
      } else if (valueAwaitResult.value == 0) {
        debugPrint('startCountdownTimerResultPage = 0');
        Get.offAll(SuggestionPage(), transition: Transition.fade);
        valueAwaitResult = timer_result_default_value.obs;
        cancelResetAllTimer();
      } else {
        cancelResetAllTimer();
      }
    });
  }

  void cancelResetAllTimer() {
    // _countdownTimer?.cancel();
    _countdownTimerResult?.cancel();
    resetListStatusFeedback();
    valueAwait = timer_default_value.obs;
    valueAwaitResult = timer_result_default_value.obs;
  }

  // void pauseTimer() {
  //   // _countdownTimer!.cancel();
  // }

  // void restartTimer(Function? function) {
  //   // _countdownTimer!.cancel();
  //   update();
  //   valueAwait.value = timer_default_value;
  //   // startCountdownTimer(() {
  //   //   function!();
  //   // });
  // }
}
