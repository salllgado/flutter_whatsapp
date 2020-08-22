import 'package:flutter/material.dart';
import 'package:flutterwhatsapp/model/Chat.dart';
import 'package:flutterwhatsapp/resources/AppColors.dart';

class TalksTab extends StatefulWidget {
  @override
  _TalksTabState createState() => _TalksTabState();
}

class _TalksTabState extends State<TalksTab> {
  List<Chat> chatList = [
    Chat("Lais", "Olá",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-a6e5e.appspot.com/o/Profile%2Fperfil1.jpg?alt=media&token=7fa6b120-6680-43a0-83ff-b6deafcce76b"),
    Chat("Leila", "Venha aqui meu filho",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-a6e5e.appspot.com/o/Profile%2Fperfil1.jpg?alt=media&token=7fa6b120-6680-43a0-83ff-b6deafcce76b"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: chatList.length,
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: EdgeInsets.all(8),
              leading: CircleAvatar(
                maxRadius: 30,
                backgroundColor: AppColors.primaryCollor,
                backgroundImage: NetworkImage(chatList[index].photoUrl),
              ),
              title: Text(
                chatList[index].name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                chatList[index].lastMessage,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            );
          }),
    );
  }
}
