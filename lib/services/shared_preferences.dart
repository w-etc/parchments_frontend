import 'package:parchments_flutter/constants/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<int> getWriterId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt(WRITER_ID);
}

Future<void> setWriterId(int writerId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt(WRITER_ID, writerId);
}