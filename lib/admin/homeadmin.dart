import 'package:cb_login/admin/gudang.dart';
import 'package:cb_login/admin/menumng.dart';
import 'package:cb_login/admin/penerimaan.dart';
import 'package:cb_login/admin/pengeluaran.dart';
import 'package:cb_login/admin/permintaan.dart';
import 'package:cb_login/admin/role.dart';
import 'package:cb_login/admin/submenu.dart';
import 'package:cb_login/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeAdmin extends StatefulWidget {
  final String id;
  final String namaUser;
  final String emailUser;
  final String role_id;

  const HomeAdmin({Key key, this.id, this.namaUser, this.emailUser, this.role_id}) : super(key: key);

  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    final drawerHeader = UserAccountsDrawerHeader(
      accountName: Text(widget.namaUser),
      accountEmail: Text(widget.emailUser),
      currentAccountPicture: CircleAvatar(
        child: Image.asset("assets/img/default.jpg"),
      ),
    );
    final drawerItems = ListView(
      children: <Widget>[
        drawerHeader,
        ListTile(
          leading: FaIcon(FontAwesomeIcons.tachometerAlt),
          title: Text("Dashboard"),
          onTap: (){},
        ),
        ListTile(
          leading: FaIcon(FontAwesomeIcons.userTie),
          title: Text("Role"),
          onTap: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Role())
            );
          },
        ),
        Divider(),
        ListTile(
          leading: FaIcon(FontAwesomeIcons.commentDollar),
          title: Text("Penerimaan"),
          onTap: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Penerimaan())
            );
          },
        ),
        ListTile(
          leading: FaIcon(FontAwesomeIcons.handHolding),
          title: Text("Permintaan"),
          onTap: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Permintaan())
            );
          },
        ),
        ListTile(
          leading: FaIcon(FontAwesomeIcons.warehouse),
          title: Text("Gudang"),
          onTap: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => DataGudang())
            );
          },
        ),
        ListTile(
          leading: FaIcon(FontAwesomeIcons.outdent),
          title: Text("Pengeluaran"),
          onTap: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Pengeluaran())
            );
          },
        ),
        Divider(),
        ListTile(
          leading: FaIcon(FontAwesomeIcons.folder),
          title: Text("Menu Management"),
          onTap: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MenuMng())
            );
          },
        ),
        ListTile(
          leading: FaIcon(FontAwesomeIcons.folderOpen),
          title: Text("Submenu Management"),
          onTap: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SubmenuMng())
            );
          },
        ),
        Divider(),
        ListTile(
          leading: FaIcon(FontAwesomeIcons.signOutAlt),
          title: Text("Logout"),
          onTap: (){
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => CBHome())
            );
          },
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Cahaya Baru"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/img/logo_cb.png", height: 90,),
              SizedBox(height: 20,),
              Text("Selamat Datang",style: TextStyle(fontSize: 30),),
              SizedBox(height: 20,),
              Image.asset("assets/img/textlogo_cb.png")
            ],
          ),
      ),
      drawer: Drawer(
        child: drawerItems,
      ),
    );
  }
}