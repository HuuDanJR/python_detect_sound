import 'dart:async';
import 'package:bingo_game/page/game/left/export.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketManager {
  static final SocketManager _instance = SocketManager._();
  factory SocketManager() {
    return _instance;
  }

  IO.Socket? _socket;
  late StreamController<List<Map<String, dynamic>>> _streamController;
  late StreamController<List<Map<String, dynamic>>> _streamControllerBanner;

  IO.Socket? get socket => _socket;

  Stream<List<Map<String, dynamic>>> get dataStream => _streamController.stream;
  Stream<List<Map<String, dynamic>>> get dataStreamBanner => _streamControllerBanner.stream;

  SocketManager._() {
    _streamController =StreamController<List<Map<String, dynamic>>>.broadcast();
    _streamControllerBanner =StreamController<List<Map<String, dynamic>>>.broadcast();
  }

  void initSocket() {
    _socket = IO.io(StringFactory.URL_SOCKET, <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
    });

    _socket?.on('eventFromServer', (data) {
      // debugPrint('eventFromServer log: $data');
      processData(data);
    });
    _socket?.on('eventBannerFromServer', (data) {
      // debugPrint('eventFromServer log: $data');
      processDataBanner(data);
    });
    _socket?.connect();
  }

  void connectSocket() {
    _socket?.connect();
  }

  void disposeSocket() {
    _socket?.disconnect();
    _socket = null;
  }

  void processData(dynamic data) {
    List<Map<String, dynamic>> resultData = [];
    try {
      // Convert dynamic data to a list of Map<String, dynamic>
      List<dynamic> dataList = data as List<dynamic>;
      resultData =dataList.map((item) => item as Map<String, dynamic>).toList();
    } catch (e) {
      debugPrint('Error parsing data: $e');
    }
    _streamController.add(resultData);
    //process here
    _streamController.add(resultData);
  }
  void processDataBanner(dynamic data) {
    List<Map<String, dynamic>> resultData = [];
    try {
      // Convert dynamic data to a list of Map<String, dynamic>
      List<dynamic> dataList = data as List<dynamic>;
      resultData =dataList.map((item) => item as Map<String, dynamic>).toList();
    } catch (e) {
      debugPrint('Error parsing data: $e');
    }
    _streamControllerBanner.add(resultData);
    //process here
    _streamControllerBanner.add(resultData);
  }

  Future<void> eventChangeSlide(int index) async {
    socket!.emit('eventChangeSlide',index);
  }
  Future<void> eventChangeBanner(int index) async {
    socket!.emit('eventChangeBanner',index);
  }


  
}
