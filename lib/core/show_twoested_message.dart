import 'package:fluttertoast/fluttertoast.dart';

void showTwoestedMessage(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    timeInSecForIosWeb: 2,
    fontSize: 14.0,
  );
}
