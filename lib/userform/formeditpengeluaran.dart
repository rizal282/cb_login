import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Editpengeluaran extends StatefulWidget {
  final String id, _kodeBarang, _namaBarang, _qtyItem, _kodeSatuan, _tglKeluar;

  Editpengeluaran(this.id, this._kodeBarang, this._namaBarang, this._qtyItem, this._kodeSatuan, this._tglKeluar);
  @override
  _EditpengeluaranState createState() => _EditpengeluaranState();
}

class _EditpengeluaranState extends State<Editpengeluaran> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _kodeBarang = new TextEditingController();
  final _namaBarang = new TextEditingController();
  final _qtyItem = new TextEditingController();
  final _kodeSatuan = new TextEditingController();
  String _tglKeluar = "....";

  void pickTanggal() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1994),
            lastDate: DateTime(2030))
        .then((DateTime val) {
      if (val != null) {
        setState(() {
          _tglKeluar = val.toString();
        });
      }
    });
  }

  void setValueForm(){
    _kodeBarang.text = widget._kodeBarang;
    _namaBarang.text = widget._namaBarang;
    _qtyItem.text = widget._qtyItem;
    _kodeSatuan.text = widget._kodeSatuan;

    setState(() {
      _tglKeluar = widget._tglKeluar;
    });
  }

  void saveEdit() async {
    List tgl =_tglKeluar.split(" ");

    await http.post("http://192.168.43.171/cb-login/user/editPengeluaran", body: {
      "kodeBarang" : _kodeBarang.text,
      "namaBarang" : _namaBarang.text,
      "qtyItem" : _qtyItem.text,
      "kodeSatuan" : _kodeSatuan.text,
      "tglKeluar" : tgl[0],
      "id" : widget.id,
      "table" : "tabel_pengeluaran"
    });

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Sukses"),
          content: Text("Data Pengeluaran diupdate!"),
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
    setValueForm();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form Edit Pengeluaran"),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Tanggal Keluar : "),
                  Text(_tglKeluar),
                  IconButton(
                      icon: Icon(Icons.date_range),
                      onPressed: () {
                        pickTanggal();
                      })
                ],
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
                      saveEdit();
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