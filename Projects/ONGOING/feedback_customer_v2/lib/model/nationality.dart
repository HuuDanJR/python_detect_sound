class Natinality {
    bool status;
    String message;
    List<NatinalityDatum> data;

    Natinality({
        required this.status,
        required this.message,
        required this.data,
    });

    factory Natinality.fromJson(Map<String, dynamic> json) => Natinality(
        status: json["status"],
        message: json["message"],
        data: List<NatinalityDatum>.from(json["data"].map((x) => NatinalityDatum.fromJson(x))),
    );
   
}

class NatinalityDatum {
    int number;
    String title;
    String preferredName;
    String isoCode2;
    List<String> nationality;

    NatinalityDatum({
        required this.number,
        required this.title,
        required this.preferredName,
        required this.isoCode2,
        required this.nationality,
    });

    factory NatinalityDatum.fromJson(Map<String, dynamic> json) => NatinalityDatum(
        number: json["Number"],
        title: json["Title"],
        preferredName: json["PreferredName"],
        isoCode2: json["ISOCode2"],
        nationality: List<String>.from(json["Nationality"].map((x) => x)),
    );
    
}
