import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

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
    file.putFile(fileImage);

    StorageUploadTask task = file.putFile(fileImage);
    String fileUrl = await file.getDownloadURL();

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
          _saveDataOnFirestore(fileUrl),
          setState(() {
            this._imageUrl = fileUrl;
          })
        });
  }

  Future _getImageURLFromRemote() async {
    FirebaseAuth authInstance = FirebaseAuth.instance;
    FirebaseUser user = await authInstance.currentUser();
    String _userUID = user.uid;

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("users").document(_userUID).get();

    Map<String, dynamic> userData = snapshot.data;
    _nameController.text = userData["name"];
    _emailController.text = userData["email"];

    setState(() {
      this._imageUrl = userData["imageUrl"];
    });
  }

  Future _saveDataOnFirestore(String url) async {
    FirebaseAuth authInstance = FirebaseAuth.instance;
    FirebaseUser user = await authInstance.currentUser();
    String _userUID = user.uid;

    Map<String, dynamic> updateData = {"imageUrl": url};

    Firestore db = Firestore.instance;
    db.collection("users").document(_userUID).updateData(updateData);
  }

  Future _saveUserDataOnFirestore(String name) async {
    FirebaseAuth authInstance = FirebaseAuth.instance;
    FirebaseUser user = await authInstance.currentUser();
    String _userUID = user.uid;

    Map<String, dynamic> updateData = {"name": name};

    Firestore db = Firestore.instance;
    db.collection("users").document(_userUID).updateData(updateData);
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

  Widget getImageView() {
    return CircleAvatar(
      radius: 80,
      backgroundColor: AppColors.primaryCollor,
      child: ClipOval(
        child: Image.network(
          _imageUrl,
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget getLoadingIndicator() {
    return Padding(
      padding: EdgeInsets.all(32),
      child: Column(
        children: [CircularProgressIndicator()],
      )
    );
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
            onPressed: () {
              _saveUserDataOnFirestore(
                  _nameController.text);
            },
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
                child: _imageUrl != null
                    ? getImageView()
                    : Container(height: 150, width: 150),
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
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    hintText: AppStrings.emailHint,
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    filled: true,
                    fillColor: AppColors.textFieldBackground,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)),
                  ),
                ),
              ),
            _loading ? getLoadingIndicator() : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
