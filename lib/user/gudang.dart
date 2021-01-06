import 'dart:convert';

import 'package:cb_login/adminform/formeditgudang.dart';
import 'package:cb_login/adminform/formgudang.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataGudang extends StatefulWidget {
  @override
  _DataGudangState createState() => _DataGudangState();
}

class _DataGudangState extends State<DataGudang> {
  List _dataBarangGudang = List();

  @override
  void initState() {
    _getDataBarangGudang(); 
    super.initState();
  }

  void _getDataBarangGudang() async {
    var response = await http.get("http://192.168.43.171/cb-login/user/gudang1");

    setState(() {
      _dataBarangGudang = json.decode(response.body) as List;
    });
  }

  void hapusDataGudang(String id) async {
    await http.post("http://192.168.43.171/cb-login/user/hapusDataGudang", body: {
      "id_data" : id
    });

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Sukses"),
          content: Text("Data Gudang dihapus!"),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  // resetForm();
                  Navigator.of(context).pop();

                },
                child: Text("OK"))
          ],
        ));
  }

  SingleChildScrollView _dataListGudang() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Icon(Icons.list)),
            DataColumn(
              label: Text('Kode Barang'),
            ),
            DataColumn(
              label: Text('Nama Barang'),
            ),
            DataColumn(
              label: Text('Kode Satuan'),
            ),
            DataColumn(
              label: Text('Stok'),
            ),
          ],
          rows: _dataBarangGudang.map((f) => DataRow(cells: <DataCell>[
            DataCell(
              PopupMenuButton(itemBuilder: (context){
                return [
                  PopupMenuItem(child: IconButton(icon: Icon(Icons.edit), onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Editgudang(f["id_data"], f["kd_barang"], f["nm_barang"], f["kd_satuan"], f["stok"]))
                    );
                  })),
                  PopupMenuItem(child: IconButton(icon: Icon(Icons.delete), onPressed: (){
                    hapusDataGudang(f["id_data"]);
                  })),
                ];
              })
            ),
            DataCell(Text(f["kd_barang"])),
            DataCell(Text(f["nm_barang"])),
            DataCell(Text(f["kd_satuan"])),
            DataCell(Text(f["stok"])),
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
            Text("Data Barang Gudang", style: TextStyle(fontSize: 25),),
            _dataListGudang()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => FormGudang())
          );
        },
      ),
    );
  }
}