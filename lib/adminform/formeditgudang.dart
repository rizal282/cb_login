import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Editgudang extends StatefulWidget {
  final String id_barang, kd_barang, nm_barang, kd_satuan, stok;

  const Editgudang(this.id_barang, this.kd_barang, this.nm_barang, this.kd_satuan, this.stok);

  @override
  _EditgudangState createState() => _EditgudangState();
}

class _EditgudangState extends State<Editgudang> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _kodeBarang = new TextEditingController();
  final _namaBarang = new TextEditingController();
  final _qtyItem = new TextEditingController();
  final _kodeSatuan = new TextEditingController();

  void setValForm(){
    _kodeBarang.text = widget.kd_barang;
    _namaBarang.text = widget.nm_barang;
    _kodeSatuan.text = widget.kd_satuan;
    _qtyItem.text = widget.stok;
  }

  void saveEditGudang() async {
    await http.post("http://192.168.43.171/cb-login/admin/updateGudang", body: {
      "kodeBarang" : _kodeBarang.text,
      "namaBarang" : _namaBarang.text,
      "qtyItem" : _qtyItem.text,
      "kodeSatuan" : _kodeSatuan.text,
      "id_barang" : widget.id_barang,
      "tabel_barang" : "tabel_barang",
    });

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Sukses"),
          content: Text("Data Gudang diupdate!"),
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

  @override
  void initState() {
    setValForm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Data Gudang"),
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
                      saveEditGudang();
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
