import 'dart:convert';

import 'package:cb_login/admin/homeadmin.dart';
import 'package:cb_login/user/homeuser.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CB Login",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue
      ),
      home: CBHome(),
    );
  }
}

class CBHome extends StatefulWidget {
  @override
  _CBHomeState createState() => _CBHomeState();
}

class _CBHomeState extends State<CBHome> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final email = new TextEditingController();
  final password = new TextEditingController();

  String id, nama, emailuser, role_id;

  void login() async {
    if(formKey.currentState.validate()){
      var response = await http.post("http://192.168.43.171/cb-login/auth/login", body: {
        "email" : email.text,
        "password" : password.text
      });

     var dataLog = json.decode(response.body);

     if(dataLog.length == null){
       Fluttertoast.showToast(
         msg: "User Tidak Ada",
         gravity: ToastGravity.BOTTOM,
         toastLength: Toast.LENGTH_SHORT
       );
     }else{
       if(dataLog[0]["is_active"] == "1"){
         setState(() {
            id = dataLog[0]["id"];
            nama = dataLog[0]["name"];
            emailuser = dataLog[0]["email"];
            role_id = dataLog[0]["role_id"];
          });
         if(dataLog[0]["role_id"] == "1"){
           Navigator.of(context).pushReplacement(
             MaterialPageRoute(builder: (context) => HomeAdmin(id: id, namaUser: nama, emailUser: emailuser, role_id: role_id,))
           );
         }else{
           Navigator.of(context).pushReplacement(
             MaterialPageRoute(builder: (context) => HomeUser(nama, emailuser))
           );
         }
       }else{
         print("tidak ada data user");
       }
     }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          width: 330,
          height: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Form(
                    key: formKey,
                    child: formElement(),
                  ),
        ),
      ),

      backgroundColor: Colors.blue,
    );
  }

  Widget formElement() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          width: 90,
          height: 90,
          child: Image.asset("assets/img/logo_cb.png")),
        Text("Login", style: TextStyle(fontSize: 20),),
        TextFormField(
          controller: email,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: "Email Address",
            hintText: "Enter Email Address",
            border: OutlineInputBorder(),
          ),
        ),
        TextFormField(
          controller: password,
          obscureText: true,
          decoration: InputDecoration(
            labelText: "Password",
            hintText: "Enter Password",
            border: OutlineInputBorder(),
          ),
        ),
        Card(
          color: Colors.blue,
          elevation: 4,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: InkWell(
              child: Center(
                child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 15),),
              ),
              splashColor: Colors.white,
              onTap: (){
                login();
              },
            ),
          ),
        )
      ],
    );
  }
}