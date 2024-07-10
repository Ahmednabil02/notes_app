import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class HiveHelper {
  static const notesBox = "note_box";
  static const notesBoxKey = "note_box_key";

  static var box = Hive.box(notesBox);
  static List<String> noteslist = [];
  static void add(String text) async {
    noteslist.add(text);
    await box.put(notesBoxKey, noteslist);
  }

  static void remove(int index) async {
    noteslist.removeAt(index);
    await box.put(notesBoxKey, noteslist);
  }

  static void clearList() async {
    noteslist.clear();
    await box.put(notesBoxKey, noteslist);
  }

  static void getnote() {
    if (box.isNotEmpty) {
      noteslist = box.get(notesBoxKey);
    }
  }
}
