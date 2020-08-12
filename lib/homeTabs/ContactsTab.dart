import 'package:flutter/material.dart';
import 'package:flutterwhatsapp/model/Contact.dart';
import 'package:flutterwhatsapp/resources/AppColors.dart';

class ContactsTab extends StatefulWidget {
  @override
  _ContactTabState createState() => _ContactTabState();
}

class _ContactTabState extends State<ContactsTab> {

  List<Contact> contactList = [
    Contact("Juliana", "https://firebasestorage.googleapis.com/v0/b/whatsapp-a6e5e.appspot.com/o/Profile%2Fperfil1.jpg?alt=media&token=7fa6b120-6680-43a0-83ff-b6deafcce76b")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: contactList.length,
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: EdgeInsets.all(8),
              leading: CircleAvatar(
                maxRadius: 30,
                backgroundColor: AppColors.primaryCollor,
                backgroundImage: NetworkImage(contactList[index].photoUrl),
              ),
              title: Text(
                contactList[index].name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )
            );
          }),
    );
  }
}
