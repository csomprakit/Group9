import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fast_contacts/fast_contacts.dart';

class importContacts extends StatefulWidget {
  const importContacts({super.key});

  @override
  State<importContacts> createState() => _importContactsState();
}

class _importContactsState extends State<importContacts> {

  Future<List<Contact>> getContacts() async {
    bool isGranted = await Permission.contacts.status.isGranted;
    if (!isGranted) {
      isGranted = await Permission.contacts.request().isGranted;
    }
    if (isGranted) {
      return await FastContacts.getAllContacts();
    }
    return [];
  }

  Future<void> shareDownloadLink(String contactName) async {
    final _message = 'Check out this Recipe book app! Download link: link';

    await FlutterShare.share(
      title: 'Download Recipe Book App',
      text: _message,
    );
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Contact List"),
          backgroundColor: Colors.orangeAccent,
        ),
        body: Container(
          height: double.infinity,
          child: FutureBuilder(
            future: getContacts(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(
                  child:
                  SizedBox(height: 50, child: CircularProgressIndicator()),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    Contact contact = snapshot.data[index];
                    return Column(children: [
                      ListTile(
                        leading: const CircleAvatar(
                          radius: 20,
                          child: Icon(Icons.person),
                        ),
                        title: Text(contact.displayName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (contact.phones.isNotEmpty)
                              Text(contact.phones[0].toString()),
                            if (contact.emails.isNotEmpty)
                              Text(contact.emails[0].toString()),
                          ],
                        ),
                        onTap: () {
                          shareDownloadLink(contact.displayName);
                        },
                      ),
                      const Divider()
                    ]);
                  });
            },
          ),
        ),
      ),
    );
  }

}