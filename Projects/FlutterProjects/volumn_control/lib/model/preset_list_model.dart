// To parse this JSON data, do
//
//     final presetListModel = presetListModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'package:volumn_control/model/volume_list_model.dart';

PresetListModel presetListModelFromJson(String str) => PresetListModel.fromJson(json.decode(str));


class PresetListModel {
    final bool status;
    final String message;
    final List<Datum> data;

    PresetListModel({
        required this.status,
        required this.message,
        required this.data,
    });

    factory PresetListModel.fromJson(Map<String, dynamic> json) => PresetListModel(
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

   
}

class Datum {
    final String id;
    final String presetId;
    final String presetName;
    final DateTime createdAt;
    final List<Volume> volumes;
    final int v;

    Datum({
        required this.id,
        required this.presetId,
        required this.presetName,
        required this.createdAt,
        required this.volumes,
        required this.v,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        presetId: json["presetId"],
        presetName: json["presetName"],
        createdAt: DateTime.parse(json["createdAt"]),
        volumes: List<Volume>.from(json["volumes"].map((x) => Volume.fromJson(x))),
        v: json["__v"],
    );

    
}


