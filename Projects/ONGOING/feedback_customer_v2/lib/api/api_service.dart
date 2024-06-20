import 'dart:async';
import 'package:dio/dio.dart';
import 'package:feedback_customer/model/staff_model.dart';

const String BASE_URL = 'http://localhost:8095';
// final String BASE_URL = 'http://192.168.101.58:8095';
const String CREATE_FEEDBACK = '$BASE_URL/feedback/create';
const String LIST_STAFF = '$BASE_URL/staff/list';
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
    print('response data from request: ${response.data}');
    return (response.data);
  }

  //
  Future<dynamic> getListAllStaff() async {
    final response = await dio.get(
      LIST_STAFF,
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
    print('response data from request: ${response.data}');
    return StaffModel.fromJson(response.data);
  }
}
