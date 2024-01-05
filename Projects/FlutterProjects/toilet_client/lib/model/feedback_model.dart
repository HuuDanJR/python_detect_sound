

class FeedbackModel {
    final bool status;
    final String message;
    final int totalResult;
    final List<Datum> data;

    FeedbackModel({
        required this.status,
        required this.message,
        required this.totalResult,
        required this.data,
    });

    factory FeedbackModel.fromJson(Map<String, dynamic> json) => FeedbackModel(
        status: json["status"],
        message: json["message"],
        totalResult: json["totalResult"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );
}

class Datum {
    final String id;
    final String datumId;
    final String driver;
    final int star;
    final String content;
    final List<String> experience;
    final DateTime createdAt;
    final int v;

    Datum({
        required this.id,
        required this.datumId,
        required this.driver,
        required this.star,
        required this.content,
        required this.experience,
        required this.createdAt,
        required this.v,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        datumId: json["id"],
        driver: json["driver"],
        star: json["star"],
        content: json["content"],
        experience: List<String>.from(json["experience"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        v: json["__v"],
    );
}







