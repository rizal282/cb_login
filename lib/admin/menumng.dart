import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MenuMng extends StatefulWidget {
  @override
  _MenuMngState createState() => _MenuMngState();
}

class _MenuMngState extends State<MenuMng> {
  List menuMng = List();

  void getMenuMng() async {
    var response = await http.get("http://192.168.43.171/cb-login/menu/menuManagement");

    setState(() {
      menuMng = json.decode(response.body) as List;
    });

  }

  @override
  void initState() {
    getMenuMng();
    super.initState();
  }

  SingleChildScrollView _dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('ID'),
            ),
            DataColumn(
              label: Text('Menu'),
            ),
            DataColumn(
              label: Text('Edit'),
            ),
            DataColumn(
              label: Text('Hapus'),
            ),
          ],
          rows: menuMng.map((f) => DataRow(cells: <DataCell>[
            DataCell(Text(f["id"])),
            DataCell(Text(f["menu"])),

            DataCell(
              IconButton(icon: Icon(Icons.edit), onPressed: null)
            ),
            DataCell(IconButton(icon: Icon(Icons.delete), onPressed: null)),
          ])).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cahaya Baru"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Text("Menu Management", style: TextStyle(fontSize: 25)),

            _dataBody()
          ],
        ),
      ),
    );
  }
}