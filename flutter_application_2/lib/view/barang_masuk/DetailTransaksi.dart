import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_2/model/api.dart';
import 'package:flutter_application_2/model/BarangMasukModel.dart';
import 'package:flutter_application_2/model/TransaksiMasukModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_application_2/Loading.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class DetailTransaksi extends StatefulWidget {
  final VoidCallback reload;
  final TransaksiMasukModel model;
  DetailTransaksi(this.model, this.reload);
  @override
  State<DetailTransaksi> createState() => _DetailTransaksiState();
}

class _DetailTransaksiState extends State<DetailTransaksi> {
  var loading = false;
  final list = [];
  Future<void>? _launched;
  late Uri _urlpdf =
      Uri.parse(BaseUrl.urlBaBm + widget.model.id_transaksi.toString());
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  getPref() async {
    _lihatData();
  }

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(
        Uri.parse(BaseUrl.urlDetailTBM + widget.model.id_transaksi.toString()));
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new BarangMasukModel(api['foto'], api['nama_barang'],
            api['nama_brand'], api['jumlah_masuk']);
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 6, 111, 192),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  "Transaksi #" + widget.model.id_transaksi.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              )
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _lihatData,
                key: _refresh,
                child: loading
                    ? Loading()
                    : ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, i) {
                          final x = list[i];
                          return Container(
                            margin: EdgeInsets.all(5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: 64,
                                      minHeight: 64,
                                      maxWidth: 84,
                                      maxHeight: 84,
                                    ),
                                    child: Image.network(
                                      BaseUrl.path + x.foto.toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(x.nama_barang.toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal)),
                                      Divider(
                                        color: Colors.transparent,
                                      ),
                                      Text("Brand " + x.nama_brand.toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal)),
                                      Divider(
                                        color: Colors.transparent,
                                      ),
                                      Text(
                                          "Jumlah " + x.jumlah_masuk.toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal)),
                                      Divider(
                                        color: Colors.transparent,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
            Flexible(
              child: loading == true
                  ? Text("")
                  : Column(
                      children: [
                        Table(
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: <TableRow>[
                              TableRow(children: <Widget>[
                                ListTile(title: Text("Keterangan")),
                                ListTile(
                                    title: Text(
                                  widget.model.keterangan.toString(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                )),
                              ]),
                              TableRow(children: <Widget>[
                                ListTile(title: Text("Tujuan Transaksi")),
                                ListTile(
                                    title: Text(
                                  widget.model.tujuan.toString(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                )),
                              ]),
                              TableRow(children: <Widget>[
                                ListTile(title: Text("Total Barang Masuk")),
                                ListTile(
                                    title: Text(
                                  widget.model.total_item.toString(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                )),
                              ]),
                            ]),
                        SizedBox(
                          height: 20,
                        ),
                        MaterialButton(
                          color: Color.fromARGB(255, 41, 69, 91),
                          onPressed: () {
                            _launched = launchInBrowser(_urlpdf);
                            // Navigator.pop(context);
                          },
                          child: Text(
                            "Buat BA",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.white),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ],
                    ),
            ),
          ],
        ));
  }
}