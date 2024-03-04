import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:volumn_control/model/preset_list_model.dart';
import 'package:volumn_control/model/volume_list_model.dart';
import 'package:volumn_control/public/myAPIstring.dart';

class MyAPIService {
  Dio dio = Dio();
  final myDio = Dio();

  Future runDevice({deviceName, position}) async {
    final myString = MyString.GET_DEVICE_API(
        deviceName: deviceName, position: position.toString());
    print('runDevice string ${myString}');
    debugPrint(myString);
    final response = await dio.get(
      myString,
      options: Options(
        contentType: Headers.jsonContentType,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    print('runDevice ${response.data}');
    return response.data;
  }

  Future runDeviceFullURL({required url}) async {
    final myString = MyString.GET_DEVICE_API_FULLURL(url);
    print('runDeviceFullURL $myString');
    final response = await dio.get(
      MyString.GET_DEVICE_API_FULLURL(url),
      options: Options(
        contentType: Headers.jsonContentType,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    print('runDeviceFullURL ${response.data}');
    return response.data;
  }

  Future<VolumeListModel> listVolme({endpoint}) async {
    final response = await dio.get(
      MyString.GET_LIST_VOLUME('list_volume'),
      options: Options(
        contentType: Headers.jsonContentType,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    // print(response.data);
    return VolumeListModel.fromJson(response.data);
  }

  Future<dynamic> updateVolumeValue({value, id}) async {
    final Map<String, dynamic> body = {
      "currentValue": value,
    };
    final response = await dio.post(
      MyString.UPDATE_VOLUME_VALUE(endpoint: 'update_volume_value', id: id),
      data: body,
      options: Options(
        contentType: Headers.jsonContentType,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    return (response.data);
  }

  Future<PresetListModel> listPreset({value, id}) async {
    final Map<String, dynamic> body = {
      "currentValue": value,
    };
    final response = await dio.get(
      MyString.GET_PRESET_LIST(endpoint: 'list_preset'),
      data: body,
      options: Options(
        contentType: Headers.jsonContentType,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    return PresetListModel.fromJson(response.data);
  }

  //CREATE PRESET 
  Future createPreset({
    required String presetID,
    required String  presetName,
    List<Volume>? volumes,
  }) async {
    try {
      Map<String, dynamic> body = {
        "presetId":presetID,
        "presetName":presetName,
        "volumes": volumes,
      };
      final response = await dio.post(
        MyString.CREATE_PRESET(endpoint: 'create_preset'),
        data: body,
        options: Options(
            contentType: Headers.jsonContentType,
            sendTimeout: const Duration(seconds: 10)),
      );
      return response.data;
    } catch (e) {
      print('Error: $e');
      rethrow; 
    }
  }
}
