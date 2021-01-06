import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SubmenuMng extends StatefulWidget {
  @override
  _SubmenuMngState createState() => _SubmenuMngState();
}

class _SubmenuMngState extends State<SubmenuMng> {
  List submenuMng = List();

  void getSubmenu() async {
    var response = await http.get("http://192.168.43.171/cb-login/menu/submenu");
  }

  @override
  void initState() {
    getSubmenu();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CAHAYA BARU"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Text("Submenu"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){

        },
      ),
    );
  }
}