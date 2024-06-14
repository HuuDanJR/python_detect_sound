import 'dart:convert';

GamePlay gamePlayFromJson(String str) => GamePlay.fromJson(json.decode(str));

String gamePlayToJson(GamePlay data) => json.encode(data.toJson());

class GamePlay {
    bool status;
    String message;
    int totalResult;
    List<GamePlayData> data;

    GamePlay({
        required this.status,
        required this.message,
        required this.totalResult,
        required this.data,
    });

    factory GamePlay.fromJson(Map<String, dynamic> json) => GamePlay(
        status: json["status"],
        message: json["message"],
        totalResult: json["totalResult"],
        data: List<GamePlayData>.from(json["data"].map((x) => GamePlayData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "totalResult": totalResult,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class GamePlayData {
    String id;
    String gameName;
    DateTime createdAt;
    bool enable;
    List<int> round;
    int v;

    GamePlayData({
        required this.id,
        required this.gameName,
        required this.createdAt,
        required this.enable,
        required this.round,
        required this.v,
    });

    factory GamePlayData.fromJson(Map<String, dynamic> json) => GamePlayData(
        id: json["_id"],
        gameName: json["game_name"],
        createdAt: DateTime.parse(json["createdAt"]),
        enable: json["enable"],
        round: List<int>.from(json["round"].map((x) => x)),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "game_name": gameName,
        "createdAt": createdAt.toIso8601String(),
        "enable": enable,
        "round": List<dynamic>.from(round.map((x) => x)),
        "__v": v,
    };
}
