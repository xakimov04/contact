import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../services/database_helper.dart';

class ContactViewModel extends ChangeNotifier {
  List<Contact> _contacts = [];
  List<Contact> _allContacts = []; // Barcha kontaktlar ro'yxati
  List<Contact> get contacts => _contacts;

  Future<void> fetchContacts() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _contacts = await DatabaseHelper.instance.readAllContacts();
      _allContacts = List.from(_contacts); // Barcha kontaktlarni saqlash
      notifyListeners();
    });
  }

  Future<void> addContact(Contact contact) async {
    await DatabaseHelper.instance.create(contact);
    fetchContacts();
  }

  Future<void> updateContact(Contact contact) async {
    await DatabaseHelper.instance.update(contact);
    fetchContacts();
  }

  Future<void> deleteContact(int id) async {
    await DatabaseHelper.instance.delete(id);
    fetchContacts();
  }

  void searchContacts(String query) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (query.isEmpty) {
        _contacts = List.from(_allContacts); // Agar qidiruv bo'lmasa, barcha kontaktlarni ko'rsatish
      } else {
        final contacts = _allContacts.where((contact) {
          final nameLower = contact.name.toLowerCase();
          final phoneLower = contact.phone.toLowerCase();
          final searchLower = query.toLowerCase();

          return nameLower.contains(searchLower) || phoneLower.contains(searchLower);
        }).toList();

        _contacts = contacts;
      }
      notifyListeners();
    });
  }
}
