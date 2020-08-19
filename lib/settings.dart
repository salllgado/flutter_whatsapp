import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterwhatsapp/model/User.dart';

import 'package:flutterwhatsapp/resources/AppColors.dart';
import 'package:flutterwhatsapp/resources/AppStrings.dart';
import 'package:image_picker/image_picker.dart';

enum SourceType { camera, gallery }

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // Variables
  TextEditingController _nameController = TextEditingController();
  Image _userImageFile;
  String _imageUrl;
  bool _loading = false;

  @override
  void initState() {
    _getImageURLFromRemote();
    super.initState();
  }

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

  Future getImage(SourceType sourceType) async {
    PickedFile fileImage;
    ImagePicker pickerView = ImagePicker();

    switch (sourceType) {
      case SourceType.camera:
        fileImage = await pickerView.getImage(source: ImageSource.camera);
        break;
      case SourceType.gallery:
        fileImage = await pickerView.getImage(source: ImageSource.gallery);
        break;
      default:
        break;
    }

    setState(() {
      if (fileImage != null) {
        File _imageFile = File(fileImage.path);
        if (_imageFile != null) {
          _userImageFile = Image.file(_imageFile);
          _loading = true;
          _saveImageOnRemote(_imageFile);
        }
      }
    });
  }

  Future _saveImageOnRemote(File fileImage) async {
    FirebaseAuth authInstance = FirebaseAuth.instance;
    FirebaseUser user = await authInstance.currentUser();
    String _userUID = user.uid;

    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference mainFolder = storage.ref();
    StorageReference file = mainFolder.child("Profile").child("$_userUID.jpg");
    // file.putFile(fileImage);

    StorageUploadTask task = file.putFile(fileImage);

    task.events.listen((storageTaskEvent) {
      switch (storageTaskEvent.type) {
        case StorageTaskEventType.progress:
          setState(() {
            this._loading = true;
          });
          break;
        case StorageTaskEventType.success:
          setState(() {
            this._loading = false;
          });
          break;
      }
    });

    task.onComplete.then((snapshot) => {
      _getImageURLFromRemote()
    });
  }

  Future _getImageURLFromRemote() async {
    FirebaseAuth authInstance = FirebaseAuth.instance;
    FirebaseUser user = await authInstance.currentUser();
    String _userUID = user.uid;

    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference mainFolder = storage.ref();

    /* 
    caso não houver imagem o app vai quebrar, no exemplo salvamos a url no firebase para recuperar ela por la
    e verificar se ela é nula ou não
    */
    String _imageUrl = await mainFolder.child("Profile").child("$_userUID.jpg").getDownloadURL();

    setState(() {
      this._imageUrl = _imageUrl;
    });
  }

  Widget handlerLoadingIfNeeded() {
    if (_loading) {
      CircularProgressIndicator();
    } else {
      return Container();
    }
  }

  Widget showAlertView() {
    return CupertinoActionSheet(
        title:
            const Text('Selecione uma opção para fazer o upload de uma imagem'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: const Text("Camera"),
            onPressed: () {
              getImage(SourceType.camera);
              Navigator.pop(context, "Camera action");
            },
          ),
          CupertinoActionSheetAction(
            child: const Text("Galeria"),
            onPressed: () {
              getImage(SourceType.gallery);
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
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
        actions: [
          FlatButton(
            child: Text(
              "Salvar",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            onPressed: () {},
          ),
        ],
      ),
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
                  child: handlerLoadingIfNeeded(),
                  backgroundImage: _imageUrl != null ? NetworkImage(_imageUrl) : null,
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
                      child: showAlertView(),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    hintText: AppStrings.nameHint,
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    filled: true,
                    fillColor: AppColors.textFieldBackground,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
