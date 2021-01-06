import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class Role extends StatefulWidget {
  @override
  _RoleState createState() => _RoleState();
}

class _RoleState extends State<Role> {
  List roleList = List();

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
              label: Text('Role'),
            ),
            DataColumn(
              label: Text('Access'),
            ),
            DataColumn(
              label: Text('Edit'),
            ),
            DataColumn(
              label: Text('Hapus'),
            ),
          ],
          rows: roleList.map((f) => DataRow(cells: <DataCell>[
            DataCell(Text(f["id"])),
            DataCell(Text(f["role"])),
            DataCell(IconButton(icon: Icon(Icons.accessibility_new), onPressed: (){
              
            })),
            DataCell(
              IconButton(icon: Icon(Icons.edit), onPressed: null)
            ),
            DataCell(IconButton(icon: Icon(Icons.delete), onPressed: null)),
          ])).toList(),
        ),
      ),
    );
  }

  void getDataRole() async {
    var response = await http.get("http://192.168.43.171/cb-login/admin/role1");
    
    setState(() {
      roleList = json.decode(response.body) as List;
    });

    print(roleList[0]);

  }

  @override
  void initState() {
    getDataRole();
    super.initState();
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
            Text("Role", style: TextStyle(fontSize: 25),),
            _dataBody()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: FaIcon(FontAwesomeIcons.plus),
        onPressed: () {

        },
      ),
    );
  }
}
