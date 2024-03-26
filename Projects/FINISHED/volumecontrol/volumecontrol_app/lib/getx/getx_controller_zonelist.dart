import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volumn_control/api/api_service.dart';
import 'package:volumn_control/model/volume_list_model.dart';

class ZoneListController extends GetxController {
  
  ZoneListController();

  final RxList<Volume> volumes = <Volume>[].obs;

  @override
  void onInit() {
    fetchVolumes();
    super.onInit();
  }

  Future<void> fetchVolumes() async {
    final  serviceAPIs=MyAPIService();
    try {
      final result = await serviceAPIs.listVolme();
      volumes.value = result.data;
      debugPrint('fetchVolumes ${result.data.length}');
    } catch (e) {
      print('Error fetching volumes: $e');
    }
  }

  void updateVolumeList() async {
    await fetchVolumes();
  }
}