

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    final bool status;
    final String message;
    final int totalResult;
    final List<Datum> data;

    UserModel({
        required this.status,
        required this.message,
        required this.totalResult,
        required this.data,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        status: json["status"],
        message: json["message"],
        totalResult: json["totalResult"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "totalResult": totalResult,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    final String? id;
    final int? idUser;
    final String? usernameEn;
    final String? username;
    final String? imageUrl;
    final String? password;
    final DateTime createdAt;
    final int v;

    Datum({
        required this.id,
        required this.idUser,
        required this.usernameEn,
        required this.username,
        required this.imageUrl,
        required this.password,
        required this.createdAt,
        required this.v,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        idUser: json["id_user"],
        usernameEn: json["username_en"],
        username: json["username"],
        imageUrl: json["image_url"],
        password: json["password"],
        createdAt: DateTime.parse(json["createdAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "id_user": idUser,
        "username_en": usernameEn,
        "username": username,
        "image_url": imageUrl,
        "password": password,
        "createdAt": createdAt.toIso8601String(),
        "__v": v,
    };
}
