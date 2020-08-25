import 'package:flutter/material.dart';
import 'package:flutterwhatsapp/model/Contact.dart';

class Messages extends StatefulWidget {

  // class params to be injected
  Contact contact;

  Messages(this.contact);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.contact.name), ),
      body: Center(
        child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              children: [Text("Não existe contatos disponiveis")],
            )),
      ),
    );
  }
}
