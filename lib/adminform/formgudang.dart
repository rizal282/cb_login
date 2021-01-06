import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FormGudang extends StatefulWidget {
  @override
  _FormGudangState createState() => _FormGudangState();
}

class _FormGudangState extends State<FormGudang> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _kodeBarang = new TextEditingController();
  final _namaBarang = new TextEditingController();
  final _qtyItem = new TextEditingController();
  final _kodeSatuan = new TextEditingController();

  void resetForm(){
    _kodeBarang.text = "";
    _namaBarang.text = "";
    _qtyItem.text = "";
    _kodeSatuan.text = "";
  }

  void saveBarang() async {
    if(formKey.currentState.validate()){

      await http.post("http://192.168.43.171/cb-login/user/inputDataGudang", body: {
        "kodeBarang" : _kodeBarang.text,
        "namaBarang" : _namaBarang.text,
        "qtyItem" : _qtyItem.text,
        "kodeSatuan" : _kodeSatuan.text,
      });

      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Sukses"),
                content: Text("Data Gudang disimpan!"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form Data Gudang"),
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
                validator: (String val){
                  if(val.isEmpty){
                    return "Kode barang kosong!";
                  }

                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Kode barang",
                  hintText: "Masukan kode barang",
                  border: OutlineInputBorder()
                ),
              ),
              SizedBox(height: 15,),
              TextFormField(
                controller: _namaBarang,
                validator: (String val){
                  if(val.isEmpty){
                    return "Nama barang kosong!";
                  }

                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Nama barang",
                  hintText: "Masukan nama barang",
                  border: OutlineInputBorder()
                ),
              ),
              SizedBox(height: 15,),
              TextFormField(
                controller: _qtyItem,
                keyboardType: TextInputType.number,
                validator: (String val){
                  if(val.isEmpty){
                    return "Quantity item kosong!";
                  }

                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Quantity barang",
                  hintText: "Masukan quantity barang",
                  border: OutlineInputBorder()
                ),
              ),
              SizedBox(height: 15,),
              TextFormField(
                controller: _kodeSatuan,
                validator: (String val){
                  if(val.isEmpty){
                    return "Kode satuan kosong!";
                  }

                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Kode satuan",
                  hintText: "Masukan kode satuan",
                  border: OutlineInputBorder()
                ),
              ),
              
              SizedBox(height: 15,),
              
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
                      saveBarang();
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