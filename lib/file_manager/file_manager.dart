import 'package:login_page/model/User/contact.dart';

import 'package:json_store/json_store.dart';
import 'package:sqflite_common/sqlite_api.dart';

class FileManager {
  JsonStore jsonStore = JsonStore();
  saveBigList(List<Contact> contacts) async {
    List<Contact> localContacts = await loadBigList();
    for (var item in localContacts) {
      if (checkExitsItem(item, contacts) == false) {
        await jsonStore.deleteItem('contacts-${item.uid}');
      }
    }

    Batch batch = await jsonStore.startBatch();
    await Future.forEach(contacts, (contact) async {
      Contact data = contact as Contact;
      await jsonStore.setItem(
        'contacts-${data.uid}',
        data.toJson(),
        batch: batch,
      );
    });
    await jsonStore.commitBatch(batch);
  }

  bool checkExitsItem(Contact contact, List<Contact> contacts) {
    for (var item in contacts) {
      if (contact.uid == item.uid) {
        return true;
      }
    }
    return false;
  }

  clearDatatbase() async {
    await jsonStore.clearDataBase();
  }

  Future<List<Contact>> loadBigList() async {
    List<Contact> contacts = [];
    List<Map<String, dynamic>>? json =
        await jsonStore.getListLike('contacts-%');
    contacts = json != null
        ? json.map((messageJson) => Contact.fromJson(messageJson)).toList()
        : [];

    return contacts;
  }

  FileManager() {
    jsonStore = JsonStore();
  }
}
