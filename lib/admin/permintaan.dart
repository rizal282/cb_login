import 'dart:convert';
import 'dart:io';

import 'package:cb_login/admin/pdfviewer.dart';
import 'package:cb_login/adminform/formeditpermintaan.dart';
import 'package:cb_login/adminform/formpermintaan.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Permintaan extends StatefulWidget {
  @override
  _PermintaanState createState() => _PermintaanState();
}

class _PermintaanState extends State<Permintaan> {
  List dataPermintaan = List();

  void getPermintaan() async {
    final response = await http.get("http://192.168.43.171/cb-login/admin/permintaan");

    setState(() {
      dataPermintaan = json.decode(response.body) as List;
    });
  }

  void _hapusPermintaan(String id) async {
    await http.post("http://192.168.43.171/cb-login/admin/hapusPermintaan", body: {
      "id" : id
    });

    showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Sukses"),
                content: Text("Data Permintaan dihapus!"),
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

  void _cetakPdf(context) async {
    var data = await http.get("http://192.168.43.171/cb-login/admin/permintaan"); 
    List dataPermintaan = jsonDecode(data.body);

    final pw.Document pdf = pw.Document(deflate: zlib.encode);

    pdf.addPage(
      pw.MultiPage(
        orientation: pw.PageOrientation.landscape,
        build: (context) => [
          pw.Table.fromTextArray(context: context, data: <List<String>>[
            <String>["Kode Barang", "Nama Barang", "Jumlah Item", "Kode Satuan", "Tgl Req"],
            ...dataPermintaan.map((f) => [
              f["kd_barang"],
              f["nm_barang"],
              f["jumlahpcs"],
              f["kd_satuan"],
              f["request_tgl"],
            ])
          ])
        ]
      )
    );

    final String dir = (await getExternalStorageDirectory()).path;
    final String path = "$dir/laporan_permintaan_${DateTime.now()}.pdf";
    final File file = File(path);

    print(path);
    file.writeAsBytesSync(pdf.save());
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => Pdfviewerpage(path: path,))
    );
  }

  @override
  void initState() {
    getPermintaan();
    super.initState();
  }

  SingleChildScrollView tbDataPermintaan() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Icon(Icons.list)),
            DataColumn(label: Text("Kode Barang")),
            DataColumn(label: Text("Nama Barang")),
            DataColumn(label: Text("Qty Barang")),
            DataColumn(label: Text("Kode Satuan")),
            DataColumn(label: Text("Tgl Request")),
          ], 
          rows: dataPermintaan.map((f) => DataRow(cells: <DataCell>[
            DataCell(PopupMenuButton(itemBuilder: (context){
              return [
                PopupMenuItem(child: IconButton(icon: Icon(Icons.edit), onPressed: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Editpermintaan(f["id"], f["kd_barang"], f["nm_barang"], f["jumlahpcs"], f["kd_satuan"], f["request_tgl"]))
                  );
                })),
                PopupMenuItem(child: IconButton(icon: Icon(Icons.delete), onPressed: (){
                  _hapusPermintaan(f["id"]);
                })),
              ];
            })),
            DataCell(Text(f["kd_barang"])),
            DataCell(Text(f["nm_barang"])),
            DataCell(Text(f["jumlahpcs"])),
            DataCell(Text(f["kd_satuan"])),
            DataCell(Text(f["request_tgl"])),
          ])).toList(),),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cahaya Baru"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: (){
              _cetakPdf(context);
            },
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Text("Permintaan", style: TextStyle(fontSize: 25),),
            tbDataPermintaan()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => FormPenerimaan())
          );
        },
      child: Icon(Icons.add),
      ),
    );
  }
}