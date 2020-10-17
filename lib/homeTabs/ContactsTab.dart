import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterwhatsapp/model/Contact.dart';
import 'package:flutterwhatsapp/model/FirebaseUserData.dart';
import 'package:flutterwhatsapp/model/User.dart';
import 'package:flutterwhatsapp/resources/AppColors.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterwhatsapp/resources/AppStrings.dart';
import 'package:flutterwhatsapp/resources/FirebaseKeys.dart';
import 'package:flutterwhatsapp/worker/RouterWorker.dart';

class ContactsTab extends StatefulWidget {
  @override
  _ContactTabState createState() => _ContactTabState();
}

class _ContactTabState extends State<ContactsTab> {
  List<Contact> contactList;

  Future<List<Contact>> _getContactList() async {
    Firestore instance = Firestore.instance;
    QuerySnapshot snapshot = await instance.collection(FirebaseKeys.usersCollection).getDocuments();

    List<Contact> contactList = List();

    for (DocumentSnapshot item in snapshot.documents) {
      var data = item.data;

      FirebaseUser user = await FirebaseUserData.getFireabseUser();

      if (data[Contact.emailFirebaseKey] != user.email) {
        Contact contact =
            Contact(item.documentID, data[Contact.nameFirebaseKey], data[Contact.emailFirebaseKey], data[Contact.photoUrlFirebaseKey]);
        contactList.add(contact);
      }
    }

    return contactList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Contact>>(
        future: _getContactList(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      children: [CircularProgressIndicator()],
                    )),
              );
              break;
            case ConnectionState.done:
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    List<Contact> contactList = snapshot.data;
                    Contact contact = contactList[index];

                    if (snapshot.data.length == 0) {
                      return Center(
                        child: Padding(
                            padding: EdgeInsets.all(32),
                            child: Column(
                              children: [
                                Text(AppStrings.emptyViewContactList)
                              ],
                            )),
                      );
                    }
                    return ListTile(
                      contentPadding: EdgeInsets.all(8),
                      leading: CircleAvatar(
                        maxRadius: 30,
                        backgroundColor: AppColors.primaryCollor,
                        backgroundImage: contact.photoUrl != null
                            ? NetworkImage(contactList[index].photoUrl)
                            : null,
                      ),
                      title: Text(
                        contact.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                            context,
                            RouterWorker.messagesRouteName,
                            arguments: contact);
                      },
                    );
                  });
              break;
          }
        });
  }
}
