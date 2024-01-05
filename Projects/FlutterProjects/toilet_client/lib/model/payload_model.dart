// import 'dart:convert';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:get/get.dart';

// class PayloadModel {
//   PayloadModel({
//     required this.route,
//     required this.orderId,
//     required this.title,
//     required this.body,
//     required this.imageUrl,
//   });

//   factory PayloadModel.fromJsonString(String str) =>
//       PayloadModel._fromJson(json.decode(str));

//   String toJsonString() => jsonEncode(_toJson());

//   factory PayloadModel._fromJson(Map<String, dynamic> json) => PayloadModel(
//         route: json['route'],
//         orderId: json['orderId'],
//         title: json['title'],
//         body: json['body'],
//         imageUrl: json['imageUrl'],
//   );

//   factory PayloadModel.fromMessage(RemoteMessage message) => PayloadModel(
//         route: message.data.containsKey('route') ? message.data['route'] : null,
//         orderId: message.data.containsKey('orderId')
//             ? message.data['orderId']
//             : null,
//         title: message.data.containsKey('title') ? message.data['title'] : null,
//         body: message.data.containsKey('body') ? message.data['body'] : null,
//         imageUrl: message.data.containsKey('imageUrl')
//             ? message.data['imageUrl']
//             : null,
//       );

//   Map<String, dynamic> _toJson() => {
//         'route': route,
//         'orderId': orderId,
//         'title': title,
//         'body': body,
//         'imageUrl': imageUrl,
//       };

//   bool get isDataIsNullEmpty => route!.isNull && orderId!.isEmpty;

//   String? route;
//   String? orderId;
//   String? title;
//   String? body;
//   String? imageUrl;

//   @override
//   String toString() {
//     return 'route: $route, orderId: $orderId, title: $title, body: $body, imageUrl: $imageUrl';
//   }
// }
