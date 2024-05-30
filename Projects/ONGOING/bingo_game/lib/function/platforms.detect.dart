import 'package:flutter/foundation.dart';


  bool detectPlatform() {
    bool myvalue = false;
    myvalue = kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android);
    return myvalue;
  }

