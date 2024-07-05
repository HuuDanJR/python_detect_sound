
import 'package:feedback_customer/model/staff_model.dart';

class Info {
  String suggestionName;
  int customerNumber;
  String customerName;
  String nationality; // default EN | JP | KR | CN
  String languageApp;
  List<String> serviceBad;
  List<String> serviceGood;
  bool hasNote; // is there anything you would like to convey to the mangaer top enhance our service?
  String note;
  bool hasEnterInputMemory;
  StaffModelData staff;
  bool reachResultPage; //finish all the steps

  Info({required this.suggestionName, required this.customerName,
   required this.customerNumber,required this.nationality,required this.languageApp,required this.serviceBad,required this.serviceGood,
   required this.hasNote,required this.note,
   required this.hasEnterInputMemory,required this.staff,
   required this.reachResultPage});
}
