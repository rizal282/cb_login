import 'package:cb_login/main.dart';
import 'package:cb_login/user/gudang.dart';
import 'package:cb_login/user/pengeluaran.dart';
import 'package:cb_login/user/permintaan.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cb_login/user/penerimaan.dart';

class HomeUser extends StatefulWidget {
  final String userName;
  final String emailUser;

  HomeUser(this.userName, this.emailUser);
  @override
   HomeUserState createState() =>  HomeUserState();
}

class  HomeUserState extends State <HomeUser> {
  @override
  Widget build(BuildContext context) {
    final drawerHeader = UserAccountsDrawerHeader(
      accountName: Text(widget.userName),
      accountEmail: Text(widget.emailUser),
      currentAccountPicture: CircleAvatar(
        child: Image.asset("assets/img/default.jpg"),
      ),
    );
    final drawerItems = ListView(
      children: <Widget>[
        drawerHeader,
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
              Text("Selamat Datang",style: TextStyle(fontSize: 30),),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FaIcon(FontAwesomeIcons.cropAlt),
                  SizedBox(width: 8,),
                  Text("Cahaya Baru", style: TextStyle(fontSize: 30),)
                ],
              )
            ],
          ),
      ),
      drawer: Drawer(
        child: drawerItems,
      ),
    );
  }
}