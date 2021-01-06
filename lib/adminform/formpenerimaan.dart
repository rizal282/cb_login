import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Formpenerimaan extends StatefulWidget {
  @override
  _FormpenerimaanState createState() => _FormpenerimaanState();
}

class _FormpenerimaanState extends State<Formpenerimaan> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _kodeBarang = new TextEditingController();
  final _namaBarang = new TextEditingController();
  final _kodeSatuan = new TextEditingController();
  final _qtyItem = new TextEditingController();

  String _tgl = "....";

  void pickTanggal() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1994),
            lastDate: DateTime(2030))
        .then((DateTime val) {
      if (val != null) {
        setState(() {
          _tgl = val.toString();
        });
      }
    });
  }

  void inputPenerimaan() async {
    if (formKey.currentState.validate()) {
      var _tglinput = _tgl.split(" ");

      await http
          .post("http://192.168.43.171/cb-login/user/inputPenerimaan", body: {
        "kodeBarang": _kodeBarang.text,
        "namaBarang": _namaBarang.text,
        "kdSatuan": _kodeSatuan.text,
        "tglInput": _tglinput[0],
        "qtyItem": _qtyItem.text,
        "status": "Belum Dikirim"
      });

      showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text("Sukses"),
                          content: Text("Data Penerimaan disimpan!"),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  // resetForm();
                                  Navigator.of(context).pop();
                                  resetForm();
                                },
                                child: Text("OK"))
                          ],
                        ));
    }
  }

  void resetForm(){
    _kodeBarang.text = "";
    _namaBarang.text = "";
    _kodeSatuan.text = "";
    _qtyItem.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form Penerimaan"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8),
        child: Form(
          key: formKey,
          child: formElement(),
        ),
      ),
    );
  }

  Widget formElement() {
    return ListView(
      children: <Widget>[
        TextFormField(
          controller: _kodeBarang,
          validator: (String val) {
            if (val.isEmpty) {
              return "Kode barang masih kosong";
            }

            return null;
          },
          decoration: InputDecoration(
              labelText: "Kode barang",
              hintText: "Masukan kode barang",
              border: OutlineInputBorder()),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          controller: _namaBarang,
          validator: (String val) {
            if (val.isEmpty) {
              return "Nama barang masih kosong";
            }

            return null;
          },
          decoration: InputDecoration(
              labelText: "Nama barang",
              hintText: "Masukan nama barang",
              border: OutlineInputBorder()),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          controller: _kodeSatuan,
          validator: (String val) {
            if (val.isEmpty) {
              return "Kode satuan masih kosong";
            }

            return null;
          },
          decoration: InputDecoration(
              labelText: "Kode satuan",
              hintText: "Masukan kode satuan",
              border: OutlineInputBorder()),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Tanggal Masuk : "),
            Text(_tgl),
            IconButton(
                icon: Icon(Icons.date_range),
                onPressed: () {
                  pickTanggal();
                })
          ],
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          controller: _qtyItem,
          keyboardType: TextInputType.number,
          validator: (String val) {
            if (val.isEmpty) {
              return "Jumlah item kosong";
            }

            return null;
          },
          decoration: InputDecoration(
              labelText: "Jumlah item",
              hintText: "Masukan jumlah item",
              border: OutlineInputBorder()),
        ),
        SizedBox(
          height: 20,
        ),
        Card(
          elevation: 4,
          color: Colors.blueAccent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 40,
            child: InkWell(
              splashColor: Colors.white,
              child: Center(
                child: Text("Simpan"),
              ),
              onTap: () {
                inputPenerimaan();
              },
            ),
          ),
        )
      ],
    );
  }
}
