import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterwhatsapp/resources/AppColors.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  void containerForSheet<T>({BuildContext context, Widget child}) {
    showCupertinoModalPopup<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T value) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text('You clicked $value'),
        duration: Duration(milliseconds: 800),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Configurações")),
      body: Container(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 32),
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: AppColors.primaryCollor,
                  // backgroundImage: NetworkImage(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: FlatButton(
                  child: Text(
                    "Trocar imagem",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    containerForSheet<String>(
                      context: context,
                      child: CupertinoActionSheet(
                          title: const Text(
                              'Selecione uma opção para fazer o upload de uma imagem'),
                          actions: <Widget>[
                            CupertinoActionSheetAction(
                              child: const Text("Camera"),
                              onPressed: () {
                                Navigator.pop(context, "Camera action");
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: const Text("Galeria"),
                              onPressed: () {
                                Navigator.pop(context, "Galeria action");
                              },
                            ),
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            child: const Text('Cancelar'),
                            isDefaultAction: true,
                            onPressed: () {
                              Navigator.pop(context, 'Cancel');
                            },
                          )),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
