import 'package:cloud_firestore/cloud_firestore.dart';

class NoteService {
  final CollectionReference _database =
      FirebaseFirestore.instance.collection('note list');

  Stream<Map<String, String>> getNoteList() {
    return _database.snapshots().map((QuerySnapshot) {
      final Map<String, String> items = {};
      QuerySnapshot.docs.map((docSnapshot) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        if (data.containsKey('title')) {
          Map<dynamic, dynamic> values = data as Map<dynamic, dynamic>;
          values.forEach((key, value) {
            items[key] = value['title'] as String;
          });
        }
      });
      return items;
    });
  }

  void addNoteList(String nama, String alamat, String balance) {
    _database.doc().set({'name': nama, 'address': alamat, 'balance': balance});
  }

  Future<void> removeNoteList(String key) async {
    await _database.doc(key).delete();
  }
}
