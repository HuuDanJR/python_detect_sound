import 'dart:async';
import 'package:bingo_game/model/gameplay.dart';
import 'package:bingo_game/page/game/left/export.dart';
import 'package:bingo_game/page/game/right/export.dart';
import 'package:dio/dio.dart';

class ServiceAPIs {
  Dio dio = Dio();
  final Duration receiveAndSendTimeout = const Duration(seconds: 720);

  Future<dynamic> listGamePlayed() async {
    debugPrint('listGamePlayed ->');
    final response = await dio.get(
      ConfigFactory.list_gamePlayed,
      options: Options(
        receiveTimeout: receiveAndSendTimeout,
        sendTimeout: receiveAndSendTimeout,
        contentType: Headers.jsonContentType,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    // debugPrint('list game played data:  ${response.data}');
    return GamePlay.fromJson(response.data);
  }


  Future<dynamic> createNewGame({required  createAt,required String game_name,required bool enable,required List<int> round}) async {
     Map<String, dynamic> body = {
      "game_name": game_name,
      "enable": enable,
      "round": round,
      "createAt":createAt,
    };
    debugPrint('createNewGame ->');
    final response = await dio.post(
      ConfigFactory.createNewGame,
      data: body,
      options: Options(
        receiveTimeout: receiveAndSendTimeout,
        sendTimeout: receiveAndSendTimeout,
        contentType: Headers.jsonContentType,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    // debugPrint('list game played data:  ${response.data}');
    return (response.data);
  }

  Future<dynamic> listDisplayTopRankingStatus() async {
    final response = await dio.get(
      ConfigFactory.list_display,
      options: Options(
        receiveTimeout: receiveAndSendTimeout,
        sendTimeout: receiveAndSendTimeout,
        contentType: Headers.jsonContentType,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    debugPrint('${response.data}');
    return response.data;
  }

  //update display status
  Future<dynamic> updateDisplayTopRankingStatus(
      {required String id, String? name, required bool? enable}) async {
    Map<String, dynamic> body = {
      "name": "display_top_ranking",
      "enable": enable,
      "content": "display_top_ranking_content"
    };
    final response = await dio.put(
      ConfigFactory.update_display(id),
      data: body,
      options: Options(
        receiveTimeout: receiveAndSendTimeout,
        sendTimeout: receiveAndSendTimeout,
        contentType: Headers.jsonContentType,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    debugPrint('${response.data}');
    return (response.data);
  }
}
