import 'dart:async';
import 'package:dio/dio.dart';
import 'package:feedback_customer/model/nationality.dart';
import 'package:feedback_customer/model/result_feedback.dart';
import 'package:feedback_customer/model/staff_model.dart';
import 'package:flutter/material.dart';

const String HOST = '192.168.101.58';
// const String HOST = 'localhost';
const String BASE_URL = 'http://$HOST:8095';
const String CREATE_FEEDBACK = '$BASE_URL/feedback/create';
const String LIST_STAFF = '$BASE_URL/staff/list';
const String LIST_STAFF_shuffle = '$BASE_URL/staff/list_shuffle';
const String NATINALITY_BY_CUSTOMER = 'http://$HOST:8090/api/user_nationality';
const String CREATE_FEEDBACK_V2 = '$BASE_URL/feedback_v2/create';
const String TAG_PRODUCT = 'production';
const String TAG_DEV = 'testing';

class ServiceAPIs {
  Dio dio = Dio();

  Future<dynamic> createFeedback(
      {required String tag,
      required int id,
      required String content,
      required List<String> exp}) async {
    List<String> sanitizedExp = exp.map((e) => e.replaceAll('\n', '')).toList();

    Map<String, dynamic> body = {
      "id": id,
      "content": content,
      "experience": sanitizedExp,
      "tag": tag
    };

    final response = await dio.post(
      CREATE_FEEDBACK,
      data: body,
      options: Options(
        contentType: Headers.jsonContentType,
        receiveTimeout: const Duration(seconds: 10000),
        sendTimeout: const Duration(seconds: 10000),
        followRedirects: false,
        validateStatus: (status) {
          return true;
        },
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    // print('response data from request: ${response.data}');
    return (response.data);
  }

  //get list all staff
  Future<StaffModel> getListAllStaff() async {
    final response = await dio.get(
      LIST_STAFF_shuffle,
      options: Options(
        contentType: Headers.jsonContentType,
        receiveTimeout: const Duration(seconds: 10000),
        sendTimeout: const Duration(seconds: 10000),
        followRedirects: false,
        validateStatus: (status) {
          return true;
        },
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    // print('response data from request: ${response.data}');
    return StaffModel.fromJson(response.data);
  }



  //get list all staff
  Future<Natinality> getNationalityByCustomer(number) async {
    Map<String, dynamic> body = {
      "number": number,
    };
    final response = await dio.post(
      NATINALITY_BY_CUSTOMER,
      data: body,
      options: Options(
        contentType: Headers.jsonContentType,
        receiveTimeout: const Duration(seconds: 10000),
        sendTimeout: const Duration(seconds: 10000),
        followRedirects: false,
        validateStatus: (status) {
          return true;
        },
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    // debugPrint('getNationalityByCustomer: ${response.data}');
    return Natinality.fromJson(response.data);
  }

  




  Future<ResultFeedBack> createFeedBackV2({
  required String statusName,
  required String customerNumber,
  required String customerName,
  required String customerCode,
  required String customerNatinality,
  required String note,
  required String hasNote,
  required List<String> service_good,
  required List<String> service_bad,
  required String staffNameEn,
  required String staffName,
  required String staffCode,
  required String staffRole,
  required String tag,
}) async {
  Map<String, dynamic> body = {
    'statusName': statusName,
    'customerNumber': customerNumber,
    'customerName': customerName,
    'customerCode': customerCode,
    'customerNatinality': customerNatinality,
    'note': note,
    'hasNote': hasNote,
    'service_good': service_good,
    'service_bad': service_bad,
    'staffNameEn': staffNameEn,
    'staffName': staffName,
    'staffCode': staffCode,
    'staffRole': staffRole,
    'tag': tag,
  };

  final response = await dio.post(
    CREATE_FEEDBACK_V2,
    data: body,
    options: Options(
      contentType: Headers.jsonContentType,
      receiveTimeout: const Duration(seconds: 10000),
      sendTimeout: const Duration(seconds: 10000),
      followRedirects: false,
      validateStatus: (status) {
        return true;
      },
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
      },
    ),
  );

  debugPrint('createFeedBackV2 response.data: ${response.data}');
  return ResultFeedBack.fromJson(response.data);
}

}
