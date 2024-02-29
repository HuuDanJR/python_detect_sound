import 'package:get/get.dart';
import 'package:volumn_control/api/api_service.dart';
import 'package:volumn_control/model/volume.dart';
import 'package:volumn_control/public/myAPIstring.dart';

class MyGetXController extends GetxController {
  RxBool visible = false.obs;
  RxBool isSwitch = false.obs;
  RxDouble valueSlider = 0.0.obs;
  RxList<VolumeModel> volumeList = <VolumeModel>[].obs;
  RxDouble dx = 0.0.obs;
  RxDouble dy = 0.0.obs;
  RxDouble zoomRatio = 1.0.obs;
  RxDouble valueSliderAll = 0.0.obs;
  RxBool hasChangeValueSlider = false.obs;
  RxList<String> stringList = <String>[].obs;


  final serviceAPIs = MyAPIService();

  // Method to save a VolumeModel
  void saveVolume(VolumeModel volume) {
    bool itemExists = volumeList
        .any((item) => item.id == volume.id && item.name == volume.name);
    if (itemExists) {
      int index = volumeList.indexWhere(
          (item) => item.id == volume.id && item.name == volume.name);
      volumeList[index].currentValue = volume.currentValue;
    } else {
      volumeList.add(volume);
    }
    print('All items in volumeList:');
    for (var item in volumeList) {
      print(
          '${item.name} / ${item.id} / ${item.currentValue} / ${item.urlName} / ${item.isShow}');
    }
  }

//show slider volumn model
  VolumeModel? showVolume() {
    var showItem = volumeList.firstWhere(
      (item) => item.isShow,
    );
    if (showItem == null && volumeList.isNotEmpty) {
      showItem = volumeList.first;
    }
    print(
        '${showItem.name} / ${showItem.id} / ${showItem.currentValue} / ${showItem.urlName} / ${showItem.isShow}');
    return showItem;
  }

  void toggleVisible() {
    visible.toggle();
  }

  void toggleSwitch() {
    isSwitch.toggle();
  }

  void toggleHasChangeValueSlider() {
    hasChangeValueSlider.toggle();
  }

  void turnOnVisible() {
    visible.value = true;
  }

  void turnOffVisible() {
    visible.value = false;
  }

  void saveZoomRatio(double value) {
    zoomRatio.value = value;
  }

  void saveDxDy({double? dxValue, double? dyValue}) {
    // if (scale == 0) {
    //   debugPrint('saveDxDy scale = 0 initial size');
    //   dx.value = dxValue!;
    //   dy.value = dyValue!;
    // }
    // else if (scale == 1) {
    //   debugPrint('saveDxDy scale = 1 covering size');
    //   dx.value = dxValue!;
    //   dy.value = dyValue!;
    // }
    // else if (scale == 2) {
    //   debugPrint('saveDxDy scale = 2 original size');
    //   dx.value = dxValue!;
    //   dy.value = dyValue!;
    // }
    // else if (scale == 3) {
    //   debugPrint('saveDxDy scale = 2 zoom in');
    //   dx.value = dxValue!;
    //   dy.value = dyValue!;
    // }
    dx.value = dxValue!;
    dy.value = dyValue!;
  }

  //save value slider
  void saveValueSlider(double value) {
    valueSlider.value = value;
    update();
  }

  //save value slider
  void saveValueSliderAll(double value) {
    valueSliderAll.value = value;
    update();

    serviceAPIs.listVolme().then((value) {
      for (int i = 0; i < value.data.length; i++) {
        serviceAPIs.runDeviceFullURL(
                url: MyString.GET_DEVICE_API(
                    deviceName: value.data[i].deviceName,
                    position: '${valueSliderAll.value}'))
            .whenComplete(() {
          serviceAPIs.updateVolumeValue(value: valueSliderAll.value, id: value.data[i].id);
        });
      }
      //then update volume current value
  });
  }


  //save all id to a list<String>
  void saveStringToList(Rx<String> stringRx) {
    // Listen to changes in the stringRx
    ever(stringRx, (_) {
      // Update the stringList with the new value from stringRx
      stringList.assignAll([stringRx.value]);
    });
    stringList.assignAll([stringRx.value]);
  }
  List<String> getListStringId() {
    return stringList.toList();
  }
}
