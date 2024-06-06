import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider12/provider.dart';
import '../viewmodels/contact_viewmodel.dart';
import '../models/contact.dart';
import 'contact_form.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactList extends StatefulWidget {
  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ContactViewModel>(context, listen: false).fetchContacts();
    });
    Provider.of<ContactViewModel>(context, listen: false).fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    final contactViewModel = Provider.of<ContactViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts',
            style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon:const  Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: ContactSearchDelegate(contactViewModel));
            },
          ),
        ],
      ),
      body: contactViewModel.contacts.isEmpty
          ? Center(
              child: Text('No contacts found',
                  style: GoogleFonts.lato(fontSize: 18)))
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8),
              itemCount: contactViewModel.contacts.length,
              itemBuilder: (context, index) {
                final contact = contactViewModel.contacts[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Slidable(
                    key: ValueKey(contact.id),
                    startActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ContactForm(contact: contact),
                              ),
                            );
                          },
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            contactViewModel.deleteContact(contact.id!);
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Text(contact.name[0],
                            style: TextStyle(color: Colors.white)),
                      ),
                      title: Text(contact.name,
                          style: GoogleFonts.lato(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      subtitle: Text(contact.phone,
                          style: GoogleFonts.lato(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContactForm(contact: contact),
                          ),
                        );
                      },
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      tileColor: Colors.grey.shade200,
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContactForm(),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Groups',
          ),
        ],
        selectedItemColor: Colors.redAccent,
      ),
    );
  }
}

class ContactSearchDelegate extends SearchDelegate {
  final ContactViewModel contactViewModel;

  ContactSearchDelegate(this.contactViewModel);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    contactViewModel.searchContacts(query);
    return ListView.builder(
      itemCount: contactViewModel.contacts.length,
      itemBuilder: (context, index) {
        final contact = contactViewModel.contacts[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Text(contact.name[0], style: TextStyle(color: Colors.white)),
          ),
          title: Text(contact.name,
              style:
                  GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w600)),
          subtitle: Text(contact.phone, style: GoogleFonts.lato(fontSize: 16)),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          tileColor: Colors.grey.shade200,
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    contactViewModel.searchContacts(query);
    return ListView.builder(
      itemCount: contactViewModel.contacts.length,
      itemBuilder: (context, index) {
        final contact = contactViewModel.contacts[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Text(contact.name[0], style: TextStyle(color: Colors.white)),
          ),
          title: Text(contact.name,
              style:
                  GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w600)),
          subtitle: Text(contact.phone, style: GoogleFonts.lato(fontSize: 16)),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          tileColor: Colors.grey.shade200,
        );
      },
    );
  }
}
