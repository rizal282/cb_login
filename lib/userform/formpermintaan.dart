import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FormPenerimaan extends StatefulWidget {
  @override
  _FormPenerimaanState createState() => _FormPenerimaanState();
}

class _FormPenerimaanState extends State<FormPenerimaan> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _kodeBarang = new TextEditingController();
  final _namaBarang = new TextEditingController();
  final _jmlpcs = new TextEditingController();
  final _kodeSatuan = new TextEditingController();
  String _tglRequest = "....";

  void pickTanggal() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1994),
            lastDate: DateTime(2030))
        .then((DateTime val) {
      if (val != null) {
        setState(() {
          _tglRequest = val.toString();
        });
      }
    });
  }

  void simpanPermintaan() async {
    if (formKey.currentState.validate()) {
      List tgl = _tglRequest.split(" ");

      await http
          .post("http://192.168.43.171/cb-login/user/inputPermintaan", body: {
        "kodeBarang": _kodeBarang.text,
        "namaBarang": _namaBarang.text,
        "jumlahpcs": _jmlpcs.text,
        "kodesatuan": _kodeSatuan.text,
        "tanggal": tgl[0]
      });

      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Sukses"),
                content: Text("Data Permintaan disimpan!"),
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

  void resetForm() {
    _kodeBarang.text = "";
    _namaBarang.text = "";
    _jmlpcs.text = "";
    _kodeSatuan.text = "";

    setState(() {
      _tglRequest = "....";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form Permintaan"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8),
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _kodeBarang,
                validator: (String val) {
                  if (val.isEmpty) {
                    return "Kode barang kosong";
                  }

                  return null;
                },
                decoration: InputDecoration(
                    labelText: "Kode barang",
                    hintText: "Masukan kode barang",
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _namaBarang,
                validator: (String val) {
                  if (val.isEmpty) {
                    return "Nama barang kosong";
                  }

                  return null;
                },
                decoration: InputDecoration(
                    labelText: "Nama barang",
                    hintText: "Masukan nama barang",
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _jmlpcs,
                keyboardType: TextInputType.number,
                validator: (String val) {
                  if (val.isEmpty) {
                    return "Jumlah barang kosong";
                  }

                  return null;
                },
                decoration: InputDecoration(
                    labelText: "Jumlah barang",
                    hintText: "Masukan jumlah barang",
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _kodeSatuan,
                validator: (String val) {
                  if (val.isEmpty) {
                    return "Kode satuan kosong";
                  }

                  return null;
                },
                decoration: InputDecoration(
                    labelText: "Kode satuan",
                    hintText: "Masukan kode satuan",
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Tanggal Masuk : "),
                  Text(_tglRequest),
                  IconButton(
                      icon: Icon(Icons.date_range),
                      onPressed: () {
                        pickTanggal();
                      })
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Card(
                elevation: 4,
                color: Colors.blueAccent,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 45,
                  child: InkWell(
                    splashColor: Colors.white,
                    child: Center(
                      child: Text("Simpan"),
                    ),
                    onTap: () {
                      simpanPermintaan();
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
