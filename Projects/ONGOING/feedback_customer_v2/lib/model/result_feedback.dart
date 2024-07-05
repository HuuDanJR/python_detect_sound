// To parse this JSON data, do
//
//     final resultFeedBack = resultFeedBackFromJson(jsonString);

import 'dart:convert';

ResultFeedBack resultFeedBackFromJson(String str) => ResultFeedBack.fromJson(json.decode(str));

String resultFeedBackToJson(ResultFeedBack data) => json.encode(data.toJson());

class ResultFeedBack {
    bool status;
    String message;
    ResultFeedBackData data;

    ResultFeedBack({
        required this.status,
        required this.message,
        required this.data,
    });

    factory ResultFeedBack.fromJson(Map<String, dynamic> json) => ResultFeedBack(
        status: json["status"],
        message: json["message"],
        data: ResultFeedBackData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
    };
}

class ResultFeedBackData {
    String statusName;
    int customerNumber;
    String customerName;
    String customerCode;
    String customerNatinality;
    String note;
    bool hasNote;
    List<String> serviceGood;
    List<String> serviceBad;
    String staffNameEn;
    String staffName;
    String staffCode;
    String staffRole;
    String tag;
    String id;
    String createdAt;
    int v;

    ResultFeedBackData({
        required this.statusName,
        required this.customerNumber,
        required this.customerName,
        required this.customerCode,
        required this.customerNatinality,
        required this.note,
        required this.hasNote,
        required this.serviceGood,
        required this.serviceBad,
        required this.staffNameEn,
        required this.staffName,
        required this.staffCode,
        required this.staffRole,
        required this.tag,
        required this.id,
        required this.createdAt,
        required this.v,
    });

    factory ResultFeedBackData.fromJson(Map<String, dynamic> json) => ResultFeedBackData(
        statusName: json["statusName"],
        customerNumber: json["customerNumber"],
        customerName: json["customerName"],
        customerCode: json["customerCode"],
        customerNatinality: json["customerNatinality"],
        note: json["note"],
        hasNote: json["hasNote"],
        serviceGood: List<String>.from(json["service_good"].map((x) => x)),
        serviceBad: List<String>.from(json["service_bad"].map((x) => x)),
        staffNameEn: json["staffNameEn"],
        staffName: json["staffName"],
        staffCode: json["staffCode"],
        staffRole: json["staffRole"],
        tag: json["tag"],
        id: json["_id"],
        createdAt: json["createdAt"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "statusName": statusName,
        "customerNumber": customerNumber,
        "customerName": customerName,
        "customerCode": customerCode,
        "customerNatinality": customerNatinality,
        "note": note,
        "hasNote": hasNote,
        "service_good": List<dynamic>.from(serviceGood.map((x) => x)),
        "service_bad": List<dynamic>.from(serviceBad.map((x) => x)),
        "staffNameEn": staffNameEn,
        "staffName": staffName,
        "staffCode": staffCode,
        "staffRole": staffRole,
        "tag": tag,
        "_id": id,
        "createdAt": createdAt,
        "__v": v,
    };
}
