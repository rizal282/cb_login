import 'dart:convert';
import 'package:cb_login/adminform/formeditpenerimaan.dart';
import 'package:cb_login/adminform/formpenerimaan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Penerimaan extends StatefulWidget {
  @override
  _PenerimaanState createState() => _PenerimaanState();
}

class _PenerimaanState extends State<Penerimaan> {
  List listPenerimaan = List();
  // List _kode = List();

  void getPenerimaan() async {
    final response = await http.get("http://192.168.43.171/cb-login/admin/penerimaan");

    setState(() {
      listPenerimaan = json.decode(response.body) as List;
    });
  }

  void kirimBarang(String kodeBarang, String qty) async {
    var response = await http.post("http://192.168.43.171/cb-login/admin/cekKodeBarang", body: {
      "kodeBarang" : kodeBarang
    });

    var listkode = json.decode(response.body);

    if(listkode.length == 1){
        await http.post("http://192.168.43.171/cb-login/admin/updateStokBarang", body: {
        "kodeBarang" : kodeBarang,
        "stokbaru" : qty,
      });

      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Sukses"),
            content: Text("Terkirim"),
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

  }

  void hapusPenerimaan(String id) async {
    await http.post("http://192.168.43.171/cb-login/admin/hapusPenerimaan", body: {
      "id" : id
    });

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Sukses"),
          content: Text("Terhapus!"),
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

  SingleChildScrollView tabelPenerimaan() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Icon(Icons.list)),
            DataColumn(label: Text("Kode Barang")),
            DataColumn(label: Text("Nama Barang")),
            DataColumn(label: Text("Satuan")),
            DataColumn(label: Text("Tgl Masuk")),
            DataColumn(label: Text("Qty Item")),
            DataColumn(label: Text("Status")),
            DataColumn(label: Text("Kirim")),
          ], 
          rows: listPenerimaan.map((f) => DataRow(cells: <DataCell>[
            DataCell(PopupMenuButton(itemBuilder: (context){
              return [
                PopupMenuItem(child: IconButton(icon: Icon(Icons.edit), onPressed: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditPenerimaan(f["id"], f["kd_barang"], f["nm_barang"], f["kd_satuan"], f["qty_item"], f["tgl_masuk"]))
                  );
                }),),
                PopupMenuItem(child: IconButton(icon: Icon(Icons.delete), onPressed: (){
                  hapusPenerimaan(f["id"]);
                }),),
              ];
            })),
            DataCell(Text(f["kd_barang"])),
            DataCell(Text(f["nm_barang"])),
            DataCell(Text(f["kd_satuan"])),
            DataCell(Text(f["tgl_masuk"])),
            DataCell(Text(f["qty_item"])),
            DataCell(Text(f["status"])),
            DataCell(
              f["status"] == "Belum Dikirim" 
              ? IconButton(
                icon: Icon(Icons.send), 
                onPressed: (){
                  kirimBarang(f["kd_barang"], f["qty_item"]);
                })
              : Text("Dikirim")
            ),
          ])).toList(),
        ),
      ),
    );
  }

  @override
  void initState() {
    getPenerimaan();
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
            Text("Penerimaan Barang", style: TextStyle(fontSize: 25),),
            tabelPenerimaan()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Formpenerimaan())
          );
        },
      ),
    );
  }
}