import 'dart:convert';
import 'dart:io';

import 'package:cb_login/admin/pdfviewer.dart';
import 'package:cb_login/adminform/formeditpengeluaran.dart';
import 'package:cb_login/adminform/formpengeluaran.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Pengeluaran extends StatefulWidget {
  @override
  _PengeluaranState createState() => _PengeluaranState();
}

class _PengeluaranState extends State<Pengeluaran> {
  List listPengeluaran = List();

  void getPengeluaran() async {
    var response = await http.get("http://192.168.43.171/cb-login/admin/pengeluaran");

    setState(() {
      listPengeluaran = json.decode(response.body) as List;
    });
  }

  void _hapusPengeluaran(String id) async {
    await http.post("http://192.168.43.171/cb-login/admin/hapusPengeluaran", body: {
      "id" : id
    });

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Sukses"),
          content: Text("Data Pengeluaran dihapus!"),
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
    var data = await http.get("http://192.168.43.171/cb-login/admin/pengeluaran"); 
    List dataPengeluaran = jsonDecode(data.body);

    final pw.Document pdf = pw.Document(deflate: zlib.encode);

    pdf.addPage(
      pw.MultiPage(
        orientation: pw.PageOrientation.landscape,
        build: (context) => [
          pw.Table.fromTextArray(context: context, data: <List<String>>[
            <String>["Kode Barang", "Nama Barang", "Jumlah Item", "Kode Satuan", "Tgl Keluar"],
            ...dataPengeluaran.map((f) => [
              f["kd_barang"],
              f["nm_barang"],
              f["qty_item"],
              f["kd_satuan"],
              f["tgl_keluar"],
            ])
          ])
        ]
      )
    );

    final String dir = (await getExternalStorageDirectory()).path;
    final String path = "$dir/laporan_pengeluaran_${DateTime.now()}.pdf";
    final File file = File(path);

    print(path);
    file.writeAsBytesSync(pdf.save());
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => Pdfviewerpage(path: path,))
    );
  }

  SingleChildScrollView tabelPengeluaran() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Icon(Icons.list)),
            DataColumn(label: Text("Kode Barang")),
            DataColumn(label: Text("Nama Barang")),
            DataColumn(label: Text("Qty Item")),
            DataColumn(label: Text("Satuan")),
            DataColumn(label: Text("Tgl Keluar")),
            
          ], 
          rows: listPengeluaran.map((f) => DataRow(cells: <DataCell>[
            DataCell(
              PopupMenuButton(itemBuilder: (contex){
                return [
                  PopupMenuItem(child: IconButton(icon: Icon(Icons.edit), onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Editpengeluaran(f["id"], f["kd_barang"], f["nm_barang"], f["qty_item"], f["kd_satuan"], f["tgl_keluar"]))
                    );
                  }),),
                  PopupMenuItem(child: IconButton(icon: Icon(Icons.delete), onPressed: (){
                    _hapusPengeluaran(f["id"]);
                  }),),
                ];
              })
            ),
            DataCell(Text(f["kd_barang"])),
            DataCell(Text(f["nm_barang"])),
            DataCell(Text(f["qty_item"])),
            DataCell(Text(f["kd_satuan"])),
            DataCell(Text(f["tgl_keluar"])),
            
          ])).toList(),
        ),
      ),
    );
  }

  @override
  void initState() {
    getPengeluaran();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cahaya Baru"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.picture_as_pdf), onPressed: (){
            _cetakPdf(context);
          })
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Text("Pengeluaran Barang", style: TextStyle(fontSize: 25),),
            tabelPengeluaran()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => FormPengeluaran())
          );
        },
      ),
    );
  }
}