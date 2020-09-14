import 'package:flutter/material.dart';
import 'package:flutterwhatsapp/model/Contact.dart';
import 'package:flutterwhatsapp/resources/AppColors.dart';
import 'package:flutterwhatsapp/resources/Images.dart';

class Messages extends StatefulWidget {
  // class params to be injected
  Contact contact;

  Messages(this.contact);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  TextEditingController textEntryController = TextEditingController();
  static List<String> messages = ["Bom dia !!!", "Bom dia ;)", "Como passou a noite, Como passou a noite, Como passou a noite", "Bem, e tu, Bem, e tu, Bem, e tu", "Sonhei com você kkkk"];

  void _sendImage() {}

  void _sendMessage() {}

  // - layout
  var listView = Expanded(
      child: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            Alignment boxAlignment = Alignment.centerRight;
            Color boxColor = Color(0xffd2ffa5);
            
            double leftPadding = 8;
            double rightPadding = 8;
            double maxPadding = 60;

            if (index % 2 == 0) {
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
                    padding: EdgeInsets.fromLTRB(leftPadding, 8, rightPadding, 8),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: boxColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        messages[index],
                        style: TextStyle(fontSize: 18),
                      ),
                    )));
          }));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.contact.name),
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
                listView,
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
