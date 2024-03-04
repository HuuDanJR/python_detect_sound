// To parse this JSON data, do
//
//     final volumeListModel = volumeListModelFromJson(jsonString);

import 'dart:convert';

VolumeListModel volumeListModelFromJson(String str) => VolumeListModel.fromJson(json.decode(str));

String volumeListModelToJson(VolumeListModel data) => json.encode(data.toJson());

class VolumeListModel {
    final bool status;
    final String message;
    final List<Volume> data;

    VolumeListModel({
        required this.status,
        required this.message,
        required this.data,
    });

    factory VolumeListModel.fromJson(Map<String, dynamic> json) => VolumeListModel(
        status: json["status"],
        message: json["message"],
        data: List<Volume>.from(json["data"].map((x) => Volume.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Volume {
    final String id;
    final String VolumeId;
    final String name;
    final String deviceName;
    final bool isSync;
    final String url;
    final DateTime createdAt;
    final double minValue;
    final double maxValue;
    final double currentValue;
    final String presetId;
    final int v;

    Volume({
        required this.id,
        required this.VolumeId,
        required this.name,
        required this.deviceName,
        required this.isSync,
        required this.url,
        required this.createdAt,
        required this.minValue,
        required this.maxValue,
        required this.currentValue,
        required this.presetId,
        required this.v,
    });

    factory Volume.fromJson(Map<String, dynamic> json) => Volume(
        id: json["_id"] ?? 0,
        VolumeId: json["id"] ?? "default",
        name: json["name"] ?? 'name',
        deviceName: json["deviceName"] ??"deviceName",
        isSync: json["isSync"]??false,
        url: json["url"]??"",
        createdAt: DateTime.parse(json["createdAt"]) ?? DateTime.now(),
        minValue: json["minValue"]?.toDouble() ?? 0.0,
        maxValue: json["maxValue"]?.toDouble() ?? 0.0,
        currentValue: json["currentValue"]?.toDouble() ?? 0.0,
        presetId: json["presetId"]??"presetDefault",
        v: json["__v"]??"",
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "id": VolumeId,
        "name": name,
        "deviceName": deviceName,
        "isSync": isSync,
        "url": url,
        "createdAt": createdAt.toIso8601String(),
        "minValue": minValue,
        "maxValue": maxValue,
        "currentValue": currentValue,
        "presetId": presetId,
        "__v": v,
    };
}
