// To parse this JSON data, do
//
// final staffModel = staffModelFromJson(jsonString);

import 'dart:convert';

StaffModel staffModelFromJson(String str) => StaffModel.fromJson(json.decode(str));

String staffModelToJson(StaffModel data) => json.encode(data.toJson());

class StaffModel {
    bool status;
    String message;
    int totalResult;
    List<StaffModelData> data;

    StaffModel({
        required this.status,
        required this.message,
        required this.totalResult,
        required this.data,
    });

    factory StaffModel.fromJson(Map<String, dynamic> json) => StaffModel(
        status: json["status"],
        message: json["message"],
        totalResult: json["totalResult"],
        data: List<StaffModelData>.from(json["data"].map((x) => StaffModelData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "totalResult": totalResult,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class StaffModelData {
    String id;
    String code;
    String usernameEn;
    String username;
    String imageUrl;
    String role;
    DateTime createdAt;
    bool isActive;
    int v;

    StaffModelData({
        required this.id,
        required this.code,
        required this.usernameEn,
        required this.username,
        required this.imageUrl,
        required this.role,
        required this.createdAt,
        required this.isActive,
        required this.v,
    });

    factory StaffModelData.defaultInstance() {
    return StaffModelData(
        id: 'default',
        code: 'default',
        usernameEn: 'default',
        username: 'default',
        imageUrl: 'https://t4.ftcdn.net/jpg/00/23/72/59/360_F_23725944_W2aSrg3Kqw3lOmU4IAn7iXV88Rnnfch1.jpg',
        role: 'default',
        createdAt: DateTime.now(),
        isActive: false,
        v:0,
    );
    }
    factory StaffModelData.fromJson(Map<String, dynamic> json) => StaffModelData(
        id: json["_id"],
        code: json["code"],
        usernameEn: json["username_en"],
        username: json["username"],
        imageUrl: json["image_url"],
        role: json["role"],
        createdAt: DateTime.parse(json["createdAt"]),
        isActive: json["isActive"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "code": code,
        "username_en": usernameEn,
        "username": username,
        "image_url": imageUrl,
        "role": role,
        "createdAt": createdAt.toIso8601String(),
        "isActive": isActive,
        "__v": v,
    };
}
