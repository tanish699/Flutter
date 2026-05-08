import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {

  List<Contact> contacts = [];

  List<Contact> filteredContacts = [];

  bool isLoading = true;

  final TextEditingController searchController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    fetchContacts();
  }

  // ================= FETCH CONTACTS =================

  Future<void> fetchContacts() async {

    bool permission =
    await FlutterContacts.requestPermission();

    if (permission) {

      final List<Contact> deviceContacts =
      await FlutterContacts.getContacts(
        withProperties: true,
      );

      setState(() {

        contacts = deviceContacts;

        filteredContacts = deviceContacts;

        isLoading = false;
      });

    } else {

      setState(() {
        isLoading = false;
      });
    }
  }

  // ================= SEARCH =================

  void searchContacts(String value) {

    final results = contacts.where((contact) {

      final name =
      contact.displayName.toLowerCase();

      final phone = contact.phones.isNotEmpty
          ? contact.phones.first.number
          : "";

      return name.contains(value.toLowerCase()) ||
          phone.contains(value);

    }).toList();

    setState(() {
      filteredContacts = results;
    });
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            // ================= SEARCH =================

            TextField(

              controller: searchController,

              onChanged: searchContacts,

              decoration: InputDecoration(

                hintText: "Search",

                suffixIcon: const Icon(Icons.search),

                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),

                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.orange,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ================= CONTACT LIST =================

            Expanded(

              child: isLoading

                  ? const Center(
                child: CircularProgressIndicator(),
              )

                  : filteredContacts.isEmpty

                  ? const Center(
                child: Text(
                  "No Contacts Found",
                ),
              )

                  : ListView.builder(

                itemCount: filteredContacts.length,

                itemBuilder: (context, index) {

                  final contact =
                  filteredContacts[index];

                  final phone =
                  contact.phones.isNotEmpty
                      ? contact
                      .phones.first.number
                      : "No Number";

                  return Container(

                    margin: const EdgeInsets.only(
                      bottom: 12,
                    ),

                    padding: const EdgeInsets.all(14),

                    decoration: BoxDecoration(

                      color: Colors.blue.shade50,

                      borderRadius:
                      BorderRadius.circular(14),
                    ),

                    child: Row(

                      children: [

                        // ================= AVATAR =================

                        Container(

                          height: 45,
                          width: 45,

                          decoration: BoxDecoration(

                            color: Colors.orange.shade100,

                            borderRadius:
                            BorderRadius.circular(8),
                          ),

                          child: Center(

                            child: Text(

                              contact.displayName
                                  .isNotEmpty
                                  ? contact.displayName[0]
                                  : "?",

                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight:
                                FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        // ================= NAME + NUMBER =================

                        Expanded(

                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [

                              Text(

                                contact.displayName,

                                style:
                                const TextStyle(
                                  fontSize: 22,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(

                                phone,

                                style:
                                TextStyle(
                                  fontSize: 16,
                                  color: Colors
                                      .grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}