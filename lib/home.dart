import 'package:flutter/material.dart';
import 'package:flutterwhatsapp/homeTabs/ContactsTab.dart';
import 'package:flutterwhatsapp/homeTabs/TalksTab.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  TabController _tabController;

  @override
  void initState() {
    
    _tabController = TabController(
      vsync: this, 
      length: 2
    );
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home"), bottom: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        indicatorWeight: 4,
        labelPadding: EdgeInsets.all(16),
        labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        tabs: <Widget>[
          Text("Conversas"),
          Text("Contatos")
      ])),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          TalksTab(),
          ContactsTab()
      ]),
    );
  }
}
