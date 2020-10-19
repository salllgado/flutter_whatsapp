import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterwhatsapp/model/Contact.dart';
import 'package:flutterwhatsapp/model/Menssage.dart';
import 'package:flutterwhatsapp/resources/AppColors.dart';
import 'package:flutterwhatsapp/resources/Images.dart';

import 'model/FirebaseUserData.dart';

class Messages extends StatefulWidget {
  // class params to be injected
  Contact contact;
  Messages(this.contact);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  TextEditingController textEntryController = TextEditingController();
  static Firestore db = Firestore.instance;
  static String userUID;
  static String destinationUserUID;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    userUID = await FirebaseUserData.getFireabseUserId();
    destinationUserUID = widget.contact.userId;
  }

  void _sendImage() {}

  void _sendMessage() {
    String textMenssage = textEntryController.text;
    if (textMenssage != null) {
      Menssage menssage = Menssage(userUID, textMenssage, "", "text");
      _saveMenssage(userUID, destinationUserUID, menssage);
      _saveMenssage(destinationUserUID, userUID, menssage);
    }
  }

  void _saveMenssage(
      String userId, String destinationUserId, Menssage menssage) async {
    await db
        .collection("menssages")
        .document(userId)
        .collection(destinationUserId)
        .add(menssage.toMap());

    textEntryController.clear();
  }

  var streamView = StreamBuilder(
      stream: db
          .collection("menssages")
          .document(userUID)
          .collection(destinationUserUID)
          .snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: [
                  Text("Carregando contatos"),
                  CircularProgressIndicator()
                ],
              ),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            QuerySnapshot querySnapshot = snapshot.data;

            if (snapshot.hasError) {
              Center(
                child: Column(
                  children: [Text("Carregando contatos")],
                ),
              );
            } else {
              return Expanded(
                  child: ListView.builder(
                      itemCount: querySnapshot.documents.length,
                      itemBuilder: (context, index) {

                        // criar objeto de mensagens
                        List<DocumentSnapshot> mensagens = querySnapshot.documents.toList();
                        DocumentSnapshot item = mensagens[index];

                        Alignment boxAlignment = Alignment.centerRight;
                        Color boxColor = Color(0xffd2ffa5);

                        double leftPadding = 8;
                        double rightPadding = 8;
                        double maxPadding = 60;

                        if (userUID != item["idUsuario"]) {
                          // sou eu
                          boxColor = Colors.white;
                          boxAlignment = Alignment.centerLeft;
                          rightPadding = maxPadding;
                          leftPadding = 8;
                        } else {
                          rightPadding = 8;
                          leftPadding = maxPadding;
                        }

                        return Align(
                            alignment: boxAlignment,
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    leftPadding, 8, rightPadding, 8),
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: boxColor,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Text(
                                    item["mensagem"],
                                    style: TextStyle(fontSize: 18),
                                  ),
                                )));
                      }));
            }
        }
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
            child: Row(
              children: [
                Padding(
                  child: CircleAvatar(
                    maxRadius: 20,
                    backgroundColor: AppColors.primaryCollor,
                    backgroundImage: widget.contact.photoUrl != null
                        ? NetworkImage(widget.contact.photoUrl)
                        : null,
                  ),
                  padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                ),
                Padding(
                  child: Text(widget.contact.name),
                  padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(Images.chatBg), fit: BoxFit.cover),
          ),
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(children: [
                streamView,
                Container(
                  padding: EdgeInsets.all(8),
                  child: Row(children: [
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Container(
                        child: TextField(
                          controller: textEntryController,
                          autofocus: true,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                              hintText: "Digite uma mensagem",
                              contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                              filled: true,
                              fillColor: AppColors.textFieldBackground,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              prefixIcon: IconButton(
                                icon: Icon(Icons.camera_alt),
                                onPressed: _sendImage,
                              )),
                        ),
                      ),
                    )),
                    FloatingActionButton(
                      backgroundColor: AppColors.primaryCollor,
                      child: Icon(Icons.send, color: Colors.white),
                      mini: true,
                      onPressed: _sendMessage,
                    )
                  ]),
                )
              ]),
            ),
          ),
        ));
  }
}
