import 'package:dio/dio.dart';
import 'package:toilet_client/model/feedback_model.dart';
import 'package:toilet_client/utils/mystring.dart';

class MyAPIService {
  Dio dio = Dio();

  //send notification
  Future<dynamic> sendNotification(
      {registrationToken, title, body, star, List<String>? feedback}) async {
    Map<String, dynamic> mybody = {
      "registrationToken": "$registrationToken",
      "title": "$title",
      "body": "$body",
      "message": "message",
      "star": "$star",
      "feedback": feedback
    };
    final response = await dio.post(
      '${MyString.CREATE_NOTI_ALL}',
      data: mybody,
      options: Options(
        contentType: Headers.jsonContentType,
      ),
    );
    return response.data;
  }

  Future createFeedBack({
    driver,
    star,
    content,
    List<String>? experience,
  }) async {
    try {
      Map<String, dynamic> body = {
        "driver": "$driver" ?? "DEFAUTL DRIVER",
        "star": star ?? 5,
        "content": "$content" ?? "DEFAULT CONTENT",
        "experience": experience ?? [],
        "createdAt": DateTime.now().toString(),
        "isprocess": false,
        "processcreateAt": DateTime.now().toString(),
      };
      final response = await dio.post(
        MyString.CREATE_FEEDBACK_STATUS,
        data: body,
        options: Options(
            contentType: Headers.jsonContentType,
            sendTimeout: const Duration(seconds: 10)),
      );
      // print('response: ${response.data}');
      return response.data;
    } catch (e) {
      // Handle DioError or other exceptions
      print('Error: $e');
      throw e; // You can throw the error again if needed
    }
  }

  Future<FeedbackModel> fetchFeedBack() async {
    final response = await dio.get(
      MyString.LIST_FEEDBACK,
      options: Options(
        contentType: Headers.jsonContentType,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    return FeedbackModel.fromJson(response.data);
  }
}
