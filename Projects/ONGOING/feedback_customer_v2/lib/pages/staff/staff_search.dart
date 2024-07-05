import 'package:feedback_customer/pages/staff/staff_search_view.dart';
import 'package:flutter/material.dart';

class StaffSearch extends StatelessWidget {
  final double widthArea;
  final double heightTextField;

  const StaffSearch({
    super.key,
    required this.widthArea,
    required this.heightTextField,
  });

  @override
  Widget build(BuildContext context) {
    return StaffSearchView(
      widthArea: widthArea,
      heightTextField: heightTextField,
    );
  }
}
