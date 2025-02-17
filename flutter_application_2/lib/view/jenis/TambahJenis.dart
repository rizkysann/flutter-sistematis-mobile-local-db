// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter_application_2/model/api.dart';
import 'package:flutter_application_2/model/JenisModel.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';
import 'dart:convert';

class TambahJenis extends StatefulWidget {
  // const MyWidget({super.key});`
  final VoidCallback reload;
  TambahJenis(this.reload);

  @override
  State<TambahJenis> createState() => _TambahJenisState();
}

class _TambahJenisState extends State<TambahJenis> {
  FocusNode myFocusNode = new FocusNode();
  String? jenis;
  final _key = new GlobalKey<FormState>();
  check() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      simpanJenis();
    }
  }

  simpanJenis() async {
    try {
      final response = await http.post(
          Uri.parse(BaseUrl.urlTambahJenis.toString()),
          body: {"jenis": jenis});
      final data = jsonDecode(response.body);
      print(data);
      int code = data['succes'];
      String pesan = data['message'];
      print(data);
      if (code == 1) {
        setState(() {
          Navigator.pop(context);
          widget.reload();
        });
      } else {
        print(pesan);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(244, 244, 244, 1),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 6, 111, 192),
          title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    "Tambah Jenis Barang",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                )
              ]),
        ),
        body: Form(
          key: _key,
          child: ListView(
            padding: EdgeInsets.all(16.0),
            children: <Widget>[
              TextFormField(
                validator: (e) {
                  if ((e as dynamic).isEmpty) {
                    return "Silahkan isi Jenis";
                  }
                },
                onSaved: (e) => jenis = e,
                decoration: InputDecoration(
                  labelText: 'Jenis Barang',
                  labelStyle: TextStyle(
                      color: myFocusNode.hasFocus
                          ? Colors.blue
                          : Color.fromARGB(255, 32, 54, 70)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 32, 54, 70)),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              MaterialButton(
                color: Color.fromARGB(255, 2, 129, 29),
                onPressed: () {
                  check();
                },
                child: Text(
                  "Simpan",
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              )
            ],
          ),
        ));
  }
}
