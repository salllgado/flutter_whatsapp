import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutterwhatsapp/worker/RouterWorker.dart';
import 'package:flutterwhatsapp/homeTabs/contactsTab.dart';
import 'package:flutterwhatsapp/homeTabs/talksTab.dart';
import 'package:flutterwhatsapp/resources/AppStrings.dart';

import 'model/FirebaseUserData.dart';
import 'model/User.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;

  FirebaseAuth auth = FirebaseAuth.instance;

  List<String> itensMenu = [
    AppStrings.configurationMenuPopupMenuItem,
    AppStrings.logoutMenuPopupMenuItem
  ];

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  // Verifica se há usuário logado
  void _verifyUser() async {
    FirebaseUser user = await FirebaseUserData.getFireabseUser();
    if (user == null) {
        Navigator.pushReplacementNamed(context, RouterWorker.loginRouteName);
    }
  }

  _actionPopUpMenu(String item) {
    switch (item) {
      case AppStrings.configurationMenuPopupMenuItem:
        Navigator.pushNamed(context, RouterWorker.settingsRouteName);
        break;
      case AppStrings.logoutMenuPopupMenuItem:
        _doLogout();
        break;
    }
  }

  _doLogout() async {
    await auth.signOut();
    Navigator.pushReplacementNamed(context, RouterWorker.loginRouteName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.homeScreenTitle),
        bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorWeight: 4,
            labelPadding: EdgeInsets.all(16),
            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            tabs: <Widget>[
                Text(AppStrings.talksTabTitle),
                Text(AppStrings.contactsTabTitle)
              ]),
        actions: [
          PopupMenuButton<String>(
            onSelected: _actionPopUpMenu,
            itemBuilder: (context) {
              return itensMenu.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: TabBarView(
          controller: _tabController,
          children: <Widget>[TalksTab(), ContactsTab()]),
    );
  }
}
